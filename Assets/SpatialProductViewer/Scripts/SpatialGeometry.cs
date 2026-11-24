using System;
using UnityEngine;

namespace SpatialProductViewer
{
    public static class SpatialGeometry
    {
        public readonly struct Box
        {
            public readonly Vector3 center;
            public readonly Vector3 halfSize;
            public readonly Quaternion rotation;
            readonly Vector3 axisX;
            readonly Vector3 axisY;
            readonly Vector3 axisZ;
            public readonly Vector3 worldHalfSize;

            public Box(Vector3 center, Vector3 halfSize, Quaternion rotation)
            {
                this.center = center;
                this.halfSize = halfSize;
                this.rotation = rotation;

                axisX = rotation * Vector3.right;
                axisY = rotation * Vector3.up;
                axisZ = rotation * Vector3.forward;

                worldHalfSize = Abs(axisX) * halfSize.x + Abs(axisY) * halfSize.y + Abs(axisZ) * halfSize.z;
            }

            public Vector3 Axis(int axisIndex)
            {
                if (axisIndex == 0)
                {
                    return axisX;
                }
                else if (axisIndex == 1)
                {
                    return axisY;
                }
                else
                {
                    return axisZ;
                }
            }

            public float Radius(Vector3 axis)
            {
                return Math.Abs(Vector3.Dot(axis, Axis(0))) * halfSize.x
                    + Math.Abs(Vector3.Dot(axis, Axis(1))) * halfSize.y
                    + Math.Abs(Vector3.Dot(axis, Axis(2))) * halfSize.z;
            }

            public Vector3 Corner(int cornerIndex)
            {
                return center
                    + rotation * Vector3.Scale(
                        halfSize,
                        new Vector3(
                            (cornerIndex & 1) == 0 ? -1 : 1,
                            (cornerIndex & 2) == 0 ? -1 : 1,
                            (cornerIndex & 4) == 0 ? -1 : 1
                        )
                    );
            }
        }

        public static Vector3 Abs(Vector3 value)
        {
            return new Vector3(Math.Abs(value.x), Math.Abs(value.y), Math.Abs(value.z));
        }

        public static Box FromProduct(Bounds local, Pose pose, Vector3 scale)
        {
            return new Box(
                pose.position + pose.rotation * Vector3.Scale(local.center, scale),
                Vector3.Scale(local.extents, Abs(scale)),
                pose.rotation
            );
        }

        public static bool Overlaps(Box firstBox, Box secondBox, float clearance, out float penetration)
        {
            penetration = float.MaxValue;
            var centerOffset = secondBox.center - firstBox.center;
            var combinedExtents = firstBox.worldHalfSize + secondBox.worldHalfSize + Vector3.one * clearance;
            if (Math.Abs(centerOffset.x) > combinedExtents.x
                || Math.Abs(centerOffset.y) > combinedExtents.y
                || Math.Abs(centerOffset.z) > combinedExtents.z)
            {
                penetration = 0f;
                return false;
            }

            for (int axisIndex = 0; axisIndex < 15; axisIndex++)
            {
                var separatingAxis = axisIndex < 3
                    ? firstBox.Axis(axisIndex)
                    : axisIndex < 6
                        ? secondBox.Axis(axisIndex - 3)
                        : Vector3.Cross(firstBox.Axis((axisIndex - 6) / 3), secondBox.Axis((axisIndex - 6) % 3));

                float axisLengthSquared = separatingAxis.sqrMagnitude;
                if (axisLengthSquared < 0.0000001f)
                {
                    continue;
                }

                separatingAxis /= (float)Math.Sqrt(axisLengthSquared);
                float axisOverlap = firstBox.Radius(separatingAxis)
                    + secondBox.Radius(separatingAxis)
                    + clearance - Math.Abs(Vector3.Dot(centerOffset, separatingAxis));
                if (axisOverlap <= 0.00001f)
                {
                    penetration = 0f;
                    return false;
                }

                penetration = Math.Min(penetration, axisOverlap);
            }

            return true;
        }

        public static bool Contains(Vector2 point, Vector2[] polygon, float tolerance = 0.002f)
        {
            if (polygon == null || polygon.Length < 3)
            {
                return false;
            }

            bool isInside = false;
            for (int currentIndex = 0, previousIndex = polygon.Length - 1; currentIndex < polygon.Length; previousIndex = currentIndex++)
            {
                var edgeStart = polygon[previousIndex];
                var edgeEnd = polygon[currentIndex];
                var edgeDirection = edgeEnd - edgeStart;
                float segmentFraction = edgeDirection.sqrMagnitude > 0f
                    ? Mathf.Clamp01(Vector2.Dot(point - edgeStart, edgeDirection) / edgeDirection.sqrMagnitude)
                    : 0f;
                if ((point - (edgeStart + edgeDirection * segmentFraction)).sqrMagnitude <= tolerance * tolerance)
                {
                    return true;
                }

                if ((edgeStart.y > point.y) != (edgeEnd.y > point.y)
                    && point.x < (edgeEnd.x - edgeStart.x) * (point.y - edgeStart.y)
                        / (edgeEnd.y - edgeStart.y) + edgeStart.x)
                {
                    isInside = !isInside;
                }
            }

            return isInside;
        }
    }
}
