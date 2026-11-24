Shader "SpatialProductViewer/Outline/Contour"
{
    Properties { _OutlineColor("Outline colour",Color)=(0.25,1,0.6,1) _OutlineWidthPixels("Width in pixels",Range(1,8))=3 }
    SubShader
    {
        Tags { "RenderPipeline"="UniversalPipeline" }
        Pass
        {
            Name "Contour"
            Cull Off ZWrite Off ZTest Always
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            HLSLPROGRAM
            #pragma target 4.5
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma multi_compile _ STEREO_INSTANCING_ON STEREO_MULTIVIEW_ON
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"
            float4 _OutlineColor,_OutlineTexelSize;
            float _OutlineWidthPixels;
            half Mask(float2 uv) { return SAMPLE_TEXTURE2D_X(_BlitTexture,sampler_PointClamp,uv).r; }
            half4 Frag(Varyings input):SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
                float2 uv=input.texcoord;
                half center=Mask(uv),expanded=center;
                float2 radius=_OutlineTexelSize.xy*_OutlineWidthPixels;
                // Samples around a circle: outline the union of the model parts, including geometry holes.
                [unroll] for(int i=0;i<16;i++)
                {
                    float angle=i*(6.28318530718/16);
                    expanded=max(expanded,Mask(uv+float2(cos(angle),sin(angle))*radius));
                }
                half edge=saturate(expanded-center);
                clip(edge-.001h); // Leave model colour and passthrough alpha untouched inside/outside the contour.
                return half4(_OutlineColor.rgb,edge*_OutlineColor.a);
            }
            ENDHLSL
        }
    }
}
