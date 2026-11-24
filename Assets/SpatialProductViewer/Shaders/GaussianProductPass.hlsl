// Based on UnitySplats Gsplat.shader, Copyright (c) 2025 Yize Wu, MIT License.
// See Packages/com.arloopa.unitysplats/LICENSE.md and Third Party Notices.md.
#pragma target 4.5
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile_instancing
#pragma multi_compile _ STEREO_INSTANCING_ON STEREO_MULTIVIEW_ON
#pragma multi_compile SH_BANDS_0 SH_BANDS_1 SH_BANDS_2 SH_BANDS_3 SH_BANDS_4
#pragma multi_compile UNCOMPRESSED SPARK
#pragma multi_compile GSPLAT_VERTEX_BUFFERS GSPLAT_VERTEX_TEXTURES
#pragma multi_compile __ GSPLAT_ORDER_BUFFER
#define GSPLAT_DISABLE_SKINNING
#ifdef GSPLAT_VERTEX_TEXTURES
int _GsplatTextureWidth;
#endif
#include "UnityCG.cginc"
#include "Packages/com.arloopa.unitysplats/Runtime/Shaders/Gsplat.hlsl"
#ifdef UNCOMPRESSED
#include "Packages/com.arloopa.unitysplats/Runtime/Shaders/GsplatUncompressed.hlsl"
#endif
#ifdef SPARK
#include "Packages/com.arloopa.unitysplats/Runtime/Shaders/GsplatSpark.hlsl"
#endif
#ifndef SPV_SPLAT_MASK
// UnityCG uses the built-in texture macros; adapt the shared URP/glTF depth include.
#ifndef TEXTURE2D_ARRAY_FLOAT
#define TEXTURE2D_ARRAY_FLOAT(name) Texture2DArray<float> name
#define SAMPLER(name) SamplerState name
#define SAMPLE_TEXTURE2D_ARRAY(tex,samp,coord,index) tex.Sample(samp,float3(coord,index))
#endif
#include "ProductOcclusion.hlsl"
#endif
bool _GammaToLinear;
int _SplatCount, _SplatInstanceSize, _SHDegree, _Antialiased;
float4x4 _MATRIX_M;
float _Brightness, _ScaleFactor;
#ifndef SPV_SPLAT_MASK
#if defined(GSPLAT_VERTEX_TEXTURES) && !defined(GSPLAT_ORDER_BUFFER)
Texture2D<float4> _OrderTexture;
uint LoadSplatOrder(uint index)
{
    float4 encoded=_OrderTexture.Load(int3(GsplatLinearTextureCoord(index,_GsplatTextureWidth),0));
    return GsplatDecodeTextureUInt(encoded);
}
#else
StructuredBuffer<uint> _OrderBuffer;
uint LoadSplatOrder(uint index) {return _OrderBuffer[index];}
#endif
#endif
struct appdata
{
    float4 vertex:POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
    #if !defined(UNITY_INSTANCING_ENABLED) && !defined(UNITY_PROCEDURAL_INSTANCING_ENABLED) && !defined(UNITY_STEREO_INSTANCING_ENABLED)
    uint instanceID:SV_InstanceID;
    #endif
};
struct v2f
{
    float2 uv:TEXCOORD0;
    float3 positionWS:TEXCOORD1;
    float4 vertex:SV_POSITION;
    float4 color:COLOR;
    UNITY_VERTEX_OUTPUT_STEREO
};
v2f vert(appdata v)
{
    v2f o;UNITY_SETUP_INSTANCE_ID(v);UNITY_INITIALIZE_OUTPUT(v2f,o);UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    o.vertex=discardVec;
    SplatSource source;
    #if !defined(UNITY_INSTANCING_ENABLED) && !defined(UNITY_PROCEDURAL_INSTANCING_ENABLED) && !defined(UNITY_STEREO_INSTANCING_ENABLED)
    source.order=v.instanceID*_SplatInstanceSize+(uint)v.vertex.z;
    #else
    source.order=unity_InstanceID*_SplatInstanceSize+(uint)v.vertex.z;
    #endif
    if(source.order>=_SplatCount)return o;
    #ifdef SPV_SPLAT_MASK
    source.id=source.order;
    #else
    source.id=LoadSplatOrder(source.order);
    #endif
    source.cornerUV=v.vertex.xy*_ScaleFactor;
    SplatCenter center;SplatCorner corner;float4 color;float3 modelCenter,modelNormal;
    if(!InitSplatData(source,mul(UNITY_MATRIX_V,_MATRIX_M),_Antialiased!=0,center,corner,color,modelCenter,modelNormal))return o;
    if(color.w<=1.0/255.0)return o;
    #if !defined(SPV_SPLAT_MASK) && !defined(SH_BANDS_0)
    float3 dir=normalize(mul(center.view,(float3x3)center.modelView));
    float3 sh[SH_COEFFS];InitSH(source.id,sh);color.rgb+=EvalSH(sh,dir,_SHDegree);
    #endif
    ClipCorner(corner,color.w);
    o.vertex=center.proj+float4(corner.offset.x,_ProjectionParams.x*corner.offset.y,0,0);
    o.color=color;o.uv=corner.uv;o.positionWS=mul(_MATRIX_M,float4(modelCenter,1)).xyz;return o;
}
float4 frag(v2f i):SV_Target
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
    float A=dot(i.uv,i.uv);clip(1-A);
    float maxUV=max(abs(i.uv.x),abs(i.uv.y));
    float falloff=-exp((maxUV-_ScaleFactor*1.16)*25*_ScaleFactor);
    float alpha=(exp(-A*4)+falloff)*i.color.a;
    #ifdef SPV_SPLAT_MASK
    // Ignore the faint tails: outline the visible capture instead of every Gaussian quad.
    clip(alpha-.15);return 1;
    #else
    clip(alpha-1.0/255.0);SpatialProductClip(i.positionWS);
    float3 color=_GammaToLinear ? GammaToLinearSpace(i.color.rgb) : i.color.rgb;
    return float4(color*alpha*_Brightness,alpha);
    #endif
}
