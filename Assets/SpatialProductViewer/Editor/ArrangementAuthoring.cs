using System;
using System.Linq;
using SpatialProductViewer;
using UnityEditor;
using UnityEditor.Events;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;
using UnityEngine.XR.Interaction.Toolkit.UI;

// Explicit authoring command: all layout controls are saved in the catalog prefab.
public static class ArrangementAuthoring
{
    const string Base = "Assets/SpatialProductViewer/";
    const string Window = Base + "Prefabs/ProductCatalogWindow.prefab";
    static Font font;

    [MenuItem("Tools/Spatial Product Viewer/Add Arrangement Controls")]
    public static void Author()
    {
        foreach (var guid in AssetDatabase.FindAssets("t:ProductDefinition",new[] { Base + "Products" }))
        {
            var definition = AssetDatabase.LoadAssetAtPath<ProductDefinition>(AssetDatabase.GUIDToAssetPath(guid));
            if (!string.IsNullOrEmpty(definition.PersistentId)) continue;
            definition.SetPersistentId("builtin:" + guid); EditorUtility.SetDirty(definition);
        }
        font = AssetDatabase.LoadAssetAtPath<Font>(AssetDatabase.GUIDToAssetPath("78c7f42a7547f22448a621eaeeef3fd2"));
        if (!font) throw new InvalidOperationException("The UI font is missing.");
        var root = PrefabUtility.LoadPrefabContents(Window);
        try
        {
            if (root.GetComponent<ArrangementPanel>()) throw new InvalidOperationException("Arrangement controls are already authored.");
            var catalog = root.GetComponent<ProductCatalogController>();
            var catalogFields = new SerializedObject(catalog);
            var expanded = (GameObject)catalogFields.FindProperty("expandedPanel").objectReferenceValue;
            var manager = root.AddComponent<ArrangementManager>();
            var controller = root.AddComponent<ArrangementPanel>();
            var managerFields = new SerializedObject(manager);
            Set(managerFields,"catalog",catalog);
            Set(managerFields,"library",root.GetComponentInChildren<LocalModelLibrary>(true));
            managerFields.ApplyModifiedPropertiesWithoutUndo();

            var panel = Rect("Arrangement Panel",root.transform,new Vector2(840,900),new Vector2(0,.51f));
            panel.transform.localScale = Vector3.one * .001f;
            var canvas = panel.gameObject.AddComponent<Canvas>(); canvas.renderMode = RenderMode.WorldSpace; canvas.sortingOrder = 20;
            panel.gameObject.AddComponent<GraphicRaycaster>();
            panel.gameObject.AddComponent<TrackedDeviceGraphicRaycaster>();
            var back = Rect("Glass Backplate",panel,new Vector2(840,900),Vector2.zero);
            Art(back.gameObject,new Color(.18f,.24f,.32f,.94f),true);
            Label("Title",panel,"Saved layouts",new Vector2(-60,394),new Vector2(610,52),32,TextAnchor.MiddleLeft,true);
            Label("Subtitle",panel,"Five local save slots  /  Includes imported models",new Vector2(0,348),new Vector2(750,32),18);
            Button("Close",panel,"Close",new Vector2(338,394),new Vector2(100,44),controller.Close);
            var titles = new Text[5]; var details = new Text[5]; var graphics = new SelectionMenuGraphic[5];
            for (int i = 0; i < 5; i++)
            {
                var row = Rect("Save Slot " + (i+1),panel,new Vector2(760,76),new Vector2(0,257-i*88));
                graphics[i] = Art(row.gameObject,new Color(.2f,.27f,.35f,.92f),true);
                var button = row.gameObject.AddComponent<Button>(); button.targetGraphic = graphics[i]; NoNavigation(button);
                var listener = new UnityAction<int>(controller.SelectSlot);
                UnityEventTools.AddIntPersistentListener(button.onClick,listener,i);
                titles[i] = Label("Name",row,(i+1) + "   Empty slot",new Vector2(0,13),new Vector2(700,30),22,TextAnchor.MiddleLeft,true);
                details[i] = Label("Details",row,"Ready for a new layout",new Vector2(0,-19),new Vector2(700,25),16,TextAnchor.MiddleLeft);
            }
            var source = AssetDatabase.LoadAssetAtPath<GameObject>(Base + "Prefabs/LocalModelImportPanel.prefab").GetComponent<LocalModelImportPanel>();
            var nameField = (InputField)new SerializedObject(source).FindProperty("productName").objectReferenceValue;
            var input = UnityEngine.Object.Instantiate(nameField,panel);
            input.name = "Layout Name"; input.transform.localScale = Vector3.one;
            input.GetComponent<RectTransform>().anchoredPosition = new Vector2(70,-193);
            input.GetComponent<RectTransform>().sizeDelta = new Vector2(600,48);
            foreach (var label in input.GetComponentsInChildren<Text>(true))
            {
                label.rectTransform.anchorMin = Vector2.zero; label.rectTransform.anchorMax = Vector2.one;
                label.rectTransform.offsetMin = new Vector2(16,4); label.rectTransform.offsetMax = new Vector2(-16,-4);
                label.fontSize = 20;
            }
            input.characterLimit = 64; input.text = "Layout 1";
            input.onValueChanged = new InputField.OnChangeEvent(); input.onEndEdit = new InputField.EndEditEvent();
            UnityEventTools.AddPersistentListener(input.onValueChanged,controller.NameChanged);
            Label("Name Label",panel,"Name",new Vector2(-321,-193),new Vector2(100,38),20,TextAnchor.MiddleLeft);
            var save = Button("Save Layout",panel,"Save layout",new Vector2(-255,-268),new Vector2(235,50),controller.Save);
            var load = Button("Load Layout",panel,"Load in room",new Vector2(0,-268),new Vector2(235,50),controller.Load);
            var near = Button("Place Near Me",panel,"Place near me",new Vector2(255,-268),new Vector2(235,50),controller.PlaceNearMe);
            var message = Label("Message",panel,"Arrange your products, then choose a slot and Save.",new Vector2(0,-351),new Vector2(750,92),19);
            Label("Storage Hint",panel,"Loading replaces current products after confirmation.",new Vector2(0,-415),new Vector2(750,32),16);
            var fields = new SerializedObject(controller);
            Set(fields,"manager",manager); Set(fields,"panel",panel.gameObject); Set(fields,"catalogPanel",expanded);
            Set(fields,"layoutName",input); Set(fields,"message",message);
            Set(fields,"saveButton",save); Set(fields,"loadButton",load); Set(fields,"nearButton",near);
            Set(fields,"saveLabel",save.GetComponentInChildren<Text>());
            Set(fields,"loadLabel",load.GetComponentInChildren<Text>());
            Set(fields,"nearLabel",near.GetComponentInChildren<Text>());
            SetArray(fields,"slotTitles",titles); SetArray(fields,"slotDetails",details); SetArray(fields,"slotGraphics",graphics);
            fields.ApplyModifiedPropertiesWithoutUndo();
            panel.gameObject.SetActive(false);
            Button("Saved Layouts Button",expanded.transform,"Saved layouts",new Vector2(-272,-410),new Vector2(180,40),controller.Open);
            var status = (Text)catalogFields.FindProperty("statusLabel").objectReferenceValue;
            status.rectTransform.anchoredPosition = new Vector2(100,-410);
            status.rectTransform.sizeDelta = new Vector2(530,38);
            status.resizeTextForBestFit = true; status.resizeTextMinSize = 13; status.resizeTextMaxSize = 18;
            PrefabUtility.SaveAsPrefabAsset(root,Window);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
        AssetDatabase.SaveAssets();
        Debug.Log("ARRANGEMENT AUTHORING COMPLETE: five saved slots, persistent product IDs and editable controls.");
    }

    public static void AuthorBatch()
    {
        try { Author(); EditorApplication.Exit(0); }
        catch (Exception error) { Debug.LogException(error); EditorApplication.Exit(1); }
    }

    public static void RefreshControls()
    {
        var root = PrefabUtility.LoadPrefabContents(Window);
        try
        {
            foreach (var art in root.GetComponentsInChildren<SelectionMenuGraphic>(true))
                if (!art.GetComponent<CanvasRenderer>()) art.gameObject.AddComponent<CanvasRenderer>();
            var panel = root.GetComponent<ArrangementPanel>();
            var input = (InputField)new SerializedObject(panel).FindProperty("layoutName").objectReferenceValue;
            foreach (var label in input.GetComponentsInChildren<Text>(true))
            {
                label.rectTransform.anchorMin = Vector2.zero; label.rectTransform.anchorMax = Vector2.one;
                label.rectTransform.offsetMin = new Vector2(16,4); label.rectTransform.offsetMax = new Vector2(-16,-4);
                label.fontSize = 20;
            }
            PrefabUtility.SaveAsPrefabAsset(root,Window);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
    }

    static RectTransform Rect(string name, Transform parent, Vector2 size, Vector2 position)
    {
        var go = new GameObject(name,typeof(RectTransform)); go.layer = 5;
        var rect = (RectTransform)go.transform; rect.SetParent(parent,false);
        rect.sizeDelta = size; rect.anchoredPosition = position; return rect;
    }
    static SelectionMenuGraphic Art(GameObject go, Color color, bool raycast)
    {
        if (!go.GetComponent<CanvasRenderer>()) go.AddComponent<CanvasRenderer>();
        var art = go.AddComponent<SelectionMenuGraphic>(); art.color = color; art.raycastTarget = raycast; return art;
    }
    static Text Label(string name, Transform parent, string text, Vector2 position, Vector2 size, int fontSize,
        TextAnchor anchor = TextAnchor.MiddleCenter, bool bold = false)
    {
        var label = Rect(name,parent,size,position).gameObject.AddComponent<Text>();
        label.font = font; label.fontSize = fontSize; label.fontStyle = bold ? FontStyle.Bold : FontStyle.Normal;
        label.alignment = anchor; label.color = new Color(.94f,.98f,1,1); label.raycastTarget = false;
        label.supportRichText = false; label.text = text; return label;
    }
    static Button Button(string name, Transform parent, string text, Vector2 position, Vector2 size, UnityAction callback)
    {
        var rect = Rect(name,parent,size,position);
        var art = Art(rect.gameObject,new Color(.18f,.29f,.37f,.95f),true);
        var button = rect.gameObject.AddComponent<Button>(); button.targetGraphic = art; NoNavigation(button);
        UnityEventTools.AddPersistentListener(button.onClick,callback);
        Label("Label",rect,text,Vector2.zero,new Vector2(size.x-12,size.y-4),20);
        return button;
    }
    static void NoNavigation(Selectable selectable) => selectable.navigation = new Navigation { mode = Navigation.Mode.None };
    static void Set(SerializedObject target, string property, UnityEngine.Object value) => target.FindProperty(property).objectReferenceValue = value;
    static void SetArray<T>(SerializedObject target, string property, T[] values) where T : UnityEngine.Object
    {
        var field = target.FindProperty(property); field.arraySize = values.Length;
        for (int i = 0; i < values.Length; i++) field.GetArrayElementAtIndex(i).objectReferenceValue = values[i];
    }
}
