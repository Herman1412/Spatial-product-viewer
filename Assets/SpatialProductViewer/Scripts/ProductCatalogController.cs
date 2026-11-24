using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.Interaction.Toolkit.Interactables;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent]
    public sealed class ProductCatalogController : MonoBehaviour
    {
        [SerializeField]
        GameObject expandedPanel;
        [SerializeField]
        GameObject minimizedPanel;
        [SerializeField]
        ScrollRect scroll;
        [SerializeField]
        RectTransform content;
        [SerializeField]
        Text countLabel;
        [SerializeField]
        Text statusLabel;
        [SerializeField]
        SelectionMenuGraphic[] categoryGraphics;
        [SerializeField]
        ProductCatalogCard[] importedSlots;
        [SerializeField]
        Transform spawnPreparation;
        [SerializeField]
        Camera viewerCamera;
        [SerializeField]
        ProductSelectionController selectionController;
        [SerializeField]
        XRGrabInteractable windowGrab;
        [SerializeField, Min(0.3f)]
        float spawnDistance = 1.25f;
        [SerializeField]
        float spawnVerticalOffset = -0.35f;
        [SerializeField]
        Color activeCategoryColor = new Color(0.24f, 0.48f, 0.58f, 1f);
        [SerializeField]
        Color inactiveCategoryColor = new Color(0.18f, 0.24f, 0.32f, 0.95f);

        ProductCatalogCard[] cards;
        readonly Collider[] overlaps = new Collider[64];
        int category;
        float feedbackUntil;
        int placementFrame = -1;
        const string DefaultHint = "";

        void Start()
        {
            cards = content.GetComponentsInChildren<ProductCatalogCard>(true);
            ApplyFilter();
        }

        void Update()
        {
            if (feedbackUntil > 0f && Time.unscaledTime >= feedbackUntil)
            {
                statusLabel.text = DefaultHint;
                feedbackUntil = 0f;
            }
        }

        public void ShowAll()
        {
            SetCategory(0);
        }

        public void ShowCubes()
        {
            SetCategory(1);
        }

        public void ShowBlocks()
        {
            SetCategory(2);
        }

        public void ShowImported()
        {
            SetCategory(3);
        }

        public void ShowFurniture()
        {
            SetCategory(4);
        }

        public void ShowElectronics()
        {
            SetCategory(5);
        }

        public void ShowObjects()
        {
            SetCategory(6);
        }

        public ProductDefinition FindProduct(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return null;
            }

            foreach (var card in content.GetComponentsInChildren<ProductCatalogCard>(true))
            {
                if (card.Definition && card.Definition.PersistentId == id)
                {
                    return card.Definition;
                }
            }

            return null;
        }

        public SelectableProduct CreateProduct(
            ProductDefinition definition,
            Pose pose,
            Vector3 scale,
            Vector3 resetScale,
            Transform parent = null
        )
        {
            if (!definition || !definition.Prefab || !spawnPreparation || spawnPreparation.gameObject.activeInHierarchy)
            {
                throw new System.InvalidOperationException("The catalog needs a product prefab and inactive Spawn Preparation.");
            }

            var product = Instantiate(definition.Prefab, spawnPreparation, false);
            product.gameObject.SetActive(false);
            product.transform.SetParent(parent, false);
            product.transform.localScale = scale;
            product.transform.SetPositionAndRotation(pose.position, pose.rotation);
            product.ConfigureProduct(definition, resetScale);
            product.SetDisplayName(definition.DisplayName);
            product.SetModelMaterial(definition.Material);
            product.name = definition.DisplayName;
            product.gameObject.SetActive(true);
            return product;
        }

        public bool HasImportSlot
        {
            get
            {
                if (importedSlots == null)
                {
                    return false;
                }

                foreach (var slot in importedSlots)
                {
                    if (slot && !slot.Definition)
                    {
                        return true;
                    }
                }

                return false;
            }
        }

        public bool AddImported(ProductDefinition definition)
        {
            if (!definition || importedSlots == null)
            {
                return false;
            }

            foreach (var slot in importedSlots)
            {
                if (!slot || slot.Definition)
                {
                    continue;
                }

                slot.Bind(definition);
                cards = content.GetComponentsInChildren<ProductCatalogCard>(true);
                ApplyFilter();
                return true;
            }

            return false;
        }

        void SetCategory(int value)
        {
            category = value;
            ApplyFilter();
        }

        void ApplyFilter()
        {
            if (cards == null)
            {
                return;
            }

            int count = 0;
            foreach (var card in cards)
            {
                if (!card)
                {
                    continue;
                }

                bool visible = card.Definition && (category == 0 || (int)card.Definition.Category == category - 1);
                card.gameObject.SetActive(visible);
                if (visible)
                {
                    count++;
                    card.Refresh();
                }
            }

            countLabel.text = $"{count} product{(count == 1 ? "" : "s")}  /  True scale";
            for (int i = 0; i < categoryGraphics.Length; i++)
            {
                if (categoryGraphics[i])
                {
                    categoryGraphics[i].color = i == category ? activeCategoryColor : inactiveCategoryColor;
                }
            }

            scroll.StopMovement();
            LayoutRebuilder.ForceRebuildLayoutImmediate(content);
            Canvas.ForceUpdateCanvases();
            scroll.verticalNormalizedPosition = 1f;
        }

        public void Minimize()
        {
            scroll.StopMovement();
            expandedPanel.SetActive(false);
            minimizedPanel.SetActive(true);
        }

        public void Restore()
        {
            minimizedPanel.SetActive(false);
            expandedPanel.SetActive(true);
        }

        public void Place(ProductCatalogCard card)
        {
            if (!card || !card.Definition || placementFrame == Time.frameCount)
            {
                return;
            }

            if (windowGrab && windowGrab.isSelected)
            {
                Feedback("Release the grab bar before placing a product");
                return;
            }

            var camera = viewerCamera ? viewerCamera : Camera.main;
            var definition = card.Definition;
            if (!camera || !definition.Prefab || !spawnPreparation || spawnPreparation.gameObject.activeInHierarchy)
            {
                Feedback("Assign a product prefab and an inactive Spawn Preparation object");
                return;
            }

            var localBounds = definition.Prefab.GetLocalBounds();
            var modelSize = localBounds.size;
            if (Mathf.Min(modelSize.x, modelSize.y, modelSize.z) < 0.0001f)
            {
                Feedback("The product prefab needs model renderers with valid bounds");
                return;
            }

            var forward = Vector3.ProjectOnPlane(camera.transform.forward, Vector3.up).normalized;
            if (forward.sqrMagnitude < 0.01f)
            {
                forward = Vector3.forward;
            }

            var right = Vector3.Cross(Vector3.up, forward);
            var rotation = Quaternion.LookRotation(forward, Vector3.up);
            var dimensions = definition.DimensionsMeters;
            var center = camera.transform.position + forward * spawnDistance + Vector3.up * spawnVerticalOffset;
            Physics.SyncTransforms();
            if (!FindClearPosition(center, forward, right, rotation, dimensions, out center))
            {
                Feedback("Move a nearby product to make room, then try again");
                return;
            }

            placementFrame = Time.frameCount;
            var scale = new Vector3(dimensions.x / modelSize.x, dimensions.y / modelSize.y, dimensions.z / modelSize.z);
            var pose = new Pose(center - rotation * Vector3.Scale(localBounds.center, scale), rotation);
            var product = CreateProduct(definition, pose, scale, scale);
            if (!selectionController)
            {
                selectionController = FindAnyObjectByType<ProductSelectionController>();
            }

            if (selectionController)
            {
                selectionController.Select(product);
            }

            foreach (var item in cards)
            {
                if (item)
                {
                    item.SetCurrent(item == card);
                }
            }

            Feedback($"Placed {definition.DisplayName}");
        }

        bool FindClearPosition(
            Vector3 center,
            Vector3 forward,
            Vector3 right,
            Quaternion rotation,
            Vector3 dimensions,
            out Vector3 result
        )
        {
            var room = FindAnyObjectByType<RoomGeometryService>();
            for (int row = 0; row < 3; row++)
            {
                for (int column = 0; column < 3; column++)
                {
                    float lateral = column == 0 ? 0f : (column == 1 ? 1f : -1f) * (dimensions.x + 0.12f);
                    var candidate = center + forward * (row * (dimensions.z + 0.12f)) + right * lateral;
                    var pose = new Pose(candidate, rotation);
                    if (room && !room.TryPlacement(new Bounds(Vector3.zero, dimensions), Vector3.one, ref pose))
                    {
                        continue;
                    }

                    candidate = pose.position;
                    int count = Physics.OverlapBoxNonAlloc(
                        candidate,
                        dimensions * 0.5f + Vector3.one * 0.02f,
                        overlaps,
                        rotation,
                        ~0,
                        QueryTriggerInteraction.Ignore
                    );
                    bool occupied = count == overlaps.Length;
                    for (int i = 0; i < count; i++)
                    {
                        if (overlaps[i] && overlaps[i].GetComponentInParent<SelectableProduct>())
                        {
                            occupied = true;
                            break;
                        }
                    }

                    if (!occupied)
                    {
                        result = candidate;
                        return true;
                    }
                }
            }

            result = center;
            return false;
        }

        void Feedback(string message)
        {
            statusLabel.text = message;
            feedbackUntil = Time.unscaledTime + 4f;
        }
    }
}
