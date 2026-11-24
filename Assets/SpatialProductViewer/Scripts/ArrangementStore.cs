using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;

namespace SpatialProductViewer
{
    [Serializable]
    public sealed class ArrangementData
    {
        public int version = 1;
        public string name;
        public string savedUtc;
        public string frameId;
        public Vector3 viewerPosition;
        public Quaternion viewerRotation = Quaternion.identity;
        public List<ArrangementProduct> products = new List<ArrangementProduct>();
    }

    [Serializable]
    public sealed class ArrangementProduct
    {
        public string productId;
        public string displayName;
        public Vector3 position;
        public Vector3 localScale;
        public Vector3 resetScale;
        public Quaternion rotation;
        public ProductSnapState snapping;
    }

    public static class ArrangementStore
    {
        public const int SlotCount = 5;
        public const int MaximumProducts = 128;
        const int MaximumFileBytes = 1024 * 1024;

        static string SlotPath(string root, int slot)
        {
            if (slot < 0 || slot >= SlotCount)
            {
                throw new ArgumentOutOfRangeException(nameof(slot));
            }

            return Path.Combine(root, "slot-" + (slot + 1));
        }

        static string[] Generations(string slot)
        {
            if (!Directory.Exists(slot))
            {
                return Array.Empty<string>();
            }

            return Directory.GetDirectories(slot).Where(p =>
            {
                var name = Path.GetFileName(p);
                return name.Length == 52
                    && name[19] == '-'
                    && long.TryParse(name.Substring(0, 19), out _)
                    && Guid.TryParseExact(name.Substring(20), "N", out _);
            }).OrderByDescending(Path.GetFileName, StringComparer.Ordinal).ToArray();
        }

        public static bool HasSave(string root, int slot)
        {
            return Generations(SlotPath(root, slot)).Length > 0;
        }

        public static ArrangementData Read(string root, int slot, out bool recovered)
        {
            recovered = false;
            var generations = Generations(SlotPath(root, slot));
            if (generations.Length == 0)
            {
                return null;
            }

            Exception last = null;
            for (int i = 0; i < generations.Length; i++)
            {
                try
                {
                    string path = Path.Combine(generations[i], "layout.json");
                    if (new FileInfo(path).Length > MaximumFileBytes)
                    {
                        throw new InvalidDataException("Layout file is too large.");
                    }

                    var data = JsonUtility.FromJson<ArrangementData>(File.ReadAllText(path));
                    Validate(data);
                    recovered = i > 0;
                    return data;
                }
                catch (Exception error)
                {
                    last = error;
                }
            }

            throw new InvalidDataException("This save could not be read. Existing products were kept.", last);
        }

        public static void Save(string root, int slot, ArrangementData data)
        {
            Validate(data);
            var folder = SlotPath(root, slot);
            Directory.CreateDirectory(folder);
            var generations = Generations(folder);
            long generation = DateTime.UtcNow.Ticks;
            if (generations.Length > 0)
            {
                generation = Math.Max(generation, long.Parse(Path.GetFileName(generations[0]).Substring(0, 19)) + 1);
            }

            string id = Guid.NewGuid().ToString("N");
            string pending = Path.Combine(folder, ".pending-" + id);
            Directory.CreateDirectory(pending);
            try
            {
                File.WriteAllText(Path.Combine(pending, "layout.json"), JsonUtility.ToJson(data, true));
                Directory.Move(pending, Path.Combine(folder, generation.ToString("D19") + "-" + id));
            }
            finally
            {
                if (Directory.Exists(pending))
                {
                    Directory.Delete(pending, true);
                }
            }

            foreach (var obsolete in Generations(folder).Skip(2))
            {
                try
                {
                    Directory.Delete(obsolete, true);
                }
                catch (IOException)
                {
                }
                catch (UnauthorizedAccessException)
                {
                }
            }
        }

        public static void Validate(ArrangementData data)
        {
            if (data == null
                || data.version != 1
                || data.products == null
                || data.products.Count > MaximumProducts
                || string.IsNullOrWhiteSpace(data.name)
                || data.name.Length > 64
                || (data.frameId?.Length ?? 0) > 180
                || !DateTime.TryParse(data.savedUtc, null, System.Globalization.DateTimeStyles.RoundtripKind, out _)
                || !ValidPosition(data.viewerPosition)
                || !ValidRotation(data.viewerRotation))
            {
                throw new InvalidDataException("Invalid arrangement data.");
            }

            foreach (var product in data.products)
            {
                if (product == null
                    || string.IsNullOrWhiteSpace(product.productId)
                    || product.productId.Length > 128
                    || string.IsNullOrWhiteSpace(product.displayName)
                    || product.displayName.Length > 64
                    || !ValidPosition(product.position)
                    || !ValidRotation(product.rotation)
                    || !ValidScale(product.localScale)
                    || !ValidScale(product.resetScale)
                    || !ValidSnapping(product.snapping))
                {
                    throw new InvalidDataException("A saved product has invalid transforms or identity.");
                }
            }
        }

        static bool Finite(float value)
        {
            return !float.IsNaN(value) && !float.IsInfinity(value);
        }

        static bool ValidSnapping(ProductSnapState state)
        {
            return state == null
                || ((int)state.surfaceMode >= 0
                && (int)state.surfaceMode <= 4
                && ProductSnapState.ValidStep(state.rotationStep)
                && (!state.hasRotationReference
                || ValidRotation(state.rotationReference))
                && (state.surfaceId?.Length ?? 0) <= 180
                && (state.wallSide == 1
                || state.wallSide == -1));
        }

        static bool ValidPosition(Vector3 value)
        {
            return Finite(value.x) && Finite(value.y) && Finite(value.z) && value.sqrMagnitude < 100000000f;
        }

        public static bool ValidScale(Vector3 value)
        {
            return Finite(value.x)
                && Finite(value.y)
                && Finite(value.z)
                && Mathf.Min(value.x, value.y, value.z) > 0f
                && Mathf.Max(value.x, value.y, value.z) < 1000000000f;
        }

        static bool ValidRotation(Quaternion value)
        {
            float length = value.x * value.x + value.y * value.y + value.z * value.z + value.w * value.w;
            return Finite(length) && Mathf.Abs(length - 1f) < 0.01f;
        }
    }
}
