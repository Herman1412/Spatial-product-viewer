using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    [ExecuteAlways, DisallowMultipleComponent]
    public sealed class ProductCatalogCard : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
    {
        [SerializeField]
        ProductDefinition definition;
        [SerializeField]
        ProductCatalogController catalog;
        [SerializeField]
        Text title;
        [SerializeField]
        Text dimensions;
        [SerializeField]
        ProductPreviewGraphic preview;
        [SerializeField]
        Image thumbnail;
        [SerializeField]
        SelectionMenuGraphic backplate;
        [SerializeField]
        Color normalBorder = new Color(0.65f, 0.9f, 1f, 0.35f);
        [SerializeField]
        Color highlightedBorder = new Color(0.35f, 0.95f, 1f, 1f);

        bool hovered;
        bool current;
        ProductDefinition lastDefinition;
        Vector3 lastDimensions;
        Color lastColor;
        Sprite lastThumbnail;

        public ProductDefinition Definition => definition;

        public void Bind(ProductDefinition product)
        {
            definition = product;
            Refresh();
        }

        void OnEnable()
        {
            if (!catalog)
            {
                catalog = GetComponentInParent<ProductCatalogController>();
            }

            Refresh();
        }

        void OnDisable()
        {
            hovered = false;
            RefreshBorder();
        }

        void Update()
        {
            if (!Application.isPlaying)
            {
                Refresh();
            }
        }

        public void Refresh()
        {
            if (!definition)
            {
                return;
            }

            if (title && title.text != definition.DisplayName)
            {
                title.text = definition.DisplayName;
            }

            var label = definition.DimensionsLabel;
            if (dimensions && dimensions.text != label)
            {
                dimensions.text = label;
            }

            if (preview
                && (lastDefinition != definition
                || lastDimensions != definition.DimensionsMeters
                || lastColor != definition.PreviewColor))
            {
                preview.Refresh(definition);
            }

            if (thumbnail && (lastDefinition != definition || lastThumbnail != definition.Thumbnail))
            {
                thumbnail.sprite = definition.Thumbnail;
                thumbnail.enabled = definition.Thumbnail;
                if (preview)
                {
                    preview.enabled = !definition.Thumbnail;
                }
            }

            lastDefinition = definition;
            lastDimensions = definition.DimensionsMeters;
            lastColor = definition.PreviewColor;
            lastThumbnail = definition.Thumbnail;
            RefreshBorder();
        }

        public void PlaceProduct()
        {
            if (catalog && definition)
            {
                catalog.Place(this);
            }
        }

        public void SetCurrent(bool value)
        {
            current = value;
            RefreshBorder();
        }

        public void OnPointerEnter(PointerEventData _)
        {
            hovered = true;
            RefreshBorder();
        }

        public void OnPointerExit(PointerEventData _)
        {
            hovered = false;
            RefreshBorder();
        }

        void RefreshBorder()
        {
            if (backplate)
            {
                backplate.BorderColor = hovered || current ? highlightedBorder : normalBorder;
            }
        }
    }
}
