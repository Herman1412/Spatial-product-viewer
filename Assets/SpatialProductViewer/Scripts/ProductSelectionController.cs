using UnityEngine;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent]
    public sealed class ProductSelectionController : MonoBehaviour
    {
        [SerializeField]
        ProductSelectionView view;
        [SerializeField]
        Camera viewerCamera;
        [SerializeField, Min(0.01f)]
        float duplicateGap = 0.08f;

        int selectionFrame = -1;

        public SelectableProduct Selected { get; private set; }
        public Camera ViewerCamera => viewerCamera ? viewerCamera : Camera.main;

        void Start()
        {
            view.Show(null);
        }

        void OnDisable()
        {
            Deselect();
        }

        public void Select(SelectableProduct product)
        {
            if (!product || Selected == product || selectionFrame == Time.frameCount)
            {
                return;
            }

            selectionFrame = Time.frameCount;
            Deselect();
            Selected = product;
            view.Show(product);
        }

        public void Deselect()
        {
            if (Selected)
            {
                Selected.SetScaleUnlocked(false);
            }

            Selected = null;
            if (view)
            {
                view.Show(null);
            }
        }

        public void Forget(SelectableProduct product)
        {
            if (Selected == product)
            {
                Deselect();
            }
        }

        public void DuplicateSelected()
        {
            if (!Selected || Selected.Grab.isSelected)
            {
                return;
            }

            var source = Selected;
            var camera = ViewerCamera;
            var direction = camera
                ? Vector3.ProjectOnPlane(camera.transform.right, Vector3.up).normalized
                : Vector3.right;
            if (direction.sqrMagnitude < 0.01f)
            {
                direction = Vector3.right;
            }

            var extents = source.GetWorldBounds().extents;
            var room = FindAnyObjectByType<RoomGeometryService>();
            var spatial = source.GetComponent<ProductSpatialConstraint>();
            var pose = new Pose();
            bool found = false;
            var forward = Vector3.Cross(direction, Vector3.up);
            var offsets = spatial && spatial.SurfaceMode == ProductSurfaceMode.Wall && spatial.HasSurfaceBinding
                ? new[]
            {
                source.transform.right,
                -source.transform.right,
                source.transform.up,
                -source.transform.up,
                direction,
                -direction,
                forward,
                -forward
            }
                : new[]
            {
                direction,
                -direction,
                forward,
                -forward
            };
            foreach (var offset in offsets)
            {
                float distance = 2f * Vector3.Dot(extents, SpatialGeometry.Abs(offset)) + duplicateGap;
                pose = new Pose(source.transform.position + offset * distance, source.transform.rotation);
                if (spatial
                    ? !spatial.TryDuplicatePose(ref pose)
                    : room && !room.TryPlacement(source.GetLocalBounds(), source.transform.lossyScale, ref pose))
                {
                    continue;
                }

                found = true;
                break;
            }

            if (!found)
            {
                view.ShowNotice("No clear space beside this product");
                return;
            }

            source.RestoreAppearance();
            var copy = Instantiate(source, pose.position, pose.rotation, source.transform.parent);
            copy.name = source.DisplayName + " (Copy)";
            source.RefreshAppearance();
            selectionFrame = -1;
            Select(copy);
        }

        public void DeleteSelected()
        {
            if (!Selected || Selected.Grab.isSelected)
            {
                return;
            }

            var product = Selected;
            Deselect();
            product.gameObject.SetActive(false);
            Destroy(product.gameObject);
        }

        public void ToggleScaling()
        {
            if (Selected && !Selected.Grab.isSelected)
            {
                Selected.SetScaleUnlocked(!Selected.ScaleUnlocked);
            }
        }

        public void ResetSelectedScale()
        {
            if (Selected && !Selected.Grab.isSelected)
            {
                Selected.ResetScale();
            }
        }

        void Surface(ProductSurfaceMode mode)
        {
            if (Selected && !Selected.Grab.isSelected)
            {
                Selected.GetComponent<ProductSpatialConstraint>()?.SetSurfaceMode(mode);
            }
        }

        void Rotation(int step)
        {
            if (Selected && !Selected.Grab.isSelected)
            {
                Selected.GetComponent<ProductSpatialConstraint>()?.SetRotationStep(step);
            }
        }

        public void SurfaceFree()
        {
            Surface(ProductSurfaceMode.Free);
        }

        public void SurfaceFloor()
        {
            Surface(ProductSurfaceMode.Floor);
        }

        public void SurfaceTable()
        {
            Surface(ProductSurfaceMode.Tabletop);
        }

        public void SurfaceWall()
        {
            Surface(ProductSurfaceMode.Wall);
        }

        public void RotationFree()
        {
            Rotation(0);
        }

        public void Rotation15()
        {
            Rotation(15);
        }

        public void Rotation45()
        {
            Rotation(45);
        }

        public void Rotation90()
        {
            Rotation(90);
        }
    }
}
