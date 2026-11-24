using UnityEngine;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    public sealed class ProductPreviewGraphic : MaskableGraphic
    {
        [SerializeField]
        ProductDefinition definition;

        public void Refresh(ProductDefinition product)
        {
            definition = product;
            SetVerticesDirty();
        }

        protected override void OnPopulateMesh(VertexHelper vh)
        {
            vh.Clear();
            if (!definition)
            {
                return;
            }

            var productSize = definition.DimensionsMeters;
            var previewRect = GetPixelAdjustedRect();
            var projectedCorners = new Vector2[8];
            var minimum = Vector2.one * float.MaxValue;
            var maximum = Vector2.one * float.MinValue;
            for (int cornerIndex = 0; cornerIndex < 8; cornerIndex++)
            {
                float cornerX = productSize.x * ((cornerIndex & 1) == 0 ? -0.5f : 0.5f);
                float cornerY = productSize.y * ((cornerIndex & 2) == 0 ? -0.5f : 0.5f);
                float cornerZ = productSize.z * ((cornerIndex & 4) == 0 ? -0.5f : 0.5f);
                projectedCorners[cornerIndex] = new Vector2(0.82f * cornerX + 0.52f * cornerZ, cornerY + 0.28f * cornerZ - 0.18f * cornerX);
                minimum = Vector2.Min(minimum, projectedCorners[cornerIndex]);
                maximum = Vector2.Max(maximum, projectedCorners[cornerIndex]);
            }

            float previewScale = Mathf.Min(
                previewRect.width * 0.82f / Mathf.Max(0.01f, maximum.x - minimum.x),
                previewRect.height * 0.86f / Mathf.Max(0.01f, maximum.y - minimum.y)
            );
            previewScale = Mathf.Min(previewScale, previewRect.height * 0.95f);
            for (int cornerIndex = 0; cornerIndex < projectedCorners.Length; cornerIndex++)
            {
                projectedCorners[cornerIndex] = previewRect.center + (projectedCorners[cornerIndex] - (minimum + maximum) * 0.5f) * previewScale;
            }

            var previewColor = definition.PreviewColor;
            Quad(vh, projectedCorners, 0, 1, 3, 2, previewColor);
            Quad(
                vh,
                projectedCorners,
                1,
                5,
                7,
                3,
                new Color(previewColor.r * 0.62f, previewColor.g * 0.68f, previewColor.b * 0.8f, 1f)
            );
            Quad(vh, projectedCorners, 2, 3, 7, 6, Color.Lerp(previewColor, Color.white, 0.32f));
        }

        static void Quad(VertexHelper vh, Vector2[] p, int a, int b, int c, int d, Color tint)
        {
            int start = vh.currentVertCount;
            vh.AddVert(p[a], tint, Vector2.zero);
            vh.AddVert(p[b], tint, Vector2.zero);
            vh.AddVert(p[c], tint, Vector2.zero);
            vh.AddVert(p[d], tint, Vector2.zero);
            vh.AddTriangle(start, start + 1, start + 2);
            vh.AddTriangle(start, start + 2, start + 3);
        }
    }
}
