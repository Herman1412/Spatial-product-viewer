using UnityEngine;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent]
    public sealed class ProductDimensionView : MonoBehaviour
    {
        [SerializeField]
        Transform measurementRoot;
        [SerializeField]
        LineRenderer[] rulers;
        [SerializeField]
        RectTransform[] labelBoards;
        [SerializeField]
        Text[] labels;
        [SerializeField, Min(0.01f)]
        float edgeOffset = 0.045f;
        [SerializeField, Min(0.001f)]
        float tickSize = 0.014f;
        [SerializeField, Min(0.0001f)]
        float lineWidth = 0.0015f;

        readonly Vector3[] points = new Vector3[10];
        readonly Vector3[] positions = new Vector3[3];
        readonly int[] lastMillimetres = { -1, -1, -1 };
        static readonly string[] AxisNames = { "W", "H", "D" };

        public void SetVisible(bool visible)
        {
            if (measurementRoot && measurementRoot.gameObject.activeSelf != visible)
            {
                measurementRoot.gameObject.SetActive(visible);
            }
        }

        public void Refresh(SelectableProduct product, Camera camera)
        {
            if (!product || !measurementRoot)
            {
                SetVisible(false);
                return;
            }

            SetVisible(true);

            var localBounds = product.GetLocalBounds();
            var productSize = Vector3.Scale(localBounds.size, SpatialGeometry.Abs(product.transform.lossyScale));
            var halfSize = productSize * 0.5f;
            var productCenter = product.transform.TransformPoint(localBounds.center);
            measurementRoot.SetPositionAndRotation(productCenter, product.transform.rotation);

            var viewerLocalPosition = camera
                ? Quaternion.Inverse(product.transform.rotation) * (camera.transform.position - productCenter)
                : new Vector3(1, 1, -1);
            float viewerSideX = viewerLocalPosition.x < 0 ? -1 : 1;
            float viewerSideZ = viewerLocalPosition.z < 0 ? -1 : 1;
            float rulerOffset = edgeOffset;

            Draw(
                0,
                new Vector3(-halfSize.x, -halfSize.y, viewerSideZ * halfSize.z),
                new Vector3(halfSize.x, -halfSize.y, viewerSideZ * halfSize.z),
                new Vector3(0, 0, viewerSideZ * rulerOffset)
            );

            Draw(
                1,
                new Vector3(viewerSideX * halfSize.x, -halfSize.y, viewerSideZ * halfSize.z),
                new Vector3(viewerSideX * halfSize.x, halfSize.y, viewerSideZ * halfSize.z),
                new Vector3(viewerSideX * rulerOffset, 0, viewerSideZ * rulerOffset)
            );

            Draw(
                2,
                new Vector3(viewerSideX * halfSize.x, -halfSize.y, -halfSize.z),
                new Vector3(viewerSideX * halfSize.x, -halfSize.y, halfSize.z),
                new Vector3(viewerSideX * rulerOffset, 0, 0)
            );

            positions[0] = new Vector3(0, -halfSize.y + 0.019f, viewerSideZ * (halfSize.z + rulerOffset + 0.025f));
            positions[1] = new Vector3(viewerSideX * (halfSize.x + rulerOffset + 0.07f), 0, viewerSideZ * (halfSize.z + rulerOffset));
            positions[2] = new Vector3(viewerSideX * (halfSize.x + rulerOffset + 0.07f), -halfSize.y + 0.019f, 0);

            for (int axisIndex = 0; axisIndex < 3; axisIndex++)
            {
                labelBoards[axisIndex].localPosition = positions[axisIndex];
                int roundedMillimetres = Mathf.RoundToInt(productSize[axisIndex] * 1000f);
                if (lastMillimetres[axisIndex] != roundedMillimetres)
                {
                    labels[axisIndex].text = $"{AxisNames[axisIndex]}: {productSize[axisIndex] * 100f:0.#} cm";
                    lastMillimetres[axisIndex] = roundedMillimetres;
                }

                if (!camera)
                {
                    continue;
                }

                var labelDirection = labelBoards[axisIndex].position - camera.transform.position;
                if (labelDirection.sqrMagnitude < 0.0001f)
                {
                    continue;
                }

                var labelUp = Mathf.Abs(Vector3.Dot(labelDirection.normalized, Vector3.up)) > 0.98f
                    ? camera.transform.up
                    : Vector3.up;
                labelBoards[axisIndex].rotation = Quaternion.LookRotation(labelDirection, labelUp);
            }
        }

        void Draw(int axis, Vector3 start, Vector3 end, Vector3 offset)
        {
            var offsetStart = start + offset;
            var offsetEnd = end + offset;
            var halfTick = offset.normalized * (tickSize * 0.5f);

            points[0] = start;
            points[1] = offsetStart;
            points[2] = offsetStart - halfTick;
            points[3] = offsetStart + halfTick;
            points[4] = offsetStart;

            points[5] = offsetEnd;
            points[6] = offsetEnd - halfTick;
            points[7] = offsetEnd + halfTick;
            points[8] = offsetEnd;
            points[9] = end;

            rulers[axis].widthMultiplier = lineWidth;
            rulers[axis].positionCount = points.Length;
            rulers[axis].SetPositions(points);
        }
    }
}
