using UnityEngine;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    [ExecuteAlways, DisallowMultipleComponent]
    public sealed class ProductSelectionView : MonoBehaviour
    {
        [SerializeField]
        ProductSelectionController selectionController;
        [SerializeField]
        Transform boundsRoot;
        [SerializeField]
        RectTransform menu;
        [SerializeField]
        Text productTitle;
        [SerializeField]
        Text productDimensions;
        [SerializeField]
        Text scaleLabel;
        [SerializeField]
        Text hint;
        [SerializeField]
        SelectionMenuGraphic scaleGraphic;
        [SerializeField]
        Button duplicateButton;
        [SerializeField]
        Button deleteButton;
        [SerializeField]
        Button scaleButton;
        [SerializeField]
        Button resetScaleButton;
        [SerializeField]
        Text placementStatus;
        [SerializeField]
        ProductOutlineView outlineView;
        [SerializeField]
        ProductDimensionView dimensionView;
        [SerializeField]
        Button[] surfaceButtons;
        [SerializeField]
        Button[] rotationButtons;
        [SerializeField]
        Text snapStatus;
        [SerializeField, Min(0f)]
        float menuGap = 0.05f;
        [Header("Scene view preview (only outside Play mode)")]
        [SerializeField]
        bool previewInEditor = true;
        [SerializeField]
        SelectableProduct previewProduct;

        SelectableProduct target;
        string notice;
        float noticeUntil;

        public void ShowNotice(string value)
        {
            notice = value;
            noticeUntil = Time.unscaledTime + 3f;
        }

        public void Show(SelectableProduct product)
        {
            target = product;
            SetVisible(product);
        }

        void SetVisible(bool visible)
        {
            if (boundsRoot && boundsRoot.gameObject.activeSelf != visible)
            {
                boundsRoot.gameObject.SetActive(visible);
            }

            if (menu && menu.gameObject.activeSelf != visible)
            {
                menu.gameObject.SetActive(visible);
            }

            if (dimensionView)
            {
                dimensionView.SetVisible(visible);
            }

            if (!visible && outlineView)
            {
                outlineView.Hide();
            }
        }

        void LateUpdate()
        {
            if (!Application.isPlaying && previewInEditor && !previewProduct)
            {
                return;
            }

            var product = Application.isPlaying ? target : (previewInEditor ? previewProduct : null);
            if (!product)
            {
                SetVisible(false);
                return;
            }

            SetVisible(true);
            var local = product.GetLocalBounds();
            var scale = product.transform.lossyScale;
            scale = new Vector3(Mathf.Abs(scale.x), Mathf.Abs(scale.y), Mathf.Abs(scale.z));
            var productSize = Vector3.Scale(local.size, scale);
            boundsRoot.SetPositionAndRotation(product.transform.TransformPoint(local.center), product.transform.rotation);
            var world = product.GetWorldBounds();
            menu.position = new Vector3(
                world.center.x,
                world.max.y + menuGap + menu.rect.height * menu.lossyScale.y * 0.5f,
                world.center.z
            );
            var camera = selectionController ? selectionController.ViewerCamera : Camera.main;
            if (dimensionView)
            {
                dimensionView.Refresh(product, camera);
            }

            if (camera)
            {
                var forward = Vector3.ProjectOnPlane(menu.position - camera.transform.position, Vector3.up);
                if (forward.sqrMagnitude > 0.001f)
                {
                    menu.rotation = Quaternion.LookRotation(forward, Vector3.up);
                }
            }

            bool held = Application.isPlaying && product.Grab && product.Grab.isSelected;
            bool unlocked = Application.isPlaying && product.ScaleUnlocked;
            duplicateButton.interactable = deleteButton.interactable = scaleButton.interactable = !held;
            if (resetScaleButton)
            {
                resetScaleButton.interactable = !held;
            }

            SetText(productTitle, product.DisplayName);
            SetText(
                productDimensions,
                $"{productSize.x * 100f:0.#} × {productSize.y * 100f:0.#} × {productSize.z * 100f:0.#} cm"
            );
            SetText(scaleLabel, unlocked ? "Lock scale" : "Scale");
            SetText(
                hint,
                Application.isPlaying && Time.unscaledTime < noticeUntil
                ? notice
                : held
                    ? "Release to use controls"
                    : unlocked
                        ? "Use two hands to resize"
                        : ""
            );
            var spatial = Application.isPlaying ? product.GetComponent<ProductSpatialConstraint>() : null;
            int surface = spatial
                ? spatial.SurfaceMode == ProductSurfaceMode.Floor
                    ? 1
                    : spatial.SurfaceMode == ProductSurfaceMode.Tabletop
                        ? 2
                        : spatial.SurfaceMode == ProductSurfaceMode.Wall
                            ? 3
                            : 0
                : 0;
            SetSnapButtons(surfaceButtons, surface, !held && spatial);
            int step = spatial ? spatial.RotationStep : 0;
            SetSnapButtons(rotationButtons, step == 15
                ? 1
                : step == 45
                    ? 2
                    : step == 90
                        ? 3
                        : 0, !held && spatial);
            SetText(
                snapStatus,
                spatial ? spatial.SnapStatus : "Free detaches  /  Wall attaches the product's back face"
            );
            SetText(placementStatus, spatial ? spatial.FitLabel : "Room fit appears here in Play mode");
            var fitColor = spatial ? spatial.FitColor : new Color(0.3f, 0.95f, 1f);
            if (placementStatus)
            {
                placementStatus.color = fitColor;
            }

            if (outlineView)
            {
                outlineView.Refresh(product, fitColor, camera);
            }

            scaleGraphic.Glyph = unlocked
                ? SelectionMenuGraphic.GlyphType.ScaleUnlocked
                : SelectionMenuGraphic.GlyphType.ScaleLocked;
        }

        static void SetText(Text text, string value)
        {
            if (text && text.text != value)
            {
                text.text = value;
            }
        }

        static void SetSnapButtons(Button[] buttons, int selected, bool enabled)
        {
            if (buttons == null)
            {
                return;
            }

            for (int i = 0; i < buttons.Length; i++)
            {
                if (!buttons[i])
                {
                    continue;
                }

                buttons[i].interactable = enabled;
                var art = buttons[i].targetGraphic;
                if (art)
                {
                    art.color = i == selected
                        ? new Color(0.15f, 0.43f, 0.52f, 0.98f)
                        : new Color(0.14f, 0.2f, 0.28f, 0.95f);
                }
            }
        }
    }
}
