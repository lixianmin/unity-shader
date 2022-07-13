
Shader "core/urp/02.xray"
{
	Properties
	{
        [Header(The Blocked Part)]
        [Space(10)]
        _XRayColor ("X-Ray Color", Color) = (0,1,1,1)
        _XRayWidth ("X-Ray Width", Range(1, 2)) = 1
        _XRayBrightness ("X-Ray Brightness",Range(0, 2)) = 1

		[Header(The Normal Part)]
        [Space(10)]
		[MainColor] _BaseColor ("Color", Color) = (1,1,1,1)
        [MainTexture] _BaseMap ("Albedo", 2D) = "white" {}

        // _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

        _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
        // _SmoothnessTextureChannel("Smoothness texture channel", Float) = 0

        _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        // _MetallicGlossMap("Metallic", 2D) = "white" {}

        // _SpecColor("Specular", Color) = (0.2, 0.2, 0.2)
        // _SpecGlossMap("Specular", 2D) = "white" {}

        // [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        // [ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0

        _BumpScale("Bump Scale", Float) = 1.0
        [NoScaleOffset] _BumpMap("Bump Map", 2D) = "bump" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "True" "ShaderModel"="2.0" }
		Cull Back

        Pass
        {
            Name "XRay"
            Tags {"LightMode" = "UniversalForward"} 

            ZTest Greater
            ZWrite Off

            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            
            // -------------------------------------
            // Material Keywords
            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP
            
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            // #include "Packages/com.unity.render-pipelines.universal/Shaders/LitForwardPass.hlsl"


            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float4 tangentOS    : TANGENT;
            };

            struct Varyings
            {
                float4 positionCS       : SV_POSITION;
                float2 viewDirectionWS  : TEXCOORD0;
                float3 normalWS         : TEXCOORD1;
            };

            // TEXTURE2D(_BaseMap);
            // SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4   _XRayColor;
                half    _XRayWidth;
                half    _XRayBrightness;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output = (Varyings)0;
                // output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

                output.positionCS = vertexInput.positionCS;
                output.viewDirectionWS = GetWorldSpaceNormalizeViewDir(vertexInput.positionWS);
                output.normalWS = normalInput.normalWS;

                return output;
            }

            half4 frag(Varyings input): SV_Target 
            {
                // Fresnel算法
                half nv = saturate(dot(input.normalWS, input.viewDirectionWS));
                nv = pow(1 - nv, _XRayWidth) * _XRayBrightness;

                half4 color;
                color.rgb = _XRayColor.rgb;
                color.a = nv;

                return color;
            }

            ENDHLSL
        }

        // UsePass "core/urp/01.standard"
        // Used for rendering shadowmaps
        // TODO: there's one issue with adding this UsePass here, it won't make this shader compatible with SRP Batcher
        // as the ShadowCaster pass from Lit shader is using a different UnityPerMaterial CBUFFER. 
        // Maybe we should add a DECLARE_PASS macro that allows to user to inform the UnityPerMaterial CBUFFER to use?
        UsePass "Universal Render Pipeline/Lit/ShadowCaster"
        UsePass "Universal Render Pipeline/Lit/DepthOnly"
        // UsePass "Universal Render Pipeline/Lit/DepthNormals"
        // UsePass "Universal Render Pipeline/Lit/GBuffer"
	}
}