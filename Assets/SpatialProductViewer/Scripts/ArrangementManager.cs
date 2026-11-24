using System;
using System.IO;
using System.Linq;
using UnityEngine;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent]
    public sealed class ArrangementManager : MonoBehaviour
    {
        [SerializeField]
        ProductCatalogController catalog;
        [SerializeField]
        LocalModelLibrary library;
        [SerializeField]
        Camera viewerCamera;
        [SerializeField]
        ProductSelectionController selection;
        [SerializeField]
        RoomGeometryService room;

        public bool Ready => !library || (library.IsReady && !library.Busy);

        public string StoragePath
        {
            get
            {
#if UNITY_EDITOR
                return Path.Combine(Path.GetDirectoryName(Application.dataPath), "UserSettings", "Arrangements");
#else
                return Path.Combine(Application.persistentDataPath, "Arrangements");
#endif
            }
        }

        void FindReferences()
        {
            if (!catalog)
            {
                catalog = GetComponent<ProductCatalogController>();
            }

            if (!viewerCamera)
            {
                viewerCamera = Camera.main;
            }

            if (!selection)
            {
                selection = FindAnyObjectByType<ProductSelectionController>();
            }

            if (!room)
            {
                room = FindAnyObjectByType<RoomGeometryService>();
            }
        }

        public static SelectableProduct[] PlacedProducts()
        {
            return FindObjectsByType<SelectableProduct>();
        }

        public bool Save(int slot, string title, out string message)
        {
            try
            {
                FindReferences();
                EnsureReady();
                var products = PlacedProducts();
                if (products.Any(p => p.Grab && p.Grab.isSelected))
                {
                    throw new InvalidOperationException("Release all products before saving.");
                }

                if (products.Length > ArrangementStore.MaximumProducts)
                {
                    throw new InvalidOperationException("Save up to 128 products in one layout.");
                }

                var frame = Pose.identity;
                string frameId = "";
                if (room)
                {
                    room.TryArrangementFrame(null, out frameId, out frame);
                }

                var inverse = Quaternion.Inverse(frame.rotation);
                title = string.IsNullOrWhiteSpace(title) ? "Layout " + (slot + 1) : title.Trim();
                if (title.Length > 64)
                {
                    title = title.Substring(0, 64);
                }

                var data = new ArrangementData
                {
                    name = title,
                    savedUtc = DateTime.UtcNow.ToString("O"),
                    frameId = frameId,
                    viewerPosition = viewerCamera
                        ? inverse * (viewerCamera.transform.position - frame.position)
                        : Vector3.zero,
                    viewerRotation = viewerCamera
                        ? inverse * Heading(viewerCamera.transform.rotation)
                        : Quaternion.identity
                };
                foreach (var product in products)
                {
                    var definition = product.Definition;
                    if (!definition
                        || string.IsNullOrEmpty(definition.PersistentId)
                        || catalog.FindProduct(definition.PersistentId) != definition)
                    {
                        throw new InvalidOperationException("A product is not linked to the catalog. Place it from a product card before saving.");
                    }

                    data.products.Add(new ArrangementProduct { productId = definition.PersistentId, displayName = product.DisplayName, position = inverse * (product.transform.position - frame.position), rotation = inverse * product.transform.rotation, localScale = product.transform.lossyScale, resetScale = product.DefaultLocalScale, snapping = product.GetComponent<ProductSpatialConstraint>()?.CaptureSnapState(frame.rotation) });
                }

                ArrangementStore.Save(StoragePath, slot, data);
                message = $"Saved {title}: {products.Length} product(s). "
                    + (string.IsNullOrEmpty(frameId)
                    ? "No scanned floor; use Place near me after changing spaces."
                    : "Linked to this room's floor.");
                return true;
            }
            catch (Exception error)
            {
                message = "Could not save: " + error.Message;
                return false;
            }
        }

        public bool Load(int slot, bool nearViewer, out string message)
        {
            GameObject staged = null;
            try
            {
                FindReferences();
                EnsureReady();
                var previous = PlacedProducts();
                if (previous.Any(p => p.Grab && p.Grab.isSelected))
                {
                    throw new InvalidOperationException("Release all products before loading.");
                }

                var data = ArrangementStore.Read(StoragePath, slot, out bool recovered);
                if (data == null)
                {
                    throw new InvalidOperationException("This slot is empty.");
                }

                var definitions = data.products.Select(p => catalog.FindProduct(p.productId)).ToArray();
                for (int i = 0; i < definitions.Length; i++)
                {
                    if (!definitions[i] || !definitions[i].Prefab)
                    {
                        throw new InvalidOperationException("Missing model: "
                            + data.products[i].displayName
                            + ". Its original library entry must be available.");
                    }
                }

                Pose frame = ResolveFrame(data, nearViewer);
                staged = new GameObject("Arrangement - " + data.name);
                staged.SetActive(false);
                for (int i = 0; i < definitions.Length; i++)
                {
                    var saved = data.products[i];
                    var product = catalog.CreateProduct(
                        definitions[i],
                        new Pose(frame.position + frame.rotation * saved.position, frame.rotation * saved.rotation),
                        saved.localScale,
                        saved.resetScale,
                        staged.transform
                    );
                    product.SetDisplayName(saved.displayName);
                    product.name = saved.displayName;
                    product.GetComponent<ProductSpatialConstraint>()?.RestoreSnapState(saved.snapping, frame.rotation, nearViewer);
                }

                if (selection)
                {
                    selection.Deselect();
                }

                foreach (var product in previous)
                {
                    product.gameObject.SetActive(false);
                    Destroy(product.gameObject);
                }

                staged.SetActive(true);
                while (staged.transform.childCount > 0)
                {
                    staged.transform.GetChild(0).SetParent(null, true);
                }

                Destroy(staged);
                staged = null;
                Physics.SyncTransforms();
                message = $"Loaded {data.name}: {data.products.Count} product(s)"
                    + (nearViewer ? " near you." : ".")
                    + (recovered ? " Recovered the previous valid save." : "");
                return true;
            }
            catch (Exception error)
            {
                if (staged)
                {
                    Destroy(staged);
                }

                message = "Could not load: " + error.Message;
                return false;
            }
        }

        void EnsureReady()
        {
            if (!Ready)
            {
                throw new InvalidOperationException("Wait for the local model library to finish loading.");
            }

            if (!catalog)
            {
                throw new InvalidOperationException("The product catalog is missing.");
            }
        }

        Pose ResolveFrame(ArrangementData data, bool nearViewer)
        {
            if (!nearViewer)
            {
                if (string.IsNullOrEmpty(data.frameId))
                {
                    return Pose.identity;
                }

                if (room && room.TryArrangementFrame(data.frameId, out _, out var savedFrame))
                {
                    return savedFrame;
                }

                throw new InvalidOperationException("The saved room is not available. Scan the same room, or use Place near me.");
            }

            if (!viewerCamera)
            {
                throw new InvalidOperationException("A tracked camera is needed for Place near me.");
            }

            var rotation = Heading(viewerCamera.transform.rotation) * Quaternion.Inverse(Heading(data.viewerRotation));
            var target = viewerCamera.transform.position;
            if (!string.IsNullOrEmpty(data.frameId) && room && room.TryArrangementFrame(null, out _, out var floor))
            {
                target.y = floor.position.y + data.viewerPosition.y;
            }

            return new Pose(target - rotation * data.viewerPosition, rotation);
        }

        static Quaternion Heading(Quaternion rotation)
        {
            var forward = Vector3.ProjectOnPlane(rotation * Vector3.forward, Vector3.up);
            return forward.sqrMagnitude > 0.001f
                ? Quaternion.LookRotation(forward, Vector3.up)
                : Quaternion.identity;
        }
    }
}
