using System.Collections.Generic;
using UnityEngine;

namespace SpatialProductViewer
{
    internal sealed class SnappingSurface
    {
        public readonly string id;
        public readonly ProductSurfaceMode kind;
        public readonly Pose frame;
        public readonly Vector3 point;
        public readonly Vector3 normal;
        readonly Vector2[] polygon;
        readonly float winding;
        readonly float padding;
        readonly List<Vector2> firstClipBuffer = new List<Vector2>(32);
        readonly List<Vector2> secondClipBuffer = new List<Vector2>(32);

        public SnappingSurface(
            string id,
            ProductSurfaceMode kind,
            Pose frame,
            Vector3 point,
            Vector2[] polygon,
            float padding = 0
        )
        {
            this.id = id;
            this.kind = kind;
            this.frame = frame;
            this.point = point;
            this.polygon = polygon;
            this.padding = padding;
            normal = frame.rotation * Vector3.up;
            float signedArea = 0;
            for (int vertexIndex = 0; vertexIndex < polygon.Length; vertexIndex++)
            {
                var edgeStart = polygon[vertexIndex];
                var edgeEnd = polygon[(vertexIndex + 1) % polygon.Length];
                signedArea += edgeStart.x * edgeEnd.y - edgeEnd.x * edgeStart.y;
            }

            winding = signedArea < 0 ? -1 : 1;
        }

        public bool Project(
            Bounds local,
            Vector3 scale,
            ref Pose pose,
            int side,
            int step,
            Quaternion reference,
            float clearance
        )
        {
            var productCenter = SpatialGeometry.FromProduct(local, pose, scale).center;
            var surfaceNormal = kind == ProductSurfaceMode.Wall ? normal * (side < 0 ? -1 : 1) : normal;
            if (kind == ProductSurfaceMode.Wall)
            {
                var projectedUp = Vector3.ProjectOnPlane(pose.rotation * Vector3.up, surfaceNormal);
                var referenceDirection = Vector3.ProjectOnPlane(Vector3.up, surfaceNormal).normalized;
                if (referenceDirection.sqrMagnitude < 0.001f)
                {
                    return false;
                }

                if (projectedUp.sqrMagnitude < 0.001f)
                {
                    projectedUp = referenceDirection;
                }

                float rotationAngle = Vector3.SignedAngle(referenceDirection, projectedUp, surfaceNormal);
                if (step > 0)
                {
                    rotationAngle = Mathf.Round(rotationAngle / step) * step;
                }

                pose.rotation = Quaternion.LookRotation(surfaceNormal, Quaternion.AngleAxis(rotationAngle, surfaceNormal) * referenceDirection);
            }
            else
            {
                var projectedForward = Vector3.ProjectOnPlane(pose.rotation * Vector3.forward, surfaceNormal);
                var referenceDirection = Vector3.ProjectOnPlane(reference * Vector3.forward, surfaceNormal).normalized;
                if (referenceDirection.sqrMagnitude < 0.001f)
                {
                    referenceDirection = Vector3.ProjectOnPlane(Vector3.forward, surfaceNormal).normalized;
                }

                if (projectedForward.sqrMagnitude < 0.001f)
                {
                    projectedForward = referenceDirection;
                }

                float rotationAngle = Vector3.SignedAngle(referenceDirection, projectedForward, surfaceNormal);
                if (step > 0)
                {
                    rotationAngle = Mathf.Round(rotationAngle / step) * step;
                }

                pose.rotation = Quaternion.LookRotation(Quaternion.AngleAxis(rotationAngle, surfaceNormal) * referenceDirection, surfaceNormal);
            }

            pose.position = productCenter - pose.rotation * Vector3.Scale(local.center, scale);

            var productBox = SpatialGeometry.FromProduct(local, pose, scale);
            pose.position += surfaceNormal * (
                clearance + padding + productBox.Radius(surfaceNormal)
                - Vector3.Dot(productBox.center - point, surfaceNormal)
            );

            productBox = SpatialGeometry.FromProduct(local, pose, scale);
            if (!FeasibleCenter(productBox, clearance, out var target))
            {
                return false;
            }

            var localCenter = Quaternion.Inverse(frame.rotation) * (productBox.center - frame.position);
            pose.position += frame.rotation * new Vector3(target.x - localCenter.x, 0, target.y - localCenter.z);
            return true;
        }

        bool FeasibleCenter(SpatialGeometry.Box box, float clearance, out Vector2 closest)
        {
            closest = default;

            firstClipBuffer.Clear();
            firstClipBuffer.AddRange(polygon);
            var inputPolygon = firstClipBuffer;
            var outputPolygon = secondClipBuffer;

            for (int boundaryEdgeIndex = 0; boundaryEdgeIndex < polygon.Length; boundaryEdgeIndex++)
            {
                var boundaryStart = polygon[boundaryEdgeIndex];
                var boundaryEnd = polygon[(boundaryEdgeIndex + 1) % polygon.Length];
                var edgeDirection = boundaryEnd - boundaryStart;
                if (edgeDirection.sqrMagnitude < 0.00000001f)
                {
                    continue;
                }

                var inwardNormal = new Vector2(-edgeDirection.y, edgeDirection.x).normalized * winding;
                var worldInwardNormal = frame.rotation * new Vector3(inwardNormal.x, 0, inwardNormal.y);
                float minimumProjection = Vector2.Dot(inwardNormal, boundaryStart) + box.Radius(worldInwardNormal) + clearance;

                outputPolygon.Clear();
                if (inputPolygon.Count == 0)
                {
                    return false;
                }

                var previousVertex = inputPolygon[inputPolygon.Count - 1];
                float previousDistance = Vector2.Dot(inwardNormal, previousVertex) - minimumProjection;

                foreach (var currentVertex in inputPolygon)
                {
                    float currentDistance = Vector2.Dot(inwardNormal, currentVertex) - minimumProjection;
                    if ((previousDistance >= 0) != (currentDistance >= 0))
                    {
                        outputPolygon.Add(Vector2.LerpUnclamped(
                            previousVertex,
                            currentVertex,
                            previousDistance / (previousDistance - currentDistance)
                        ));
                    }

                    if (currentDistance >= 0)
                    {
                        outputPolygon.Add(currentVertex);
                    }

                    previousVertex = currentVertex;
                    previousDistance = currentDistance;
                }

                var previousInput = inputPolygon;
                inputPolygon = outputPolygon;
                outputPolygon = previousInput;
            }

            if (inputPolygon.Count < 3)
            {
                return false;
            }

            var localCenter = Quaternion.Inverse(frame.rotation) * (box.center - frame.position);
            var candidateCenter = new Vector2(localCenter.x, localCenter.z);
            bool centerIsInside = true;
            float closestDistanceSquared = float.MaxValue;
            for (int edgeIndex = 0; edgeIndex < inputPolygon.Count; edgeIndex++)
            {
                var edgeStart = inputPolygon[edgeIndex];
                var edgeEnd = inputPolygon[(edgeIndex + 1) % inputPolygon.Count];
                var edgeDirection = edgeEnd - edgeStart;

                if (winding * (edgeDirection.x * (candidateCenter.y - edgeStart.y) - edgeDirection.y * (candidateCenter.x - edgeStart.x)) < -0.00001f)
                {
                    centerIsInside = false;
                }

                float segmentFraction = edgeDirection.sqrMagnitude > 0.00000001f
                    ? Mathf.Clamp01(Vector2.Dot(candidateCenter - edgeStart, edgeDirection) / edgeDirection.sqrMagnitude)
                    : 0;
                var pointOnEdge = edgeStart + edgeDirection * segmentFraction;
                float distanceSquared = (pointOnEdge - candidateCenter).sqrMagnitude;
                if (distanceSquared < closestDistanceSquared)
                {
                    closestDistanceSquared = distanceSquared;
                    closest = pointOnEdge;
                }
            }

            if (centerIsInside)
            {
                closest = candidateCenter;
            }

            return true;
        }
    }
}
