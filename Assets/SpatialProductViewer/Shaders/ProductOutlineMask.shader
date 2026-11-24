Shader "SpatialProductViewer/Outline/Mask"
{
    Properties
    {
        _OutlineAlphaTexture("Opacity texture",2D)="white" {}
        _OutlineUVTransform("UV scale and offset",Vector)=(1,1,0,0)
        _OutlineUVRotation("UV rotation terms",Vector)=(0,0,0,0)
        _OutlineUVSet("UV set",Float)=0
        _OutlineOpacity("Opacity",Float)=1
        _OutlineCutoff("Cutoff",Float)=0.5
        _OutlineUseAlpha("Respect opacity",Float)=0
    }
    SubShader
    {
        Tags { "RenderPipeline"="UniversalPipeline" }
        Pass
        {
            Name "Silhouette"
            Cull Off ZWrite Off ZTest Always ColorMask R
            HLSLPROGRAM
            #pragma target 4.5
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma multi_compile_instancing
            #pragma multi_compile _ STEREO_INSTANCING_ON STEREO_MULTIVIEW_ON
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            TEXTURE2D(_OutlineAlphaTexture);SAMPLER(sampler_OutlineAlphaTexture);
            CBUFFER_START(UnityPerMaterial)
                float4 _OutlineUVTransform,_OutlineUVRotation;
                float _OutlineUVSet,_OutlineOpacity,_OutlineCutoff,_OutlineUseAlpha;
            CBUFFER_END
            struct Attributes { float4 positionOS:POSITION;float2 uv0:TEXCOORD0;float2 uv1:TEXCOORD1;half4 color:COLOR;UNITY_VERTEX_INPUT_INSTANCE_ID };
            struct Varyings { float4 positionCS:SV_POSITION;float2 uv:TEXCOORD0;half alpha:TEXCOORD1;UNITY_VERTEX_OUTPUT_STEREO };
            Varyings Vert(Attributes input)
            {
                Varyings o;UNITY_SETUP_INSTANCE_ID(input);UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.positionCS=TransformObjectToHClip(input.positionOS.xyz);
                float2 uv=_OutlineUVSet>.5 ? input.uv1 : input.uv0;
                o.uv=uv*_OutlineUVTransform.xy+float2(uv.y*_OutlineUVRotation.y,uv.x*_OutlineUVRotation.x)+_OutlineUVTransform.zw;
                o.alpha=input.color.a;return o;
            }
            half4 Frag(Varyings input):SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
                if(_OutlineUseAlpha>.5) clip(SAMPLE_TEXTURE2D(_OutlineAlphaTexture,sampler_OutlineAlphaTexture,input.uv).a*_OutlineOpacity*input.alpha-_OutlineCutoff);
                return 1;
            }
            ENDHLSL
        }
    }
}
