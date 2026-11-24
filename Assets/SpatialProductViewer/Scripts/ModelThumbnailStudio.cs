using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace SpatialProductViewer
{
    public sealed class ModelThumbnailStudio : MonoBehaviour
    {
        [SerializeField]
        Camera thumbnailCamera;
        [SerializeField]
        Transform modelStage;
        [SerializeField, Range(64, 512)]
        int resolution = 256;
        [SerializeField, Range(8, 31)]
        int previewLayer = 31;

        public Sprite Capture(SelectableProduct template, Vector3 dimensions)
        {
            if (!thumbnailCamera || !modelStage || SystemInfo.graphicsDeviceType == GraphicsDeviceType.Null)
            {
                return null;
            }

            var root = new GameObject("Thumbnail model");
            root.transform.SetParent(modelStage, false);
            RenderTexture target = null;
            Texture2D pixels = null;
            var previous = RenderTexture.active;
            try
            {
                foreach (Transform child in template.transform)
                {
                    Instantiate(child.gameObject, root.transform, false).SetActive(true);
                }

                foreach (var child in root.GetComponentsInChildren<Transform>(true))
                {
                    child.gameObject.layer = previewLayer;
                }

                var bounds = template.GetLocalBounds();
                float factor = 1f / Mathf.Max(dimensions.x, dimensions.y, dimensions.z);
                root.transform.localScale = new Vector3(dimensions.x / bounds.size.x, dimensions.y / bounds.size.y, dimensions.z / bounds.size.z) * factor;
                root.transform.localPosition = -Vector3.Scale(bounds.center, root.transform.localScale);
                thumbnailCamera.cullingMask = 1 << previewLayer;
                target = new RenderTexture(resolution, resolution, 24, RenderTextureFormat.ARGB32)
                {
                    antiAliasing = 1
                };
                target.Create();
                foreach (var splat in root.GetComponentsInChildren<Gsplat.GsplatRenderer>())
                {
#if UNITY_EDITOR
                    foreach (var material in splat.GsplatAsset.Materials)
                    {
                        UnityEditor.ShaderUtil.CompilePass(material, 0, true);
                    }

#endif
                    splat.Update();
                    splat.PrepareForSortAndDraw();
                    splat.Draw();
                }

                var request = new UniversalRenderPipeline.SingleCameraRequest
                {
                    destination = target
                };
                RenderPipeline.SubmitRenderRequest(thumbnailCamera, request);
                RenderTexture.active = target;
                pixels = new Texture2D(resolution, resolution, TextureFormat.RGBA32, false);
                pixels.ReadPixels(new Rect(0, 0, resolution, resolution), 0, 0);
                pixels.Apply(false, true);
                var sprite = Sprite.Create(pixels, new Rect(0, 0, resolution, resolution), Vector2.one * 0.5f, 100);
                pixels = null;
                return sprite;
            }
            catch (System.Exception e)
            {
                Debug.LogWarning("Model thumbnail unavailable: " + e.Message, this);
                return null;
            }
            finally
            {
                RenderTexture.active = previous;
                if (target)
                {
                    target.Release();
                    Destroy(target);
                }

                if (pixels)
                {
                    Destroy(pixels);
                }

                if (!template.GetComponent<GaussianProduct>())
                {
                    root.SetActive(false);
                }

                Destroy(root);
            }
        }
    }
}
