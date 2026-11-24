using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.Universal;

namespace SpatialProductViewer
{
    public sealed class ProductOutlineRendererFeature : ScriptableRendererFeature
    {
        MaskPass maskPass;
        ContourPass contourPass;

        public override void Create()
        {
            maskPass = new MaskPass
            {
                renderPassEvent = RenderPassEvent.AfterRenderingPrePasses
            };
            contourPass = new ContourPass
            {
                renderPassEvent = RenderPassEvent.BeforeRenderingTransparents
            };
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            var view = ProductOutlineView.Active;
            if (view && view.AllowsCamera(renderingData.cameraData.camera))
            {
                contourPass.renderPassEvent = view.Target.TryGetComponent<GaussianProduct>(out _)
                    ? RenderPassEvent.AfterRenderingTransparents
                    : RenderPassEvent.BeforeRenderingTransparents;
                renderer.EnqueuePass(maskPass);
                renderer.EnqueuePass(contourPass);
            }
        }

        sealed class FrameMask : ContextItem
        {
            public TextureHandle texture;

            public override void Reset()
            {
                texture = default;
            }
        }

        sealed class MaskPass : ScriptableRenderPass
        {
            class MaskData
            {
                public ProductOutlineView view;
                public Camera camera;
            }

            public override void RecordRenderGraph(RenderGraph graph, ContextContainer frameData)
            {
                var cameraData = frameData.Get<UniversalCameraData>();
                var outline = ProductOutlineView.Active;
                if (!outline || !outline.AllowsCamera(cameraData.camera))
                {
                    return;
                }

                var textureDescriptor = cameraData.cameraTargetDescriptor;
                textureDescriptor.graphicsFormat = GraphicsFormat.R8_UNorm;
                textureDescriptor.depthStencilFormat = GraphicsFormat.None;
                textureDescriptor.msaaSamples = 1;
                textureDescriptor.bindMS = false;
                textureDescriptor.useMipMap = false;
                textureDescriptor.autoGenerateMips = false;
                var maskTexture = UniversalRenderer.CreateRenderGraphTexture(graph, textureDescriptor, "Selected product silhouette", true, FilterMode.Point);
                frameData.GetOrCreate<FrameMask>().texture = maskTexture;
                using (var builder = graph.AddRasterRenderPass<MaskData>("Product silhouette", out var data))
                {
                    data.view = outline;
                    data.camera = cameraData.camera;
                    builder.SetRenderAttachment(maskTexture, 0, AccessFlags.Write);
                    builder.AllowGlobalStateModification(true);
                    builder.SetRenderFunc(static (
                        MaskData renderData,
                        RasterGraphContext context
                    ) => renderData.view.DrawMask(context.cmd, renderData.camera));
                }
            }
        }

        sealed class ContourPass : ScriptableRenderPass
        {
            static readonly int ColorId = Shader.PropertyToID("_OutlineColor");
            static readonly int WidthId = Shader.PropertyToID("_OutlineWidthPixels");
            static readonly int TexelId = Shader.PropertyToID("_OutlineTexelSize");

            class CompositeData
            {
                public TextureHandle mask;
                public Material material;
                public Color color;
                public float width;
                public Vector4 texelSize;
            }

            public ContourPass()
            {
                requiresIntermediateTexture = true;
            }

            public override void RecordRenderGraph(RenderGraph graph, ContextContainer frameData)
            {
                var cameraData = frameData.Get<UniversalCameraData>();
                var resources = frameData.Get<UniversalResourceData>();
                var outline = ProductOutlineView.Active;
                if (!outline || !outline.AllowsCamera(cameraData.camera) || !frameData.Contains<FrameMask>())
                {
                    return;
                }

                var maskTexture = frameData.Get<FrameMask>().texture;
                if (!maskTexture.IsValid())
                {
                    return;
                }

                var textureDescriptor = cameraData.cameraTargetDescriptor;
                using (var builder = graph.AddRasterRenderPass<CompositeData>("Product contour", out var data))
                {
                    data.mask = maskTexture;
                    data.material = outline.OutlineMaterial;
                    data.color = outline.OutlineColor;
                    data.width = outline.WidthPixels;
                    data.texelSize = new Vector4(
                        1f / textureDescriptor.width,
                        1f / textureDescriptor.height,
                        textureDescriptor.width,
                        textureDescriptor.height
                    );
                    builder.UseTexture(maskTexture, AccessFlags.Read);
                    builder.SetRenderAttachment(resources.activeColorTexture, 0, AccessFlags.ReadWrite);
                    if (resources.activeDepthTexture.IsValid())
                    {
                        builder.SetRenderAttachmentDepth(resources.activeDepthTexture, AccessFlags.Read);
                    }

                    builder.AllowGlobalStateModification(true);
                    builder.SetRenderFunc(static (CompositeData renderData, RasterGraphContext context) =>
                    {
                        renderData.material.SetColor(ColorId, renderData.color);
                        renderData.material.SetFloat(WidthId, renderData.width);
                        renderData.material.SetVector(TexelId, renderData.texelSize);
                        Blitter.BlitTexture(context.cmd, renderData.mask, new Vector4(1, 1, 0, 0), renderData.material, 0);
                    });
                }
            }
        }
    }
}
