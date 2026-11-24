// Gaussian projection adapted from UnitySplats (Copyright 2025 Yize Wu, MIT).
// Dependencies and their license notices remain in Packages/com.arloopa.unitysplats.
Shader "SpatialProductViewer/Gaussian Product"
{
    Properties {}
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Pass
        {
            Name "GaussianProduct"
            Cull Off ZWrite Off
            Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
            HLSLPROGRAM
            #include_with_pragmas "GaussianProductPass.hlsl"
            ENDHLSL
        }
        Pass
        {
            Name "SelectionMask"
            Tags { "LightMode"="SPVSelectionMask" }
            Cull Off ZWrite Off ZTest Always ColorMask R
            Blend One Zero
            HLSLPROGRAM
            #define SPV_SPLAT_MASK
            #include_with_pragmas "GaussianProductPass.hlsl"
            ENDHLSL
        }
    }
}
