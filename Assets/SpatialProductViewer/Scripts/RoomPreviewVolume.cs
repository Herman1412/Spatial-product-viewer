using UnityEngine;

namespace SpatialProductViewer
{
    [ExecuteAlways]
    public sealed class RoomPreviewVolume : MonoBehaviour
    {
        [SerializeField]
        bool isFloor;
        [SerializeField]
        ProductSurfaceMode snapSurface = ProductSurfaceMode.Free;
        [SerializeField]
        Vector3 size = Vector3.one;
        [SerializeField]
        LineRenderer outline;

        RoomGeometryService room;
        readonly Vector3[] vertices = new Vector3[16];
        static readonly int[] BoxPath = { 0,1,3,2,0,4,5,1,5,7,3,7,6,2,6,4 };
        public bool IsFloor => isFloor;
        public ProductSurfaceMode SnapSurface => isFloor ? ProductSurfaceMode.Floor : ProductSnapState.NormalizeSurface(snapSurface);
        public Vector3 Size => size;

        void OnValidate()
        {
            size = Vector3.Max(size, Vector3.one * 0.01f);
        }

        void LateUpdate()
        {
            if (!outline)
            {
                return;
            }

            if (!Application.isPlaying)
            {
                outline.enabled = false;
                return;
            }

            if (!room)
            {
                room = FindAnyObjectByType<RoomGeometryService>();
            }

            outline.enabled = room && room.IsEditorPreview && room.ShowRoom;
            if (!outline.enabled)
            {
                return;
            }

            outline.loop = true;
            outline.useWorldSpace = false;
            if (isFloor)
            {
                outline.positionCount = 4;
                outline.SetPosition(0, new Vector3(-size.x / 2, 0.004f, -size.z / 2));
                outline.SetPosition(1, new Vector3(size.x / 2, 0.004f, -size.z / 2));
                outline.SetPosition(2, new Vector3(size.x / 2, 0.004f, size.z / 2));
                outline.SetPosition(3, new Vector3(-size.x / 2, 0.004f, size.z / 2));
            }
            else
            {
                for (int i = 0; i < BoxPath.Length; i++)
                {
                    int c = BoxPath[i];
                    vertices[i] = Vector3.Scale(
                        size * 0.5f,
                        new Vector3((c & 1) == 0 ? -1 : 1, (c & 2) == 0 ? -1 : 1, (c & 4) == 0 ? -1 : 1)
                    );
                }

                outline.positionCount = vertices.Length;
                outline.SetPositions(vertices);
            }
        }

        void OnDrawGizmos()
        {
            var previous = Gizmos.matrix;
            Gizmos.matrix = transform.localToWorldMatrix;
            Gizmos.color = isFloor ? new Color(0.2f, 0.9f, 1f, 0.6f) : new Color(1f, 0.6f, 0.2f, 0.6f);
            Gizmos.DrawWireCube(Vector3.zero, isFloor ? new Vector3(size.x, 0.01f, size.z) : size);
            Gizmos.matrix = previous;
        }
    }
}
