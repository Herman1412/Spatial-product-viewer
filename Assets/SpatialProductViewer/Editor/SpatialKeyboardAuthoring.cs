using System;
using System.Collections.Generic;
using System.Linq;
using SpatialProductViewer;
using UnityEditor;
using UnityEditor.Events;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;
using UnityEngine.XR.Interaction.Toolkit.UI;

public static class SpatialKeyboardAuthoring
{
    const string Base="Assets/SpatialProductViewer/Prefabs/";
    [MenuItem("Tools/Spatial Product Viewer/Configure Editable Text Keyboard")]
    public static void Author()
    {
        var font=AssetDatabase.LoadAssetAtPath<GameObject>(Base+"LocalModelImportPanel.prefab").GetComponentInChildren<Text>(true).font;
        if(!font)throw new InvalidOperationException("Assign the existing UI font before authoring the keyboard.");
        string path=Base+"SpatialTextKeyboard.prefab";
        var prefab=AssetDatabase.LoadAssetAtPath<GameObject>(path);
        if(!prefab)
        {
            var root=new GameObject("Spatial Text Keyboard",typeof(SpatialTextKeyboard));
            try
            {
                var keyboard=root.GetComponent<SpatialTextKeyboard>();
                var panel=Rect(root.transform,"Keyboard Panel",Vector2.zero,new Vector2(680,440));panel.localScale=Vector3.one*.001f;
                var canvas=panel.gameObject.AddComponent<Canvas>();canvas.renderMode=RenderMode.WorldSpace;canvas.overrideSorting=true;canvas.sortingOrder=25;
                panel.gameObject.AddComponent<TrackedDeviceGraphicRaycaster>();
                panel.gameObject.AddComponent<CanvasRenderer>();
                var art=panel.gameObject.AddComponent<SelectionMenuGraphic>();art.color=new Color(.09f,.14f,.2f,.99f);
                var title=Label(panel,"Editing Field","Text",font,new Vector2(0,183),new Vector2(620,30),22);
                title.fontStyle=FontStyle.Bold;
                var preview=Label(panel,"Text Preview","Your text appears here |",font,new Vector2(0,143),new Vector2(620,38),24);
                preview.alignment=TextAnchor.MiddleLeft;
                var letters=new List<Text>();var textOnly=new List<Button>();
                string[] rows={"1234567890","qwertyuiop","asdfghjkl"};
                for(int row=0;row<rows.Length;row++)
                {
                    string values=rows[row];float start=-(values.Length-1)*30;
                    for(int i=0;i<values.Length;i++)
                    {
                        string value=values[i].ToString();
                        var button=Key(panel,"Key "+value,value,font,new Vector2(start+i*60,88-row*58),52,null);
                        UnityEventTools.AddStringPersistentListener(button.onClick,keyboard.Type,value);
                        if(char.IsLetter(values[i])){textOnly.Add(button);letters.Add(button.GetComponentInChildren<Text>());}
                    }
                }
                var shift=Key(panel,"Shift","Shift",font,new Vector2(-258,-86),88,keyboard.Shift);textOnly.Add(shift);
                for(int i=0;i<7;i++)
                {
                    string value="zxcvbnm"[i].ToString();
                    var button=Key(panel,"Key "+value,value,font,new Vector2(-180+i*60,-86),52,null);
                    UnityEventTools.AddStringPersistentListener(button.onClick,keyboard.Type,value);textOnly.Add(button);letters.Add(button.GetComponentInChildren<Text>());
                }
                Key(panel,"Backspace","Back",font,new Vector2(258,-86),88,keyboard.Backspace);
                Key(panel,"Clear","Clear",font,new Vector2(-261,-146),76,keyboard.Clear);
                string[] symbols={"_","-",".","/"};
                for(int i=0;i<4;i++)
                {
                    string value=symbols[i];var button=Key(panel,"Key "+value,value,font,new Vector2(-193+i*50,-146),44,null);
                    UnityEventTools.AddStringPersistentListener(button.onClick,keyboard.Type,value);
                    if(i==0 || i==3)textOnly.Add(button);
                }
                var space=Key(panel,"Space","Space",font,new Vector2(46,-146),116,null);
                UnityEventTools.AddStringPersistentListener(space.onClick,keyboard.Type," ");textOnly.Add(space);
                Key(panel,"Cancel","Cancel",font,new Vector2(154,-146),88,keyboard.Cancel);
                var done=Key(panel,"Done","Done",font,new Vector2(258,-146),104,keyboard.Done);
                done.targetGraphic.color=new Color(.12f,.4f,.45f,1);
                var fields=new SerializedObject(keyboard);fields.FindProperty("panel").objectReferenceValue=panel;
                fields.FindProperty("title").objectReferenceValue=title;fields.FindProperty("preview").objectReferenceValue=preview;
                fields.FindProperty("shiftLabel").objectReferenceValue=shift.GetComponentInChildren<Text>();
                Assign(fields,"letterLabels",letters.Cast<UnityEngine.Object>().ToArray());Assign(fields,"textOnlyButtons",textOnly.Cast<UnityEngine.Object>().ToArray());
                fields.ApplyModifiedPropertiesWithoutUndo();PrefabUtility.SaveAsPrefabAsset(root,path);
            }
            finally{UnityEngine.Object.DestroyImmediate(root);}
            prefab=AssetDatabase.LoadAssetAtPath<GameObject>(path);
        }
        var keyboardContents=PrefabUtility.LoadPrefabContents(path);
        try
        {
            foreach(var graphic in keyboardContents.GetComponentsInChildren<Graphic>(true))
                if(!graphic.GetComponent<CanvasRenderer>())graphic.gameObject.AddComponent<CanvasRenderer>();
            PrefabUtility.SaveAsPrefabAsset(keyboardContents,path);
        }
        finally{PrefabUtility.UnloadPrefabContents(keyboardContents);}
        prefab=AssetDatabase.LoadAssetAtPath<GameObject>(path);
        path=Base+"LocalModelImportPanel.prefab";
        var contents=PrefabUtility.LoadPrefabContents(path);
        try
        {
            foreach(var input in contents.GetComponentsInChildren<InputField>(true))
                Bind(input,null,(RectTransform)contents.transform);
            PrefabUtility.SaveAsPrefabAsset(contents,path);
        }
        finally{PrefabUtility.UnloadPrefabContents(contents);}
        path=Base+"ProductCatalogWindow.prefab";contents=PrefabUtility.LoadPrefabContents(path);
        try
        {
            var keyboard=contents.GetComponentInChildren<SpatialTextKeyboard>(true);
            if(!keyboard)keyboard=((GameObject)PrefabUtility.InstantiatePrefab(prefab,contents.transform)).GetComponent<SpatialTextKeyboard>();
            var keyboardFields=new SerializedObject(keyboard);((RectTransform)keyboardFields.FindProperty("panel").objectReferenceValue).gameObject.SetActive(false);
            var arrangement=contents.GetComponent<ArrangementPanel>();
            var arrangementPanel=(GameObject)new SerializedObject(arrangement).FindProperty("panel").objectReferenceValue;
            foreach(var input in contents.GetComponentsInChildren<InputField>(true))
            {
                var import=input.GetComponentInParent<LocalModelImportPanel>(true);
                Bind(input,keyboard,import ? (RectTransform)import.transform : (RectTransform)arrangementPanel.transform);
            }
            PrefabUtility.SaveAsPrefabAsset(contents,path);
        }
        finally{PrefabUtility.UnloadPrefabContents(contents);}
        AssetDatabase.SaveAssets();Debug.Log("SPATIAL KEYBOARD AUTHORED: saved QWERTY keys and five field adapters, including layout names.");
    }
    static void Bind(InputField input,SpatialTextKeyboard keyboard,RectTransform anchor)
    {
        var adapter=input.GetComponent<SpatialKeyboardField>() ?? input.gameObject.AddComponent<SpatialKeyboardField>();
        var fields=new SerializedObject(adapter);fields.FindProperty("input").objectReferenceValue=input;
        fields.FindProperty("keyboard").objectReferenceValue=keyboard;fields.FindProperty("keyboardAnchor").objectReferenceValue=anchor;
        fields.FindProperty("caption").stringValue=input.name=="Known Width" ? "Width (cm)" : input.name=="Known Height" ? "Height (cm)"
            : input.name=="Known Depth" ? "Depth (cm)" : input.name=="Layout Name" ? "Layout name" : "Product name";
        fields.ApplyModifiedPropertiesWithoutUndo();
    }
    static RectTransform Rect(Transform parent,string name,Vector2 position,Vector2 size)
    {
        var go=new GameObject(name,typeof(RectTransform));go.layer=5;
        var rect=(RectTransform)go.transform;rect.SetParent(parent,false);rect.anchoredPosition=position;rect.sizeDelta=size;return rect;
    }
    static Text Label(Transform parent,string name,string value,Font font,Vector2 position,Vector2 size,int fontSize)
    {
        var rect=Rect(parent,name,position,size);rect.gameObject.AddComponent<CanvasRenderer>();var text=rect.gameObject.AddComponent<Text>();
        text.font=font;text.text=value;text.fontSize=fontSize;text.color=new Color(.94f,.98f,1,1);text.alignment=TextAnchor.MiddleCenter;
        text.raycastTarget=false;text.supportRichText=false;text.resizeTextForBestFit=true;text.resizeTextMinSize=12;text.resizeTextMaxSize=fontSize;return text;
    }
    static Button Key(Transform parent,string name,string label,Font font,Vector2 position,float width,UnityAction action)
    {
        var rect=Rect(parent,name,position,new Vector2(width,46));rect.gameObject.AddComponent<CanvasRenderer>();
        var graphic=rect.gameObject.AddComponent<SelectionMenuGraphic>();graphic.color=new Color(.14f,.21f,.29f,1);
        var fields=new SerializedObject(graphic);fields.FindProperty("cornerRadius").floatValue=12;fields.ApplyModifiedPropertiesWithoutUndo();
        var button=rect.gameObject.AddComponent<Button>();button.targetGraphic=graphic;button.navigation=new Navigation{mode=Navigation.Mode.None};
        Label(rect,"Label",label,font,Vector2.zero,new Vector2(width-6,38),20);
        if(action!=null)UnityEventTools.AddPersistentListener(button.onClick,action);return button;
    }
    static void Assign(SerializedObject fields,string name,UnityEngine.Object[] values)
    {
        var array=fields.FindProperty(name);array.arraySize=values.Length;
        for(int i=0;i<values.Length;i++)array.GetArrayElementAtIndex(i).objectReferenceValue=values[i];
    }
    public static void AuthorBatch()
    {
        try{Author();EditorApplication.Exit(0);}catch(Exception e){Debug.LogException(e);EditorApplication.Exit(1);}
    }
}
