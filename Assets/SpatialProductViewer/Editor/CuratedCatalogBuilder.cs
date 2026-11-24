using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using SpatialProductViewer;
using UnityEditor;
using UnityEditor.Events;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

// Authoring only: builds ordinary assets and saved UI instances. Nothing runs at player startup.
public static class CuratedCatalogBuilder
{
    const string Base = "Assets/SpatialProductViewer/";
    const string ManifestPath = Base + "Models/Curated/catalog.json";
    const string ProductFolder = Base + "Products/Curated";
    const string PrefabFolder = Base + "Prefabs/Products";
    const string WindowPath = Base + "Prefabs/ProductCatalogWindow.prefab";

    [Serializable] public class Manifest { public Model[] models; }
    [Serializable] public class Model
    {
        public string id, title, model, thumbnail, source, authors, license, scaleBasis;
        public int category, scaleAxis;
        public float targetMeters;
    }
    [Serializable] public class Measurements { public List<Measurement> models = new List<Measurement>(); }
    [Serializable] public class Measurement
    {
        public string id;
        public Vector3 dimensionsMeters;
        public int renderers, materialSlots, triangles;
    }

    [MenuItem("Tools/Spatial Product Viewer/Rebuild Curated Catalog")]
    public static void Rebuild()
    {
        var manifest = JsonUtility.FromJson<Manifest>(File.ReadAllText(ManifestPath));
        EnsureFolder(ProductFolder); EnsureFolder(PrefabFolder);
        var definitions = new List<ProductDefinition>();
        var measurements = new Measurements();
        foreach (var model in manifest.models)
        {
            definitions.Add(BuildProduct(model, out var measurement));
            measurements.models.Add(measurement);
        }
        PrepareCardTemplate();
        BuildWindow(definitions);
        File.WriteAllText(Base + "Models/Curated/measurements.json", JsonUtility.ToJson(measurements, true));
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        Debug.Log($"CURATED CATALOG READY: {definitions.Count} curated products; 24 free import slots.");
    }

    // Explicit entry point for the isolated authoring project; no APK build or device installation.
    public static void RebuildBatch()
    {
        try { Rebuild(); Validate(); EditorApplication.Exit(0); }
        catch (Exception error) { Debug.LogException(error); EditorApplication.Exit(1); }
    }

    static ProductDefinition BuildProduct(Model model, out Measurement measurement)
    {
        var source = AssetDatabase.LoadAssetAtPath<GameObject>(model.model);
        if (!source) throw new InvalidOperationException("Model did not import: " + model.model);
        var importer = (TextureImporter)AssetImporter.GetAtPath(model.thumbnail);
        importer.textureType = TextureImporterType.Sprite;
        importer.spriteImportMode = SpriteImportMode.Single;
        importer.alphaIsTransparency = true;
        importer.mipmapEnabled = false;
        importer.maxTextureSize = 512;
        importer.SaveAndReimport();
        var image = AssetDatabase.LoadAssetAtPath<Sprite>(model.thumbnail);
        if (!image) throw new InvalidOperationException("Missing thumbnail: " + model.id);

        var root = PrefabUtility.LoadPrefabContents(Base + "Prefabs/ImportedProduct.prefab");
        Vector3 dimensions;
        try
        {
            root.SetActive(false);
            root.name = model.title;
            var visual = (GameObject)PrefabUtility.InstantiatePrefab(source, root.transform);
            visual.name = "Model - " + model.title;
            var product = root.GetComponent<SelectableProduct>();
            product.SetDisplayName(model.title);
            product.ConfigureImportedModel();
            var original = product.GetLocalBounds().size;
            if (Mathf.Min(original.x, original.y, original.z) < .0001f)
                throw new InvalidOperationException("Invalid bounds: " + model.id);
            if (model.scaleAxis >= 0)
            {
                float scale = model.targetMeters / original[model.scaleAxis];
                visual.transform.localScale *= scale;
                product.ConfigureImportedModel();
            }
            dimensions = product.GetLocalBounds().size;
            var renderers = root.GetComponentsInChildren<Renderer>(true);
            measurement = new Measurement { id = model.id, dimensionsMeters = dimensions,
                renderers = renderers.Length, materialSlots = renderers.Sum(r => r.sharedMaterials.Length),
                triangles = root.GetComponentsInChildren<MeshFilter>(true).Sum(f =>
                    f.sharedMesh ? Enumerable.Range(0, f.sharedMesh.subMeshCount).Sum(i => (int)f.sharedMesh.GetIndexCount(i) / 3) : 0) };
            root.SetActive(true);
            PrefabUtility.SaveAsPrefabAsset(root, PrefabFolder + "/" + model.id + ".prefab");
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }

        var path = ProductFolder + "/" + model.id + ".asset";
        var definition = AssetDatabase.LoadAssetAtPath<ProductDefinition>(path);
        if (!definition) { definition = ScriptableObject.CreateInstance<ProductDefinition>(); AssetDatabase.CreateAsset(definition, path); }
        var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(PrefabFolder + "/" + model.id + ".prefab");
        definition.ConfigureCatalog(model.title, (ProductDefinition.ProductCategory)model.category,
            dimensions, prefab.GetComponent<SelectableProduct>(), image);
        if (string.IsNullOrEmpty(definition.PersistentId))
            definition.SetPersistentId("builtin:" + AssetDatabase.AssetPathToGUID(path));
        EditorUtility.SetDirty(definition);
        return definition;
    }

    static void PrepareCardTemplate()
    {
        var path = Base + "Prefabs/ProductCard.prefab";
        var root = PrefabUtility.LoadPrefabContents(path);
        try
        {
            var fields = new SerializedObject(root.GetComponent<ProductCatalogCard>());
            foreach (var name in new[] { "title", "dimensions" })
            {
                var label = (Text)fields.FindProperty(name).objectReferenceValue;
                label.resizeTextForBestFit = true;
                label.resizeTextMinSize = 13;
                label.resizeTextMaxSize = name == "title" ? 21 : 18;
            }
            PrefabUtility.SaveAsPrefabAsset(root, path);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
    }

    static void BuildWindow(List<ProductDefinition> definitions)
    {
        var root = PrefabUtility.LoadPrefabContents(WindowPath);
        try
        {
            var controller = root.GetComponent<ProductCatalogController>();
            var fields = new SerializedObject(controller);
            var content = (RectTransform)fields.FindProperty("content").objectReferenceValue;
            var slots = fields.FindProperty("importedSlots");
            var cards = content.GetComponentsInChildren<ProductCatalogCard>(true).ToList();
            foreach (var definition in definitions)
            {
                var card = cards.FirstOrDefault(c => c.Definition == definition);
                if (!card)
                {
                    var instance = (GameObject)PrefabUtility.InstantiatePrefab(AssetDatabase.LoadAssetAtPath<GameObject>(Base + "Prefabs/ProductCard.prefab"), content);
                    card = instance.GetComponent<ProductCatalogCard>();
                }
                card.name = definition.DisplayName + " Card";
                card.gameObject.SetActive(true);
                card.Bind(definition);
                var cardFields = new SerializedObject(card);
                cardFields.FindProperty("catalog").objectReferenceValue = controller;
                cardFields.ApplyModifiedPropertiesWithoutUndo();
                card.Refresh();
                card.transform.SetAsLastSibling();
                PrefabUtility.RecordPrefabInstancePropertyModifications(card);
            }
            // Move the empty slots after all built-in cards, also on a subsequent rebuild.
            for (int i = 0; i < slots.arraySize; i++)
                ((ProductCatalogCard)slots.GetArrayElementAtIndex(i).objectReferenceValue).transform.SetAsLastSibling();
            Transform Find(string name) => root.GetComponentsInChildren<Transform>(true).First(t => t.name == name);
            var all = Find("All Filter").gameObject;
            var furniture = Find("Cubes Filter").gameObject;
            var electronics = Find("Blocks Filter").gameObject;
            // Retain historical hierarchy names so the authoring command is repeatable.
            var imported = Find("Imported Filter").gameObject;
            var objects = root.GetComponentsInChildren<Transform>(true).FirstOrDefault(t => t.name == "Objects Filter")?.gameObject;
            if (!objects) { objects = UnityEngine.Object.Instantiate(all, all.transform.parent); objects.name = "Objects Filter"; }
            SetFilter(all, "All", -340, 96, controller.ShowAll);
            SetFilter(furniture, "Furniture", -210, 150, controller.ShowFurniture);
            SetFilter(electronics, "Electronics", -55, 150, controller.ShowElectronics);
            SetFilter(objects, "Objects", 90, 124, controller.ShowObjects);
            SetFilter(imported, "Imported", 235, 150, controller.ShowImported);
            var graphics = fields.FindProperty("categoryGraphics");
            graphics.arraySize = 7;
            var filterObjects = new[] { all, null, null, imported, furniture, electronics, objects };
            for (int i = 0; i < filterObjects.Length; i++)
                graphics.GetArrayElementAtIndex(i).objectReferenceValue = filterObjects[i] ? filterObjects[i].GetComponent<SelectionMenuGraphic>() : null;
            var count = (Text)fields.FindProperty("countLabel").objectReferenceValue;
            count.rectTransform.anchoredPosition = new Vector2(-80, 359);
            count.rectTransform.sizeDelta = new Vector2(430, 24);
            count.fontSize = 14;
            int productCount = content.GetComponentsInChildren<ProductCatalogCard>(true).Count(c => c.Definition);
            count.text = $"{productCount} products  /  True scale";
            fields.ApplyModifiedPropertiesWithoutUndo();
            LayoutRebuilder.ForceRebuildLayoutImmediate(content);
            var scroll = (ScrollRect)fields.FindProperty("scroll").objectReferenceValue;
            scroll.verticalNormalizedPosition = 1;
            PrefabUtility.SaveAsPrefabAsset(root, WindowPath);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
    }

    static void SetFilter(GameObject buttonObject, string title, float x, float width, UnityAction action)
    {
        var rect = (RectTransform)buttonObject.transform;
        rect.anchoredPosition = new Vector2(x, 326);
        rect.sizeDelta = new Vector2(width, 44);
        buttonObject.GetComponentInChildren<Text>(true).text = title;
        var button = buttonObject.GetComponent<Button>();
        while (button.onClick.GetPersistentEventCount() > 0) UnityEventTools.RemovePersistentListener(button.onClick, 0);
        UnityEventTools.AddPersistentListener(button.onClick, action);
    }

    [MenuItem("Tools/Spatial Product Viewer/Validate Curated Catalog")]
    public static void Validate()
    {
        var window = AssetDatabase.LoadAssetAtPath<GameObject>(WindowPath);
        var cards = window.GetComponentsInChildren<ProductCatalogCard>(true);
        var manifest = JsonUtility.FromJson<Manifest>(File.ReadAllText(ManifestPath));
        if (cards.Count(c => !c.Definition) != 24)
            throw new InvalidOperationException("Expected 24 free import slots");
        foreach (var model in manifest.models)
        {
            var definition = AssetDatabase.LoadAssetAtPath<ProductDefinition>(ProductFolder + "/" + model.id + ".asset");
            if (!definition || !cards.Any(c => c.Definition == definition))
                throw new InvalidOperationException("Missing curated catalog card: " + model.id);
        }
        foreach (var card in cards.Where(c => c.Definition))
        {
            var def = card.Definition;
            if (!def.Prefab || !def.DimensionsLabel.EndsWith(" cm")) throw new InvalidOperationException("Invalid card: " + def.name);
            if (Vector3.Distance(def.Prefab.GetLocalBounds().size, def.DimensionsMeters) > .001f && def.Category >= ProductDefinition.ProductCategory.Furniture)
                throw new InvalidOperationException("Dimension mismatch: " + def.name);
            if (def.Category >= ProductDefinition.ProductCategory.Furniture && !def.Thumbnail)
                throw new InvalidOperationException("Missing thumbnail: " + def.name);
            foreach (var renderer in def.Prefab.GetComponentsInChildren<Renderer>(true))
                foreach (var material in renderer.sharedMaterials)
                    if (!material || !material.shader || !material.shader.isSupported) throw new InvalidOperationException("Missing/unsupported material: " + def.name);
        }
        Debug.Log($"CURATED CATALOG VALIDATED: {cards.Count(c => c.Definition)} cards, dimensions, prefabs, materials, thumbnails and 24 free import slots.");
    }

    static void EnsureFolder(string path)
    {
        if (AssetDatabase.IsValidFolder(path)) return;
        var parent = Path.GetDirectoryName(path).Replace('\\', '/');
        EnsureFolder(parent);
        AssetDatabase.CreateFolder(parent, Path.GetFileName(path));
    }
}
