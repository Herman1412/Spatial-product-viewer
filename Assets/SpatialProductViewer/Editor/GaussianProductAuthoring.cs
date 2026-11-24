using System;
using System.Linq;
using Gsplat;
using SpatialProductViewer;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering.Universal;
using UnityEngine.UI;

public static class GaussianProductAuthoring
{
    const string Base="Assets/SpatialProductViewer/";
    [MenuItem("Tools/Spatial Product Viewer/Configure Gaussian Products")]
    public static void Author()
    {
        var shader=AssetDatabase.LoadAssetAtPath<Shader>(Base+"Shaders/GaussianProduct.shader");
        if(!shader)throw new InvalidOperationException("Gaussian product shader is missing.");
        var settings=GsplatSettings.Instance;
        var materials=new GsplatMaterial[2];
        foreach(var compression in new[]{Gsplat.CompressionMode.Uncompressed,Gsplat.CompressionMode.Spark})
        {
            string name="Gaussian"+compression;
            var material=AssetDatabase.LoadAssetAtPath<Material>(Base+"Materials/"+name+".mat");
            if(!material)
            {
                material=new Material(shader) {name=name,enableInstancing=true};
                material.EnableKeyword(compression==Gsplat.CompressionMode.Spark ? "SPARK" : "UNCOMPRESSED");
                material.EnableKeyword("GSPLAT_VERTEX_BUFFERS");material.EnableKeyword("SH_BANDS_0");
                AssetDatabase.CreateAsset(material,Base+"Materials/"+name+".mat");
            }
            string path=Base+"Materials/"+name+"Settings.asset";
            var options=AssetDatabase.LoadAssetAtPath<GsplatMaterial>(path);
            if(!options)
            {
                options=UnityEngine.Object.Instantiate(settings.Materials[(int)compression]);options.name=name+"Settings";
                options.DefaultMaterial=material;AssetDatabase.CreateAsset(options,path);
            }
            materials[(int)compression]=options;
        }
        settings.Materials=materials;
        // Individual draw bindings carry product occlusion and selection. Global merged draws
        // use a different shader and cannot preserve those per-product bindings.
        settings.EnableGlobalSort=false;settings.ShowDebugLog=false;settings.DisplayBoundingBoxes=false;
        EditorUtility.SetDirty(settings);
        string prefabPath=Base+"Prefabs/ImportedGaussianProduct.prefab";
        var prefab=AssetDatabase.LoadAssetAtPath<GameObject>(prefabPath);
        if(!prefab)
        {
            var root=PrefabUtility.LoadPrefabContents(Base+"Prefabs/ImportedProduct.prefab");
            try
            {
                root.name="Imported Gaussian Product";
                var visual=new GameObject("Gaussian Visual",typeof(GsplatRenderer));visual.transform.SetParent(root.transform,false);
                var renderer=visual.GetComponent<GsplatRenderer>();renderer.SHDegree=1;renderer.AsyncUpload=false;renderer.CutoutsUpdateBounds=false;
                var product=root.AddComponent<GaussianProduct>();var fields=new SerializedObject(product);
                fields.FindProperty("splatRenderer").objectReferenceValue=renderer;fields.ApplyModifiedPropertiesWithoutUndo();
                PrefabUtility.SaveAsPrefabAsset(root,prefabPath);
            }
            finally {PrefabUtility.UnloadPrefabContents(root);}
            prefab=AssetDatabase.LoadAssetAtPath<GameObject>(prefabPath);
        }
        var splat=prefab.GetComponentInChildren<GsplatRenderer>(true);
        if(splat.CutoutsUpdateBounds)
        {
            splat.CutoutsUpdateBounds=false;EditorUtility.SetDirty(splat);PrefabUtility.SavePrefabAsset(prefab);
        }
        string catalogPath=Base+"Prefabs/ProductCatalogWindow.prefab";
        var catalog=PrefabUtility.LoadPrefabContents(catalogPath);
        try
        {
            var library=catalog.GetComponentInChildren<LocalModelLibrary>(true);
            var fields=new SerializedObject(library);fields.FindProperty("importedGaussianPrefab").objectReferenceValue=prefab.GetComponent<SelectableProduct>();
            fields.ApplyModifiedPropertiesWithoutUndo();PrefabUtility.SaveAsPrefabAsset(catalog,catalogPath);
        }
        finally {PrefabUtility.UnloadPrefabContents(catalog);}
        string panelPath=Base+"Prefabs/LocalModelImportPanel.prefab";
        var panel=PrefabUtility.LoadPrefabContents(panelPath);
        try
        {
            foreach(var text in panel.GetComponentsInChildren<Text>(true))
            {
                if(text.text.Contains("Choose a local GLB"))text.text="Local GLB or Gaussian PLY / SPZ / SPLAT. No server or upload.";
                if(text.text.Contains("Embedded textures"))text.text="GLB / PLY / SPZ / SPLAT · Stored on this device";
                if(text.text=="Choose GLB")text.text="Choose file";
                if(text.text.Contains("after choosing a GLB"))text.text="Model size appears after choosing a file";
            }
            PrefabUtility.SaveAsPrefabAsset(panel,panelPath);
        }
        finally {PrefabUtility.UnloadPrefabContents(panel);}
        var featureType=typeof(GsplatRenderer).Assembly.GetType("Gsplat.GsplatURPFeature",true);
        foreach(var guid in AssetDatabase.FindAssets("t:UniversalRendererData",new[]{"Assets/Settings"}))
        {
            var renderer=AssetDatabase.LoadAssetAtPath<UniversalRendererData>(AssetDatabase.GUIDToAssetPath(guid));
            if(renderer.rendererFeatures.Any(f=>f && f.GetType()==featureType))continue;
            var feature=(ScriptableRendererFeature)ScriptableObject.CreateInstance(featureType);feature.name="Gaussian splat sorting";
            AssetDatabase.AddObjectToAsset(feature,renderer);renderer.rendererFeatures.Add(feature);feature.Create();renderer.SetDirty();EditorUtility.SetDirty(renderer);
        }
        AssetDatabase.SaveAssets();Debug.Log("GAUSSIAN PRODUCTS AUTHORED: saved prefab, import bindings, materials, settings and URP features.");
    }
    public static void AuthorBatch()
    {
        try {Author();EditorApplication.Exit(0);}
        catch(Exception e){Debug.LogException(e);EditorApplication.Exit(1);}
    }
}
