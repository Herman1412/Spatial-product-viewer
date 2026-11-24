using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;
using UnityEngine.XR.Management;
using UnityEngine.XR.OpenXR.Features.Meta;

#if UNITY_ANDROID && !UNITY_EDITOR
using UnityEngine.Android;

#endif
namespace SpatialProductViewer
{
    [DefaultExecutionOrder(-150), DisallowMultipleComponent]
    public sealed class RoomGeometryService : MonoBehaviour
    {
        [SerializeField]
        ARPlaneManager planeManager;
        [SerializeField]
        ARBoundingBoxManager boundingBoxManager;
        [SerializeField]
        bool floorSnapEnabled;
        [SerializeField]
        bool roomGuardEnabled;
        [SerializeField]
        bool showRoom;
        [SerializeField, Min(0.001f)]
        float surfaceThickness = 0.04f;
        [SerializeField, Min(0f)]
        float clearance = 0.005f;
        [Header("Editor-only sample room; stripped from device builds")]
        [SerializeField]
        bool useEditorPreview = true;
        [SerializeField]
        RoomPreviewVolume[] editorVolumes;

        readonly List<Floor> floors = new List<Floor>();
        readonly List<SnappingSurface> snapSurfaces = new List<SnappingSurface>();
        readonly List<SpatialGeometry.Box> obstacles = new List<SpatialGeometry.Box>();
        readonly List<ProductSpatialConstraint> products = new List<ProductSpatialConstraint>();
        float nextRefresh;
        string message = "Waiting for spatial-data permission";
        bool permissionGranted;
        string notice;
        float noticeUntil;
        const string ScenePermission = "com.oculus.permission.USE_SCENE";

        public bool FloorSnapEnabled => floorSnapEnabled;
        public bool RoomGuardEnabled => roomGuardEnabled;
        public bool ShowRoom => showRoom;
        public bool HasFloor => floors.Count > 0;
        public bool HasRoom => floors.Count > 0 || obstacles.Count > 0;
        public int Revision { get; private set; }
        public bool IsEditorPreview { get; private set; }
        public bool SpatialPermissionGranted => permissionGranted;
        public Quaternion RotationFrame => floors.Count > 0 ? floors[0].frame.rotation : Quaternion.identity;

        public string Status
        {
            get
            {
                if (Time.unscaledTime < noticeUntil)
                {
                    return notice;
                }
                else if (HasRoom)
                {
                    return $"{(IsEditorPreview ? "EDITOR SAMPLE" : "Scanned room")}: {floors.Count} floor(s), {obstacles.Count} obstacle(s)";
                }
                else
                {
                    return message;
                }
            }
        }

        sealed class Floor
        {
            public string id;
            public Pose frame;
            public Matrix4x4 inverse;
            public Vector3 point;
            public Vector3 normal;
            public Vector2[] polygon;

            public bool Contains(Vector3 world)
            {
                var local = inverse.MultiplyPoint3x4(world);
                return SpatialGeometry.Contains(new Vector2(local.x, local.z), polygon);
            }

            public float Height(Vector3 world)
            {
                return point.y - (normal.x * (world.x - point.x) + normal.z * (world.z - point.z)) / normal.y;
            }
        }

        void Awake()
        {
            if (!planeManager)
            {
                planeManager = FindAnyObjectByType<ARPlaneManager>(FindObjectsInactive.Include);
            }

            if (!boundingBoxManager)
            {
                boundingBoxManager = FindAnyObjectByType<ARBoundingBoxManager>(FindObjectsInactive.Include);
            }

            SetManagers(false);
        }

        void Start()
        {
#if UNITY_EDITOR
            IsEditorPreview = useEditorPreview;
            if (IsEditorPreview)
            {
                RefreshGeometry();
                return;
            }

#endif
            RequestPermission();
        }

        void Update()
        {
            if (Time.unscaledTime < nextRefresh)
            {
                return;
            }

            nextRefresh = Time.unscaledTime + 0.25f;
            RefreshGeometry();
        }

        void OnApplicationPause(bool paused)
        {
            if (paused || IsEditorPreview)
            {
                return;
            }

#if UNITY_ANDROID && !UNITY_EDITOR
            if (Permission.HasUserAuthorizedPermission(ScenePermission))
            {
                OnPermissionGranted();
            }
            else
            {
                permissionGranted = false;
                SetManagers(false);
            }
#else
            OnPermissionGranted();
#endif
        }

        void SetManagers(bool enabled)
        {
            if (planeManager)
            {
                planeManager.enabled = enabled;
            }

            if (boundingBoxManager)
            {
                boundingBoxManager.enabled = enabled;
            }
        }

        void RequestPermission()
        {
#if UNITY_ANDROID && !UNITY_EDITOR
            if (Permission.HasUserAuthorizedPermission(ScenePermission))
            {
                OnPermissionGranted();
                return;
            }

            SetManagers(false);
            permissionGranted = false;
            message = "Allow spatial data to load the room";
            var callbacks = new PermissionCallbacks();
            callbacks.PermissionGranted += _ => OnPermissionGranted();
            callbacks.PermissionDenied += _ =>
            {
                message = "Spatial permission denied; Scan / retry to request again";
                SetManagers(false);
            };
            Permission.RequestUserPermission(ScenePermission, callbacks);
#else
            OnPermissionGranted();
#endif
        }

        void OnPermissionGranted()
        {
            permissionGranted = true;
            message = "No room data yet; complete Space Setup or press Scan / retry";
            SetManagers(true);
            nextRefresh = 0f;
        }

        public void RequestScan()
        {
            if (IsEditorPreview)
            {
                message = "Using the editable editor sample room";
                RefreshGeometry();
                return;
            }

            if (!permissionGranted)
            {
                RequestPermission();
                return;
            }

            var manager = XRGeneralSettings.Instance ? XRGeneralSettings.Instance.Manager : null;
            var loader = manager ? manager.activeLoader : null;
            var session = loader ? loader.GetLoadedSubsystem<XRSessionSubsystem>() as MetaOpenXRSessionSubsystem : null;
            if (session != null && session.TryRequestSceneCapture())
            {
                message = "Complete the room setup in the headset";
            }
            else
            {
                message = "Open Quest Space Setup, scan the room, then retry";
                SetManagers(false);
                SetManagers(true);
            }

            nextRefresh = 0f;
        }

        public void ToggleFloorSnap()
        {
            if (!floorSnapEnabled && !HasFloor)
            {
                Notice("A classified floor is required; scan the room first");
                return;
            }

            floorSnapEnabled = !floorSnapEnabled;
            Revision++;
        }

        public void ToggleRoomGuard()
        {
            if (!roomGuardEnabled && !HasRoom)
            {
                Notice("Room data is required; scan the room first");
                return;
            }

            roomGuardEnabled = !roomGuardEnabled;
            Revision++;
        }

        public void ToggleRoomVisuals()
        {
            showRoom = !showRoom;
        }

        void Notice(string value)
        {
            notice = value;
            noticeUntil = Time.unscaledTime + 4f;
        }

        public void Register(ProductSpatialConstraint product)
        {
            if (!products.Contains(product))
            {
                products.Add(product);
            }
        }

        public void Unregister(ProductSpatialConstraint product)
        {
            products.Remove(product);
        }

        void RefreshGeometry()
        {
            floors.Clear();
            obstacles.Clear();
            snapSurfaces.Clear();
#if UNITY_EDITOR
            if (IsEditorPreview)
            {
                foreach (var volume in editorVolumes)
                {
                    if (!volume || !volume.gameObject.activeInHierarchy)
                    {
                        continue;
                    }

                    if (volume.IsFloor)
                    {
                        AddFloor(volume.transform, Vector3.zero, volume.Size, null, "editor:" + volume.name);
                    }
                    else
                    {
                        var obstacle = new SpatialGeometry.Box(
                            volume.transform.position,
                            Vector3.Scale(volume.Size * 0.5f, SpatialGeometry.Abs(volume.transform.lossyScale)),
                            volume.transform.rotation
                        );
                        obstacles.Add(obstacle);
                        AddBoxSurfaces(obstacle, volume.SnapSurface, "editor:" + volume.name);
                    }
                }

                Revision++;
                return;
            }

#endif
            if (!permissionGranted)
            {
                Revision++;
                return;
            }

            if (planeManager && planeManager.enabled)
            {
                foreach (var plane in planeManager.trackables)
                {
                    if (!plane || plane.trackingState != TrackingState.Tracking || plane.subsumedBy)
                    {
                        continue;
                    }

                    var size = new Vector3(plane.size.x, surfaceThickness, plane.size.y);
                    Vector2[] polygon = null;
                    if (plane.boundary.IsCreated && plane.boundary.Length >= 3)
                    {
                        polygon = new Vector2[plane.boundary.Length];
                        for (int i = 0; i < polygon.Length; i++)
                        {
                            polygon[i] = plane.boundary[i];
                        }
                    }

                    if ((plane.classifications & PlaneClassifications.Floor) != 0
                        && Vector3.Dot(plane.normal, Vector3.up) > 0.9f)
                    {
                        AddFloor(
                            plane.transform,
                            plane.transform.InverseTransformPoint(plane.center),
                            size,
                            polygon,
                            "floor:" + plane.trackableId
                        );
                    }
                    else if ((plane.classifications & PlaneClassifications.DoorFrame) == 0)
                    {
                        bool table = (plane.classifications & PlaneClassifications.Table) != 0
                            && Vector3.Dot(plane.normal, Vector3.up) > 0.9f;
                        var wallClasses = PlaneClassifications.WallFace | PlaneClassifications.InnerWallFace | PlaneClassifications.InvisibleWallFace;
                        bool wall = Mathf.Abs(Vector3.Dot(plane.normal, Vector3.up)) < 0.1f
                            && ((plane.classifications & wallClasses) != 0
                            || plane.classifications == PlaneClassifications.None);
                        var center = table ? plane.center - plane.normal * surfaceThickness * 0.5f : plane.center;
                        obstacles.Add(new SpatialGeometry.Box(
                            center,
                            Vector3.Scale(size * 0.5f, SpatialGeometry.Abs(plane.transform.lossyScale)),
                            plane.transform.rotation
                        ));
                        if (table || wall)
                        {
                            AddPlaneSurface(
                                plane.transform,
                                plane.transform.InverseTransformPoint(plane.center),
                                size,
                                polygon,
                                (table ? "table:" : "wall:") + plane.trackableId,
                                table ? ProductSurfaceMode.Tabletop : ProductSurfaceMode.Wall,
                                wall ? surfaceThickness * 0.5f : 0
                            );
                        }
                    }
                }
            }

            if (boundingBoxManager && boundingBoxManager.enabled)
            {
                foreach (var box in boundingBoxManager.trackables)
                {
                    if (box && box.trackingState == TrackingState.Tracking)
                    {
                        var obstacle = new SpatialGeometry.Box(
                            box.transform.position,
                            Vector3.Scale(box.size * 0.5f, SpatialGeometry.Abs(box.transform.lossyScale)),
                            box.transform.rotation
                        );
                        obstacles.Add(obstacle);
                        if ((box.classifications & BoundingBoxClassifications.Table) != 0)
                        {
                            AddBoxSurfaces(obstacle, ProductSurfaceMode.Tabletop, "table-box:" + box.trackableId);
                        }
                    }
                }
            }

            Revision++;
        }

        void AddFloor(Transform frame, Vector3 localCenter, Vector3 size, Vector2[] polygon, string id)
        {
            if (Vector3.Dot(frame.up, Vector3.up) < 0.9f)
            {
                return;
            }

            if (polygon == null)
            {
                var c = new Vector2(localCenter.x, localCenter.z);
                var e = new Vector2(size.x, size.z) * 0.5f;
                polygon = new[]
                {
                    c + new Vector2(-e.x, -e.y),
                    c + new Vector2(e.x, -e.y),
                    c + e,
                    c + new Vector2(-e.x, e.y)
                };
            }

            floors.Add(new Floor { id = id, frame = new Pose(frame.position, frame.rotation), inverse = frame.worldToLocalMatrix, point = frame.TransformPoint(localCenter), normal = frame.up, polygon = polygon });
            AddPlaneSurface(frame, localCenter, size, polygon, id, ProductSurfaceMode.Floor);
        }

        void AddPlaneSurface(
            Transform frame,
            Vector3 center,
            Vector3 size,
            Vector2[] polygon,
            string id,
            ProductSurfaceMode kind,
            float padding = 0
        )
        {
            if (polygon == null)
            {
                polygon = Rectangle(new Vector2(center.x, center.z), new Vector2(size.x, size.z) * 0.5f);
            }

            var scale = frame.lossyScale;
            var scaled = new Vector2[polygon.Length];
            for (int i = 0; i < polygon.Length; i++)
            {
                scaled[i] = Vector2.Scale(polygon[i], new Vector2(scale.x, scale.z));
            }

            snapSurfaces.Add(new SnappingSurface(
                id,
                kind,
                new Pose(frame.position, frame.rotation),
                frame.TransformPoint(center),
                scaled,
                padding
            ));
        }

        static Vector2[] Rectangle(Vector2 center, Vector2 half)
        {
            return new[]
            {
                center + new Vector2(-half.x, -half.y),
                center + new Vector2(half.x, -half.y),
                center + half,
                center + new Vector2(-half.x, half.y)
            };
        }

        void AddBoxSurfaces(SpatialGeometry.Box box, ProductSurfaceMode kind, string id)
        {
            if (Vector3.Dot(box.Axis(1), Vector3.up) < 0.9f)
            {
                return;
            }

            if (kind == ProductSurfaceMode.Tabletop)
            {
                var top = box.center + box.Axis(1) * box.halfSize.y;
                snapSurfaces.Add(new SnappingSurface(
                    id,
                    kind,
                    new Pose(top, box.rotation),
                    top,
                    Rectangle(Vector2.zero, new Vector2(box.halfSize.x, box.halfSize.z))
                ));
            }
            else if (kind == ProductSurfaceMode.Wall)
            {
                int thin = box.halfSize.x < box.halfSize.z ? 0 : 2;
                for (int side = -1; side <= 1; side += 2)
                {
                    var normal = box.Axis(thin) * side;
                    var point = box.center + normal * box.halfSize[thin];
                    var frame = new Pose(point, Quaternion.LookRotation(box.Axis(1), normal));
                    snapSurfaces.Add(new SnappingSurface(
                        id + ":" + side,
                        kind,
                        frame,
                        point,
                        Rectangle(Vector2.zero, new Vector2(box.halfSize[thin == 0 ? 2 : 0], box.halfSize.y))
                    ));
                }
            }
        }

        public ProductSurfaceMode EffectiveSurface(ProductSurfaceMode mode)
        {
            return ProductSnapState.NormalizeSurface(mode);
        }

        public bool TrySnapItem(
            ProductSurfaceMode mode,
            Bounds local,
            Vector3 scale,
            ref Pose pose,
            ref string surfaceId,
            ref int wallSide,
            int rotationStep,
            Quaternion reference,
            float captureDistance,
            ProductSpatialConstraint owner,
            out bool waiting,
            out string status
        )
        {
            waiting = false;
            status = "Free placement";
            mode = ProductSnapState.NormalizeSurface(mode);
            if (mode == ProductSurfaceMode.Free)
            {
                var center = SpatialGeometry.FromProduct(local, pose, scale).center;
                pose.rotation = ProductSnapState.SnapYaw(pose.rotation, reference, rotationStep);
                pose.position = center - pose.rotation * Vector3.Scale(local.center, scale);
                return true;
            }

            string label = mode == ProductSurfaceMode.Tabletop
                ? "tabletop"
                : mode == ProductSurfaceMode.Wall
                    ? "wall"
                    : "floor";
            if (!string.IsNullOrEmpty(surfaceId))
            {
                foreach (var surface in snapSurfaces)
                {
                    if (surface.id == surfaceId && surface.kind == mode)
                    {
                        status = "Attached to " + label;
                        if (surface.Project(local, scale, ref pose, wallSide, rotationStep, reference, clearance))
                        {
                            return true;
                        }

                        status = "Product is too large for this " + label;
                        return false;
                    }
                }

                waiting = true;
                status = "Attached " + label + " unavailable; Scan room or select Free";
                return false;
            }

            var originalCenter = SpatialGeometry.FromProduct(local, pose, scale).center;
            float closest = float.MaxValue;
            SnappingSurface best = null;
            Pose bestPose = pose;
            int bestSide = 1;
            bool any = false;
            foreach (var surface in snapSurfaces)
            {
                if (surface.kind != mode)
                {
                    continue;
                }

                any = true;
                int side = mode == ProductSurfaceMode.Wall && Vector3.Dot(originalCenter - surface.point, surface.normal) < 0
                    ? -1
                    : 1;
                var candidate = pose;
                if (!surface.Project(local, scale, ref candidate, side, rotationStep, reference, clearance))
                {
                    continue;
                }

                float distance = (SpatialGeometry.FromProduct(local, candidate, scale).center - originalCenter).sqrMagnitude;
                if (mode != ProductSurfaceMode.Floor && distance > captureDistance * captureDistance)
                {
                    continue;
                }

                if (roomGuardEnabled
                    && OverlapScore(owner, SpatialGeometry.FromProduct(local, candidate, scale)) > 0.0001f)
                {
                    continue;
                }

                if (distance >= closest)
                {
                    continue;
                }

                closest = distance;
                best = surface;
                bestPose = candidate;
                bestSide = side;
            }

            if (best != null)
            {
                pose = bestPose;
                surfaceId = best.id;
                wallSide = bestSide;
                status = "Attached to " + label;
                return true;
            }

            waiting = !any;
            status = any
                ? "Move near a " + label + " with space for this product"
                : "No " + label + " data; Scan room";
            if (mode == ProductSurfaceMode.Floor)
            {
                return false;
            }

            pose.rotation = ProductSnapState.SnapYaw(pose.rotation, reference, rotationStep);
            pose.position = originalCenter - pose.rotation * Vector3.Scale(local.center, scale);
            return true;
        }

        public bool TryArrangementFrame(string requestedId, out string id, out Pose pose)
        {
            foreach (var floor in floors)
            {
                if (string.IsNullOrEmpty(requestedId) || floor.id == requestedId)
                {
                    id = floor.id;
                    pose = floor.frame;
                    return true;
                }
            }

            id = null;
            pose = Pose.identity;
            return false;
        }

        public bool TrySnap(Bounds local, Vector3 scale, ref Pose pose)
        {
            var box = SpatialGeometry.FromProduct(local, pose, scale);
            Floor best = null;
            float distance = float.MaxValue;
            foreach (var floor in floors)
            {
                if (!floor.Contains(box.center))
                {
                    continue;
                }

                float delta = Mathf.Abs(box.center.y - floor.Height(box.center));
                if (delta < distance)
                {
                    distance = delta;
                    best = floor;
                }
            }

            if (best == null)
            {
                return false;
            }

            var forward = Vector3.ProjectOnPlane(pose.rotation * Vector3.forward, best.normal);
            if (forward.sqrMagnitude < 0.001f)
            {
                forward = Vector3.ProjectOnPlane(Vector3.forward, best.normal);
            }

            pose.rotation = Quaternion.LookRotation(forward, best.normal);
            box = SpatialGeometry.FromProduct(local, pose, scale);
            float bottomDistance = Vector3.Dot(box.center - best.point, best.normal) - box.Radius(best.normal);
            pose.position.y += (clearance - bottomDistance) / best.normal.y;
            return true;
        }

        public bool FitsFloor(SpatialGeometry.Box box)
        {
            if (!HasFloor)
            {
                return true;
            }

            for (int i = 0; i < 8; i++)
            {
                bool inside = false;
                var corner = box.Corner(i);
                foreach (var floor in floors)
                {
                    if (floor.Contains(corner))
                    {
                        inside = true;
                        break;
                    }
                }

                if (!inside)
                {
                    return false;
                }
            }

            return true;
        }

        public float OverlapScore(ProductSpatialConstraint owner, SpatialGeometry.Box box)
        {
            float score = 0f;
            foreach (var floor in floors)
            {
                if (floor.Contains(box.center))
                {
                    score = Mathf.Max(
                        score,
                        clearance + box.Radius(floor.normal) - Vector3.Dot(box.center - floor.point, floor.normal)
                    );
                }
            }

            foreach (var obstacle in obstacles)
            {
                if (SpatialGeometry.Overlaps(box, obstacle, clearance, out var depth))
                {
                    score += depth;
                }
            }

            foreach (var other in products)
            {
                if (other
                    && other != owner
                    && other.isActiveAndEnabled
                    && SpatialGeometry.Overlaps(box, other.CurrentBox, clearance, out var depth))
                {
                    score += depth;
                }
            }

            return score;
        }

        public bool TryPlacement(Bounds local, Vector3 scale, ref Pose pose, ProductSpatialConstraint owner = null)
        {
            if (roomGuardEnabled && !HasRoom)
            {
                return false;
            }

            if (floorSnapEnabled && (!HasFloor || !TrySnap(local, scale, ref pose)))
            {
                return false;
            }

            var box = SpatialGeometry.FromProduct(local, pose, scale);
            return (!(roomGuardEnabled
                || floorSnapEnabled)
                || FitsFloor(box))
                && (!roomGuardEnabled
                || OverlapScore(owner, box) <= 0.0001f);
        }
    }
}
