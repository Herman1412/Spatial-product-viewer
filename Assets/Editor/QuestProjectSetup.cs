using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEditor.SceneManagement;
using UnityEditor.XR.Management;
using UnityEditor.XR.OpenXR;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;
using UnityEngine.XR.Management;
using UnityEngine.XR.OpenXR;
using UnityEngine.XR.OpenXR.Features;
using Unity.XR.CoreUtils;

namespace SpatialProductViewer.Editor
{
    /// <summary>Quest foundation using the project's existing Unity OpenXR/XRI stack.</summary>
    public static class QuestProjectSetup
    {
        public const string ScenePath = "Assets/Scenes/QuestFoundation.unity";
        const string RigPath = "Assets/Samples/XR Interaction Toolkit/3.5.1/Starter Assets/Prefabs/XR Origin (XR Rig).prefab";
        const string MaterialPath = "Assets/Settings/QuestTestCube.mat";

        [MenuItem("Spatial Product Viewer/Quest/Apply Android Settings")]
        public static void Configure()
        {
            PlayerSettings.productName = "Spatial Product Viewer";
            PlayerSettings.SetApplicationIdentifier(NamedBuildTarget.Android, "com.spatialproductviewer.quest");
            PlayerSettings.SetScriptingBackend(NamedBuildTarget.Android, ScriptingImplementation.IL2CPP);
            PlayerSettings.Android.targetArchitectures = AndroidArchitecture.ARM64;
            PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel32;
            PlayerSettings.Android.targetSdkVersion = AndroidSdkVersions.AndroidApiLevel34;
            PlayerSettings.SetUseDefaultGraphicsAPIs(BuildTarget.Android, false);
            PlayerSettings.SetGraphicsAPIs(BuildTarget.Android, new[] { GraphicsDeviceType.Vulkan });
            PlayerSettings.colorSpace = ColorSpace.Linear;

            var xr = XRGeneralSettingsPerBuildTarget.XRGeneralSettingsForBuildTarget(BuildTargetGroup.Android);
            if (xr == null || xr.Manager == null || !xr.Manager.activeLoaders.Any(l => l is OpenXRLoader))
                throw new BuildFailedException("Enable the Android OpenXR loader in XR Plug-in Management first.");
            xr.InitManagerOnStart = true;
            EditorUtility.SetDirty(xr);

            var settings = OpenXRSettings.GetSettingsForBuildTargetGroup(BuildTargetGroup.Android);
            if (settings == null)
                throw new BuildFailedException("Android OpenXR settings are missing.");
            settings.renderMode = OpenXRSettings.RenderMode.SinglePassInstanced;
            EnableFeature(settings, "UnityEngine.XR.OpenXR.Features.MetaQuestSupport.MetaQuestFeature");
            EnableFeature(settings, "UnityEngine.XR.OpenXR.Features.Meta.ARCameraFeature");
            EnableFeature(settings, "UnityEngine.XR.OpenXR.Features.Meta.ARSessionFeature");
            EnableFeature(settings, "UnityEngine.XR.OpenXR.Features.Interactions.OculusTouchControllerProfile");
            EnableFeature(settings, "UnityEngine.XR.OpenXR.Features.Interactions.MetaQuestTouchPlusControllerProfile");
            EditorUtility.SetDirty(settings);
            AssetDatabase.SaveAssets();
            Debug.Log("Quest settings applied: OpenXR, Vulkan, IL2CPP, ARM64, Android API 32/34.");
        }

        static void EnableFeature(OpenXRSettings settings, string typeName)
        {
            var feature = settings.GetFeatures<OpenXRFeature>().FirstOrDefault(f => f != null && f.GetType().FullName == typeName);
            if (feature == null)
                throw new BuildFailedException($"Required OpenXR feature is missing: {typeName}");
            feature.enabled = true;
            EditorUtility.SetDirty(feature);
        }

        [MenuItem("Spatial Product Viewer/Quest/Create Foundation Scene")]
        public static void CreateScene()
        {
            if (File.Exists(ScenePath))
            {
                Debug.Log($"Foundation scene already exists: {ScenePath}. Open it to continue; existing work is preserved.");
                return;
            }
            if (!Application.isBatchMode && !EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo())
                return;

            var rigAsset = AssetDatabase.LoadAssetAtPath<GameObject>(RigPath);
            if (rigAsset == null)
                throw new BuildFailedException($"The imported XRI Starter Assets rig is missing: {RigPath}");

            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            var rig = (GameObject)PrefabUtility.InstantiatePrefab(rigAsset);
            rig.name = "Quest XR Origin";
            var origin = rig.GetComponent<XROrigin>();
            origin.RequestedTrackingOriginMode = XROrigin.TrackingOriginMode.Floor;
            // Physical movement only in this first MR scene; prevent virtual falling or turning.
            var locomotion = rig.transform.Find("Locomotion");
            if (locomotion != null)
                locomotion.gameObject.SetActive(false);
            var characterController = rig.GetComponent<CharacterController>();
            if (characterController != null)
                characterController.enabled = false;

            var camera = origin.Camera;
            camera.clearFlags = CameraClearFlags.SolidColor;
            camera.backgroundColor = Color.clear;
            camera.nearClipPlane = 0.05f;
            camera.farClipPlane = 50f;
            camera.allowHDR = false;
            camera.GetUniversalAdditionalCameraData().renderPostProcessing = false;
            camera.gameObject.AddComponent<ARCameraManager>();
            new GameObject("AR Session", typeof(ARSession));
            new GameObject("XR Interaction Manager", typeof(XRInteractionManager));

            RenderSettings.skybox = null;
            RenderSettings.ambientMode = AmbientMode.Flat;
            RenderSettings.ambientLight = new Color(0.65f, 0.65f, 0.65f);
            var light = new GameObject("Directional Light", typeof(Light)).GetComponent<Light>();
            light.type = LightType.Directional;
            light.intensity = 1f;
            light.shadows = LightShadows.None;
            light.transform.rotation = Quaternion.Euler(45f, -30f, 0f);

            var material = AssetDatabase.LoadAssetAtPath<Material>(MaterialPath);
            if (material == null)
            {
                var shader = Shader.Find("Universal Render Pipeline/Lit");
                if (shader == null)
                    throw new BuildFailedException("The URP Lit shader is unavailable.");
                material = new Material(shader) { name = "Quest Test Cube" };
                material.color = new Color(0.12f, 0.65f, 0.85f);
                AssetDatabase.CreateAsset(material, MaterialPath);
            }
            var cube = GameObject.CreatePrimitive(PrimitiveType.Cube);
            cube.name = "Grab Test Cube (25 cm)";
            cube.transform.position = new Vector3(0f, 1.2f, 0.8f);
            cube.transform.localScale = Vector3.one * 0.25f;
            cube.GetComponent<Renderer>().sharedMaterial = material;
            var body = cube.AddComponent<Rigidbody>();
            body.useGravity = false;
            body.isKinematic = true;
            var grab = cube.AddComponent<XRGrabInteractable>();
            grab.movementType = XRBaseInteractable.MovementType.Kinematic;
            grab.throwOnDetach = false;
            grab.useDynamicAttach = true;

            if (!EditorSceneManager.SaveScene(scene, ScenePath))
                throw new BuildFailedException("Could not save the Quest foundation scene.");
            // Keep the template available in the project; only the focused scene goes into this APK.
            EditorBuildSettings.scenes = new[] { new EditorBuildSettingsScene(ScenePath, true) };
            AssetDatabase.SaveAssets();
            Debug.Log($"Created {ScenePath}. Test passthrough, head/controller tracking, and grip to grab the 25 cm cube.");
        }

        [MenuItem("Spatial Product Viewer/Quest/Validate Foundation Scene")]
        public static void Validate()
        {
            if (!File.Exists(ScenePath))
                throw new BuildFailedException("Create the Quest foundation scene first.");
            if (!Application.isBatchMode && !EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo())
                throw new OperationCanceledException("Quest scene validation cancelled.");
            EditorSceneManager.OpenScene(ScenePath);
            var cameras = UnityEngine.Object.FindObjectsByType<Camera>(FindObjectsSortMode.None);
            var camera = cameras.SingleOrDefault(c => c.CompareTag("MainCamera"));
            if (camera == null || camera.clearFlags != CameraClearFlags.SolidColor || camera.backgroundColor.a != 0f ||
                !camera.TryGetComponent<ARCameraManager>(out var arCamera) || !arCamera.enabled)
                throw new BuildFailedException("A transparent Main Camera with an enabled ARCameraManager is required.");
            if (UnityEngine.Object.FindFirstObjectByType<ARSession>() == null ||
                UnityEngine.Object.FindFirstObjectByType<XROrigin>() == null ||
                UnityEngine.Object.FindFirstObjectByType<XRInteractionManager>() == null ||
                UnityEngine.Object.FindFirstObjectByType<XRGrabInteractable>() == null)
                throw new BuildFailedException("The AR session, XR origin, interaction manager, or grab test object is missing.");

            foreach (var root in EditorSceneManager.GetActiveScene().GetRootGameObjects())
            foreach (var transform in root.GetComponentsInChildren<Transform>(true))
                if (GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(transform.gameObject) > 0)
                    throw new BuildFailedException($"Missing script on {transform.name}.");

            var failures = new List<OpenXRFeature.ValidationRule>();
            OpenXRProjectValidation.GetCurrentValidationIssues(failures, BuildTargetGroup.Android);
            foreach (var failure in failures)
            {
                if (failure.error)
                    Debug.LogError(failure.message);
                else
                    Debug.LogWarning(failure.message);
            }
            if (failures.Any(f => f.error))
                throw new BuildFailedException("Resolve the Android OpenXR validation errors listed above.");
            Debug.Log("Quest foundation validation passed. Device verification is still required.");
        }

        [MenuItem("Spatial Product Viewer/Quest/Build Development APK")]
        public static void Build()
        {
            if (EditorUserBuildSettings.activeBuildTarget != BuildTarget.Android)
                throw new BuildFailedException("Select Meta Quest in File > Build Profiles and switch platform first.");
            Configure();
            Validate();
            var output = "Builds/Quest/SpatialProductViewer.apk";
            var args = Environment.GetCommandLineArgs();
            for (var i = 0; i < args.Length - 1; i++)
                if (args[i] == "-questBuildPath")
                    output = args[i + 1];
            Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(output)));
            EditorUserBuildSettings.buildAppBundle = false;
            EditorUserBuildSettings.exportAsGoogleAndroidProject = false;
            var report = BuildPipeline.BuildPlayer(new BuildPlayerOptions
            {
                scenes = new[] { ScenePath },
                locationPathName = output,
                target = BuildTarget.Android,
                options = BuildOptions.Development,
            });
            if (report.summary.result != BuildResult.Succeeded)
                throw new BuildFailedException($"Quest APK build failed: {report.summary.result}");
            Debug.Log($"Quest APK built: {Path.GetFullPath(output)} ({report.summary.totalSize} bytes).");
        }

        // unity -batchmode -buildTarget Android -executeMethod SpatialProductViewer.Editor.QuestProjectSetup.BatchBuild
        public static void BatchBuild()
        {
            Configure();
            CreateScene();
            Build();
        }
    }
}
