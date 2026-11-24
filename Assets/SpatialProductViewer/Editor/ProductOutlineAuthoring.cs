using System;
using System.Linq;
using SpatialProductViewer;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public static class ProductOutlineAuthoring
{
    const string Base="Assets/SpatialProductViewer/";
    [MenuItem("Tools/Spatial Product Viewer/Use Product Silhouette Outline")]
    public static void Author()
    {
        var mask=Material("ProductOutlineMask","ProductOutlineMask.shader");
        var contour=Material("ProductOutlineContour","ProductOutlineComposite.shader");
        string path=Base+"Prefabs/ProductSelectionControls.prefab";
        var root=PrefabUtility.LoadPrefabContents(path);
        try
        {
            var view=root.GetComponent<ProductSelectionView>();var fields=new SerializedObject(view);
            var anchor=(Transform)fields.FindProperty("boundsRoot").objectReferenceValue;
            while(anchor.childCount>0) UnityEngine.Object.DestroyImmediate(anchor.GetChild(0).gameObject);
            anchor.name="Selection Anchor (no visible box)";
            var outline=root.GetComponent<ProductOutlineView>() ?? root.AddComponent<ProductOutlineView>();
            var data=new SerializedObject(outline);data.FindProperty("maskMaterial").objectReferenceValue=mask;
            data.FindProperty("outlineMaterial").objectReferenceValue=contour;data.ApplyModifiedPropertiesWithoutUndo();
            fields.FindProperty("outlineView").objectReferenceValue=outline;fields.ApplyModifiedPropertiesWithoutUndo();
            PrefabUtility.SaveAsPrefabAsset(root,path);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
        int count=0;
        foreach(var guid in AssetDatabase.FindAssets("t:UniversalRendererData",new[]{"Assets/Settings"}))
        {
            path=AssetDatabase.GUIDToAssetPath(guid);var renderer=AssetDatabase.LoadAssetAtPath<UniversalRendererData>(path);
            if(!renderer.rendererFeatures.OfType<ProductOutlineRendererFeature>().Any())
            {
                var feature=ScriptableObject.CreateInstance<ProductOutlineRendererFeature>();feature.name="Product silhouette outline";
                AssetDatabase.AddObjectToAsset(feature,renderer);renderer.rendererFeatures.Add(feature);feature.Create();
                EditorUtility.SetDirty(feature);renderer.SetDirty();EditorUtility.SetDirty(renderer);
            }
            count++;
        }
        if(count==0) throw new InvalidOperationException("No project URP renderer data was found.");
        AssetDatabase.SaveAssets();
        Debug.Log("PRODUCT OUTLINE AUTHORED: selected-model silhouette, preserved fit colours, editable materials and width, "+count+" URP renderers; box colliders and rulers retained.");
    }
    static Material Material(string name,string shaderFile)
    {
        var shader=AssetDatabase.LoadAssetAtPath<Shader>(Base+"Shaders/"+shaderFile);
        if(!shader) throw new InvalidOperationException("Outline shader did not import: "+shaderFile);
        var errors=ShaderUtil.GetShaderMessages(shader).Where(m=>m.severity==UnityEditor.Rendering.ShaderCompilerMessageSeverity.Error);
        if(errors.Any()) throw new InvalidOperationException(string.Join(" / ",errors.Select(m=>m.message)));
        var material=AssetDatabase.LoadAssetAtPath<Material>(Base+"Materials/"+name+".mat");
        if(!material) { material=new Material(shader) {name=name};AssetDatabase.CreateAsset(material,Base+"Materials/"+name+".mat"); }
        return material;
    }
    public static void AuthorBatch()
    {
        try { Author();EditorApplication.Exit(0); }
        catch(Exception e) { Debug.LogException(e);EditorApplication.Exit(1); }
    }
}
