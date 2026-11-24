using System;
using System.Linq;
using SpatialProductViewer;
using UnityEditor;
using UnityEditor.Events;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public static class ProductSnappingAuthoring
{
    const string Base="Assets/SpatialProductViewer/Prefabs/";
    [MenuItem("Tools/Spatial Product Viewer/Remove Legacy Room Snap Mode")]
    public static void RemoveRoomMode()
    {
        var path=Base+"ProductSelectionControls.prefab";
        var root=PrefabUtility.LoadPrefabContents(path);
        try
        {
            var fields=new SerializedObject(root.GetComponent<ProductSelectionView>());
            var array=fields.FindProperty("surfaceButtons");
            var buttons=Enumerable.Range(0,array.arraySize).Select(i=>(Button)array.GetArrayElementAtIndex(i).objectReferenceValue).ToArray();
            foreach(var button in buttons.Where(b=>b && b.name=="Surface Room"))
                UnityEngine.Object.DestroyImmediate(button.gameObject);
            var names=new[]{"Free","Floor","Table","Wall"};
            var controller=root.GetComponent<ProductSelectionController>();
            UnityAction[] actions={controller.SurfaceFree,controller.SurfaceFloor,controller.SurfaceTable,controller.SurfaceWall};
            var remaining=new Button[names.Length];
            for(int i=0;i<remaining.Length;i++)
            {
                var button=buttons.First(b=>b && b.name=="Surface "+names[i]);remaining[i]=button;
                var rect=(RectTransform)button.transform;rect.anchoredPosition=new Vector2(-210+i*140,-24);rect.sizeDelta=new Vector2(124,34);
                var label=button.GetComponentInChildren<Text>(true);label.rectTransform.sizeDelta=new Vector2(116,30);
                while(button.onClick.GetPersistentEventCount()>0) UnityEventTools.RemovePersistentListener(button.onClick,0);
                UnityEventTools.AddPersistentListener(button.onClick,actions[i]);
                button.targetGraphic.color=i==0 ? new Color(.15f,.43f,.52f,.98f) : new Color(.14f,.2f,.28f,.95f);
            }
            Assign(fields,"surfaceButtons",remaining);
            ((Text)fields.FindProperty("snapStatus").objectReferenceValue).text="Free detaches  /  Wall attaches the product's back face";
            fields.ApplyModifiedPropertiesWithoutUndo();PrefabUtility.SaveAsPrefabAsset(root,path);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
        AssetDatabase.SaveAssets();Debug.Log("ROOM MODE REMOVED: four saved surface controls, Free selected by default.");
    }
    public static void RemoveRoomModeBatch()
    {
        try { RemoveRoomMode();EditorApplication.Exit(0); }
        catch(Exception e) { Debug.LogException(e);EditorApplication.Exit(1); }
    }
    [MenuItem("Tools/Spatial Product Viewer/Add Per-Item Snapping Controls")]
    public static void Author()
    {
        var path=Base+"ProductSelectionControls.prefab";var root=PrefabUtility.LoadPrefabContents(path);
        try
        {
            var view=root.GetComponent<ProductSelectionView>();var fields=new SerializedObject(view);
            if(fields.FindProperty("surfaceButtons").arraySize>0) throw new InvalidOperationException("Snapping controls already exist; edit the prefab.");
            var controller=root.GetComponent<ProductSelectionController>();
            var menu=(RectTransform)fields.FindProperty("menu").objectReferenceValue;
            var panel=menu.GetComponentsInChildren<SelectionMenuGraphic>(true).First(g=>g.Glyph==SelectionMenuGraphic.GlyphType.Panel && !g.GetComponent<Button>());
            menu.sizeDelta=new Vector2(600,400);panel.rectTransform.sizeDelta=menu.sizeDelta;
            Position(fields,"productTitle",170,560,26);Position(fields,"productDimensions",145,560,24);
            Position(fields,"placementStatus",-150,560,24);Position(fields,"hint",-176,560,22);
            foreach(var button in menu.GetComponentsInChildren<Button>(true))
            { var rect=(RectTransform)button.transform;rect.anchoredPosition=new Vector2(rect.anchoredPosition.x,95); }
            foreach(var text in menu.GetComponentsInChildren<Text>(true))
                if(new[]{"Deselect","Duplicate","Delete","Scale","Reset size"}.Contains(text.text))
                {
                    var rect=text.rectTransform;
                    rect.anchoredPosition=new Vector2(rect.anchoredPosition.x,rect.parent==menu ? 41 : -54);
                }
            var font=((Text)fields.FindProperty("productTitle").objectReferenceValue).font;
            TextLabel(menu,"Surface Heading","SURFACE",font,new Vector2(0,7),new Vector2(560,20),13);
            TextLabel(menu,"Rotation Heading","ROTATION SNAP",font,new Vector2(0,-59),new Vector2(560,20),13);
            var status=TextLabel(menu,"Snap Status","Free detaches  /  Wall attaches the product's back face",font,
                new Vector2(0,-124),new Vector2(560,28),14);
            var surface=new[]{"Free","Floor","Table","Wall"};
            UnityAction[] surfaceActions={controller.SurfaceFree,controller.SurfaceFloor,controller.SurfaceTable,controller.SurfaceWall};
            var surfaces=new Button[4];
            for(int i=0;i<4;i++) surfaces[i]=Pill(menu,"Surface "+surface[i],surface[i],font,new Vector2(-210+i*140,-24),124,surfaceActions[i],i==0);
            var rotation=new[]{"Free","15°","45°","90°"};
            UnityAction[] rotationActions={controller.RotationFree,controller.Rotation15,controller.Rotation45,controller.Rotation90};
            var rotations=new Button[4];
            for(int i=0;i<4;i++) rotations[i]=Pill(menu,"Rotation "+rotation[i],rotation[i],font,new Vector2(-210+i*140,-86),124,rotationActions[i],i==0);
            Assign(fields,"surfaceButtons",surfaces);Assign(fields,"rotationButtons",rotations);
            fields.FindProperty("snapStatus").objectReferenceValue=status;fields.ApplyModifiedPropertiesWithoutUndo();
            var bounds=(Transform)fields.FindProperty("boundsRoot").objectReferenceValue;
            menu.position=bounds.position+Vector3.up*(.2f+.05f+menu.rect.height*menu.lossyScale.y*.5f);
            PrefabUtility.SaveAsPrefabAsset(root,path);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
        path=Base+"RoomEnvironment.prefab";root=PrefabUtility.LoadPrefabContents(path);
        try
        {
            foreach(var volume in root.GetComponentsInChildren<RoomPreviewVolume>(true))
            {
                var fields=new SerializedObject(volume);
                fields.FindProperty("snapSurface").intValue=(int)(volume.IsFloor ? ProductSurfaceMode.Floor : volume.name.Contains("Table")
                    ? ProductSurfaceMode.Tabletop : volume.name.Contains("Wall") ? ProductSurfaceMode.Wall : ProductSurfaceMode.Free);
                fields.ApplyModifiedPropertiesWithoutUndo();
            }
            PrefabUtility.SaveAsPrefabAsset(root,path);
        }
        finally { PrefabUtility.UnloadPrefabContents(root); }
        AssetDatabase.SaveAssets();Debug.Log("PER-ITEM SNAPPING AUTHORED: eight saved controls and classified editor tabletop/walls.");
    }
    static void Position(SerializedObject fields,string name,float y,float width,float height)
    {
        var text=(Text)fields.FindProperty(name).objectReferenceValue;
        text.rectTransform.anchoredPosition=new Vector2(0,y);text.rectTransform.sizeDelta=new Vector2(width,height);
    }
    static Text TextLabel(Transform parent,string name,string value,Font font,Vector2 position,Vector2 size,int fontSize)
    {
        var go=new GameObject(name,typeof(RectTransform),typeof(CanvasRenderer),typeof(Text));go.layer=5;
        var rect=(RectTransform)go.transform;rect.SetParent(parent,false);rect.anchoredPosition=position;rect.sizeDelta=size;
        var text=go.GetComponent<Text>();text.font=font;text.text=value;text.fontSize=fontSize;text.alignment=TextAnchor.MiddleCenter;
        text.raycastTarget=false;text.color=new Color(.85f,.96f,1,1);text.supportRichText=false;
        text.resizeTextForBestFit=true;text.resizeTextMinSize=12;text.resizeTextMaxSize=fontSize;return text;
    }
    static Button Pill(Transform parent,string name,string value,Font font,Vector2 position,float width,UnityAction action,bool selected)
    {
        var go=new GameObject(name,typeof(RectTransform),typeof(CanvasRenderer));go.layer=5;
        var rect=(RectTransform)go.transform;rect.SetParent(parent,false);rect.anchoredPosition=position;rect.sizeDelta=new Vector2(width,34);
        var art=go.AddComponent<SelectionMenuGraphic>();art.Glyph=SelectionMenuGraphic.GlyphType.Panel;
        art.color=selected ? new Color(.15f,.43f,.52f,.98f) : new Color(.14f,.2f,.28f,.95f);
        var settings=new SerializedObject(art);settings.FindProperty("cornerRadius").floatValue=16;settings.ApplyModifiedPropertiesWithoutUndo();
        var button=go.AddComponent<Button>();button.targetGraphic=art;button.navigation=new Navigation {mode=Navigation.Mode.None};
        UnityEventTools.AddPersistentListener(button.onClick,action);
        TextLabel(rect,"Label",value,font,Vector2.zero,new Vector2(width-8,30),16);return button;
    }
    static void Assign(SerializedObject fields,string name,Button[] values)
    {
        var array=fields.FindProperty(name);array.arraySize=values.Length;
        for(int i=0;i<values.Length;i++) array.GetArrayElementAtIndex(i).objectReferenceValue=values[i];
    }
    public static void AuthorBatch()
    {
        try { Author();EditorApplication.Exit(0); }
        catch(Exception e) { Debug.LogException(e);EditorApplication.Exit(1); }
    }
}
