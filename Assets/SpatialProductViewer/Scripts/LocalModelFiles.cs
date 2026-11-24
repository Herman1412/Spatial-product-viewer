using System;
using System.Globalization;
using System.IO;
using System.Text;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace SpatialProductViewer
{
    public static class LocalModelFiles
    {
        public const int MaximumBytes = 64 * 1024 * 1024;

        public static void ValidateGlb(byte[] bytes)
        {
            if (bytes == null || bytes.Length < 20 || bytes.Length > MaximumBytes)
            {
                throw new InvalidDataException("Choose a GLB file smaller than 64 MB.");
            }

            if (BitConverter.ToUInt32(bytes, 0) != 0x46546C67 || BitConverter.ToUInt32(bytes, 4) != 2)
            {
                throw new InvalidDataException("This is not a glTF 2.0 GLB. Export the model as GLB with embedded textures.");
            }

            if (BitConverter.ToUInt32(bytes, 8) != bytes.Length)
            {
                throw new InvalidDataException("The GLB file is incomplete or has an invalid length.");
            }

            uint length = BitConverter.ToUInt32(bytes, 12);
            if (BitConverter.ToUInt32(bytes, 16) != 0x4E4F534A
                || length > 8 * 1024 * 1024
                || length > bytes.Length - 20
                || length % 4 != 0)
            {
                throw new InvalidDataException("The GLB has an invalid JSON chunk.");
            }

            var json = JObject.Parse(Encoding.UTF8.GetString(bytes, 20, (int)length));
            if (json["extensionsUsed"] is JArray used)
            {
                foreach (var extension in used)
                {
                    if ((string)extension == "KHR_gaussian_splatting")
                    {
                        throw new InvalidDataException("For Gaussian captures choose PLY, SPZ or SPLAT. GLB import currently supports mesh models.");
                    }
                }
            }

            if ((string)json["asset"]?["version"] != "2.0")
            {
                throw new InvalidDataException("Only glTF 2.0 models are supported.");
            }

            foreach (var group in new[] { "buffers", "images" })
            {
                if (json[group] is JArray resources)
                {
                    foreach (var resource in resources)
                    {
                        var uri = (string)resource["uri"];
                        if (!string.IsNullOrEmpty(uri) && !uri.StartsWith("data:", StringComparison.OrdinalIgnoreCase))
                        {
                            throw new InvalidDataException("This GLB references other files. Export a self-contained GLB with embedded textures.");
                        }
                    }
                }
            }

            if (json["extensionsRequired"] is JArray required)
            {
                foreach (var extension in required)
                {
                    if ((string)extension == "KHR_draco_mesh_compression"
                        || (string)extension == "KHR_texture_basisu"
                        || (string)extension == "EXT_meshopt_compression")
                    {
                        throw new InvalidDataException("Export without Draco, Meshopt or KTX2 compression for this importer.");
                    }
                }
            }

            if (json["nodes"] is JArray nodes && nodes.Count > 2500)
            {
                throw new InvalidDataException("This model has too many parts. Simplify it to fewer than 2,500 nodes.");
            }

            long vertices = 0;
            if (json["meshes"] is JArray meshes && json["accessors"] is JArray accessors)
            {
                foreach (var mesh in meshes)
                {
                    foreach (var primitive in mesh["primitives"] ?? new JArray())
                    {
                        int index = (int? )primitive["attributes"]?["POSITION"] ?? -1;
                        if (index >= 0 && index < accessors.Count)
                        {
                            vertices += (long? )accessors[index]["count"] ?? 0;
                        }
                    }
                }
            }

            if (vertices > 500000)
            {
                throw new InvalidDataException("This model exceeds 500,000 vertices. Use a simpler export for Quest.");
            }

            long offset = 20L + length;
            while (offset < bytes.Length)
            {
                if (offset + 8 > bytes.Length)
                {
                    throw new InvalidDataException("The GLB has an incomplete chunk.");
                }

                uint chunkSize = BitConverter.ToUInt32(bytes, (int)offset);
                if (chunkSize % 4 != 0 || offset + 8 + chunkSize > bytes.Length)
                {
                    throw new InvalidDataException("The GLB has an invalid chunk length.");
                }

                offset += 8 + chunkSize;
            }
        }

        public static bool ValidSize(Vector3 size)
        {
            return Finite(size.x)
                && Finite(size.y)
                && Finite(size.z)
                && Mathf.Min(size.x, size.y, size.z) > 0.000001f
                && Mathf.Max(size.x, size.y, size.z) <= 1000000f;
        }

        static bool Finite(float value)
        {
            return !float.IsNaN(value) && !float.IsInfinity(value);
        }

        public static Vector3 FitToHalfMetre(Vector3 source)
        {
            return source * (0.5f / Mathf.Max(source.x, source.y, source.z));
        }

        public static bool TryDimensions(
            Vector3 source,
            string width,
            string height,
            string depth,
            out Vector3 size,
            out string error
        )
        {
            size = source;
            error = null;
            var fields = new[]
            {
                width,
                height,
                depth
            };
            var values = new float[3];
            int count = 0;
            int known = -1;
            for (int i = 0; i < 3; i++)
            {
                if (string.IsNullOrWhiteSpace(fields[i]))
                {
                    continue;
                }

                if (!float.TryParse(fields[i].Replace(',', '.'), NumberStyles.Float, CultureInfo.InvariantCulture, out values[i])
                    || !Finite(values[i])
                    || values[i] < 0.1f
                    || values[i] > 1000f)
                {
                    error = "Dimensions must be between 0.1 and 1,000 cm.";
                    return false;
                }

                values[i] *= 0.01f;
                count++;
                known = i;
            }

            if (count == 2)
            {
                error = "Enter one dimension to preserve proportions, or all three for an exact size.";
                return false;
            }

            if (count == 1)
            {
                size = source * (values[known] / source[known]);
            }

            if (count == 3)
            {
                size = new Vector3(values[0], values[1], values[2]);
            }

            if (!ValidSize(size)
                || Mathf.Min(size.x, size.y, size.z) < 0.001f
                || Mathf.Max(size.x, size.y, size.z) > 10f)
            {
                error = "Choose a size between 0.1 and 1,000 cm on each axis. Use Fit to 50 cm for unknown units.";
                return false;
            }

            return true;
        }
    }
}
