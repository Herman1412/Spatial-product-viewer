using System;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEngine.XR.OpenXR;
using UnityEngine.XR.OpenXR.Features.Meta;

namespace SpatialProductViewer.Editor
{
    // Invalid serialized enum values reach Meta's native code without validation.
    // In Meta OpenXR 2.6.1, zero leaves the native plane provider uncreated and
    // ARPlaneManager then crashes in UnityOpenXRMeta_Plane_SetPlaneDetectionMode.
    public sealed class QuestPlaneProviderBuildCheck : IPreprocessBuildWithReport
    {
        public int callbackOrder => -10000;

        public void OnPreprocessBuild(BuildReport report)
        {
            var group = BuildPipeline.GetBuildTargetGroup(report.summary.platform);
            var settings = OpenXRSettings.GetSettingsForBuildTargetGroup(group);
            if (!settings) return;

            foreach (ARPlaneFeature feature in settings.GetFeatures<ARPlaneFeature>())
            {
                if (!feature || !feature.enabled) continue;
                if (Enum.IsDefined(typeof(PlaneProviderType), feature.planeProviderType)) continue;

                throw new BuildFailedException(
                    $"Meta Quest: Planes has an invalid Plane Provider Type ({(int)feature.planeProviderType}) for {group}. " +
                    "Open Project Settings > XR Plug-in Management > OpenXR, open the Meta Quest: Planes gear, " +
                    "and select Xr Fb Scene. Invalid values can crash the app in native plane detection.");
            }
        }
    }
}
