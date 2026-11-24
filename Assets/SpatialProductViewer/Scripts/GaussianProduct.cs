using Gsplat;
using UnityEngine;
using UnityEngine.Rendering;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent]
    public sealed class GaussianProduct : MonoBehaviour
    {
        [SerializeField]
        GsplatRenderer splatRenderer;

        MaterialPropertyBlock maskProperties;

        public GsplatAsset Asset => splatRenderer ? splatRenderer.GsplatAsset : null;

        public void SetAsset(GsplatAsset asset, float fileUnits = 1)
        {
            splatRenderer.GsplatAsset = asset;
            splatRenderer.transform.localScale = Vector3.one * fileUnits;
        }

        public Bounds LocalBounds
        {
            get
            {
                if (!Asset)
                {
                    return new Bounds();
                }

                return TransformBounds(Asset.Bounds, transform.worldToLocalMatrix * splatRenderer.transform.localToWorldMatrix);
            }
        }

        public Bounds WorldBounds => TransformBounds(LocalBounds, transform.localToWorldMatrix);

        public void SetHovered(bool hovered)
        {
            if (splatRenderer)
            {
                splatRenderer.Brightness = hovered ? 1.15f : 1;
            }
        }

        public void DrawMask(RasterCommandBuffer command, Camera camera)
        {
            if (!splatRenderer
                || !splatRenderer.isActiveAndEnabled
                || (camera.cullingMask & (1 << splatRenderer.gameObject.layer)) == 0)
            {
                return;
            }

            var resource = splatRenderer.GsplatResource;
            if (!Asset || resource == null || resource.UploadedCount == 0 || resource.Disposed)
            {
                return;
            }

            var settings = GsplatSettings.Instance;
            maskProperties ??= new MaterialPropertyBlock();
            Asset.SetupMaterialPropertyBlock(maskProperties, resource);
            maskProperties.SetInteger("_SplatCount", (int)resource.UploadedCount);
            maskProperties.SetInteger("_SplatInstanceSize", (int)settings.SplatInstanceSize);
            maskProperties.SetInteger("_Antialiased", Asset.Antialiased ? 1 : 0);
            maskProperties.SetFloat("_ScaleFactor", 1 - splatRenderer.SplatDownscaleFactor);
            maskProperties.SetMatrix("_MATRIX_M", splatRenderer.transform.localToWorldMatrix);
            var material = Asset.Materials[0];
            int pass = material.FindPass("SelectionMask");
            if (pass >= 0)
            {
                command.DrawMeshInstancedProcedural(
                    settings.Mesh,
                    0,
                    material,
                    pass,
                    Mathf.CeilToInt(resource.UploadedCount / (float)settings.SplatInstanceSize),
                    maskProperties
                );
            }
        }

        static Bounds TransformBounds(Bounds bounds, Matrix4x4 matrix)
        {
            var halfSize = bounds.extents;
            var axisX = matrix.MultiplyVector(Vector3.right * halfSize.x);
            var axisY = matrix.MultiplyVector(Vector3.up * halfSize.y);
            var axisZ = matrix.MultiplyVector(Vector3.forward * halfSize.z);
            var worldSize = new Vector3(
                Mathf.Abs(axisX.x)
                    + Mathf.Abs(axisY.x)
                    + Mathf.Abs(axisZ.x),
                Mathf.Abs(axisX.y)
                    + Mathf.Abs(axisY.y)
                    + Mathf.Abs(axisZ.y),
                Mathf.Abs(axisX.z)
                    + Mathf.Abs(axisY.z)
                    + Mathf.Abs(axisZ.z)
            ) * 2;
            return new Bounds(matrix.MultiplyPoint3x4(bounds.center), worldSize);
        }
    }
}
