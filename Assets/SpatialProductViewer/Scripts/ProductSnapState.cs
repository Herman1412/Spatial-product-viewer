using System;
using UnityEngine;

namespace SpatialProductViewer
{
    public enum ProductSurfaceMode
    {
        Free = 0,
        Floor = 2,
        Tabletop = 3,
        Wall = 4
    }

    [Serializable]
    public sealed class ProductSnapState
    {
        public ProductSurfaceMode surfaceMode;
        public int rotationStep;
        public Quaternion rotationReference = Quaternion.identity;
        public bool hasRotationReference;
        public string surfaceId;
        public int wallSide = 1;

        public static ProductSurfaceMode NormalizeSurface(ProductSurfaceMode mode)
        {
            return (int)mode == 1 ? ProductSurfaceMode.Free : mode;
        }

        public static bool ValidStep(int step)
        {
            return step == 0 || step == 15 || step == 45 || step == 90;
        }

        public static Quaternion SnapYaw(Quaternion rotation, Quaternion reference, int step)
        {
            if (!ValidStep(step) || step == 0)
            {
                return rotation;
            }

            var forward = Vector3.ProjectOnPlane(rotation * Vector3.forward, Vector3.up);
            if (forward.sqrMagnitude < 0.0001f)
            {
                forward = Vector3.ProjectOnPlane(rotation * Vector3.up, Vector3.up);
            }

            var basis = Vector3.ProjectOnPlane(reference * Vector3.forward, Vector3.up);
            if (basis.sqrMagnitude < 0.0001f)
            {
                basis = Vector3.forward;
            }

            if (forward.sqrMagnitude < 0.0001f)
            {
                return rotation;
            }

            float angle = Vector3.SignedAngle(basis, forward, Vector3.up);
            return Quaternion.AngleAxis(Mathf.Round(angle / step) * step - angle, Vector3.up) * rotation;
        }
    }
}
