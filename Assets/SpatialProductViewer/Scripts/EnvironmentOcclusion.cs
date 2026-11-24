using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.XR.ARFoundation;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent, RequireComponent(typeof(Camera), typeof(AROcclusionManager), typeof(ARShaderOcclusion))]
    public sealed class EnvironmentOcclusion : MonoBehaviour
    {
        [Serializable]
        public struct ShaderPair
        {
            public Shader source;
            public Shader occluded;
        }

        [SerializeField]
        AROcclusionManager depthManager;
        [SerializeField]
        ARShaderOcclusion shaderOcclusion;
        [SerializeField]
        Transform trackingSpace;
        [SerializeField]
        RoomGeometryService room;
        [SerializeField]
        ShaderPair[] shaders;
        [SerializeField]
        bool occlusionEnabled = true;
        [SerializeField, Range(0, 0.1f)]
        float depthBias = 0.025f;
        [SerializeField, Range(0.1f, 2f)]
        float depthTimeout = 0.5f;

        readonly Dictionary<Material, Material> converted = new Dictionary<Material, Material>();
        Camera trackedCamera;
        float lastDepthFrame = float.NegativeInfinity;
        bool managersRunning;
        bool applicationPaused;

        public bool Enabled => occlusionEnabled;
        public bool HasFreshDepth => managersRunning && Time.unscaledTime - lastDepthFrame < depthTimeout;
        public bool Active => occlusionEnabled && HasFreshDepth;

        public string Status
        {
            get
            {
                if (!occlusionEnabled)
                {
                    return "Depth occlusion: off";
                }
                else if (Active)
                {
                    return "Depth occlusion: live";
                }
                else if (room && room.IsEditorPreview)
                {
                    return "Depth occlusion: Quest / Link required";
                }
                else if (!room || !room.SpatialPermissionGranted)
                {
                    return "Depth occlusion: waiting for permission";
                }
                else
                {
                    return "Depth occlusion: waiting for depth";
                }
            }
        }

        void Awake()
        {
            trackedCamera = GetComponent<Camera>();
            if (!depthManager)
            {
                depthManager = GetComponent<AROcclusionManager>();
            }

            if (!shaderOcclusion)
            {
                shaderOcclusion = GetComponent<ARShaderOcclusion>();
            }

            if (!trackingSpace)
            {
                trackingSpace = transform.parent;
            }

            if (!room)
            {
                room = FindAnyObjectByType<RoomGeometryService>();
            }

            SetRunning(false);
        }

        void OnEnable()
        {
            depthManager.frameReceived += OnDepthFrame;
            RenderPipelineManager.beginCameraRendering += BeginCamera;
            RenderPipelineManager.endCameraRendering += EndCamera;
        }

        void OnDisable()
        {
            if (depthManager)
            {
                depthManager.frameReceived -= OnDepthFrame;
            }

            RenderPipelineManager.beginCameraRendering -= BeginCamera;
            RenderPipelineManager.endCameraRendering -= EndCamera;
            SetRunning(false);
        }

        void Update()
        {
            if (!room)
            {
                room = FindAnyObjectByType<RoomGeometryService>();
            }

            bool permitted = !applicationPaused && room && room.SpatialPermissionGranted;
            if (managersRunning != (occlusionEnabled && permitted))
            {
                SetRunning(occlusionEnabled && permitted);
            }
        }

        void OnApplicationPause(bool paused)
        {
            applicationPaused = paused;
            if (paused)
            {
                SetRunning(false);
            }
        }

        public void Toggle()
        {
            occlusionEnabled = !occlusionEnabled;
            if (!occlusionEnabled)
            {
                SetRunning(false);
            }
        }

        void SetRunning(bool running)
        {
            if (!running)
            {
                if (shaderOcclusion)
                {
                    shaderOcclusion.enabled = false;
                }

                if (depthManager)
                {
                    depthManager.enabled = false;
                }

                lastDepthFrame = float.NegativeInfinity;
                Shader.SetGlobalInteger("_SPVOcclusionCameraEnabled", 0);
            }
            else
            {
                depthManager.enabled = true;
                shaderOcclusion.enabled = true;
            }

            managersRunning = running;
        }

        void OnDepthFrame(AROcclusionFrameEventArgs frame)
        {
            if (!managersRunning
                || frame.externalTextures.Count == 0
                || !frame.TryGetPoses(out var poses)
                || poses.Count == 0
                || !frame.TryGetFovs(out var fovs)
                || fovs.Count != poses.Count
                || !frame.TryGetNearFarPlanes(out _))
            {
                return;
            }

            lastDepthFrame = Time.unscaledTime;
        }

        void BeginCamera(ScriptableRenderContext _, Camera camera)
        {
            Shader.SetGlobalInteger("_SPVOcclusionCameraEnabled", camera == trackedCamera && Active ? 1 : 0);
            Shader.SetGlobalMatrix("_SPVWorldToTracking", trackingSpace ? trackingSpace.worldToLocalMatrix : Matrix4x4.identity);
            Shader.SetGlobalFloat("_SPVDepthBias", depthBias);
            Shader.SetGlobalInteger("_SPVDepthIsLinear", Shader.IsKeywordEnabled("XR_LINEAR_DEPTH") ? 1 : 0);
        }

        void EndCamera(ScriptableRenderContext _, Camera camera)
        {
            Shader.SetGlobalInteger("_SPVOcclusionCameraEnabled", 0);
        }

        public void Apply(Renderer[] renderers)
        {
            if (shaders == null)
            {
                return;
            }

            foreach (var renderer in renderers)
            {
                if (!renderer)
                {
                    continue;
                }

                var materials = renderer.sharedMaterials;
                bool changed = false;
                for (int i = 0; i < materials.Length; i++)
                {
                    var original = materials[i];
                    if (!original || !original.shader)
                    {
                        continue;
                    }

                    if (converted.TryGetValue(original, out var cached))
                    {
                        materials[i] = cached;
                        changed = true;
                        continue;
                    }

                    Shader target = null;
                    foreach (var pair in shaders)
                    {
                        if (pair.source == original.shader)
                        {
                            target = pair.occluded;
                            break;
                        }
                    }

                    if (!target)
                    {
                        continue;
                    }

                    var material = new Material(target)
                    {
                        name = original.name + " (environment occlusion)"
                    };
                    for (int property = 0; property < original.shader.GetPropertyCount(); property++)
                    {
                        string propertyName = original.shader.GetPropertyName(property);
                        if (!material.HasProperty(propertyName))
                        {
                            continue;
                        }

                        switch (original.shader.GetPropertyType(property))
                        {
                            case ShaderPropertyType.Color:
                                material.SetColor(propertyName, original.GetColor(propertyName));
                                break;
                            case ShaderPropertyType.Vector:
                                material.SetVector(propertyName, original.GetVector(propertyName));
                                break;
                            case ShaderPropertyType.Float:
                            case ShaderPropertyType.Range:
                                material.SetFloat(propertyName, original.GetFloat(propertyName));
                                break;
                            case ShaderPropertyType.Int:
                                material.SetInteger(propertyName, original.GetInteger(propertyName));
                                break;
                            case ShaderPropertyType.Texture:
                                Texture texture = original.GetTexture(propertyName);
                                if (!texture
                                    && original.shader.GetPropertyTextureDimension(property) == TextureDimension.Tex2D)
                                {
                                    texture = original.shader.GetPropertyTextureDefaultName(property) switch
                                    {
                                        "bump" => Texture2D.normalTexture,
                                        "white" => Texture2D.whiteTexture,
                                        "black" => Texture2D.blackTexture,
                                        "gray" or "grey" => Texture2D.grayTexture,
                                        _ => null
                                    };
                                }

                                material.SetTexture(propertyName, texture);
                                material.SetTextureScale(propertyName, original.GetTextureScale(propertyName));
                                material.SetTextureOffset(propertyName, original.GetTextureOffset(propertyName));
                                break;
                        }
                    }

                    foreach (string keyword in original.shaderKeywords)
                    {
                        var localKeyword = new LocalKeyword(target, keyword);
                        if (localKeyword.isValid)
                        {
                            material.SetKeyword(localKeyword, true);
                        }
                    }

                    material.renderQueue = original.renderQueue;
                    material.enableInstancing = original.enableInstancing;
                    material.doubleSidedGI = original.doubleSidedGI;
                    material.globalIlluminationFlags = original.globalIlluminationFlags;
                    material.SetOverrideTag("RenderType", original.GetTag("RenderType", false));
                    for (int pass = 0; pass < original.passCount; pass++)
                    {
                        string passName = original.GetPassName(pass);
                        material.SetShaderPassEnabled(passName, original.GetShaderPassEnabled(passName));
                    }

                    converted.Add(original, material);
                    materials[i] = material;
                    changed = true;
                }

                if (changed)
                {
                    renderer.sharedMaterials = materials;
                }
            }
        }

        void OnDestroy()
        {
            foreach (var material in converted.Values)
            {
                if (material)
                {
                    Destroy(material);
                }
            }

            converted.Clear();
        }
    }
}
