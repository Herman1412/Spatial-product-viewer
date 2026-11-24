using System;
using System.Linq;
using SpatialProductViewer;
using Unity.XR.CoreUtils;
using UnityEditor;
using UnityEditor.Events;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

public static class DepthAndDimensionsAuthoring
{
    const string Base="Assets/SpatialProductViewer/";
    [MenuItem("Tools/Spatial Product Viewer/Add Depth Occlusion and Dimensions")]
    public static void Author()
    {
        AuthorDimensions(); AuthorDepth(); AuthorRoomControls();
        var scene=EditorSceneManager.OpenScene("Assets/Scenes/QuestFoundation.unity",OpenSceneMode.Single);
        var view=UnityEngine.Object.FindAnyObjectByType<ProductSelectionView>();view.Show(null);
        var dimensions=view.GetComponent<ProductDimensionView>();
        var root=(Transform)new SerializedObject(dimensions).FindProperty("measurementRoot").objectReferenceValue;
        PrefabUtility.RecordPrefabInstancePropertyModifications(root.gameObject);
        EditorSceneManager.MarkSceneDirty(scene);EditorSceneManager.SaveScene(scene);
        AssetDatabase.SaveAssets();
        Debug.Log("DEPTH AND DIMENSIONS AUTHORED: three rulers/labels, permission-gated environment depth, five preserving shader variants and an editable occlusion toggle.");
    }

    static void AuthorDimensions()
    {
        string path=Base+"Prefabs/ProductSelectionControls.prefab";
        var root=PrefabUtility.LoadPrefabContents(path);
        try
        {
            if (root.GetComponent<ProductDimensionView>()) throw new InvalidOperationException("Dimensions already authored; edit the existing prefab.");
            var view=root.GetComponent<ProductSelectionView>();var fields=new SerializedObject(view);
            var dimensions=root.AddComponent<ProductDimensionView>();
            var measurements=new GameObject("Dimension Measurements").transform;measurements.SetParent(root.transform,false);
            var rulers=new LineRenderer[3];var boards=new RectTransform[3];var labels=new Text[3];
            var font=AssetDatabase.LoadAssetAtPath<Font>(AssetDatabase.GUIDToAssetPath("78c7f42a7547f22448a621eaeeef3fd2"));
            var material=AssetDatabase.LoadAssetAtPath<Material>(Base+"Materials/SelectionCyan.mat");
            if (!font || !material) throw new InvalidOperationException("Dimension font or material is missing.");
            var names=new[]{"Width","Height","Depth"};
            for (int i=0;i<3;i++)
            {
                var line=new GameObject(names[i]+" Ruler");line.transform.SetParent(measurements,false);
                var renderer=line.AddComponent<LineRenderer>();renderer.sharedMaterial=material;
                renderer.useWorldSpace=false;renderer.positionCount=10;renderer.widthMultiplier=.0015f;
                renderer.shadowCastingMode=ShadowCastingMode.Off;renderer.receiveShadows=false;
                renderer.alignment=LineAlignment.View;renderer.textureMode=LineTextureMode.Stretch;
                renderer.startColor=renderer.endColor=Color.white;rulers[i]=renderer;
                var go=new GameObject(names[i]+" Label",typeof(RectTransform),typeof(Canvas));go.layer=5;
                var board=(RectTransform)go.transform;board.SetParent(measurements,false);
                board.sizeDelta=new Vector2(160,38);board.localScale=Vector3.one*.0008f;
                go.GetComponent<Canvas>().renderMode=RenderMode.WorldSpace;go.GetComponent<Canvas>().sortingOrder=12;
                go.AddComponent<CanvasRenderer>();var art=go.AddComponent<SelectionMenuGraphic>();
                art.color=new Color(.08f,.15f,.22f,.9f);art.raycastTarget=false;
                var labelGo=new GameObject("Text",typeof(RectTransform),typeof(CanvasRenderer));labelGo.layer=5;
                var rect=(RectTransform)labelGo.transform;rect.SetParent(board,false);
                rect.sizeDelta=new Vector2(152,34);
                var text=labelGo.AddComponent<Text>();text.font=font;text.fontSize=20;text.alignment=TextAnchor.MiddleCenter;
                text.color=new Color(.7f,1,1,1);text.supportRichText=false;text.raycastTarget=false;
                text.resizeTextForBestFit=true;text.resizeTextMinSize=14;text.resizeTextMaxSize=20;
                boards[i]=board;labels[i]=text;
            }
            var data=new SerializedObject(dimensions);Set(data,"measurementRoot",measurements);
            Array(data,"rulers",rulers);Array(data,"labelBoards",boards);Array(data,"labels",labels);
            data.ApplyModifiedPropertiesWithoutUndo();
            Set(fields,"dimensionView",dimensions);fields.ApplyModifiedPropertiesWithoutUndo();
            // Save an inspectable 40 cm example layout in Prefab Mode, without adding a scene product.
            var example=UnityEngine.Object.Instantiate(AssetDatabase.LoadAssetAtPath<GameObject>(Base+"Prefabs/PlaceholderProduct.prefab"));
            example.SetActive(false);example.transform.localScale=Vector3.one*.4f;
            var bounds=(Transform)fields.FindProperty("boundsRoot").objectReferenceValue;
            example.transform.position=bounds.position;
            dimensions.Refresh(example.GetComponent<SelectableProduct>(),null);UnityEngine.Object.DestroyImmediate(example);
            PrefabUtility.SaveAsPrefabAsset(root,path);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
    }

    static void AuthorDepth()
    {
        string path=Base+"Prefabs/QuestInteractionRig.prefab";var root=PrefabUtility.LoadPrefabContents(path);
        try
        {
            var origin=root.GetComponent<XROrigin>();var camera=origin.Camera;
            var manager=camera.GetComponent<AROcclusionManager>() ?? camera.gameObject.AddComponent<AROcclusionManager>();
            manager.requestedEnvironmentDepthMode=EnvironmentDepthMode.Fastest;
            manager.requestedHumanDepthMode=HumanSegmentationDepthMode.Disabled;
            manager.requestedHumanStencilMode=HumanSegmentationStencilMode.Disabled;manager.enabled=false;
            var shader=camera.GetComponent<ARShaderOcclusion>() ?? camera.gameObject.AddComponent<ARShaderOcclusion>();
            shader.occlusionShaderMode=AROcclusionShaderMode.HardOcclusion;shader.enabled=false;
            var controller=camera.GetComponent<EnvironmentOcclusion>() ?? camera.gameObject.AddComponent<EnvironmentOcclusion>();
            var data=new SerializedObject(controller);Set(data,"depthManager",manager);Set(data,"shaderOcclusion",shader);
            Set(data,"trackingSpace",origin.CameraFloorOffsetObject.transform);
            string[] source={"glTF-pbrMetallicRoughness.shadergraph","glTF-pbrSpecularGlossiness.shadergraph","glTF-unlit.shadergraph","URP/glTF-pbrMetallicRoughness-Clearcoat.shadergraph"};
            var pairs=data.FindProperty("shaders");pairs.arraySize=5;
            for (int i=0;i<5;i++)
            {
                Shader original=i==4 ? Shader.Find("Universal Render Pipeline/Lit") : AssetDatabase.LoadAssetAtPath<Shader>("Packages/com.unity.cloud.gltfast/Runtime/Shader/"+source[i]);
                Shader occluded=AssetDatabase.LoadAssetAtPath<Shader>(Base+"Shaders/"+(i==4 ? "OccludedLit.shader" : System.IO.Path.GetFileName(source[i]).Replace(".shadergraph",".shader")));
                if (!original || !occluded) throw new InvalidOperationException("An occlusion shader did not import: "+i);
                var pair=pairs.GetArrayElementAtIndex(i);pair.FindPropertyRelative("source").objectReferenceValue=original;
                pair.FindPropertyRelative("occluded").objectReferenceValue=occluded;
                var errors=ShaderUtil.GetShaderMessages(occluded).Where(m=>m.severity==UnityEditor.Rendering.ShaderCompilerMessageSeverity.Error).ToArray();
                if (errors.Length>0) throw new InvalidOperationException("Shader error: "+occluded.name+" "+string.Join(" / ",errors.Select(m=>m.message)));
            }
            data.ApplyModifiedPropertiesWithoutUndo();PrefabUtility.SaveAsPrefabAsset(root,path);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
    }

    static void AuthorRoomControls()
    {
        string path=Base+"Prefabs/RoomPlacementControls.prefab";var root=PrefabUtility.LoadPrefabContents(path);
        try
        {
            var controller=root.GetComponent<RoomPlacementControls>();
            var buttons=root.GetComponentsInChildren<Button>(true);
            if (buttons.Length!=4) throw new InvalidOperationException("Expected the four original room controls.");
            var clone=UnityEngine.Object.Instantiate(buttons[2],buttons[2].transform.parent);
            clone.name="Occlusion Toggle";clone.onClick=new Button.ButtonClickedEvent();
            UnityEventTools.AddPersistentListener(clone.onClick,controller.ToggleOcclusion);
            clone.GetComponentInChildren<Text>().text="Occlusion: Wait";
            var ordered=new[]{buttons[0],buttons[1],buttons[2],clone,buttons[3]};
            for (int i=0;i<ordered.Length;i++)
            {
                var rect=(RectTransform)ordered[i].transform;
                rect.anchoredPosition=new Vector2(-300+i*150,rect.anchoredPosition.y);rect.sizeDelta=new Vector2(142,42);
                var text=ordered[i].GetComponentInChildren<Text>();text.rectTransform.sizeDelta=new Vector2(136,36);
                text.fontSize=16;text.resizeTextForBestFit=true;text.resizeTextMinSize=13;text.resizeTextMaxSize=16;
            }
            var fields=new SerializedObject(controller);Set(fields,"occlusionLabel",clone.GetComponentInChildren<Text>());
            Set(fields,"occlusionGraphic",clone.GetComponent<SelectionMenuGraphic>());fields.ApplyModifiedPropertiesWithoutUndo();
            var status=(Text)fields.FindProperty("status").objectReferenceValue;
            status.fontSize=15;status.resizeTextForBestFit=true;status.resizeTextMinSize=12;status.resizeTextMaxSize=15;
            status.rectTransform.sizeDelta=new Vector2(760,40);
            PrefabUtility.SaveAsPrefabAsset(root,path);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
    }

    static void Set(SerializedObject target,string name,UnityEngine.Object value) => target.FindProperty(name).objectReferenceValue=value;
    static void Array<T>(SerializedObject target,string name,T[] values) where T : UnityEngine.Object
    {
        var field=target.FindProperty(name);field.arraySize=values.Length;
        for (int i=0;i<values.Length;i++)field.GetArrayElementAtIndex(i).objectReferenceValue=values[i];
    }
    public static void AuthorBatch()
    {
        try { Author();EditorApplication.Exit(0); }
        catch(Exception error) { Debug.LogException(error);EditorApplication.Exit(1); }
    }
}
