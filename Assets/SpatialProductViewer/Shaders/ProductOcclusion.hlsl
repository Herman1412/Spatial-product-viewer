#ifndef SPATIAL_PRODUCT_OCCLUSION_INCLUDED
#define SPATIAL_PRODUCT_OCCLUSION_INCLUDED
#pragma target 4.5

// ARShaderOcclusion supplies the per-eye texture, projection and NDC conversion parameters.
TEXTURE2D_ARRAY_FLOAT(_EnvironmentDepthTexture);
SAMPLER(sampler_EnvironmentDepthTexture);
float4x4 _EnvironmentDepthProjectionMatrices[2];
float2 _NdcLinearConversionParameters;
float4x4 _SPVWorldToTracking;
int _SPVOcclusionCameraEnabled;
int _SPVDepthIsLinear;
float _SPVDepthBias;

float SpatialProductDepthMargin(float3 positionWS)
{
    #if !defined(SHADERGRAPH_PREVIEW)
    if (_SPVOcclusionCameraEnabled == 0) return 1;
    float3 trackingPosition = mul(_SPVWorldToTracking,float4(positionWS,1)).xyz;
    float4 projected = mul(_EnvironmentDepthProjectionMatrices[unity_StereoEyeIndex],float4(trackingPosition,1));
    if (projected.w <= 0) return 1;
    float2 uv = (projected.xy/projected.w+1)*.5;
    if (any(uv < 0) || any(uv > 1)) return 1;
    float raw = SAMPLE_TEXTURE2D_ARRAY(_EnvironmentDepthTexture,sampler_EnvironmentDepthTexture,uv,unity_StereoEyeIndex).r;
    if (_SPVDepthIsLinear == 0 && (raw <= 0 || raw >= 1)) return 1;
    float sceneDepth = _NdcLinearConversionParameters.x/(projected.z/projected.w+_NdcLinearConversionParameters.y);
    float realDepth = _SPVDepthIsLinear != 0 ? raw : _NdcLinearConversionParameters.x/(raw*2-1+_NdcLinearConversionParameters.y);
    // Invalid/out-of-range depth leaves virtual content visible. Bias reduces surface-edge flicker.
    if (realDepth > 0 && realDepth < 1000 && sceneDepth > 0)
        return realDepth+_SPVDepthBias-sceneDepth;
    #endif
    return 1;
}

void SpatialProductClip(float3 positionWS) { clip(SpatialProductDepthMargin(positionWS)); }

#endif
