
Shader "core/urp/01.standard"
{
	Properties
	{
		[MainColor] _BaseColor ("Base Color", Color) = (1,1,1,1)
        [MainTexture] _BaseMap ("Base Map", 2D) = "white" {}
       
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry" "RenderPipeline" = "UniversalPipeline" }
		Cull Back

        Pass
        {
            Tags {"LightMode" = "UniversalForward"}
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float2 uv           : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float2 uv           :TEXCOORD0;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                float4  _BaseMap_ST;
                half4   _BaseColor;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionHCS = TransformObjectToHClip(input.positionOS);
                output.uv = TRANSFORM_TEX(input.uv, _BaseMap);

                return output;
            }

            half4 frag(Varyings input): SV_Target 
            {
                return SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv) * _BaseColor;
            }

            ENDHLSL
        }
	}
}