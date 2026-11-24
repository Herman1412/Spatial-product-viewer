using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;
using UnityEngine.XR.Interaction.Toolkit.Interactors;
using UnityEngine.XR.Interaction.Toolkit.Transformers;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent, RequireComponent(typeof(XRGrabInteractable))]
    public sealed class SelectableProduct : MonoBehaviour
    {
        [SerializeField]
        string displayName = "Placeholder Cube";
        [SerializeField]
        XRGrabInteractable grab;
        [SerializeField]
        XRGeneralGrabTransformer grabTransformer;
        [SerializeField]
        Renderer[] modelRenderers;
        [SerializeField]
        ProductSelectionController selectionController;
        [SerializeField]
        Color hoverTint = new Color(0.35f, 0.9f, 1f);
        [SerializeField, Range(0f, 1f)]
        float hoverTintStrength = 0.45f;
        [SerializeField, HideInInspector]
        Vector3 defaultLocalScale;
        [SerializeField, HideInInspector]
        bool hasDefaultScale;
        [SerializeField, HideInInspector]
        ProductDefinition definition;

        MaterialPropertyBlock[] originalProperties;
        MaterialPropertyBlock tintProperties;
        bool highlighted;
        static readonly int BaseColor = Shader.PropertyToID("_BaseColor");
        static readonly int GltfBaseColor = Shader.PropertyToID("baseColorFactor");
        static readonly int ColorProperty = Shader.PropertyToID("_Color");

        public string DisplayName => displayName;
        public XRGrabInteractable Grab => grab;
        public bool ScaleUnlocked { get; private set; }
        public ProductDefinition Definition => definition;
        public Vector3 DefaultLocalScale => defaultLocalScale;
        public Renderer[] ModelRenderers => modelRenderers;

        public void ConfigureProduct(ProductDefinition source, Vector3 resetScale)
        {
            definition = source;
            defaultLocalScale = resetScale;
            hasDefaultScale = true;
        }

        public void SetDisplayName(string value)
        {
            displayName = value;
        }

        public void ConfigureImportedModel()
        {
            modelRenderers = GetComponentsInChildren<Renderer>(true);
            var bounds = GetLocalBounds();
            var box = GetComponent<BoxCollider>();
            box.center = bounds.center;
            box.size = Vector3.Max(bounds.size, Vector3.one * 0.001f);
            hasDefaultScale = false;
        }

        public void SetModelMaterial(Material material)
        {
            if (!material || modelRenderers == null)
            {
                return;
            }

            foreach (var renderer in modelRenderers)
            {
                if (renderer)
                {
                    renderer.sharedMaterial = material;
                }
            }
        }

        void Awake()
        {
            if (!hasDefaultScale)
            {
                defaultLocalScale = transform.localScale;
                hasDefaultScale = true;
            }

            if (!grab)
            {
                grab = GetComponent<XRGrabInteractable>();
            }

            if (!grabTransformer)
            {
                grabTransformer = GetComponent<XRGeneralGrabTransformer>();
            }

            if (modelRenderers == null || modelRenderers.Length == 0)
            {
                modelRenderers = GetComponentsInChildren<Renderer>();
            }

            var occlusion = FindAnyObjectByType<EnvironmentOcclusion>();
            if (occlusion)
            {
                occlusion.Apply(modelRenderers);
            }

            originalProperties = new MaterialPropertyBlock[modelRenderers.Length];
            tintProperties = new MaterialPropertyBlock();
            for (int i = 0; i < modelRenderers.Length; i++)
            {
                originalProperties[i] = new MaterialPropertyBlock();
                if (modelRenderers[i])
                {
                    modelRenderers[i].GetPropertyBlock(originalProperties[i]);
                }
            }

            SetScaleUnlocked(false);
        }

        void OnEnable()
        {
            if (!selectionController)
            {
                selectionController = FindAnyObjectByType<ProductSelectionController>();
            }

            grab.hoverEntered.AddListener(OnHoverEntered);
            grab.hoverExited.AddListener(OnHoverExited);
        }

        void OnDisable()
        {
            grab.hoverEntered.RemoveListener(OnHoverEntered);
            grab.hoverExited.RemoveListener(OnHoverExited);
            RestoreAppearance();
            if (selectionController)
            {
                selectionController.Forget(this);
            }
        }

        void OnHoverEntered(HoverEnterEventArgs _)
        {
            RefreshAppearance();
        }

        void OnHoverExited(HoverExitEventArgs _)
        {
            RefreshAppearance();
        }

        void Update()
        {
            if (!selectionController || !grab.isHovered)
            {
                return;
            }

            foreach (var hover in grab.interactorsHovering)
            {
                if (hover is not XRBaseInputInteractor input || !input.activateInput.ReadWasPerformedThisFrame())
                {
                    continue;
                }

                if (input is NearFarInteractor nearFar && nearFar.TryGetCurrentUIRaycastResult(out _))
                {
                    continue;
                }

                selectionController.Select(this);
                break;
            }
        }

        public void SetScaleUnlocked(bool unlocked)
        {
            ScaleUnlocked = unlocked;
            if (grab)
            {
                grab.trackScale = unlocked;
            }

            if (grabTransformer)
            {
                grabTransformer.allowOneHandedScaling = false;
                grabTransformer.allowTwoHandedScaling = unlocked;
            }
        }

        public void ResetScale()
        {
            if (!hasDefaultScale || !grab || grab.isSelected)
            {
                return;
            }

            SetScaleUnlocked(false);
            transform.localScale = defaultLocalScale;
            if (grabTransformer)
            {
                grabTransformer.OnLink(grab);
            }
        }

        public void RefreshAppearance()
        {
            RestoreAppearance();
            if (!grab.isHovered)
            {
                return;
            }

            if (TryGetComponent<GaussianProduct>(out var gaussian))
            {
                gaussian.SetHovered(true);
            }

            for (int i = 0; i < modelRenderers.Length; i++)
            {
                var renderer = modelRenderers[i];
                if (!renderer || !renderer.sharedMaterial)
                {
                    continue;
                }

                renderer.GetPropertyBlock(tintProperties);
                var material = renderer.sharedMaterial;
                int property = material.HasProperty(BaseColor)
                    ? BaseColor
                    : material.HasProperty(GltfBaseColor)
                        ? GltfBaseColor
                        : ColorProperty;
                if (!material.HasProperty(property))
                {
                    continue;
                }

                var original = originalProperties[i].HasColor(property)
                    ? originalProperties[i].GetColor(property)
                    : material.GetColor(property);
                tintProperties.SetColor(property, Color.Lerp(original, hoverTint, hoverTintStrength));
                renderer.SetPropertyBlock(tintProperties);
            }

            highlighted = true;
        }

        public void RestoreAppearance()
        {
            if (TryGetComponent<GaussianProduct>(out var gaussian))
            {
                gaussian.SetHovered(false);
            }

            if (!highlighted || originalProperties == null)
            {
                return;
            }

            for (int i = 0; i < modelRenderers.Length; i++)
            {
                if (modelRenderers[i])
                {
                    modelRenderers[i].SetPropertyBlock(originalProperties[i]);
                }
            }

            highlighted = false;
        }

        public Bounds GetLocalBounds()
        {
            if (TryGetComponent<GaussianProduct>(out var gaussian) && gaussian.Asset)
            {
                return gaussian.LocalBounds;
            }

            var result = new Bounds();
            bool initialized = false;
            foreach (var renderer in modelRenderers)
            {
                if (!renderer)
                {
                    continue;
                }

                var bounds = renderer.localBounds;
                var matrix = transform.worldToLocalMatrix * renderer.localToWorldMatrix;
                for (int i = 0; i < 8; i++)
                {
                    var sign = new Vector3((i & 1) == 0 ? -1 : 1, (i & 2) == 0 ? -1 : 1, (i & 4) == 0 ? -1 : 1);
                    var point = matrix.MultiplyPoint3x4(bounds.center + Vector3.Scale(bounds.extents, sign));
                    if (!initialized)
                    {
                        result = new Bounds(point, Vector3.zero);
                        initialized = true;
                    }
                    else
                    {
                        result.Encapsulate(point);
                    }
                }
            }

            return result;
        }

        public Bounds GetWorldBounds()
        {
            if (TryGetComponent<GaussianProduct>(out var gaussian) && gaussian.Asset)
            {
                return gaussian.WorldBounds;
            }

            var result = new Bounds(transform.position, Vector3.zero);
            bool initialized = false;
            foreach (var renderer in modelRenderers)
            {
                if (!renderer)
                {
                    continue;
                }

                if (!initialized)
                {
                    result = renderer.bounds;
                    initialized = true;
                }
                else
                {
                    result.Encapsulate(renderer.bounds);
                }
            }

            return result;
        }
    }
}
