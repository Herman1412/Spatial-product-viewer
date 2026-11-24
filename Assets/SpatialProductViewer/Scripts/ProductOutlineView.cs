using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace SpatialProductViewer
{
    [ExecuteAlways, DisallowMultipleComponent]
    public sealed class ProductOutlineView : MonoBehaviour
    {
        [SerializeField]
        Material maskMaterial;
        [SerializeField]
        Material outlineMaterial;
        [SerializeField, Range(1, 8)]
        float widthPixels = 3;

        struct Part
        {
            public Renderer renderer;
            public Material mask;
            public int submesh;
        }

        readonly List<Part> parts = new List<Part>();
        readonly Dictionary<Material, Material> masks = new Dictionary<Material, Material>();
        SelectableProduct target;
        GaussianProduct gaussian;
        Camera viewerCamera;
        Color outlineColor = Color.green;

        public static ProductOutlineView Active { get; private set; }
        public Material OutlineMaterial => outlineMaterial;
        public Color OutlineColor => outlineColor;
        public float WidthPixels => widthPixels;
        public SelectableProduct Target => target;
        public bool Ready => target
            && target.isActiveAndEnabled
            && maskMaterial
            && outlineMaterial
            && (parts.Count > 0
            || (gaussian
            && gaussian.Asset));

        void OnEnable()
        {
            Active = this;
        }

        void OnDisable()
        {
            if (Active == this)
            {
                Active = null;
            }

            Hide();
        }

        void OnDestroy()
        {
            Clear();
        }

        public void Refresh(SelectableProduct product, Color color, Camera camera)
        {
            outlineColor = color;
            viewerCamera = camera;
            if (target != product)
            {
                Clear();
                target = product;
                Build();
            }
        }

        public void Hide()
        {
            Clear();
            target = null;
        }

        public bool AllowsCamera(Camera camera)
        {
            if (!Ready || camera.cameraType == CameraType.Preview || camera.cameraType == CameraType.Reflection)
            {
                return false;
            }

            if (camera.cameraType == CameraType.SceneView)
            {
                return !Application.isPlaying;
            }

            return viewerCamera ? camera == viewerCamera : camera.CompareTag("MainCamera");
        }

        void Build()
        {
            if (!target || !maskMaterial)
            {
                return;
            }

            gaussian = target.GetComponent<GaussianProduct>();
            var renderers = target.ModelRenderers;
            if (renderers == null)
            {
                return;
            }

            foreach (var renderer in renderers)
            {
                if (!renderer)
                {
                    continue;
                }

                Mesh mesh = renderer is SkinnedMeshRenderer skin
                    ? skin.sharedMesh
                    : renderer.GetComponent<MeshFilter>()?.sharedMesh;
                if (!mesh)
                {
                    continue;
                }

                var materials = renderer.sharedMaterials;
                if (materials.Length == 0)
                {
                    continue;
                }

                for (int submesh = 0; submesh < mesh.subMeshCount; submesh++)
                {
                    var source = materials[Mathf.Min(submesh, materials.Length - 1)];
                    if (!source)
                    {
                        continue;
                    }

                    if (!masks.TryGetValue(source, out var mask))
                    {
                        mask = new Material(maskMaterial)
                        {
                            name = "Outline alpha: " + source.name,
                            hideFlags = HideFlags.HideAndDontSave
                        };
                        ConfigureAlpha(source, mask);
                        masks.Add(source, mask);
                    }

                    parts.Add(new Part { renderer = renderer, mask = mask, submesh = submesh });
                }
            }
        }

        static void ConfigureAlpha(Material source, Material mask)
        {
            bool cutout = source.IsKeywordEnabled("_ALPHATEST_ON")
                || (source.HasProperty("_AlphaClip")
                && source.GetFloat("_AlphaClip") > 0.5f);
            bool transparent = source.IsKeywordEnabled("_SURFACE_TYPE_TRANSPARENT")
                || (source.HasProperty("_Surface")
                && source.GetFloat("_Surface") > 0.5f);
            string texture = source.HasProperty("baseColorTexture")
                ? "baseColorTexture"
                : source.HasProperty("diffuseTexture")
                    ? "diffuseTexture"
                    : "_BaseMap";
            string factor = source.HasProperty("baseColorFactor")
                ? "baseColorFactor"
                : source.HasProperty("diffuseFactor")
                    ? "diffuseFactor"
                    : "_BaseColor";
            float cutoff = cutout
                ? source.HasProperty("alphaCutoff")
                    ? source.GetFloat("alphaCutoff")
                    : source.HasProperty("_Cutoff")
                        ? source.GetFloat("_Cutoff")
                        : 0.5f
                : 0.05f;
            mask.SetFloat("_OutlineUseAlpha", cutout || transparent ? 1 : 0);
            mask.SetFloat("_OutlineCutoff", cutoff);
            mask.SetFloat("_OutlineOpacity", source.HasProperty(factor) ? source.GetColor(factor).a : 1);
            mask.SetTexture(
                "_OutlineAlphaTexture",
                source.HasProperty(texture) && source.GetTexture(texture)
                ? source.GetTexture(texture)
                : Texture2D.whiteTexture
            );
            var st = new Vector4(1, 1, 0, 0);
            var rotation = Vector4.zero;
            if (texture == "_BaseMap" && source.HasProperty(texture))
            {
                var scale = source.GetTextureScale(texture);
                var offset = source.GetTextureOffset(texture);
                st = new Vector4(scale.x, scale.y, offset.x, offset.y);
            }
            else if (source.IsKeywordEnabled("_TEXTURE_TRANSFORM"))
            {
                if (source.HasProperty(texture + "_ST"))
                {
                    st = source.GetVector(texture + "_ST");
                }

                if (source.HasProperty(texture + "_Rotation"))
                {
                    rotation = source.GetVector(texture + "_Rotation");
                }
            }

            mask.SetVector("_OutlineUVTransform", st);
            mask.SetVector("_OutlineUVRotation", rotation);
            mask.SetFloat(
                "_OutlineUVSet",
                source.HasProperty(texture + "_texCoord") ? source.GetFloat(texture + "_texCoord") : 0
            );
        }

        public void DrawMask(RasterCommandBuffer command, Camera camera)
        {
            if (gaussian)
            {
                gaussian.DrawMask(command, camera);
            }

            foreach (var part in parts)
            {
                if (part.renderer
                    && part.renderer.enabled
                    && !part.renderer.forceRenderingOff
                    && part.renderer.gameObject.activeInHierarchy
                    && (camera.cullingMask & (1 << part.renderer.gameObject.layer)) != 0)
                {
                    command.DrawRenderer(part.renderer, part.mask, part.submesh, 0);
                }
            }
        }

        void Clear()
        {
            gaussian = null;
            parts.Clear();
            foreach (var mask in masks.Values)
            {
                if (mask)
                {
                    if (Application.isPlaying)
                    {
                        Destroy(mask);
                    }
                    else
                    {
                        DestroyImmediate(mask);
                    }
                }
            }

            masks.Clear();
        }
    }
}
