using System;
using System.Collections.Generic;
using System.Linq;
using SpatialProductViewer;
using Unity.XR.CoreUtils;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;
using UnityEngine.XR.Interaction.Toolkit.Inputs;
using UnityEngine.XR.Interaction.Toolkit.Interactors;
using UnityEngine.XR.Interaction.Toolkit.UI;
using UnityEngine.XR.OpenXR;
using UnityEngine.XR.Hands.OpenXR;
using Object = UnityEngine.Object;

public static class QuestHandsAuthoring
{
    const string ScenePath = "Assets/Scenes/QuestFoundation.unity";
    const string RigPath = "Assets/SpatialProductViewer/Prefabs/QuestInteractionRig.prefab";
    const string SampleRig = "Assets/Samples/XR Interaction Toolkit/3.5.1/Hands Interaction Demo/Prefabs/XR Origin Hands (XR Rig).prefab";

    [MenuItem("Tools/Spatial Product Viewer/Add Quest Hand Tracking")]
    public static void Author()
    {
        foreach (var group in new[] { BuildTargetGroup.Android,BuildTargetGroup.Standalone })
        {
            var settings = OpenXRSettings.GetSettingsForBuildTargetGroup(group);
            if (!settings) continue;
            var tracking = settings.GetFeature<HandTracking>();
            var aim = settings.GetFeature<MetaHandTrackingAim>();
            if (!tracking || !aim) throw new InvalidOperationException("XR Hands hand tracking and Meta aim features are required.");
            tracking.enabled = true; aim.enabled = true;
            var fields = new SerializedObject(tracking);
            fields.FindProperty("m_AutoStartSubsystem").boolValue = true;
            fields.ApplyModifiedPropertiesWithoutUndo();
            EditorUtility.SetDirty(tracking); EditorUtility.SetDirty(aim);
        }
        var plugin = AssetImporter.GetAtPath("Assets/Plugins/Android/QuestHands.androidlib") as PluginImporter;
        if (!plugin) throw new InvalidOperationException("The Android hand-support manifest must be imported as an Android library.");
        plugin.SetCompatibleWithAnyPlatform(false); plugin.SetCompatibleWithPlatform(BuildTarget.Android,true); plugin.SaveAndReimport();
        var scene = EditorSceneManager.OpenScene(ScenePath,OpenSceneMode.Single);
        var origin = Object.FindAnyObjectByType<XROrigin>();
        if (!origin) throw new InvalidOperationException("Quest XR Origin is missing.");
        if (origin.GetComponentsInChildren<HandProductInteractor>(true).Length > 0)
            throw new InvalidOperationException("Hand tracking is already authored. Edit QuestInteractionRig.prefab directly.");

        // Bake the existing scene overrides, including passthrough, room-manager references and controller inputs.
        PrefabUtility.UnpackPrefabInstance(origin.gameObject,PrefabUnpackMode.OutermostRoot,InteractionMode.AutomatedAction);
        var sample = (GameObject)PrefabUtility.InstantiatePrefab(AssetDatabase.LoadAssetAtPath<GameObject>(SampleRig),scene);
        PrefabUtility.UnpackPrefabInstance(sample,PrefabUnpackMode.Completely,InteractionMode.AutomatedAction);
        var sampleOrigin = sample.GetComponent<XROrigin>();
        var offset = origin.CameraFloorOffsetObject.transform;
        var mappings = new Dictionary<Object,Object>();
        Map(sample,origin.gameObject,mappings);
        Map(sampleOrigin.CameraFloorOffsetObject,origin.CameraFloorOffsetObject,mappings);
        Map(sampleOrigin.Camera.gameObject,origin.Camera.gameObject,mappings);
        var roots = new List<GameObject>();
        foreach (var name in new[] { "Left Hand", "Right Hand", "Hand Visualizer", "Hands Smoothing Post Processor" })
        {
            var item = sample.GetComponentsInChildren<Transform>(true).Single(t=>t.name == name);
            item.SetParent(name == "Hands Smoothing Post Processor" ? origin.transform : offset,false);
            roots.Add(item.gameObject);
        }
        foreach (var root in roots)
            foreach (var component in root.GetComponentsInChildren<Component>(true))
            {
                if (!component) throw new InvalidOperationException("A hand sample component is missing.");
                var serialized = new SerializedObject(component);
                var iterator = serialized.GetIterator();
                while (iterator.Next(true))
                {
                    if (iterator.propertyType != SerializedPropertyType.ObjectReference || !iterator.objectReferenceValue) continue;
                    var reference = iterator.objectReferenceValue;
                    if (mappings.TryGetValue(reference,out var mapped)) iterator.objectReferenceValue = mapped;
                    else if (reference is Component c && c.transform.IsChildOf(sample.transform)
                        || reference is GameObject go && go.transform.IsChildOf(sample.transform))
                        throw new InvalidOperationException("Unmapped hand reference: " + component.name + "." + iterator.propertyPath + " -> " + reference.name);
                }
                serialized.ApplyModifiedPropertiesWithoutUndo();
            }
        Object.DestroyImmediate(sample);
        var modality = origin.GetComponent<XRInputModalityManager>();
        if (!modality) throw new InvalidOperationException("The controller rig has no input modality manager.");
        modality.leftHand = roots.Single(r=>r.name == "Left Hand");
        modality.rightHand = roots.Single(r=>r.name == "Right Hand");
        foreach (var hand in new[] { modality.leftHand,modality.rightHand })
        {
            var interactor = hand.GetComponentInChildren<NearFarInteractor>(true);
            if (!interactor) throw new InvalidOperationException("The hand near/far interactor is missing.");
            interactor.gameObject.AddComponent<HandProductInteractor>();
            interactor.enableUIInteraction = true;
        }
        origin.name = "Quest XR Origin";
        PrefabUtility.SaveAsPrefabAssetAndConnect(origin.gameObject,RigPath,InteractionMode.AutomatedAction);
        // Keep older catalogs free of repeated input instructions.
        var catalog = Object.FindAnyObjectByType<ProductCatalogController>();
        var catalogRoot = PrefabUtility.GetOutermostPrefabInstanceRoot(catalog.gameObject);
        var catalogPath = PrefabUtility.GetPrefabAssetPathOfNearestInstanceRoot(catalogRoot);
        var contents = PrefabUtility.LoadPrefabContents(catalogPath);
        try
        {
            foreach (var label in contents.GetComponentsInChildren<UnityEngine.UI.Text>(true))
            {
                if (label.text == "Grip to move panel" || label.text == "Grip or pinch to move panel") label.text = "";
                if (label.text == "Trigger to place  /  Drag or use thumbstick to scroll")
                    label.text = "";
            }
            PrefabUtility.SaveAsPrefabAsset(contents,catalogPath);
        }
        finally { PrefabUtility.UnloadPrefabContents(contents); }
        EditorSceneManager.MarkSceneDirty(scene);
        EditorSceneManager.SaveScene(scene);
        AssetDatabase.SaveAssets();
        Debug.Log("QUEST HANDS AUTHORED: editable QuestInteractionRig, tracked hand meshes, pinch grabs, UI rays/poke and controller switching.");
    }

    static void Map(GameObject source, GameObject destination, Dictionary<Object,Object> mapping)
    {
        mapping[source] = destination;
        foreach (var component in source.GetComponents<Component>())
        {
            var target = destination.GetComponent(component.GetType());
            if (target) mapping[component] = target;
        }
    }

    public static void AuthorBatch()
    {
        try { Author(); EditorApplication.Exit(0); }
        catch (Exception error) { Debug.LogException(error); EditorApplication.Exit(1); }
    }
}
