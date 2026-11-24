Shader "SpatialProductViewer/Occlusion/glTF-pbrSpecularGlossiness"
{
Properties
{
[MainColor]diffuseFactor("Diffuse", Color) = (1, 1, 1, 1)
[MainTexture][NoScaleOffset]diffuseTexture("Diffuse Tex", 2D) = "white" {}
diffuseTexture_ST("Diffuse Tex ST", Vector, 4) = (1, 1, 0, 0)
diffuseTexture_Rotation("Diffuse Tex Rotation", Vector, 2) = (0, 0, 0, 0)
diffuseTexture_texCoord("Diffuse Tex UV", Int) = 0
[Normal][NoScaleOffset]normalTexture("Normal Tex", 2D) = "bump" {}
normalTexture_ST("Normal Tex ST", Vector, 4) = (1, 1, 0, 0)
normalTexture_Rotation("Normal Tex Rotation", Vector, 2) = (0, 0, 0, 0)
normalTexture_texCoord("Normal Tex UV", Int) = 0
normalTexture_scale("Normal Scale", Float) = 1
[NoScaleOffset]occlusionTexture("Occlusion Tex", 2D) = "white" {}
occlusionTexture_ST("Occlusion Tex ST", Vector, 4) = (1, 1, 0, 0)
occlusionTexture_Rotation("Occlusion Tex Rotation", Vector, 2) = (0, 0, 0, 0)
occlusionTexture_texCoord("Occlusion Tex UV", Int) = 0
occlusionTexture_strength("Occlusion Strength", Range(0, 1)) = 1
specularFactor("Specular", Color) = (1, 1, 1, 1)
glossinessFactor("Glossiness", Range(0, 1)) = 1
[NoScaleOffset]specularGlossinessTexture("Specular-Glossiness Tex", 2D) = "white" {}
specularGlossinessTexture_ST("Specular-Glossiness Tex ST", Vector, 4) = (1, 1, 0, 0)
specularGlossinessTexture_Rotation("Specular-Glossiness Tex Rotation", Vector, 2) = (0, 0, 0, 0)
specularGlossinessTexture_texCoord("Specular-Glossiness Tex UV", Int) = 0
[HDR]emissiveFactor("Emissive", Color) = (0, 0, 0, 1)
[NoScaleOffset]emissiveTexture("Emissive Tex", 2D) = "white" {}
emissiveTexture_ST("Emissive Tex ST", Vector, 4) = (1, 1, 0, 0)
emissiveTexture_Rotation("Emissive Tex Rotation", Vector, 2) = (0, 0, 0, 0)
emissiveTexture_texCoord("Emissive Tex UV", Float) = 0
emissiveExposureWeight("Emissive Exposure Weight", Float) = 0
alphaCutoff("Alpha Cutoff", Range(0, 1)) = 0.5
[HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 0
[HideInInspector]_CastShadows("_CastShadows", Float) = 1
[HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
[HideInInspector]_Surface("_Surface", Float) = 0
[HideInInspector]_Blend("_Blend", Float) = 0
[HideInInspector]_AlphaClip("_AlphaClip", Float) = 0
[HideInInspector]_BlendModePreserveSpecular("_BlendModePreserveSpecular", Float) = 0
[HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
[HideInInspector]_DstBlend("_DstBlend", Float) = 0
[HideInInspector]_SrcBlendAlpha("_SrcBlendAlpha", Float) = 1
[HideInInspector]_DstBlendAlpha("_DstBlendAlpha", Float) = 0
[HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
[HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
[HideInInspector]_ZTest("_ZTest", Float) = 4
[HideInInspector]_Cull("_Cull", Float) = 2
[HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 0
[HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
[HideInInspector]_QueueControl("_QueueControl", Float) = -1
[HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
[HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
[HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
[HideInInspector]_BUILTIN_Surface("Float", Float) = 0
[HideInInspector]_BUILTIN_Blend("Float", Float) = 0
[HideInInspector]_BUILTIN_AlphaClip("Float", Float) = 0
[HideInInspector]_BUILTIN_SrcBlend("Float", Float) = 1
[HideInInspector]_BUILTIN_DstBlend("Float", Float) = 0
[HideInInspector]_BUILTIN_ZWrite("Float", Float) = 1
[HideInInspector]_BUILTIN_ZWriteControl("Float", Float) = 0
[HideInInspector]_BUILTIN_ZTest("Float", Float) = 4
[HideInInspector]_BUILTIN_CullMode("Float", Float) = 2
[HideInInspector]_BUILTIN_QueueOffset("Float", Float) = 0
[HideInInspector]_BUILTIN_QueueControl("Float", Float) = -1
}
SubShader
{
Tags
{
"RenderPipeline"="UniversalPipeline"
"RenderType"="Opaque"
"UniversalMaterialType" = "Lit"
"Queue"="Geometry"
"DisableBatching"="False"
"ShaderGraphShader"="true"
"ShaderGraphTargetId"="UniversalLitSubTarget"
}
Pass
{
    Name "ForwardLit"
    Tags
    {
        "LightMode" = "UniversalForward"
    }

// Render State
Cull [_Cull]
Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
ZTest [_ZTest]
ZWrite [_ZWrite]
AlphaToMask [_AlphaToMask]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma target 4.5 _DEPTH_AS_INPUT_ATTACHMENT_MSAA
#pragma multi_compile_instancing
#pragma instancing_options renderinglayer
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
#pragma multi_compile_fragment _ _SCREEN_SPACE_REFLECTION
#pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DYNAMICLIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ USE_LEGACY_LIGHTMAPS
#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
#pragma multi_compile _ REFLECTION_PROBE_ROTATION
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ _LIGHT_LAYERS
#pragma multi_compile_fragment _ DEBUG_DISPLAY
#pragma multi_compile_fragment _ _LIGHT_COOKIES
#pragma multi_compile _ _CLUSTER_LIGHT_LOOP
#pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
#pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local_fragment _ _SPECULAR_SETUP
#pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_SHADOW_COORD
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_FORWARD


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
 float4 probeOcclusion;
#endif
 float4 fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord;
#endif
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV : INTERP0;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV : INTERP1;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh : INTERP2;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
 float4 probeOcclusion : INTERP3;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord : INTERP4;
#endif
 float4 tangentWS : INTERP5;
 float4 texCoord0 : INTERP6;
 float4 texCoord1 : INTERP7;
 float4 color : INTERP8;
 float4 fogFactorAndVertexLight : INTERP9;
 float3 positionWS : INTERP10;
 float3 normalWS : INTERP11;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.staticLightmapUV = input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
output.probeOcclusion = input.probeOcclusion;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.shadowCoord;
#endif
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
output.positionWS.xyz = input.positionWS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.staticLightmapUV = input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
output.probeOcclusion = input.probeOcclusion;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.shadowCoord;
#endif
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
output.positionWS = input.positionWS.xyz;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float3 NormalTS;
float3 Emission;
float Metallic;
float3 Specular;
float Smoothness;
float Occlusion;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.BaseColor = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
surface.NormalTS = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
surface.Emission = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
surface.Metallic = float(0);
surface.Specular = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
surface.Smoothness = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
surface.Occlusion = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);



    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Assets/SpatialProductViewer/Shaders/OccludedPBRForwardPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "GBuffer"
    Tags
    {
        "LightMode" = "UniversalGBuffer"
    }

// Render State
Cull [_Cull]
Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
ZTest [_ZTest]
ZWrite [_ZWrite]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma exclude_renderers gles3 glcore
#pragma multi_compile_instancing
#pragma instancing_options renderinglayer
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile_fragment _ _SCREEN_SPACE_REFLECTION
#pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DYNAMICLIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ USE_LEGACY_LIGHTMAPS
#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
#pragma multi_compile _ REFLECTION_PROBE_ROTATION
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
#pragma multi_compile_fragment _ DEBUG_DISPLAY
#pragma multi_compile _ _CLUSTER_LIGHT_LOOP
#pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local_fragment _ _SPECULAR_SETUP
#pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_SHADOW_COORD
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_GBUFFER
#define _FOG_FRAGMENT 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
 float4 probeOcclusion;
#endif
 float4 fogFactorAndVertexLight;
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord;
#endif
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if defined(LIGHTMAP_ON)
 float2 staticLightmapUV : INTERP0;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
 float2 dynamicLightmapUV : INTERP1;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh : INTERP2;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
 float4 probeOcclusion : INTERP3;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
 float4 shadowCoord : INTERP4;
#endif
 float4 tangentWS : INTERP5;
 float4 texCoord0 : INTERP6;
 float4 texCoord1 : INTERP7;
 float4 color : INTERP8;
 float4 fogFactorAndVertexLight : INTERP9;
 float3 positionWS : INTERP10;
 float3 normalWS : INTERP11;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.staticLightmapUV = input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
output.probeOcclusion = input.probeOcclusion;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.shadowCoord;
#endif
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
output.positionWS.xyz = input.positionWS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.staticLightmapUV = input.staticLightmapUV;
#endif
#if defined(DYNAMICLIGHTMAP_ON)
output.dynamicLightmapUV = input.dynamicLightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
output.probeOcclusion = input.probeOcclusion;
#endif
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
output.shadowCoord = input.shadowCoord;
#endif
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
output.positionWS = input.positionWS.xyz;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float3 NormalTS;
float3 Emission;
float Metallic;
float3 Specular;
float Smoothness;
float Occlusion;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.BaseColor = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
surface.NormalTS = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
surface.Emission = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
surface.Metallic = float(0);
surface.Specular = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
surface.Smoothness = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
surface.Occlusion = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);



    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutputFormat.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

// Render State
Cull [_Cull]
ZTest LEqual
ZWrite On
ColorMask 0

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_SHADOWCASTER


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
 float3 normalWS : INTERP3;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "MotionVectors"
    Tags
    {
        "LightMode" = "MotionVectors"
    }

// Render State
Cull [_Cull]
ZTest LEqual
ZWrite On
ColorMask RG

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 3.5
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_MOTION_VECTORS


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

// Render State
Cull [_Cull]
ZTest LEqual
ZWrite On
ColorMask R

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

// Render State
Cull [_Cull]
ZTest LEqual
ZWrite On

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile _ _WRITE_SMOOTHNESS
#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHNORMALS


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 tangentWS : INTERP0;
 float4 texCoord0 : INTERP1;
 float4 texCoord1 : INTERP2;
 float4 color : INTERP3;
 float3 normalWS : INTERP4;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Smoothness;
float3 NormalTS;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.Smoothness = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
surface.NormalTS = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);



    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "Meta"
    Tags
    {
        "LightMode" = "Meta"
    }

// Render State
Cull Off

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature _ EDITOR_VISUALIZATION
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define ATTRIBUTES_NEED_INSTANCEID
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_TEXCOORD2
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_META
#define _FOG_FRAGMENT 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 texCoord2;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 texCoord2 : INTERP2;
 float4 color : INTERP3;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.texCoord2.xyzw = input.texCoord2;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.texCoord2 = input.texCoord2.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float3 Emission;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.BaseColor = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
surface.Emission = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "SceneSelectionPass"
    Tags
    {
        "LightMode" = "SceneSelectionPass"
    }

// Render State
Cull Off

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENESELECTIONPASS 1
#define ALPHA_CLIP_THRESHOLD 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "ScenePickingPass"
    Tags
    {
        "LightMode" = "Picking"
    }

// Render State
Cull [_Cull]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define SCENEPICKINGPASS 1
#define ALPHA_CLIP_THRESHOLD 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.BaseColor = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
Pass
{
    Name "Universal 2D"
    Tags
    {
        "LightMode" = "Universal2D"
    }

// Render State
Cull [_Cull]
Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
ZTest [_ZTest]
ZWrite [_ZWrite]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines

#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_2D


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.BaseColor = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs
#ifdef HAVE_VFX_MODIFICATION
#define VFX_SRP_ATTRIBUTES Attributes
#define VFX_SRP_VARYINGS Varyings
#define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
#endif
VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

#ifdef HAVE_VFX_MODIFICATION
#if VFX_USE_GRAPH_VALUES
    uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
    /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
#endif
    /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */

#endif

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

// --------------------------------------------------
// Visual Effect Vertex Invocations
#ifdef HAVE_VFX_MODIFICATION
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
#endif

ENDHLSL
}
}
SubShader
{
Tags
{
// RenderPipeline: <None>
"RenderType"="Opaque"
"BuiltInMaterialType" = "Lit"
"Queue"="Geometry"
// DisableBatching: <None>
"ShaderGraphShader"="true"
"ShaderGraphTargetId"="BuiltInLitSubTarget"
}
Pass
{
    Name "BuiltIn Forward"
    Tags
    {
        "LightMode" = "ForwardBase"
    }

// Render State
Cull [_BUILTIN_CullMode]
Blend [_BUILTIN_SrcBlend] [_BUILTIN_DstBlend]
ZTest [_BUILTIN_ZTest]
ZWrite [_BUILTIN_ZWrite]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 3.0
#pragma multi_compile_instancing
#pragma multi_compile_fog
#pragma multi_compile_fwdbase
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile _ _SHADOWS_SOFT
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma shader_feature_local_fragment _ _BUILTIN_SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _BUILTIN_AlphaClip
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines
#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_FORWARD
#define BUILTIN_TARGET_API 1
#ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
#define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
#endif
#ifdef _BUILTIN_ALPHATEST_ON
#define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
#endif
#ifdef _BUILTIN_AlphaClip
#define _AlphaClip _BUILTIN_AlphaClip
#endif
#ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
#define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
#endif


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if defined(LIGHTMAP_ON)
 float2 lightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
 float4 fogFactorAndVertexLight;
 float4 shadowCoord;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if defined(LIGHTMAP_ON)
 float2 lightmapUV : INTERP0;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh : INTERP1;
#endif
 float4 tangentWS : INTERP2;
 float4 texCoord0 : INTERP3;
 float4 texCoord1 : INTERP4;
 float4 color : INTERP5;
 float4 fogFactorAndVertexLight : INTERP6;
 float4 shadowCoord : INTERP7;
 float3 positionWS : INTERP8;
 float3 normalWS : INTERP9;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.lightmapUV = input.lightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
output.shadowCoord.xyzw = input.shadowCoord;
output.positionWS.xyz = input.positionWS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.lightmapUV = input.lightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
output.shadowCoord = input.shadowCoord.xyzw;
output.positionWS = input.positionWS.xyz;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float3 NormalTS;
float3 Emission;
float Metallic;
float Smoothness;
float Occlusion;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.BaseColor = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
surface.NormalTS = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
surface.Emission = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
surface.Metallic = float(0);
surface.Smoothness = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
surface.Occlusion = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);



    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
{
    result.vertex     = float4(attributes.positionOS, 1);
    result.tangent    = attributes.tangentOS;
    result.normal     = attributes.normalOS;
    result.texcoord   = attributes.uv0;
    result.texcoord1  = attributes.uv1;
    result.color      = attributes.color;
    result.vertex     = float4(vertexDescription.Position, 1);
    result.normal     = vertexDescription.Normal;
    result.tangent    = float4(vertexDescription.Tangent, 0);
    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
}

void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
{
    result.pos = varyings.positionCS;
    result.worldPos = varyings.positionWS;
    result.worldNormal = varyings.normalWS;
    // World Tangent isn't an available input on v2f_surf

    result._ShadowCoord = varyings.shadowCoord;

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    result.sh = varyings.sh;
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    result.lmap.xy = varyings.lightmapUV;
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogCoord = varyings.fogFactorAndVertexLight.x;
        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
}

void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
{
    result.positionCS = surfVertex.pos;
    result.positionWS = surfVertex.worldPos;
    result.normalWS = surfVertex.worldNormal;
    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
    // World Tangent isn't an available input on v2f_surf
    result.shadowCoord = surfVertex._ShadowCoord;

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    result.sh = surfVertex.sh;
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    result.lightmapUV = surfVertex.lmap.xy;
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

ENDHLSL
}
Pass
{
    Name "BuiltIn ForwardAdd"
    Tags
    {
        "LightMode" = "ForwardAdd"
    }

// Render State
Blend SrcAlpha One, One One
ZWrite Off

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 3.0
#pragma multi_compile_instancing
#pragma multi_compile_fog
#pragma multi_compile_fwdadd_fullshadows
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
#pragma multi_compile _ _SHADOWS_SOFT
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma shader_feature_local_fragment _ _BUILTIN_SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _BUILTIN_AlphaClip
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines
#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_FORWARD_ADD
#define BUILTIN_TARGET_API 1
#ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
#define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
#endif
#ifdef _BUILTIN_ALPHATEST_ON
#define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
#endif
#ifdef _BUILTIN_AlphaClip
#define _AlphaClip _BUILTIN_AlphaClip
#endif
#ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
#define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
#endif


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if defined(LIGHTMAP_ON)
 float2 lightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
 float4 fogFactorAndVertexLight;
 float4 shadowCoord;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if defined(LIGHTMAP_ON)
 float2 lightmapUV : INTERP0;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh : INTERP1;
#endif
 float4 tangentWS : INTERP2;
 float4 texCoord0 : INTERP3;
 float4 texCoord1 : INTERP4;
 float4 color : INTERP5;
 float4 fogFactorAndVertexLight : INTERP6;
 float4 shadowCoord : INTERP7;
 float3 positionWS : INTERP8;
 float3 normalWS : INTERP9;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.lightmapUV = input.lightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
output.shadowCoord.xyzw = input.shadowCoord;
output.positionWS.xyz = input.positionWS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.lightmapUV = input.lightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
output.shadowCoord = input.shadowCoord.xyzw;
output.positionWS = input.positionWS.xyz;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float3 NormalTS;
float3 Emission;
float Metallic;
float Smoothness;
float Occlusion;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.BaseColor = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
surface.NormalTS = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
surface.Emission = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
surface.Metallic = float(0);
surface.Smoothness = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
surface.Occlusion = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);



    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
{
    result.vertex     = float4(attributes.positionOS, 1);
    result.tangent    = attributes.tangentOS;
    result.normal     = attributes.normalOS;
    result.texcoord   = attributes.uv0;
    result.texcoord1  = attributes.uv1;
    result.color      = attributes.color;
    result.vertex     = float4(vertexDescription.Position, 1);
    result.normal     = vertexDescription.Normal;
    result.tangent    = float4(vertexDescription.Tangent, 0);
    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
}

void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
{
    result.pos = varyings.positionCS;
    result.worldPos = varyings.positionWS;
    result.worldNormal = varyings.normalWS;
    // World Tangent isn't an available input on v2f_surf

    result._ShadowCoord = varyings.shadowCoord;

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    result.sh = varyings.sh;
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    result.lmap.xy = varyings.lightmapUV;
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogCoord = varyings.fogFactorAndVertexLight.x;
        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
}

void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
{
    result.positionCS = surfVertex.pos;
    result.positionWS = surfVertex.worldPos;
    result.normalWS = surfVertex.worldNormal;
    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
    // World Tangent isn't an available input on v2f_surf
    result.shadowCoord = surfVertex._ShadowCoord;

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    result.sh = surfVertex.sh;
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    result.lightmapUV = surfVertex.lmap.xy;
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRForwardAddPass.hlsl"

ENDHLSL
}
Pass
{
    Name "BuiltIn Deferred"
    Tags
    {
        "LightMode" = "Deferred"
    }

// Render State
Cull [_BUILTIN_CullMode]
Blend [_BUILTIN_SrcBlend] [_BUILTIN_DstBlend]
ZTest [_BUILTIN_ZTest]
ZWrite [_BUILTIN_ZWrite]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 4.5
#pragma multi_compile_instancing
#pragma exclude_renderers nomrt
#pragma multi_compile_prepassfinal
#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
#pragma multi_compile _ _SHADOWS_SOFT
#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
#pragma multi_compile _ _GBUFFER_NORMALS_OCT
#pragma shader_feature_local_fragment _ _BUILTIN_SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _BUILTIN_AlphaClip
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines
#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TANGENT_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEFERRED
#define BUILTIN_TARGET_API 1
#ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
#define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
#endif
#ifdef _BUILTIN_ALPHATEST_ON
#define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
#endif
#ifdef _BUILTIN_AlphaClip
#define _AlphaClip _BUILTIN_AlphaClip
#endif
#ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
#define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
#endif


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float3 positionWS;
 float3 normalWS;
 float4 tangentWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if defined(LIGHTMAP_ON)
 float2 lightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
 float4 fogFactorAndVertexLight;
 float4 shadowCoord;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float3 TangentSpaceNormal;
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
#if defined(LIGHTMAP_ON)
 float2 lightmapUV : INTERP0;
#endif
#if !defined(LIGHTMAP_ON)
 float3 sh : INTERP1;
#endif
 float4 tangentWS : INTERP2;
 float4 texCoord0 : INTERP3;
 float4 texCoord1 : INTERP4;
 float4 color : INTERP5;
 float4 fogFactorAndVertexLight : INTERP6;
 float4 shadowCoord : INTERP7;
 float3 positionWS : INTERP8;
 float3 normalWS : INTERP9;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.lightmapUV = input.lightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
output.tangentWS.xyzw = input.tangentWS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
output.shadowCoord.xyzw = input.shadowCoord;
output.positionWS.xyz = input.positionWS;
output.normalWS.xyz = input.normalWS;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
#if defined(LIGHTMAP_ON)
output.lightmapUV = input.lightmapUV;
#endif
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
output.tangentWS = input.tangentWS.xyzw;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
output.shadowCoord = input.shadowCoord.xyzw;
output.positionWS = input.positionWS.xyz;
output.normalWS = input.normalWS.xyz;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float3 NormalTS;
float3 Emission;
float Metallic;
float Smoothness;
float Occlusion;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.BaseColor = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
surface.NormalTS = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
surface.Emission = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
surface.Metallic = float(0);
surface.Smoothness = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
surface.Occlusion = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    



    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);



    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
{
    result.vertex     = float4(attributes.positionOS, 1);
    result.tangent    = attributes.tangentOS;
    result.normal     = attributes.normalOS;
    result.texcoord   = attributes.uv0;
    result.texcoord1  = attributes.uv1;
    result.color      = attributes.color;
    result.vertex     = float4(vertexDescription.Position, 1);
    result.normal     = vertexDescription.Normal;
    result.tangent    = float4(vertexDescription.Tangent, 0);
    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
}

void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
{
    result.pos = varyings.positionCS;
    result.worldPos = varyings.positionWS;
    result.worldNormal = varyings.normalWS;
    // World Tangent isn't an available input on v2f_surf

    result._ShadowCoord = varyings.shadowCoord;

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    result.sh = varyings.sh;
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    result.lmap.xy = varyings.lightmapUV;
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogCoord = varyings.fogFactorAndVertexLight.x;
        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
}

void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
{
    result.positionCS = surfVertex.pos;
    result.positionWS = surfVertex.worldPos;
    result.normalWS = surfVertex.worldNormal;
    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
    // World Tangent isn't an available input on v2f_surf
    result.shadowCoord = surfVertex._ShadowCoord;

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    result.sh = surfVertex.sh;
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    result.lightmapUV = surfVertex.lmap.xy;
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRDeferredPass.hlsl"

ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

// Render State
Cull [_BUILTIN_CullMode]
Blend [_BUILTIN_SrcBlend] [_BUILTIN_DstBlend]
ZTest LEqual
ZWrite On
ColorMask 0

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 3.0
#pragma multi_compile_shadowcaster
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
#pragma shader_feature_local_fragment _ _BUILTIN_SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _BUILTIN_AlphaClip
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines
#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_SHADOWCASTER
#define BUILTIN_TARGET_API 1
#ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
#define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
#endif
#ifdef _BUILTIN_ALPHATEST_ON
#define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
#endif
#ifdef _BUILTIN_AlphaClip
#define _AlphaClip _BUILTIN_AlphaClip
#endif
#ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
#define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
#endif


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
{
    result.vertex     = float4(attributes.positionOS, 1);
    result.tangent    = attributes.tangentOS;
    result.normal     = attributes.normalOS;
    result.texcoord   = attributes.uv0;
    result.texcoord1  = attributes.uv1;
    result.color      = attributes.color;
    result.vertex     = float4(vertexDescription.Position, 1);
    result.normal     = vertexDescription.Normal;
    result.tangent    = float4(vertexDescription.Tangent, 0);
    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
}

void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
{
    result.pos = varyings.positionCS;
    // World Tangent isn't an available input on v2f_surf


    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogCoord = varyings.fogFactorAndVertexLight.x;
        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
}

void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
{
    result.positionCS = surfVertex.pos;
    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
    // World Tangent isn't an available input on v2f_surf

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

// Render State
Cull [_BUILTIN_CullMode]
Blend [_BUILTIN_SrcBlend] [_BUILTIN_DstBlend]
ZTest LEqual
ZWrite On
ColorMask 0

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 3.0
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _BUILTIN_AlphaClip
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines
#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHONLY
#define BUILTIN_TARGET_API 1
#ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
#define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
#endif
#ifdef _BUILTIN_ALPHATEST_ON
#define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
#endif
#ifdef _BUILTIN_AlphaClip
#define _AlphaClip _BUILTIN_AlphaClip
#endif
#ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
#define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
#endif


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
{
    result.vertex     = float4(attributes.positionOS, 1);
    result.tangent    = attributes.tangentOS;
    result.normal     = attributes.normalOS;
    result.texcoord   = attributes.uv0;
    result.texcoord1  = attributes.uv1;
    result.color      = attributes.color;
    result.vertex     = float4(vertexDescription.Position, 1);
    result.normal     = vertexDescription.Normal;
    result.tangent    = float4(vertexDescription.Tangent, 0);
    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
}

void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
{
    result.pos = varyings.positionCS;
    // World Tangent isn't an available input on v2f_surf


    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogCoord = varyings.fogFactorAndVertexLight.x;
        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
}

void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
{
    result.positionCS = surfVertex.pos;
    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
    // World Tangent isn't an available input on v2f_surf

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

ENDHLSL
}
Pass
{
    Name "Meta"
    Tags
    {
        "LightMode" = "Meta"
    }

// Render State
Cull Off

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 3.0
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
#pragma shader_feature_local_fragment _ _BUILTIN_SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _BUILTIN_AlphaClip
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines
#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_TEXCOORD2
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_META
#define BUILTIN_TARGET_API 1
#ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
#define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
#endif
#ifdef _BUILTIN_ALPHATEST_ON
#define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
#endif
#ifdef _BUILTIN_AlphaClip
#define _AlphaClip _BUILTIN_AlphaClip
#endif
#ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
#define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
#endif


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 uv2 : TEXCOORD2;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float3 BaseColor;
float3 Emission;
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.BaseColor = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
surface.Emission = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
{
    result.vertex     = float4(attributes.positionOS, 1);
    result.tangent    = attributes.tangentOS;
    result.normal     = attributes.normalOS;
    result.texcoord   = attributes.uv0;
    result.texcoord1  = attributes.uv1;
    result.texcoord2  = attributes.uv2;
    result.color      = attributes.color;
    result.vertex     = float4(vertexDescription.Position, 1);
    result.normal     = vertexDescription.Normal;
    result.tangent    = float4(vertexDescription.Tangent, 0);
    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
}

void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
{
    result.pos = varyings.positionCS;
    // World Tangent isn't an available input on v2f_surf


    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogCoord = varyings.fogFactorAndVertexLight.x;
        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
}

void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
{
    result.positionCS = surfVertex.pos;
    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
    // World Tangent isn't an available input on v2f_surf

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

ENDHLSL
}
Pass
{
    Name "SceneSelectionPass"
    Tags
    {
        "LightMode" = "SceneSelectionPass"
    }

// Render State
Cull Off

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 3.0
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _BUILTIN_SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _BUILTIN_AlphaClip
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines
#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SceneSelectionPass
#define BUILTIN_TARGET_API 1
#define SCENESELECTIONPASS 1
#ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
#define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
#endif
#ifdef _BUILTIN_ALPHATEST_ON
#define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
#endif
#ifdef _BUILTIN_AlphaClip
#define _AlphaClip _BUILTIN_AlphaClip
#endif
#ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
#define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
#endif


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
{
    result.vertex     = float4(attributes.positionOS, 1);
    result.tangent    = attributes.tangentOS;
    result.normal     = attributes.normalOS;
    result.texcoord   = attributes.uv0;
    result.texcoord1  = attributes.uv1;
    result.color      = attributes.color;
    result.vertex     = float4(vertexDescription.Position, 1);
    result.normal     = vertexDescription.Normal;
    result.tangent    = float4(vertexDescription.Tangent, 0);
    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
}

void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
{
    result.pos = varyings.positionCS;
    // World Tangent isn't an available input on v2f_surf


    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogCoord = varyings.fogFactorAndVertexLight.x;
        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
}

void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
{
    result.positionCS = surfVertex.pos;
    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
    // World Tangent isn't an available input on v2f_surf

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

ENDHLSL
}
Pass
{
    Name "ScenePickingPass"
    Tags
    {
        "LightMode" = "Picking"
    }

// Render State
Cull [_BUILTIN_CullMode]

// Debug
// <None>

// --------------------------------------------------
// Pass

HLSLPROGRAM

// Pragmas
#pragma target 3.0
#pragma multi_compile_instancing
#pragma vertex vert
#pragma fragment frag

// Keywords
#pragma shader_feature_local_fragment _ _BUILTIN_SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _BUILTIN_AlphaClip
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHATEST_ON
#pragma shader_feature_local _ _EMISSIVE
#pragma shader_feature_local _ _OCCLUSION
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_EMISSIVE) && defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#elif defined(_EMISSIVE) && defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_1
#elif defined(_EMISSIVE) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_2
#elif defined(_EMISSIVE)
#define KEYWORD_PERMUTATION_3
#elif defined(_OCCLUSION) && defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_4
#elif defined(_OCCLUSION)
#define KEYWORD_PERMUTATION_5
#elif defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


// Defines
#define _NORMALMAP 1
#define _NORMAL_DROPOFF_TS 1
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define VARYINGS_NEED_CULLFACE
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS ScenePickingPass
#define BUILTIN_TARGET_API 1
#define SCENEPICKINGPASS 1
#ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
#define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
#endif
#ifdef _BUILTIN_ALPHATEST_ON
#define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
#endif
#ifdef _BUILTIN_AlphaClip
#define _AlphaClip _BUILTIN_AlphaClip
#endif
#ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
#define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
#endif


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"

// --------------------------------------------------
// Structs and Packing

// custom interpolators pre packing
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */

struct Attributes
{
 float3 positionOS : POSITION;
 float3 normalOS : NORMAL;
 float4 tangentOS : TANGENT;
 float4 uv0 : TEXCOORD0;
 float4 uv1 : TEXCOORD1;
 float4 color : COLOR;
#if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
 uint instanceID : INSTANCEID_SEMANTIC;
#endif
};
struct Varyings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};
struct SurfaceDescriptionInputs
{
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
 float FaceSign;
};
struct VertexDescriptionInputs
{
 float3 ObjectSpaceNormal;
 float3 ObjectSpaceTangent;
 float3 ObjectSpacePosition;
};
struct PackedVaryings
{
 float4 positionCS : SV_POSITION;
 float4 texCoord0 : INTERP0;
 float4 texCoord1 : INTERP1;
 float4 color : INTERP2;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
 uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
 uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
 uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
 FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
};

PackedVaryings PackVaryings (Varyings input)
{
PackedVaryings output;
ZERO_INITIALIZE(PackedVaryings, output);
output.positionCS = input.positionCS;
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}

Varyings UnpackVaryings (PackedVaryings input)
{
Varyings output;
output.positionCS = input.positionCS;
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
output.cullFace = input.cullFace;
#endif
return output;
}


// --------------------------------------------------
// Graph

// Graph Properties
CBUFFER_START(UnityPerMaterial)
half4 diffuseFactor;
float4 diffuseTexture_TexelSize;
float4 diffuseTexture_ST;
float2 diffuseTexture_Rotation;
float diffuseTexture_texCoord;
float4 normalTexture_TexelSize;
float4 normalTexture_ST;
float2 normalTexture_Rotation;
float normalTexture_texCoord;
float normalTexture_scale;
float4 occlusionTexture_TexelSize;
float occlusionTexture_strength;
float4 specularFactor;
float glossinessFactor;
float4 specularGlossinessTexture_TexelSize;
float4 specularGlossinessTexture_ST;
float2 specularGlossinessTexture_Rotation;
float specularGlossinessTexture_texCoord;
float4 emissiveFactor;
float4 emissiveTexture_TexelSize;
float4 emissiveTexture_ST;
float2 emissiveTexture_Rotation;
float emissiveTexture_texCoord;
float emissiveExposureWeight;
float alphaCutoff;
float4 occlusionTexture_ST;
float2 occlusionTexture_Rotation;
float occlusionTexture_texCoord;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(diffuseTexture);
SAMPLER(samplerdiffuseTexture);
TEXTURE2D(normalTexture);
SAMPLER(samplernormalTexture);
TEXTURE2D(occlusionTexture);
SAMPLER(samplerocclusionTexture);
TEXTURE2D(specularGlossinessTexture);
SAMPLER(samplerspecularGlossinessTexture);
TEXTURE2D(emissiveTexture);
SAMPLER(sampleremissiveTexture);

// -- Property used by ScenePickingPass
#ifdef SCENEPICKINGPASS
float4 _SelectionID;
#endif

// -- Properties used by SceneSelectionPass
#ifdef SCENESELECTIONPASS
int _ObjectId;
int _PassValue;
#endif

// Graph Includes
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Normal.cginc"
#include_with_pragmas "Packages/com.unity.cloud.gltfast/Runtime/Shader/Includes/Emission.cginc"

// Graph Functions

void Unity_Step_float(float Edge, float In, out float Out)
{
    Out = step(Edge, In);
}

void Unity_Subtract_float(float A, float B, out float Out)
{
    Out = A - B;
}

void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
{
Out = A * B;
}

void Unity_Add_float2(float2 A, float2 B, out float2 Out)
{
    Out = A + B;
}

void Unity_Multiply_float_float(float A, float B, out float Out)
{
Out = A * B;
}

void Unity_Add_float(float A, float B, out float Out)
{
    Out = A + B;
}

struct Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float
{
};

void SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(float4 Vector4_27C8CB01, float2 Vector2_55C5D8D5, float Vector1_192DCE9E, float2 Vector2_3C6B3DF8, float2 Vector2_97FB8726, Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float IN, out float2 OutVector2_1)
{
float4 _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4 = Vector4_27C8CB01;
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[0];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[1];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[2];
float _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float = _Property_369e8b5627826f8fbcd6b4a84c296177_Out_0_Vector4[3];
float2 _Property_24769925f1e933828843581e6961e79c_Out_0_Vector2 = Vector2_3C6B3DF8;
float _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float = Vector1_192DCE9E;
float _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float;
Unity_Step_float(float(1), _Property_e7bd2e971ccf4c8e9f2b2423ac36e0a9_Out_0_Float, _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float);
float _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float;
Unity_Subtract_float(float(1), _Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float, _Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float);
float2 _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_24769925f1e933828843581e6961e79c_Out_0_Vector2, (_Subtract_774f0011974c3581920861a1a5b94323_Out_2_Float.xx), _Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2);
float2 _Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2 = Vector2_97FB8726;
float2 _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2;
Unity_Multiply_float2_float2(_Property_3d3984b3c9130d86bfc7a31c38593484_Out_0_Vector2, (_Step_c9a19bad33af2d88a6c2f7d40f3c507d_Out_2_Float.xx), _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2);
float2 _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
Unity_Add_float2(_Multiply_26bb62a95e504183b156a2d9e132d568_Out_2_Vector2, _Multiply_0c8a3b7a14e201898b54ab768cdb82c8_Out_2_Vector2, _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2);
float _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[0];
float _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2[1];
float _Split_c2983ad6a945dc868007e6deda6cab3a_B_3_Float = 0;
float _Split_c2983ad6a945dc868007e6deda6cab3a_A_4_Float = 0;
float _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float);
float2 _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2 = Vector2_55C5D8D5;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[0];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float = _Property_58b1fd88e8f66d85b16546054f8f4d1a_Out_0_Vector2[1];
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_B_3_Float = 0;
float _Split_f9f5f25ac7e2a18da6aec127f22416c6_A_4_Float = 0;
float _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float);
float _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float;
Unity_Add_float(_Multiply_8bd5ab4af7a5be8e943e7f0f0d5b1750_Out_2_Float, _Multiply_fbbb4c6c5dcd2082baa013f3acf5569f_Out_2_Float, _Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float);
float _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float;
Unity_Add_float(_Add_622449cce75e9e89ae14ac30cf374313_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_B_3_Float, _Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float);
float _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float;
Unity_Multiply_float_float(_Split_f9f5f25ac7e2a18da6aec127f22416c6_R_1_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_R_1_Float, _Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float);
float _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float;
Unity_Multiply_float_float(_Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_G_2_Float, _Split_c2983ad6a945dc868007e6deda6cab3a_G_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float);
float _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float;
Unity_Add_float(_Multiply_a2b18fc3e0dccb8d9470899894756722_Out_2_Float, _Multiply_7fd54cca45136289b18639e9128acdd2_Out_2_Float, _Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float);
float _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float;
Unity_Add_float(_Add_2b23bdf7d0020d8b89a6a638f045ffa1_Out_2_Float, _Split_aaeabdec2b718a8ebfe6c8e03a8fd49d_A_4_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
float2 _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2 = float2(_Add_1e3d3c30e22b62888a783232c65f9ff2_Out_2_Float, _Add_caa933cfb8602285bc74e927d016065d_Out_2_Float);
#if defined(_TEXTURE_TRANSFORM)
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Vector2_982782b15801618896ad94fc26180d17_Out_0_Vector2;
#else
float2 _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2 = _Add_a5302de78443f180a9689b5879f9ddb5_Out_2_Vector2;
#endif
OutVector2_1 = _TEXTURETRANSFORM_a9653c74bd981d899555b2aada8dd110_Out_0_Vector2;
}

void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
{
    float3 sRGBLo = In * 12.92;
    float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
    Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
}

void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
{
Out = A * B;
}

void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
{
Out = A * B;
}

struct Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float
{
float4 VertexColor;
};

void SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(float4 Vector4_FC55EA20, UnityTexture2D Texture2D_FA7B3822, float2 Vector2_8D613221, Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float IN, out float3 baseColor_1, out float alpha_2)
{
float3 _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
Unity_ColorspaceConversion_Linear_RGB_float((IN.VertexColor.xyz), _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3);
#if defined(UNITY_COLORSPACE_GAMMA)
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = _ColorspaceConversion_5b7cc1ccc3c2cc8e9b782803430a5ba4_Out_1_Vector3;
#else
float3 _UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3 = (IN.VertexColor.xyz);
#endif
float4 _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4 = Vector4_FC55EA20;
UnityTexture2D _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D = Texture2D_FA7B3822;
float2 _Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2 = Vector2_8D613221;
float4 _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.tex, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.samplerstate, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.GetTransformedUV(_Property_4ea0ba4a4540b98986b662b0e34c9d44_Out_0_Vector2) );
if (_Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Property_253666f2e2fab1808ed872dbfb33b5fa_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_R_4_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.r;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_G_5_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.g;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_B_6_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.b;
float _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float = _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4.a;
float4 _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4;
Unity_Multiply_float4_float4(_Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4, _SampleTexture2D_138397a6db27508ebfa37e627012b311_RGBA_0_Vector4, _Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4);
float3 _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
Unity_Multiply_float3_float3(_UNITYCOLORSPACEGAMMA_694a11edcfc84825b16012f21ea98bfb_Out_0_Vector3, (_Multiply_a11bb30953bafd8285f837d1caecc92d_Out_2_Vector4.xyz), _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3);
float _Split_5426501522404b52b23f9cbad6b92767_R_1_Float = IN.VertexColor[0];
float _Split_5426501522404b52b23f9cbad6b92767_G_2_Float = IN.VertexColor[1];
float _Split_5426501522404b52b23f9cbad6b92767_B_3_Float = IN.VertexColor[2];
float _Split_5426501522404b52b23f9cbad6b92767_A_4_Float = IN.VertexColor[3];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_R_1_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[0];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_G_2_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[1];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_B_3_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[2];
float _Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float = _Property_5ecedb8c4fe0638ebff5724112c3cda5_Out_0_Vector4[3];
float _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float;
Unity_Multiply_float_float(_Split_450ef2bb19756486a3df6a4dc6eb7507_A_4_Float, _SampleTexture2D_138397a6db27508ebfa37e627012b311_A_7_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float);
float _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
Unity_Multiply_float_float(_Split_5426501522404b52b23f9cbad6b92767_A_4_Float, _Multiply_042d6775af3e4882bfd8f0ce4caa146c_Out_2_Float, _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float);
baseColor_1 = _Multiply_f0ce3c0288153f81ba18d523e8384d3a_Out_2_Vector3;
alpha_2 = _Multiply_2a101c899ff69481b176e85319651599_Out_2_Float;
}

struct Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float
{
float FaceSign;
};

void SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(UnityTexture2D Texture2D_56E509E5, float Vector1_8CFE54ED, float2 Vector2_465B70E0, Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float IN, out float3 normal_1)
{
UnityTexture2D _Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D = Texture2D_56E509E5;
float2 _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2 = Vector2_465B70E0;
float _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float = Vector1_8CFE54ED;
float _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean = max(0, IN.FaceSign.x);
float3 _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
NormalInTangentSpace_float(_Property_99936726453a9d83af52710fa8eaff75_Out_0_Texture2D, _Property_378f69bae2fc908893c1ebb5e8bb934f_Out_0_Vector2, _Property_742b9cba34c14f839bfff52c4d32f612_Out_0_Float, _IsFrontFace_7e1c59d8acde4eef86552aaa2860494b_Out_0_Boolean, _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3);
normal_1 = _NormalInTangentSpaceCustomFunction_78b78d3380e64bbfb13e1fc5482ae5db_normal_3_Vector3;
}

struct Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float
{
};

void SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(float3 Vector3_BDA4AC8B, UnityTexture2D Texture2D_8C55BE6, float2 Vector2_2269B91D, float Vector1_AC5B6513, Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float IN, out float3 Emission_1)
{
UnityTexture2D _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D = Texture2D_8C55BE6;
float2 _Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2 = Vector2_2269B91D;
float4 _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.tex, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.samplerstate, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.GetTransformedUV(_Property_217283dd70c77481a78535eff7867f2c_Out_0_Vector2) );
if (_Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4, _Property_5dd5d27c6d422d8f943427c716404c74_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_R_4_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.r;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_G_5_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.g;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_B_6_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.b;
float _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_A_7_Float = _SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.a;
float3 _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3 = Vector3_BDA4AC8B;
float3 _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
Unity_Multiply_float3_float3((_SampleTexture2D_f9a26538c4fd698b8c7267c61f255b87_RGBA_0_Vector4.xyz), _Property_46a3bee6c6d13c8fb349fc9dec034961_Out_0_Vector3, _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3);
float _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float = Vector1_AC5B6513;
float3 _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
glTFast_HDRP_GetEmissionHDRColor_float(_Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3, _Property_c481a8063e79de839b5206148ab1d254_Out_0_Float, _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3);
#if defined(SHADEROPTIONS_PRE_EXPOSITION)
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _glTFastHDRPGetEmissionHDRColorCustomFunction_39c58c66879c4ddfae5d63f413273805_Output_3_Vector3;
#else
float3 _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3 = _Multiply_8b01474d50494dd78b966a01d40b7936_Out_2_Vector3;
#endif
#if defined(_EMISSIVE)
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = _SHADEROPTIONSPREEXPOSITION_3c45f52b72e94ab9802a83bbb7097b83_Out_0_Vector3;
#else
float3 _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3 = float3(0, 0, 0);
#endif
Emission_1 = _EMISSIVE_74d85a63492c1f83955e97c724819404_Out_0_Vector3;
}

struct Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float
{
};

void SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(UnityTexture2D Texture2D_1D7F398E, float2 Vector2_CDA25D43, float3 Vector3_FDC2E8AA, float Vector1_D5749272, Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float IN, out float3 Specular_1, out float Glossiness_2)
{
UnityTexture2D _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D = Texture2D_1D7F398E;
float2 _Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2 = Vector2_CDA25D43;
float4 _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.tex, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.samplerstate, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.GetTransformedUV(_Property_7ac08bb9c0a6178ab1b2f9e9c971514a_Out_0_Vector2) );
if (_Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4, _Property_d706ec500303658d89fdb1268f848e73_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.r;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.g;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.b;
float _SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float = _SampleTexture2D_1f9908930f6e7886920319a241024128_RGBA_0_Vector4.a;
float3 _Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3 = float3(_SampleTexture2D_1f9908930f6e7886920319a241024128_R_4_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_G_5_Float, _SampleTexture2D_1f9908930f6e7886920319a241024128_B_6_Float);
float3 _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3 = Vector3_FDC2E8AA;
float3 _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Unity_Multiply_float3_float3(_Vector3_a7ca831351a82e80a7a186757f5613f2_Out_0_Vector3, _Property_62077703b054b38c92e44b773796b462_Out_0_Vector3, _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3);
float _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float = Vector1_D5749272;
float _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
Unity_Multiply_float_float(_SampleTexture2D_1f9908930f6e7886920319a241024128_A_7_Float, _Property_d479026436393f8f9952df2b22a787ed_Out_0_Float, _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float);
Specular_1 = _Multiply_b9ac75ca7bb277888b11f40b06046ae5_Out_2_Vector3;
Glossiness_2 = _Multiply_fdccaaf06135b3899e1fe2101a28b022_Out_2_Float;
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

struct Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float
{
};

void SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(float Vector1_4CC3C1C8, float Vector1_A2CAD0A5, Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float IN, out float occlusion_1)
{
float _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float = Vector1_A2CAD0A5;
float _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float = Vector1_4CC3C1C8;
float _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
Unity_Lerp_float(float(1), _Property_0648fbf8145e6687a3776abb74d24998_Out_0_Float, _Property_ffa846719babbb819c28b7709b3cebed_Out_0_Float, _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float);
#if defined(_OCCLUSION)
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = _Lerp_b7c29ac445d47585a4a8e2d6fea0f888_Out_3_Float;
#else
float _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float = float(1);
#endif
occlusion_1 = _OCCLUSION_06def7803a6a878abb0f6e19ec7c3e7a_Out_0_Float;
}

struct Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float
{
float4 VertexColor;
float FaceSign;
};

void SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(float Vector1_57266306, UnityTexture2D Texture2D_B4A7F700, float4 Vector4_709747A6, float2 Vector2_E7A4EB6D, float Vector1_723CD44F, float Vector1_345B830B, float3 Vector3_44384D65, UnityTexture2D Texture2D_8F96C631, float4 Vector4_6740F1E7, float2 Vector2_2FF7A846, float Vector1_84D2828, float Vector1_2fea160864564550934c57e1778a2de7, float3 Vector3_7DAA0EF6, float Vector1_B9A549A5, UnityTexture2D Texture2D_5B57D6EB, float4 Vector4_E9BA8DE2, float2 Vector2_65963D32, float Vector1_95F4D45C, float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float4 Vector4_6F4A9DFD, float2 Vector2_FE260CB0, float Vector1_3AB48523, UnityTexture2D Texture2D_2BD19CD4, float4 Vector4_F60D5B1F, float2 Vector2_B37C1316, float Vector1_FA39B51B, float2 Vector2_489312EB, float2 Vector2_20A21D51, Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float IN, out float3 Albedo_6, out float3 Normal_2, out float3 Emission_3, out float3 Specular_4, out float Glossiness_5, out float Occlusion_1, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float = Vector1_3AB48523;
float2 _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2 = Vector2_489312EB;
float2 _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2 = Vector2_20A21D51;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_b9c88974c0fb19818b84900b693e5639_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
UnityTexture2D _Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D = Texture2D_B4A7F700;
float _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float = Vector1_345B830B;
float4 _Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4 = Vector4_709747A6;
float2 _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2 = Vector2_E7A4EB6D;
float _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float = Vector1_723CD44F;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_1a602b6a58e7c78690200c4a436b77be;
float2 _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_febaadbdb026a78e9b7e8dd21816544f_Out_0_Vector4, _Property_897ef9726b94f68294ef8ddf475f4442_Out_0_Vector2, _Property_6db12a6511ae8f85a64c3d60cdbf5354_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_1a602b6a58e7c78690200c4a436b77be, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2);
Bindings_Normal_3d23f3f9d39dc4621898db0a20884fcd_float _Normal_26440132fb18a98db1ec547ca466585e;
_Normal_26440132fb18a98db1ec547ca466585e.FaceSign = IN.FaceSign;
float3 _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
SG_Normal_3d23f3f9d39dc4621898db0a20884fcd_float(_Property_9c9a204af48b6b86a353d8bc8ee20503_Out_0_Texture2D, _Property_b388dc2966e4168d8536c7dc427e9380_Out_0_Float, _TextureTransform_1a602b6a58e7c78690200c4a436b77be_OutVector2_1_Vector2, _Normal_26440132fb18a98db1ec547ca466585e, _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3);
float3 _Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3 = Vector3_44384D65;
UnityTexture2D _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D = Texture2D_8F96C631;
float4 _Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4 = Vector4_6740F1E7;
float2 _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2 = Vector2_2FF7A846;
float _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float = Vector1_84D2828;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_79842b5022789d889ba95a6c39169537;
float2 _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_70d0bdba09196186815c0518202d988b_Out_0_Vector4, _Property_090bd9135f42fe89985366d6587c030e_Out_0_Vector2, _Property_81c6a22f45bc1f8e80c7433d50bcfa12_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_79842b5022789d889ba95a6c39169537, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2);
float _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float = Vector1_2fea160864564550934c57e1778a2de7;
Bindings_Emission_c65a0769f13ae46a28263a75eed49ecc_float _Emission_24b8888525e64687aefeb600f69308bf;
float3 _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
SG_Emission_c65a0769f13ae46a28263a75eed49ecc_float(_Property_59a47d64a478bb89b5655f21626bcda8_Out_0_Vector3, _Property_a09f2abced71758b853f032cc6fb8b3e_Out_0_Texture2D, _TextureTransform_79842b5022789d889ba95a6c39169537_OutVector2_1_Vector2, _Property_620a271ba74548a9aaa4dfc1594a2e41_Out_0_Float, _Emission_24b8888525e64687aefeb600f69308bf, _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3);
UnityTexture2D _Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D = Texture2D_5B57D6EB;
float4 _Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4 = Vector4_E9BA8DE2;
float2 _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2 = Vector2_65963D32;
float _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float = Vector1_95F4D45C;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_51c75b27ca2e628daba723293e90f486;
float2 _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_08aec25290ecb9879a507bcefac4abb8_Out_0_Vector4, _Property_b503f90713805b89b2bf7db6e2a52ab2_Out_0_Vector2, _Property_be58098d4361cd868895764d7ef4d952_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_51c75b27ca2e628daba723293e90f486, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2);
float3 _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3 = Vector3_7DAA0EF6;
float _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float = Vector1_B9A549A5;
Bindings_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a;
float3 _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
float _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
SG_SpecularGlossiness_7c57fa3e768cc40d2abb3b1b4ccd18d4_float(_Property_bf91a2811a164b88834adcc789e2254e_Out_0_Texture2D, _TextureTransform_51c75b27ca2e628daba723293e90f486_OutVector2_1_Vector2, _Property_cc5481d8746cfb88b77b7851382f163c_Out_0_Vector3, _Property_a01985a6ef28268f9ffc7c7e627e982a_Out_0_Float, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3, _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float);
float _Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float = Vector1_57266306;
UnityTexture2D _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D = Texture2D_2BD19CD4;
float4 _Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4 = Vector4_F60D5B1F;
float2 _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2 = Vector2_B37C1316;
float _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float = Vector1_FA39B51B;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_b3e27352a6790d8bb9077bb8c178442b;
float2 _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_cd0339624fcdf48fac3397c1d6b7b677_Out_0_Vector4, _Property_50a14351ada9698c80331955e78644c1_Out_0_Vector2, _Property_74e0360225576a81a2c9e9a721d767f1_Out_0_Float, _Property_8444da4aad59bf858d318d1ce32ca4a2_Out_0_Vector2, _Property_ef9f46c1ac2ccb86a3170ff7b957baee_Out_0_Vector2, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b, _TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2);
float4 _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.tex, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.samplerstate, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.GetTransformedUV(_TextureTransform_b3e27352a6790d8bb9077bb8c178442b_OutVector2_1_Vector2) );
if (_Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode.x > 0)
_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4 = DecodeHDRSample(_SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4, _Property_aa20d33ff08366828417f02d217855b1_Out_0_Texture2D.hdrDecode);
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.r;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_G_5_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.g;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_B_6_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.b;
float _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_A_7_Float = _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_RGBA_0_Vector4.a;
Bindings_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float _Occlusion_0e714e2cf8718d809938a41db94f9879;
float _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
SG_Occlusion_a61e32a8ab2b744a3837d668b8fc3155_float(_Property_12e99ce8b164b286b3dd74db0e7f7364_Out_0_Float, _SampleTexture2D_9fa9cb7d84673880a4c3752a2c88bf44_R_4_Float, _Occlusion_0e714e2cf8718d809938a41db94f9879, _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float);
Albedo_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
Normal_2 = _Normal_26440132fb18a98db1ec547ca466585e_normal_1_Vector3;
Emission_3 = _Emission_24b8888525e64687aefeb600f69308bf_Emission_1_Vector3;
Specular_4 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Specular_1_Vector3;
Glossiness_5 = _SpecularGlossiness_0ff5afd626af1685811fdc8680c1a44a_Glossiness_2_Float;
Occlusion_1 = _Occlusion_0e714e2cf8718d809938a41db94f9879_occlusion_1_Float;
Alpha_7 = _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
}

// Custom interpolators pre vertex
/* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */

// Graph Vertex
struct VertexDescription
{
float3 Position;
float3 Normal;
float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
VertexDescription description = (VertexDescription)0;
description.Position = IN.ObjectSpacePosition;
description.Normal = IN.ObjectSpaceNormal;
description.Tangent = IN.ObjectSpaceTangent;
return description;
}

// Custom interpolators, pre surface
#ifdef FEATURES_GRAPH_VERTEX
Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
{
return output;
}
#define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
#endif

// Graph Pixel
struct SurfaceDescription
{
float Alpha;
float AlphaClipThreshold;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
SurfaceDescription surface = (SurfaceDescription)0;
float _Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float = occlusionTexture_strength;
UnityTexture2D _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D = UnityBuildTexture2DStructInternal(normalTexture, samplernormalTexture, normalTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4 = normalTexture_ST;
float2 _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2 = normalTexture_Rotation;
float _Property_31a78ad980ea208688047092e020b750_Out_0_Float = normalTexture_texCoord;
float _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float = normalTexture_scale;
float4 _Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(emissiveFactor) : emissiveFactor;
UnityTexture2D _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D = UnityBuildTexture2DStructInternal(emissiveTexture, sampleremissiveTexture, emissiveTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4 = emissiveTexture_ST;
float2 _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2 = emissiveTexture_Rotation;
float _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float = emissiveTexture_texCoord;
float _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float = emissiveExposureWeight;
float4 _Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4 = specularFactor;
float _Property_60dce70db58092878816fe8c17157c87_Out_0_Float = glossinessFactor;
UnityTexture2D _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D = UnityBuildTexture2DStructInternal(specularGlossinessTexture, samplerspecularGlossinessTexture, specularGlossinessTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4 = specularGlossinessTexture_ST;
float2 _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2 = specularGlossinessTexture_Rotation;
float _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float = specularGlossinessTexture_texCoord;
half4 _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4 = diffuseFactor;
UnityTexture2D _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D = UnityBuildTexture2DStructInternal(diffuseTexture, samplerdiffuseTexture, diffuseTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4 = diffuseTexture_ST;
float2 _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2 = diffuseTexture_Rotation;
float _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float = diffuseTexture_texCoord;
UnityTexture2D _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D = UnityBuildTexture2DStructInternal(occlusionTexture, samplerocclusionTexture, occlusionTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float4 _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4 = occlusionTexture_ST;
float2 _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2 = occlusionTexture_Rotation;
float _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float = occlusionTexture_texCoord;
float4 _UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4 = IN.uv0;
float4 _UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4 = IN.uv1;
Bindings_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.VertexColor = IN.VertexColor;
_PBRspecularglossiness_bc16432923334c54a07a6046a6416ade.FaceSign = IN.FaceSign;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3;
float3 _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float;
float _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
SG_PBRspecularglossiness_a604ef8f6e4b643cf9807d62c5c98463_float(_Property_16d5e6b9308f1980917f5fccf7ef65a0_Out_0_Float, _Property_983b60d951e41f8dbbfd076c8b6f70fb_Out_0_Texture2D, _Property_19b045ecf5cfcc849b252ea787602549_Out_0_Vector4, _Property_d8bb742f096d208f8862f72adfe66991_Out_0_Vector2, _Property_31a78ad980ea208688047092e020b750_Out_0_Float, _Property_9dd4a563be4eb48ea7dc0032355bd661_Out_0_Float, (_Property_900125282ac7b882beb5072cffc52c89_Out_0_Vector4.xyz), _Property_9e9b18e075f48384a925f4a0cd679bba_Out_0_Texture2D, _Property_c958c209f91472859081d876bf0b0ee3_Out_0_Vector4, _Property_680c5eb2895b70808a13389fcb015785_Out_0_Vector2, _Property_bb2b18863ac9468686e5b347581796a4_Out_0_Float, _Property_81ab6fa904764444a14a5d3383d977d7_Out_0_Float, (_Property_b61042c39b843b8eac28c8d34e3be1ce_Out_0_Vector4.xyz), _Property_60dce70db58092878816fe8c17157c87_Out_0_Float, _Property_7e50b0c6c511e0849f306d2f99b077e0_Out_0_Texture2D, _Property_52f9aab1e6ab4685892828e50779871d_Out_0_Vector4, _Property_8f86ee9ebde47b84aa7e1c56532e010a_Out_0_Vector2, _Property_2531aa71f78c508b91ffa639c30f8609_Out_0_Float, _Property_2335e52807b0038faa7b962f4e130447_Out_0_Vector4, _Property_fa61d662d66d5883ac29040250410f69_Out_0_Texture2D, _Property_abb0b17ea49cfa80b820561a6693fa60_Out_0_Vector4, _Property_4c45132ea34d0082bfd4b6174560b919_Out_0_Vector2, _Property_fa363d073b547e8095b1c41ca5314407_Out_0_Float, _Property_ceb236c788cd148a80d9ac1935279641_Out_0_Texture2D, _Property_e4be62b6f98fd185936a978aef624dc8_Out_0_Vector4, _Property_0a5152471ec3cf8d9e82939ffad60347_Out_0_Vector2, _Property_4ab50afa2909938ba8fa11ef853a8888_Out_0_Float, (_UV_c9fb78f50ddac182922b516126b955f6_Out_0_Vector4.xy), (_UV_d4997cd2bbfc5585ada45a0aa5fa4afa_Out_0_Vector4.xy), _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Albedo_6_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Normal_2_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Emission_3_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Specular_4_Vector3, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Glossiness_5_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Occlusion_1_Float, _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float);
float _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float = alphaCutoff;
surface.Alpha = _PBRspecularglossiness_bc16432923334c54a07a6046a6416ade_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_48ca170f4849da8a9fa8d3611cbef16c_Out_0_Float;
return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal =                          input.normalOS;
    output.ObjectSpaceTangent =                         input.tangentOS.xyz;
    output.ObjectSpacePosition =                        input.positionOS;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif

    return output;
}
SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

    






    #if UNITY_UV_STARTS_AT_TOP
    #else
    #endif


    output.uv0 = input.texCoord0;
    output.uv1 = input.texCoord1;
    output.VertexColor = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
#else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
    BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
{
    result.vertex     = float4(attributes.positionOS, 1);
    result.tangent    = attributes.tangentOS;
    result.normal     = attributes.normalOS;
    result.texcoord   = attributes.uv0;
    result.texcoord1  = attributes.uv1;
    result.color      = attributes.color;
    result.vertex     = float4(vertexDescription.Position, 1);
    result.normal     = vertexDescription.Normal;
    result.tangent    = float4(vertexDescription.Tangent, 0);
    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
}

void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
{
    result.pos = varyings.positionCS;
    // World Tangent isn't an available input on v2f_surf


    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogCoord = varyings.fogFactorAndVertexLight.x;
        COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
}

void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
{
    result.positionCS = surfVertex.pos;
    // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
    // World Tangent isn't an available input on v2f_surf

    #if UNITY_ANY_INSTANCING_ENABLED
    #endif
    #if UNITY_SHOULD_SAMPLE_SH
    #if !defined(LIGHTMAP_ON)
    #endif
    #endif
    #if defined(LIGHTMAP_ON)
    #endif
    #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
        COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
    #endif

    DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

ENDHLSL
}
}
CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
CustomEditorForRenderPipeline "UnityEditor.Rendering.BuiltIn.ShaderGraph.BuiltInLitGUI" ""
CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
FallBack "Hidden/Shader Graph/FallbackError"
}