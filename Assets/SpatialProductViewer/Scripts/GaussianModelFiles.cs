using System;
using System.IO;
using System.IO.Compression;
using System.Text;
using System.Threading;
using Gsplat;
using Gsplat.Formats;
using UnityEngine;

namespace SpatialProductViewer
{
    public static class GaussianModelFiles
    {
        public static bool Supports(string extension)
        {
            return extension == ".ply" || extension == ".spz" || extension == ".splat";
        }

        public static GsplatDecodedData Decode(
            byte[] bytes,
            string extension,
            int maximumSplats,
            CancellationToken cancellation
        )
        {
            if (bytes == null || bytes.Length < 16 || bytes.Length > LocalModelFiles.MaximumBytes)
            {
                throw new InvalidDataException("Choose a Gaussian file smaller than 64 MB.");
            }

            cancellation.ThrowIfCancellationRequested();
            using var stream = new MemoryStream(bytes, false);
            int splatCount;
            if (extension == ".ply")
            {
                splatCount = PlyCount(stream);
            }
            else if (extension == ".spz")
            {
                splatCount = SpzCount(stream);
            }
            else if (extension == ".splat" && bytes.Length % 32 == 0)
            {
                splatCount = bytes.Length / 32;
            }
            else
            {
                throw new InvalidDataException("Choose a Gaussian PLY, SPZ or 32-byte SPLAT file.");
            }

            if (splatCount < 1 || splatCount > maximumSplats)
            {
                throw new InvalidDataException($"This file has {splatCount:N0} splats; the Quest import limit is {maximumSplats:N0}. Simplify the capture before importing.");
            }

            ProgressCallback progress = (_, __) => cancellation.ThrowIfCancellationRequested();
            var decodedData = extension == ".ply"
                ? PlayCanvasPlyReader.Read(bytes, SourceCoordinates.RUB, progress)
                : extension == ".spz"
                    ? PlayCanvasSpzReader.Read(bytes, SourceCoordinates.RUB, progress)
                    : ReadSplat(bytes, cancellation);
            if (decodedData.Count != splatCount)
            {
                throw new InvalidDataException("The Gaussian count does not match its header.");
            }

            decodedData.Validate();

            var bounds = new Bounds();
            bool hasBounds = false;
            for (int splatIndex = 0; splatIndex < decodedData.Count; splatIndex++)
            {
                if ((splatIndex & 4095) == 0)
                {
                    cancellation.ThrowIfCancellationRequested();
                }

                var packedRotation = decodedData.Rotations[splatIndex];
                var rotation = new Quaternion(packedRotation.y, packedRotation.z, packedRotation.w, packedRotation.x).normalized;

                var threeSigmaScale = decodedData.Scales[splatIndex] * 3;
                var axisX = rotation * Vector3.right * threeSigmaScale.x;
                var axisY = rotation * Vector3.up * threeSigmaScale.y;
                var axisZ = rotation * Vector3.forward * threeSigmaScale.z;

                var axisAlignedExtent = new Vector3(
                    Mathf.Sqrt(axisX.x * axisX.x + axisY.x * axisY.x + axisZ.x * axisZ.x),
                    Mathf.Sqrt(axisX.y * axisX.y + axisY.y * axisY.y + axisZ.y * axisZ.y),
                    Mathf.Sqrt(axisX.z * axisX.z + axisY.z * axisY.z + axisZ.z * axisZ.z)
                );
                var splatBounds = new Bounds(decodedData.Positions[splatIndex], axisAlignedExtent * 2);
                if (!hasBounds)
                {
                    bounds = splatBounds;
                    hasBounds = true;
                }
                else
                {
                    bounds.Encapsulate(splatBounds);
                }
            }

            if (!LocalModelFiles.ValidSize(bounds.size)
                || !Finite(bounds.center.x)
                || !Finite(bounds.center.y)
                || !Finite(bounds.center.z))
            {
                throw new InvalidDataException("The Gaussian model has invalid or empty bounds.");
            }

            decodedData.Bounds = bounds;
            return decodedData;
        }

        static int PlyCount(Stream stream)
        {
            int vertexCount = -1;
            int bytesRead = 0;
            bool isBinaryLittleEndian = false;
            var lineBuffer = new StringBuilder();
            while (bytesRead++ < 1024 * 1024)
            {
                int nextByte = stream.ReadByte();
                if (nextByte < 0)
                {
                    break;
                }

                if (nextByte != '\n')
                {
                    if (nextByte != '\r')
                    {
                        lineBuffer.Append((char)nextByte);
                    }

                    continue;
                }

                var headerLine = lineBuffer.ToString().Trim();
                lineBuffer.Clear();
                if (headerLine == "format binary_little_endian 1.0")
                {
                    isBinaryLittleEndian = true;
                }

                var headerParts = headerLine.Split((char[])null, StringSplitOptions.RemoveEmptyEntries);
                if (headerParts.Length == 3 && headerParts[0] == "element" && headerParts[1] == "vertex")
                {
                    if (vertexCount != -1 || !int.TryParse(headerParts[2], out vertexCount))
                    {
                        throw new InvalidDataException("Invalid PLY vertex count.");
                    }
                }

                if (headerLine == "end_header")
                {
                    if (!isBinaryLittleEndian)
                    {
                        throw new InvalidDataException("Export Gaussian PLY as binary little-endian. ASCII and ordinary mesh/point-cloud PLY are unsupported.");
                    }

                    return vertexCount;
                }
            }

            throw new InvalidDataException("The PLY header is incomplete or too large.");
        }

        static int SpzCount(Stream stream)
        {
            bool isGzip = stream.ReadByte() == 0x1f && stream.ReadByte() == 0x8b;
            stream.Position = 0;
            using var compressed = isGzip
                ? new GZipStream(stream, System.IO.Compression.CompressionMode.Decompress, true)
                : null;
            using var reader = new BinaryReader(compressed ?? stream, Encoding.UTF8, true);
            if (reader.ReadUInt32() != 0x5053474e)
            {
                throw new InvalidDataException("This is not an SPZ Gaussian model.");
            }

            uint formatVersion = reader.ReadUInt32();
            if (formatVersion < 1 || formatVersion > 4)
            {
                throw new InvalidDataException("SPZ versions 1–4 are supported.");
            }

            return checked((int)reader.ReadUInt32());
        }

        static GsplatDecodedData ReadSplat(byte[] bytes, CancellationToken cancellation)
        {
            var decodedData = new GsplatDecodedData(bytes.Length / 32, 0);
            using var reader = new BinaryReader(new MemoryStream(bytes, false));
            for (int splatIndex = 0; splatIndex < decodedData.Count; splatIndex++)
            {
                if ((splatIndex & 4095) == 0)
                {
                    cancellation.ThrowIfCancellationRequested();
                }

                decodedData.Positions[splatIndex] = new Vector3(reader.ReadSingle(), reader.ReadSingle(), -reader.ReadSingle());
                decodedData.Scales[splatIndex] = new Vector3(reader.ReadSingle(), reader.ReadSingle(), reader.ReadSingle());
                var colorAndOpacity = new Vector4(
                    (reader.ReadByte() / 255f - 0.5f) / 0.28209479f,
                    (reader.ReadByte() / 255f - 0.5f) / 0.28209479f,
                    (reader.ReadByte() / 255f - 0.5f) / 0.28209479f,
                    reader.ReadByte() / 255f
                );
                decodedData.Colors[splatIndex] = colorAndOpacity;
                float rotationW = (reader.ReadByte() - 128) / 128f;
                float rotationX = (reader.ReadByte() - 128) / 128f;
                float rotationY = (reader.ReadByte() - 128) / 128f;
                float rotationZ = (reader.ReadByte() - 128) / 128f;
                var convertedRotation = new Vector4(rotationW, -rotationX, -rotationY, rotationZ);
                if (convertedRotation.sqrMagnitude < 0.0001f)
                {
                    throw new InvalidDataException("SPLAT contains an invalid rotation.");
                }

                decodedData.Rotations[splatIndex] = convertedRotation.normalized;
            }

            return decodedData;
        }

        static bool Finite(float value)
        {
            return !float.IsNaN(value) && !float.IsInfinity(value);
        }

        public static float NormalizeForPacking(GsplatDecodedData data, CancellationToken cancellation)
        {
            var originalBounds = data.Bounds;
            float longestSide = Mathf.Max(originalBounds.size.x, originalBounds.size.y, originalBounds.size.z);
            for (int splatIndex = 0; splatIndex < data.Count; splatIndex++)
            {
                if ((splatIndex & 4095) == 0)
                {
                    cancellation.ThrowIfCancellationRequested();
                }

                data.Positions[splatIndex] = (data.Positions[splatIndex] - originalBounds.center) / longestSide;
                data.Scales[splatIndex] /= longestSide;
            }

            data.Bounds = new Bounds(Vector3.zero, originalBounds.size / longestSide);
            return longestSide;
        }
    }
}
