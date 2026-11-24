using UnityEngine;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    public sealed class RoomPlacementControls : MonoBehaviour
    {
        [SerializeField]
        RoomGeometryService room;
        [SerializeField]
        Text guardLabel;
        [SerializeField]
        Text visualsLabel;
        [SerializeField]
        Text status;
        [SerializeField]
        SelectionMenuGraphic guardGraphic;
        [SerializeField]
        SelectionMenuGraphic visualsGraphic;
        [SerializeField]
        Text occlusionLabel;
        [SerializeField]
        SelectionMenuGraphic occlusionGraphic;

        EnvironmentOcclusion occlusion;
        float nextRefresh;

        void Start()
        {
            if (!room)
            {
                room = FindAnyObjectByType<RoomGeometryService>();
            }
        }

        void Update()
        {
            if (Time.unscaledTime < nextRefresh)
            {
                return;
            }

            nextRefresh = Time.unscaledTime + 0.2f;
            if (!room)
            {
                status.text = "Room environment is missing from the scene";
                return;
            }

            guardLabel.text = room.RoomGuardEnabled ? "Room guard: On" : "Room guard: Off";
            visualsLabel.text = room.ShowRoom ? "Show room: On" : "Show room: Off";
            if (!occlusion)
            {
                occlusion = FindAnyObjectByType<EnvironmentOcclusion>();
            }

            if (occlusionLabel)
            {
                occlusionLabel.text = !occlusion || !occlusion.Enabled
                    ? "Occlusion: Off"
                    : occlusion.Active
                        ? "Occlusion: On"
                        : "Occlusion: Wait";
            }

            if (occlusionGraphic)
            {
                Paint(occlusionGraphic, occlusion && occlusion.Active);
            }

            status.text = room.Status + (occlusion ? "  /  " + occlusion.Status : "");
            Paint(guardGraphic, room.RoomGuardEnabled);
            Paint(visualsGraphic, room.ShowRoom);
        }

        static void Paint(SelectionMenuGraphic graphic, bool on)
        {
            graphic.color = on ? new Color(0.24f, 0.48f, 0.58f, 1f) : new Color(0.18f, 0.24f, 0.32f, 0.95f);
        }

        public void ToggleGuard()
        {
            if (room)
            {
                room.ToggleRoomGuard();
            }
        }

        public void ToggleVisuals()
        {
            if (room)
            {
                room.ToggleRoomVisuals();
            }
        }

        public void ScanRoom()
        {
            if (room)
            {
                room.RequestScan();
            }
        }

        public void ToggleOcclusion()
        {
            if (!occlusion)
            {
                occlusion = FindAnyObjectByType<EnvironmentOcclusion>();
            }

            if (occlusion)
            {
                occlusion.Toggle();
            }
        }
    }
}
