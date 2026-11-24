using UnityEngine;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    [AddComponentMenu("UI/Spatial Product Viewer/Selection Menu Graphic")]
    public sealed class SelectionMenuGraphic : MaskableGraphic, ICanvasRaycastFilter
    {
        public enum GlyphType
        {
            Panel,
            Deselect,
            Duplicate,
            Delete,
            ScaleLocked,
            ScaleUnlocked,
            Minimize,
            Products,
            ChevronUp,
            ChevronDown,
            ResetSize
        }

        [SerializeField]
        GlyphType glyph;
        [SerializeField, Min(0f)]
        float cornerRadius = 28f;
        [SerializeField, Min(0f)]
        float borderWidth = 1.2f;
        [SerializeField]
        Color borderColor = new Color(0.65f, 0.9f, 1f, 0.7f);
        [SerializeField]
        Color iconColor = Color.white;
        [SerializeField, Min(0.1f)]
        float iconStroke = 2.4f;

        public GlyphType Glyph
        {
            get => glyph;
            set
            {
                if (glyph == value)
                {
                    return;
                }

                glyph = value;
                SetVerticesDirty();
            }
        }

        public Color BorderColor
        {
            get => borderColor;
            set
            {
                if (borderColor == value)
                {
                    return;
                }

                borderColor = value;
                SetVerticesDirty();
            }
        }

        protected override void OnPopulateMesh(VertexHelper vh)
        {
            vh.Clear();
            var rect = GetPixelAdjustedRect();
            var center = rect.center;
            if (glyph == GlyphType.Panel)
            {
                RoundedRect(vh, rect, cornerRadius, borderColor);
                rect = new Rect(
                    rect.x + borderWidth,
                    rect.y + borderWidth,
                    rect.width - borderWidth * 2f,
                    rect.height - borderWidth * 2f
                );
                RoundedRect(vh, rect, Mathf.Max(0f, cornerRadius - borderWidth), color);
                return;
            }

            float radius = Mathf.Min(rect.width, rect.height) * 0.5f;
            Disc(vh, center, radius, borderColor);
            Disc(vh, center, Mathf.Max(0, radius - borderWidth), color);
            float unit = radius / 36f;
            switch (glyph)
            {
                case GlyphType.ResetSize:
                    for (int i = 0; i < 24; i++)
                    {
                        float a = (45f + i * 270f / 24f) * Mathf.Deg2Rad;
                        float b = (45f + (i + 1) * 270f / 24f) * Mathf.Deg2Rad;
                        Line(
                            vh,
                            center,
                            new Vector2(Mathf.Cos(a), Mathf.Sin(a)) * 14f,
                            new Vector2(Mathf.Cos(b), Mathf.Sin(b)) * 14f,
                            unit
                        );
                    }

                    Line(vh, center, new Vector2(10, -10), new Vector2(3, -10), unit);
                    Line(vh, center, new Vector2(10, -10), new Vector2(10, -17), unit);
                    Outline(vh, center, new Rect(-5, -5, 10, 10), unit);
                    break;
                case GlyphType.Minimize:
                    Line(vh, center, new Vector2(-11, 0), new Vector2(11, 0), unit);
                    break;
                case GlyphType.Products:
                    Line(vh, center, new Vector2(0, 15), new Vector2(13, 7), unit);
                    Line(vh, center, new Vector2(13, 7), new Vector2(13, -8), unit);
                    Line(vh, center, new Vector2(13, -8), new Vector2(0, -16), unit);
                    Line(vh, center, new Vector2(0, -16), new Vector2(-13, -8), unit);
                    Line(vh, center, new Vector2(-13, -8), new Vector2(-13, 7), unit);
                    Line(vh, center, new Vector2(-13, 7), new Vector2(0, 15), unit);
                    Line(vh, center, new Vector2(-13, 7), new Vector2(0, -1), unit);
                    Line(vh, center, new Vector2(0, -1), new Vector2(13, 7), unit);
                    Line(vh, center, new Vector2(0, -1), new Vector2(0, -16), unit);
                    break;
                case GlyphType.ChevronUp:
                case GlyphType.ChevronDown:
                    float sign = glyph == GlyphType.ChevronUp ? 1f : -1f;
                    Line(vh, center, new Vector2(-10, -5 * sign), new Vector2(0, 5 * sign), unit);
                    Line(vh, center, new Vector2(0, 5 * sign), new Vector2(10, -5 * sign), unit);
                    break;
                case GlyphType.Deselect:
                    Line(vh, center, new Vector2(-10, -10), new Vector2(10, 10), unit);
                    Line(vh, center, new Vector2(-10, 10), new Vector2(10, -10), unit);
                    break;
                case GlyphType.Duplicate:
                    Outline(vh, center, new Rect(-12, -12, 17, 18), unit);
                    Line(vh, center, new Vector2(-4, 11), new Vector2(-4, 15), unit);
                    Line(vh, center, new Vector2(-4, 15), new Vector2(13, 15), unit);
                    Line(vh, center, new Vector2(13, 15), new Vector2(13, -3), unit);
                    Line(vh, center, new Vector2(13, -3), new Vector2(9, -3), unit);
                    break;
                case GlyphType.Delete:
                    Outline(vh, center, new Rect(-9, -13, 18, 23), unit);
                    Line(vh, center, new Vector2(-14, 11), new Vector2(14, 11), unit);
                    Outline(vh, center, new Rect(-5, 11, 10, 5), unit);
                    Line(vh, center, new Vector2(-3, -7), new Vector2(-3, 5), unit);
                    Line(vh, center, new Vector2(3, -7), new Vector2(3, 5), unit);
                    break;
                default:
                    Outline(vh, center, new Rect(-11, -13, 22, 18), unit);
                    float shift = glyph == GlyphType.ScaleUnlocked ? 7f : 0f;
                    Line(vh, center, new Vector2(-7 + shift, 5), new Vector2(-7 + shift, 13), unit);
                    Line(vh, center, new Vector2(-7 + shift, 13), new Vector2(7 + shift, 13), unit);
                    Line(vh, center, new Vector2(7 + shift, 13), new Vector2(7 + shift, 5), unit);
                    Disc(vh, center + new Vector2(0, -3) * unit, 2f * unit, iconColor);
                    break;
            }
        }

        void Outline(VertexHelper vh, Vector2 center, Rect r, float unit)
        {
            Line(vh, center, new Vector2(r.xMin, r.yMin), new Vector2(r.xMax, r.yMin), unit);
            Line(vh, center, new Vector2(r.xMax, r.yMin), new Vector2(r.xMax, r.yMax), unit);
            Line(vh, center, new Vector2(r.xMax, r.yMax), new Vector2(r.xMin, r.yMax), unit);
            Line(vh, center, new Vector2(r.xMin, r.yMax), new Vector2(r.xMin, r.yMin), unit);
        }

        void Line(VertexHelper vh, Vector2 center, Vector2 from, Vector2 to, float unit)
        {
            from = center + from * unit;
            to = center + to * unit;
            var normal = new Vector2(-(to - from).y, (to - from).x).normalized * (iconStroke * unit * 0.5f);
            int start = vh.currentVertCount;
            vh.AddVert(from - normal, iconColor, Vector2.zero);
            vh.AddVert(from + normal, iconColor, Vector2.zero);
            vh.AddVert(to + normal, iconColor, Vector2.zero);
            vh.AddVert(to - normal, iconColor, Vector2.zero);
            vh.AddTriangle(start, start + 1, start + 2);
            vh.AddTriangle(start, start + 2, start + 3);
            Disc(vh, from, normal.magnitude, iconColor);
            Disc(vh, to, normal.magnitude, iconColor);
        }

        static void Disc(VertexHelper vh, Vector2 center, float radius, Color tint)
        {
            const int segments = 48;
            int start = vh.currentVertCount;
            vh.AddVert(center, tint, Vector2.zero);
            for (int i = 0; i <= segments; i++)
            {
                float angle = i * Mathf.PI * 2f / segments;
                vh.AddVert(center + new Vector2(Mathf.Cos(angle), Mathf.Sin(angle)) * radius, tint, Vector2.zero);
                if (i > 0)
                {
                    vh.AddTriangle(start, start + i, start + i + 1);
                }
            }
        }

        static void RoundedRect(VertexHelper vh, Rect rect, float radius, Color tint)
        {
            radius = Mathf.Min(radius, Mathf.Min(rect.width, rect.height) * 0.5f);
            int start = vh.currentVertCount;
            vh.AddVert(rect.center, tint, Vector2.zero);
            for (int corner = 0; corner < 4; corner++)
            {
                var center = new Vector2(
                    corner is 0 or 3 ? rect.xMax - radius : rect.xMin + radius,
                    corner < 2 ? rect.yMax - radius : rect.yMin + radius
                );
                for (int i = 0; i <= 10; i++)
                {
                    float angle = (corner * 90f + i * 9f) * Mathf.Deg2Rad;
                    vh.AddVert(center + new Vector2(Mathf.Cos(angle), Mathf.Sin(angle)) * radius, tint, Vector2.zero);
                }
            }

            for (int i = 1; i <= 44; i++)
            {
                vh.AddTriangle(start, start + i, start + (i % 44) + 1);
            }
        }

        public bool IsRaycastLocationValid(Vector2 screenPoint, Camera eventCamera)
        {
            if (glyph == GlyphType.Panel)
            {
                return true;
            }

            if (!RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTransform, screenPoint, eventCamera, out var local))
            {
                return false;
            }

            var rect = rectTransform.rect;
            return (local - rect.center).sqrMagnitude <= Mathf.Pow(Mathf.Min(rect.width, rect.height) * 0.5f, 2f);
        }
    }
}
