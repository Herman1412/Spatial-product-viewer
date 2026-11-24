using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace SpatialProductViewer.Editor
{
    // A live prefab refresh can leave removed graphics in RectMask2D's nonserialized
    // clipping list. Rebuild that list through its normal lifecycle, only in previews.
    [InitializeOnLoad]
    public sealed class CatalogUiPreviewRepair : AssetPostprocessor
    {
        const string Prefabs = "Assets/SpatialProductViewer/Prefabs/";
        static bool queued;

        static CatalogUiPreviewRepair()
        {
            QueueRefresh();
            EditorApplication.hierarchyChanged += QueueRefresh;
            PrefabUtility.prefabInstanceUpdated += OnPrefabUpdated;
        }

        static void OnPrefabUpdated(GameObject _) => QueueRefresh();

        static void OnPostprocessAllAssets(string[] imported, string[] deleted,
            string[] moved, string[] movedFrom)
        {
            foreach (var path in imported)
                if (path.StartsWith(Prefabs, System.StringComparison.Ordinal))
                { QueueRefresh(); return; }
        }

        static void QueueRefresh()
        {
            if (queued || EditorApplication.isPlayingOrWillChangePlaymode) return;
            queued = true;
            EditorApplication.delayCall += RefreshWhenReady;
        }

        static void RefreshWhenReady()
        {
            queued = false;
            if (EditorApplication.isPlayingOrWillChangePlaymode) return;
            if (EditorApplication.isCompiling || EditorApplication.isUpdating)
            { QueueRefresh(); return; }
            RefreshLoadedPreviews();
        }

        [MenuItem("Tools/Spatial Product Viewer/Refresh Catalog UI Preview")]
        public static void RefreshLoadedPreviews()
        {
            if (EditorApplication.isPlayingOrWillChangePlaymode) return;
            bool refreshed = false;
            foreach (var mask in Resources.FindObjectsOfTypeAll<RectMask2D>())
            {
                if (!mask || !mask.isActiveAndEnabled || EditorUtility.IsPersistent(mask)
                    || !mask.gameObject.scene.IsValid()
                    || !mask.GetComponentInParent<ProductCatalogController>(true)) continue;

                // OnDisable clears stale targets before notifying surviving graphics;
                // OnEnable registers those surviving graphics again. No objects are deleted.
                mask.enabled = false;
                mask.enabled = true;
                refreshed = true;
            }
            if (refreshed)
            {
                EditorApplication.QueuePlayerLoopUpdate();
                SceneView.RepaintAll();
            }
        }
    }
}
