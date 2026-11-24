using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;
using UnityEngine.XR.Interaction.Toolkit.Transformers;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent, RequireComponent(typeof(SelectableProduct))]
    public sealed class ProductSpatialConstraint : XRBaseGrabTransformer
    {
        [SerializeField]
        RoomGeometryService room;
        [SerializeField, Min(0.005f)]
        float maximumStep = 0.02f;
        [SerializeField, Range(8, 256)]
        int maximumSteps = 128;
        [SerializeField]
        ProductSurfaceMode surfaceMode;
        [SerializeField]
        int rotationStep;
        [SerializeField, Min(0.05f)]
        float surfaceCaptureDistance = 0.5f;
        [SerializeField, HideInInspector]
        string surfaceId;
        [SerializeField, HideInInspector]
        int wallSide = 1;
        [SerializeField, HideInInspector]
        Quaternion rotationReference = Quaternion.identity;
        [SerializeField, HideInInspector]
        bool hasRotationReference;

        bool waitingForSurface;
        string snapStatus = "Free placement";
        SelectableProduct product;
        Bounds localBounds;
        Pose accepted;
        Vector3 acceptedScale;
        bool initialized;
        int revision = -1;

        public bool MovementBlocked { get; private set; }
        public ProductSurfaceMode SurfaceMode => ProductSnapState.NormalizeSurface(surfaceMode);
        public int RotationStep => rotationStep;
        public bool HasSurfaceBinding => !string.IsNullOrEmpty(surfaceId);
        public string SnapStatus => snapStatus;
        public bool WaitingForRoom => waitingForSurface || (room && room.RoomGuardEnabled && !room.HasRoom);
        public bool HasRoom => room && room.HasRoom;

        public string FitLabel
        {
            get
            {
                if (WaitingForRoom)
                {
                    return "Waiting for room data";
                }
                else if (MovementBlocked)
                {
                    return "Movement blocked by room bounds";
                }
                else if (Overlapping)
                {
                    return "Does not fit: overlaps room or products";
                }
                else if (!HasRoom)
                {
                    return "Scan room to check fit";
                }
                else if (room.IsEditorPreview)
                {
                    return "Fits editor sample room";
                }
                else
                {
                    return "Fits scanned room";
                }
            }
        }

        public Color FitColor
        {
            get
            {
                if (WaitingForRoom)
                {
                    return new Color(1f, 0.75f, 0.2f);
                }
                else if (MovementBlocked || Overlapping)
                {
                    return new Color(1f, 0.25f, 0.2f);
                }
                else if (!HasRoom)
                {
                    return new Color(1f, 0.75f, 0.2f);
                }
                else
                {
                    return new Color(0.25f, 1f, 0.6f);
                }
            }
        }

        public bool Overlapping => room && (room.OverlapScore(this, CurrentBox) > 0.0001f || (room.HasFloor && !room.FitsFloor(CurrentBox)));

        public SpatialGeometry.Box CurrentBox
        {
            get
            {
                if (initialized && product && product.Grab.isSelected)
                {
                    return SpatialGeometry.FromProduct(localBounds, accepted, acceptedScale);
                }
                else
                {
                    return SpatialGeometry.FromProduct(localBounds, new Pose(transform.position, transform.rotation), transform.lossyScale);
                }
            }
        }

        void EnsureReferences()
        {
            if (!product)
            {
                product = GetComponent<SelectableProduct>();
            }

            if (!room)
            {
                room = FindAnyObjectByType<RoomGeometryService>();
            }

            localBounds = product.GetLocalBounds();
            if (room)
            {
                room.Register(this);
            }

            surfaceMode = ProductSnapState.NormalizeSurface(surfaceMode);
            if (!ProductSnapState.ValidStep(rotationStep))
            {
                rotationStep = 0;
            }

            if (rotationStep > 0 && !hasRotationReference)
            {
                rotationReference = room ? room.RotationFrame : Quaternion.identity;
                hasRotationReference = true;
            }
        }

        public void SetSurfaceMode(ProductSurfaceMode mode)
        {
            mode = ProductSnapState.NormalizeSurface(mode);
            if (mode < ProductSurfaceMode.Free
                || mode > ProductSurfaceMode.Wall
                || (product
                && product.Grab.isSelected))
            {
                return;
            }

            surfaceMode = mode;
            surfaceId = null;
            wallSide = 1;
            waitingForSurface = false;
            ApplySettingsNow();
        }

        public void SetRotationStep(int step)
        {
            if (!ProductSnapState.ValidStep(step) || (product && product.Grab.isSelected))
            {
                return;
            }

            EnsureReferences();
            bool wasFree = rotationStep == 0;
            rotationStep = step;
            if (step == 0)
            {
                hasRotationReference = false;
            }
            else if (wasFree || !hasRotationReference)
            {
                rotationReference = room ? room.RotationFrame : Quaternion.identity;
                hasRotationReference = true;
            }

            ApplySettingsNow();
        }

        void ApplySettingsNow()
        {
            EnsureReferences();
            Capture();
            revision = -1;
            var pose = new Pose(transform.position, transform.rotation);
            var scale = transform.localScale;
            Constrain(ref pose, ref scale);
            transform.SetPositionAndRotation(pose.position, pose.rotation);
            transform.localScale = scale;
        }

        public ProductSnapState CaptureSnapState(Quaternion frame)
        {
            return new ProductSnapState
            {
                surfaceMode = surfaceMode,
                rotationStep = rotationStep,
                hasRotationReference = hasRotationReference,
                rotationReference = Quaternion.Inverse(frame) * rotationReference,
                surfaceId = surfaceId,
                wallSide = wallSide
            };
        }

        public void RestoreSnapState(ProductSnapState state, Quaternion frame, bool nearViewer)
        {
            surfaceMode = ProductSnapState.NormalizeSurface(state?.surfaceMode ?? ProductSurfaceMode.Free);
            rotationStep = state?.rotationStep ?? 0;
            hasRotationReference = state != null && state.hasRotationReference;
            rotationReference = hasRotationReference ? frame * state.rotationReference : Quaternion.identity;
            surfaceId = nearViewer ? null : state?.surfaceId;
            wallSide = state?.wallSide ?? 1;
            revision = -1;
            initialized = false;
        }

        public bool TryDuplicatePose(ref Pose pose)
        {
            EnsureReferences();
            var id = surfaceId;
            int side = wallSide;
            if (room)
            {
                if (!room.TrySnapItem(
                    surfaceMode,
                    localBounds,
                    transform.lossyScale,
                    ref pose,
                    ref id,
                    ref side,
                    rotationStep,
                    rotationReference,
                    surfaceCaptureDistance,
                    this,
                    out _,
                    out _
                ))
                {
                    return false;
                }

                var box = SpatialGeometry.FromProduct(localBounds, pose, transform.lossyScale);
                if (room.RoomGuardEnabled && (!room.FitsFloor(box) || room.OverlapScore(null, box) > 0.0001f))
                {
                    return false;
                }
            }
            else
            {
                pose.rotation = ProductSnapState.SnapYaw(pose.rotation, rotationReference, rotationStep);
            }

            return !SpatialGeometry.Overlaps(CurrentBox, SpatialGeometry.FromProduct(localBounds, pose, transform.lossyScale), 0.005f, out _);
        }

        public override void OnLink(XRGrabInteractable grabInteractable)
        {
            base.OnLink(grabInteractable);
            EnsureReferences();
            Capture();
        }

        public override void OnGrab(XRGrabInteractable grabInteractable)
        {
            base.OnGrab(grabInteractable);
            EnsureReferences();
            Capture();
            MovementBlocked = false;
        }

        void OnEnable()
        {
            EnsureReferences();
            Capture();
        }

        void OnDisable()
        {
            if (room)
            {
                room.Unregister(this);
            }
        }

        void Capture()
        {
            accepted = new Pose(transform.position, transform.rotation);
            acceptedScale = transform.localScale;
            initialized = true;
        }

        public override void Process(
            XRGrabInteractable grabInteractable,
            XRInteractionUpdateOrder.UpdatePhase phase,
            ref Pose targetPose,
            ref Vector3 localScale
        )
        {
            if (phase != XRInteractionUpdateOrder.UpdatePhase.Dynamic
                && phase != XRInteractionUpdateOrder.UpdatePhase.OnBeforeRender)
            {
                return;
            }

            Constrain(ref targetPose, ref localScale);
        }

        void LateUpdate()
        {
            if (!initialized)
            {
                EnsureReferences();
                Capture();
            }

            if (product.Grab.isSelected)
            {
                return;
            }

            bool changed = (transform.position - accepted.position).sqrMagnitude > 0.000001f
                || Quaternion.Angle(transform.rotation, accepted.rotation) > 0.01f
                || (transform.localScale - acceptedScale).sqrMagnitude > 0.000001f;
            if (!changed && room && revision == room.Revision)
            {
                return;
            }

            var pose = new Pose(transform.position, transform.rotation);
            var scale = transform.localScale;
            Constrain(ref pose, ref scale);
            transform.SetPositionAndRotation(pose.position, pose.rotation);
            transform.localScale = scale;
        }

        void Constrain(ref Pose target, ref Vector3 scale)
        {
            if (!initialized)
            {
                EnsureReferences();
                Capture();
            }

            if (!room)
            {
                var center = SpatialGeometry.FromProduct(localBounds, target, scale).center;
                target.rotation = ProductSnapState.SnapYaw(target.rotation, rotationReference, rotationStep);
                target.position = center - target.rotation * Vector3.Scale(localBounds.center, scale);
                MovementBlocked = false;
                snapStatus = surfaceMode == ProductSurfaceMode.Tabletop
                    || surfaceMode == ProductSurfaceMode.Wall
                    || surfaceMode == ProductSurfaceMode.Floor
                    ? "No room service; surface snapping unavailable"
                    : "Free placement";
                accepted = target;
                acceptedScale = scale;
                return;
            }

            revision = room.Revision;
            MovementBlocked = false;
            if (room.RoomGuardEnabled && !room.HasRoom)
            {
                target = accepted;
                scale = acceptedScale;
                MovementBlocked = true;
                snapStatus = "Waiting for room geometry";
                return;
            }

            string nextId = surfaceId;
            int nextSide = wallSide;
            if (!room.TrySnapItem(
                surfaceMode,
                localBounds,
                scale,
                ref target,
                ref nextId,
                ref nextSide,
                rotationStep,
                rotationReference,
                surfaceCaptureDistance,
                this,
                out waitingForSurface,
                out snapStatus
            ))
            {
                target = accepted;
                scale = acceptedScale;
                MovementBlocked = true;
                return;
            }

            bool floorConstraint = room.EffectiveSurface(surfaceMode) == ProductSurfaceMode.Floor;
            if (!room.RoomGuardEnabled && !floorConstraint)
            {
                accepted = target;
                acceptedScale = scale;
                surfaceId = nextId;
                wallSide = nextSide;
                return;
            }

            var start = accepted;
            var startScale = acceptedScale;
            float radius = Vector3.Scale(localBounds.extents, SpatialGeometry.Abs(Vector3.Max(startScale, scale))).magnitude;
            float travel = Vector3.Distance(start.position, target.position)
                + Quaternion.Angle(start.rotation, target.rotation) * Mathf.Deg2Rad * radius
                + Vector3.Scale(localBounds.extents, scale - startScale).magnitude;
            int requested = Mathf.Max(1, Mathf.CeilToInt(travel / maximumStep));
            int steps = Mathf.Min(requested, maximumSteps);
            float previousScore = room.OverlapScore(this, SpatialGeometry.FromProduct(localBounds, start, startScale));
            bool previousFloorFits = room.FitsFloor(SpatialGeometry.FromProduct(localBounds, start, startScale));
            bool attachedAtStart = !string.IsNullOrEmpty(surfaceId) && surfaceId == nextId;
            Pose lastSafe = start;
            Vector3 lastScale = startScale;
            for (int i = 1; i <= steps; i++)
            {
                float t = (float)i / requested;
                var pose = new Pose(
                    Vector3.Lerp(start.position, target.position, t),
                    Quaternion.Slerp(start.rotation, target.rotation, t)
                );
                var testScale = Vector3.Lerp(startScale, scale, t);
                if (attachedAtStart)
                {
                    var id = surfaceId;
                    int side = wallSide;
                    if (!room.TrySnapItem(surfaceMode, localBounds, testScale, ref pose, ref id, ref side, 0, rotationReference, surfaceCaptureDistance, this, out _, out _))
                    {
                        MovementBlocked = true;
                        break;
                    }
                }

                var box = SpatialGeometry.FromProduct(localBounds, pose, testScale);
                bool floorFits = !(room.RoomGuardEnabled || floorConstraint) || room.FitsFloor(box);
                float score = room.RoomGuardEnabled ? room.OverlapScore(this, box) : 0f;
                if ((!floorFits
                    && previousFloorFits)
                    || (score > 0.0001f
                    && (previousScore <= 0.0001f
                    || score >= previousScore - 0.00001f)))
                {
                    MovementBlocked = true;
                    break;
                }

                lastSafe = pose;
                lastScale = testScale;
                previousScore = score;
                previousFloorFits = floorFits;
            }

            if (requested > maximumSteps)
            {
                MovementBlocked = true;
            }

            if (MovementBlocked && rotationStep > 0 && Quaternion.Angle(start.rotation, target.rotation) > 0.01f)
            {
                lastSafe = start;
                lastScale = startScale;
            }

            if (!MovementBlocked)
            {
                lastSafe = target;
                lastScale = scale;
                surfaceId = nextId;
                wallSide = nextSide;
            }

            accepted = lastSafe;
            acceptedScale = lastScale;
            target = accepted;
            scale = acceptedScale;
        }
    }
}
