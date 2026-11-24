using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

namespace SpatialProductViewer
{
    [RequireComponent(typeof(LineRenderer))]
    public sealed class RoomTrackableVisual : MonoBehaviour
    {
        [SerializeField]
        ARPlane plane;
        [SerializeField]
        ARBoundingBox boundingBox;
        [SerializeField]
        LineRenderer outline;

        RoomGeometryService room;
        readonly Vector3[] vertices = new Vector3[16];
        static readonly int[] BoxPath = { 0,1,3,2,0,4,5,1,5,7,3,7,6,2,6,4 };

        void Awake()
        {
            if (!outline)
            {
                outline = GetComponent<LineRenderer>();
            }

            room = FindAnyObjectByType<RoomGeometryService>();
            outline.useWorldSpace = false;
            outline.loop = true;
        }

        void LateUpdate()
        {
            if (!room)
            {
                room = FindAnyObjectByType<RoomGeometryService>();
            }

            bool tracked = plane
                ? plane.trackingState == TrackingState.Tracking && !plane.subsumedBy
                : boundingBox && boundingBox.trackingState == TrackingState.Tracking;
            outline.enabled = room && room.ShowRoom && tracked;
            if (!outline.enabled)
            {
                return;
            }

            if (plane)
            {
                var boundary = plane.boundary;
                if (boundary.IsCreated && boundary.Length >= 3)
                {
                    outline.positionCount = boundary.Length;
                    for (int i = 0; i < boundary.Length; i++)
                    {
                        outline.SetPosition(i, new Vector3(boundary[i].x, 0.004f, boundary[i].y));
                    }
                }
                else
                {
                    var center = plane.centerInPlaneSpace;
                    var extents = plane.extents;
                    outline.positionCount = 4;
                    outline.SetPosition(0, new Vector3(center.x - extents.x, 0.004f, center.y - extents.y));
                    outline.SetPosition(1, new Vector3(center.x + extents.x, 0.004f, center.y - extents.y));
                    outline.SetPosition(2, new Vector3(center.x + extents.x, 0.004f, center.y + extents.y));
                    outline.SetPosition(3, new Vector3(center.x - extents.x, 0.004f, center.y + extents.y));
                }
            }
            else
            {
                for (int i = 0; i < BoxPath.Length; i++)
                {
                    int corner = BoxPath[i];
                    vertices[i] = Vector3.Scale(
                        boundingBox.size * 0.5f,
                        new Vector3((corner & 1) == 0 ? -1 : 1, (corner & 2) == 0 ? -1 : 1, (corner & 4) == 0 ? -1 : 1)
                    );
                }

                outline.positionCount = vertices.Length;
                outline.SetPositions(vertices);
            }
        }
    }
}
