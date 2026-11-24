using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;

// Explicit editor authoring, never runtime shader or menu generation.
public static class ProductOcclusionShaders
{
    const string Destination="Assets/SpatialProductViewer/Shaders/";
    [MenuItem("Tools/Spatial Product Viewer/Update Product Occlusion Shaders")]
    public static void Bake()
    {
        var importer=Assembly.Load("Unity.ShaderGraph.Editor").GetType("UnityEditor.ShaderGraph.ShaderGraphImporter");
        var generate=importer.GetMethods(BindingFlags.Static|BindingFlags.NonPublic|BindingFlags.Public)
            .Single(m=>m.Name=="GetShaderText" && m.GetParameters().Length==4);
        string[] graphs={"glTF-pbrMetallicRoughness","glTF-pbrSpecularGlossiness","glTF-unlit","URP/glTF-pbrMetallicRoughness-Clearcoat"};
        foreach(string graph in graphs)
        {
            var args=new object[]{"Packages/com.unity.cloud.gltfast/Runtime/Shader/"+graph+".shadergraph",null,null,null};
            string code=(string)generate.Invoke(null,args);
            string name=Path.GetFileName(graph);
            code=code.Replace("Shader \"Shader Graphs/"+name+"\"","Shader \"SpatialProductViewer/Occlusion/"+name+"\"");
            code=code.Replace("#pragma target 2.0","#pragma target 4.5");
            foreach(string pass in new[]{"PBRForwardPass","UnlitPass"})
                code=code.Replace("Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/"+pass+".hlsl",Destination+"Occluded"+pass+".hlsl");
            File.WriteAllText(Destination+name+".shader",code);
            AssetDatabase.ImportAsset(Destination+name+".shader",ImportAssetOptions.ForceSynchronousImport);
            var settings=new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/GraphicsSettings.asset")[0]);
            var included=settings.FindProperty("m_AlwaysIncludedShaders");
            var shader=AssetDatabase.LoadAssetAtPath<Shader>(Destination+name+".shader");
            if(!Enumerable.Range(0,included.arraySize).Any(i=>included.GetArrayElementAtIndex(i).objectReferenceValue==shader))
            {
                included.InsertArrayElementAtIndex(included.arraySize);
                included.GetArrayElementAtIndex(included.arraySize-1).objectReferenceValue=shader;
                settings.ApplyModifiedPropertiesWithoutUndo();
            }
        }
        AssetDatabase.SaveAssets();
        Debug.Log("Product occlusion shader sources baked from installed glTFast graphs.");
    }
    public static void BakeBatch()
    {
        try
        {
            Bake();
            typeof(DepthAndDimensionsAuthoring).GetMethod("AuthorDepth",BindingFlags.Static|BindingFlags.NonPublic).Invoke(null,null);
            EditorApplication.Exit(0);
        }
        catch(Exception e) { Debug.LogException(e);EditorApplication.Exit(1); }
    }
}
