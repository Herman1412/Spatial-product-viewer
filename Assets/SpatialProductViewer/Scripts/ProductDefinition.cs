using UnityEngine;

namespace SpatialProductViewer
{
    [CreateAssetMenu(menuName = "Spatial Product Viewer/Product", fileName = "New Product")]
    public sealed class ProductDefinition : ScriptableObject
    {
        public enum ProductCategory
        {
            Cubes,
            Blocks,
            Imported,
            Furniture,
            Electronics,
            Objects
        }

        [SerializeField]
        string displayName = "Cube Model A";
        [SerializeField]
        ProductCategory category;
        [SerializeField]
        Vector3 dimensionsMeters = Vector3.one * 0.4f;
        [SerializeField]
        SelectableProduct prefab;
        [SerializeField]
        Material material;
        [SerializeField]
        Sprite thumbnail;
        [SerializeField]
        Color previewColor = new Color(0.1f, 0.42f, 0.95f);
        [SerializeField, HideInInspector]
        string persistentId;

        public string DisplayName => displayName;
        public ProductCategory Category => category;
        public Vector3 DimensionsMeters => dimensionsMeters;
        public SelectableProduct Prefab => prefab;
        public Material Material => material;
        public Sprite Thumbnail => thumbnail;
        public Color PreviewColor => previewColor;
        public string PersistentId => persistentId;

        public void SetPersistentId(string value)
        {
            persistentId = value;
        }

        public string DimensionsLabel => $"{dimensionsMeters.x * 100f:0.#} × {dimensionsMeters.y * 100f:0.#} × {dimensionsMeters.z * 100f:0.#} cm";

        public void ConfigureImported(string title, Vector3 dimensions, SelectableProduct template, Sprite image)
        {
            displayName = title;
            category = ProductCategory.Imported;
            dimensionsMeters = dimensions;
            prefab = template;
            material = null;
            thumbnail = image;
        }

        public void ConfigureCatalog(
            string title,
            ProductCategory productCategory,
            Vector3 dimensions,
            SelectableProduct template,
            Sprite image
        )
        {
            ConfigureImported(title, dimensions, template, image);
            category = productCategory;
        }

        void OnValidate()
        {
            dimensionsMeters = Vector3.Max(Vector3.one * 0.01f, dimensionsMeters);
        }
    }
}
