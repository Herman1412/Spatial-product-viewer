Shader "SpatialProductViewer/Occlusion/glTF-unlit"
{
Properties
{
[MainColor]baseColorFactor("Base Color", Color) = (1, 1, 1, 1)
[MainTexture][NoScaleOffset]baseColorTexture("Base Color Tex", 2D) = "white" {}
baseColorTexture_ST("Base Color Tex ST", Vector, 4) = (1, 1, 0, 0)
baseColorTexture_Rotation("Base Color Tex Rotation", Vector, 2) = (0, 0, 0, 0)
baseColorTexture_texCoord("Base Color Tex UV", Int) = 0
alphaCutoff("Alpha Cutoff", Range(0, 1)) = 0.5
[HideInInspector]_CastShadows("_CastShadows", Float) = 1
[HideInInspector]_Surface("_Surface", Float) = 0
[HideInInspector]_Blend("_Blend", Float) = 0
[HideInInspector]_AlphaClip("_AlphaClip", Float) = 0
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
"UniversalMaterialType" = "Unlit"
"Queue"="Geometry"
"DisableBatching"="False"
"ShaderGraphShader"="true"
"ShaderGraphTargetId"="UniversalUnlitSubTarget"
}
Pass
{
    Name "Unlit"
    Tags
    {
        // LightMode: <None>
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
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma multi_compile _ USE_LEGACY_LIGHTMAPS
#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ DEBUG_DISPLAY
#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
#pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines

#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_UNLIT
#define _FOG_FRAGMENT 1
#define UNLIT_DEFAULT_DECAL_BLENDING 1
#define UNLIT_DEFAULT_SSAO 1


// custom interpolator pre-include
/* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */

// Includes
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
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
 float3 positionWS : INTERP3;
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
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
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
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

// Graph Includes
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.BaseColor = _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Assets/SpatialProductViewer/Shaders/OccludedUnlitPass.hlsl"

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
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines

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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

// Graph Includes
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines

#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

// Graph Includes
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
    Name "DepthNormalsOnly"
    Tags
    {
        "LightMode" = "DepthNormalsOnly"
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
#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
#pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines

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
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY


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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

// Graph Includes
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines

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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

// Graph Includes
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
#pragma multi_compile _ SHADOWS_SHADOWMASK
#pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
#pragma shader_feature_local_fragment _ _ALPHATEST_ON
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines

#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
#define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
#define VARYINGS_NEED_POSITION_WS
#define VARYINGS_NEED_NORMAL_WS
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_GBUFFER


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
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
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
 float3 positionWS;
 float3 normalWS;
 float4 texCoord0;
 float4 texCoord1;
 float4 color;
#if !defined(LIGHTMAP_ON)
 float3 sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
 float4 probeOcclusion;
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
 float4 uv0;
 float4 uv1;
 float4 VertexColor;
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
#if !defined(LIGHTMAP_ON)
 float3 sh : INTERP0;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
 float4 probeOcclusion : INTERP1;
#endif
 float4 texCoord0 : INTERP2;
 float4 texCoord1 : INTERP3;
 float4 color : INTERP4;
 float3 positionWS : INTERP5;
 float3 normalWS : INTERP6;
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
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
output.probeOcclusion = input.probeOcclusion;
#endif
output.texCoord0.xyzw = input.texCoord0;
output.texCoord1.xyzw = input.texCoord1;
output.color.xyzw = input.color;
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
#if !defined(LIGHTMAP_ON)
output.sh = input.sh;
#endif
#if defined(USE_APV_PROBE_OCCLUSION)
output.probeOcclusion = input.probeOcclusion;
#endif
output.texCoord0 = input.texCoord0.xyzw;
output.texCoord1 = input.texCoord1.xyzw;
output.color = input.color.xyzw;
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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

// Graph Includes
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.BaseColor = _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

        return output;
}

// --------------------------------------------------
// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitGBufferPass.hlsl"
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
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines

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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

// Graph Includes
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines

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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
UNITY_TEXTURE_STREAMING_DEBUG_VARS;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

// Graph Includes
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.BaseColor = _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
}
SubShader
{
Tags
{
// RenderPipeline: <None>
"RenderType"="Opaque"
"BuiltInMaterialType" = "Unlit"
"Queue"="Geometry"
// DisableBatching: <None>
"ShaderGraphShader"="true"
"ShaderGraphTargetId"="BuiltInUnlitSubTarget"
}
Pass
{
    Name "Pass"
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
#pragma shader_feature_local_fragment _ _BUILTIN_SURFACE_TYPE_TRANSPARENT
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHAPREMULTIPLY_ON
#pragma shader_feature_local_fragment _ _BUILTIN_AlphaClip
#pragma shader_feature_local_fragment _ _BUILTIN_ALPHATEST_ON
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
#define FEATURES_GRAPH_VERTEX
/* WARNING: $splice Could not find named fragment 'PassInstancing' */
#define SHADERPASS SHADERPASS_UNLIT
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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

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
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.BaseColor = _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

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
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

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
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

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
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

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
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
#pragma shader_feature_local _ _TEXTURE_TRANSFORM

#if defined(_TEXTURE_TRANSFORM)
#define KEYWORD_PERMUTATION_0
#else
#define KEYWORD_PERMUTATION_1
#endif


// Defines
#define ATTRIBUTES_NEED_NORMAL
#define ATTRIBUTES_NEED_TANGENT
#define ATTRIBUTES_NEED_TEXCOORD0
#define ATTRIBUTES_NEED_TEXCOORD1
#define ATTRIBUTES_NEED_COLOR
#define VARYINGS_NEED_TEXCOORD0
#define VARYINGS_NEED_TEXCOORD1
#define VARYINGS_NEED_COLOR
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
float4 baseColorFactor;
float4 baseColorTexture_TexelSize;
float4 baseColorTexture_ST;
float2 baseColorTexture_Rotation;
float baseColorTexture_texCoord;
float alphaCutoff;
CBUFFER_END


// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(baseColorTexture);
SAMPLER(samplerbaseColorTexture);

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
// GraphIncludes: <None>

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

struct Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float
{
float4 VertexColor;
};

void SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(float4 Vector4_8743F3C3, UnityTexture2D Texture2D_EBF077FA, float2 Vector2_FE260CB0, float4 Vector4_6F4A9DFD, float Vector1_B0E15B5E, float2 Vector2_B59C246, float2 Vector2_5B384487, Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float IN, out float3 Color_6, out float Alpha_7)
{
float4 _Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4 = Vector4_8743F3C3;
UnityTexture2D _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D = Texture2D_EBF077FA;
float4 _Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4 = Vector4_6F4A9DFD;
float2 _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2 = Vector2_FE260CB0;
float _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float = Vector1_B0E15B5E;
float2 _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2 = Vector2_B59C246;
float2 _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2 = Vector2_5B384487;
Bindings_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7;
float2 _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2;
SG_TextureTransform_9a44a43ef44bd4a9dbc883ebde01cc72_float(_Property_b1ae0121c155e08c9ff7c8dfb05f16fb_Out_0_Vector4, _Property_c679a5c43b089988bc1b86de0526582c_Out_0_Vector2, _Property_4dc1cf761c191f8f910dbb8e6c7e6daf_Out_0_Float, _Property_3507bc4a6e76c8848ec088878b58f3a1_Out_0_Vector2, _Property_afe41b6ec3e32a8b9688b2a3c920edf6_Out_0_Vector2, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2);
Bindings_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float _BaseColor_782316cb22891c8bae70aebb2472aa90;
_BaseColor_782316cb22891c8bae70aebb2472aa90.VertexColor = IN.VertexColor;
float3 _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
float _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float;
SG_BaseColor_8128dba25d89b4e0e99b91d27f058f07_float(_Property_2efce70471c70c85a0f905a5f9067e19_Out_0_Vector4, _Property_89fb11c868505d8bb7c2609fa0482fd5_Out_0_Texture2D, _TextureTransform_7cd133188bb05a8fb0e1e3e1947b06e7_OutVector2_1_Vector2, _BaseColor_782316cb22891c8bae70aebb2472aa90, _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3, _BaseColor_782316cb22891c8bae70aebb2472aa90_alpha_2_Float);
Color_6 = _BaseColor_782316cb22891c8bae70aebb2472aa90_baseColor_1_Vector3;
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
float4 _Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4 = baseColorFactor;
UnityTexture2D _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D = UnityBuildTexture2DStructInternal(baseColorTexture, samplerbaseColorTexture, baseColorTexture_TexelSize, float4(1, 1, 0, 0), float4(0, 0, 0, 0));
float2 _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2 = baseColorTexture_Rotation;
float4 _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4 = baseColorTexture_ST;
float _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float = baseColorTexture_texCoord;
float4 _UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4 = IN.uv0;
float4 _UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4 = IN.uv1;
Bindings_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float _Unlit_582cdd94584b6687ae07316bc869a128;
_Unlit_582cdd94584b6687ae07316bc869a128.VertexColor = IN.VertexColor;
float3 _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3;
float _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
SG_Unlit_be4372d6443624882a2e9c3b62ab6ee7_float(_Property_6d9c8dca79578a8c85e522168a99b5e8_Out_0_Vector4, _Property_14ea5c3e2fb1368ca27ef0082908c79e_Out_0_Texture2D, _Property_b20b222308aa758a9d66e14335be44ee_Out_0_Vector2, _Property_d2aed0f1c1b8c9819d2fe2018cf3c5eb_Out_0_Vector4, _Property_d4bb5b54b85bc7888209e7cebcde9d04_Out_0_Float, (_UV_f3071b9542df878381af109fcc739e9a_Out_0_Vector4.xy), (_UV_a8aaa3374272ec8cb63c221b125cad1e_Out_0_Vector4.xy), _Unlit_582cdd94584b6687ae07316bc869a128, _Unlit_582cdd94584b6687ae07316bc869a128_Color_6_Vector3, _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float);
float _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float = alphaCutoff;
surface.Alpha = _Unlit_582cdd94584b6687ae07316bc869a128_Alpha_7_Float;
surface.AlphaClipThreshold = _Property_b1d917aa343b49e69a9c205aa4a3546c_Out_0_Float;
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
CustomEditorForRenderPipeline "UnityEditor.Rendering.BuiltIn.ShaderGraph.BuiltInUnlitGUI" ""
CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
FallBack "Hidden/Shader Graph/FallbackError"
}