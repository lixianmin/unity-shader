
Shader "core/urp/01.standard"
{
	Properties
	{
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
            Tags {"LightMode" = "UniversalForward"} 

            HLSLPROGRAM
            
            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP


            #pragma vertex vert
            #pragma fragment frag

            // #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            // #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            // #pragma multi_compile _ _SHADOWS_SOFT

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            // #include "Packages/com.unity.render-pipelines.universal/Shaders/LitForwardPass.hlsl"


            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float4 tangentOS    : TANGENT;
                float2 texcoord     : TEXCOORD0;                
            };

            struct Varyings
            {
                float4 positionCS   : SV_POSITION;
                float2 uv           : TEXCOORD0;
                float3 positionWS   : TEXCOORD1;
                float3 normalWS     : TEXCOORD2;
                half4 tangentWS     : TEXCOORD3;    // xyz: tangent, w: sign
            };

            // TEXTURE2D(_BaseMap);
            // SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                // float4  _BaseMap_ST;
                // half4   _BaseColor;
            CBUFFER_END

            // // Copied from Unity built-in shader v2018.3
            // float3 UnpackScaleNormal(float4 packednormal, float scale)
            // {
            // #ifndef UNITY_NO_DXT5nm
            //     // Unpack normal as DXT5nm (1, y, 1, x) or BC5 (x, y, 0, 1)
            //     // Note neutral texture like "bump" is (0, 0, 1, 1) to work with both plain RGB normal and DXT5nm/BC5
            //     packednormal.x *= packednormal.w;
            // #endif
            //     float3 normal;
            //     normal.xy = (packednormal.xy * 2 - 1) * scale;
            //     normal.z = sqrt(1 - saturate(dot(normal.xy, normal.xy)));
            //     return normal;
            // }

            void InitializeInputData(Varyings input, half3 normalTS, out InputData inputData)
            {
                inputData = (InputData)0;
                inputData.positionWS = input.positionWS;

                half3 viewDirWS = GetWorldSpaceNormalizeViewDir(input.positionWS);

                float sgn = input.tangentWS.w;      // should be either +1 or -1
                float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);

                inputData.tangentToWorld = tangentToWorld;
                inputData.normalWS = TransformTangentToWorld(normalTS, tangentToWorld);
          

                inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
                inputData.viewDirectionWS = viewDirWS;

                inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);

            // #ifdef _ADDITIONAL_LIGHTS_VERTEX
            //     inputData.fogCoord = InitializeInputDataFog(float4(input.positionWS, 1.0), input.fogFactorAndVertexLight.x);
            //     inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
            // #else
            //     inputData.fogCoord = InitializeInputDataFog(float4(input.positionWS, 1.0), input.fogFactor);
            // #endif

            // #if defined(DYNAMICLIGHTMAP_ON)
            //     inputData.bakedGI = SAMPLE_GI(input.staticLightmapUV, input.dynamicLightmapUV, input.vertexSH, inputData.normalWS);
            // #else
            //     inputData.bakedGI = SAMPLE_GI(input.staticLightmapUV, input.vertexSH, inputData.normalWS);
            // #endif

                inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
                inputData.shadowMask = SAMPLE_SHADOWMASK(input.staticLightmapUV);

                #if defined(DEBUG_DISPLAY)
                #if defined(DYNAMICLIGHTMAP_ON)
                    inputData.dynamicLightmapUV = input.dynamicLightmapUV;
                #endif
                #if defined(LIGHTMAP_ON)
                    inputData.staticLightmapUV = input.staticLightmapUV;
                #else
                    inputData.vertexSH = input.vertexSH;
                #endif
                #endif
            }

            Varyings vert(Attributes input)
            {
                Varyings output = (Varyings)0;
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

                output.positionCS = vertexInput.positionCS;
                output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
                output.positionWS = vertexInput.positionWS;
                output.normalWS = normalInput.normalWS;

                real sign = input.tangentOS.w * GetOddNegativeScale();
                half4 tangentWS = half4(normalInput.tangentWS.xyz, sign);
                output.tangentWS = tangentWS;

                return output;
            }

            half4 frag(Varyings input): SV_Target 
            {
                SurfaceData surfaceData;
                InitializeStandardLitSurfaceData(input.uv, surfaceData);

                InputData inputData;
                InitializeInputData(input, surfaceData.normalTS, inputData);

                half4 color = UniversalFragmentPBR(inputData, surfaceData);
                color.rgb = MixFog(color.rgb, inputData.fogCoord);

                // // normal can not be adjuested on mobile platform
                // float sgn = input.tangentWS.w;      // should be either +1 or -1
                // float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                // half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                // half3 normalWS = TransformTangentToWorld(surfaceData.normalTS, tangentToWorld);

                // BRDFData brdfData;
                // InitializeBRDFData(surfaceData.albedo, surfaceData.metallic, surfaceData.specular, surfaceData.smoothness, surfaceData.alpha, brdfData);


                // half3 bakedGI = SampleSH(normalWS);

                // float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS); 
                // Light mainLight = GetMainLight(shadowCoord);
               
                // half4 color = half4(0, 0, 0, 1);                 
                // color.rgb = GlobalIllumination(brdfData, bakedGI, 1, normalWS, input.viewDirWS);
                // color.rgb += LightingPhysicallyBased(brdfData, mainLight, normalWS, input.viewDirWS);



                // shadowCoord is position in shadow light space
                // half3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                // float4 shadowCoord = TransformWorldToShadowCoord(positionWS); 
                // Light mainLight = GetMainLight(shadowCoord);

                // half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv) * _BaseColor;
                // color *= mainLight.shadowAttenuation;
                return color;
            }

            ENDHLSL
        }

        // Used for rendering shadowmaps
        // TODO: there's one issue with adding this UsePass here, it won't make this shader compatible with SRP Batcher
        // as the ShadowCaster pass from Lit shader is using a different UnityPerMaterial CBUFFER. 
        // Maybe we should add a DECLARE_PASS macro that allows to user to inform the UnityPerMaterial CBUFFER to use?
        UsePass "Universal Render Pipeline/Lit/ShadowCaster"
        UsePass "Universal Render Pipeline/Lit/DepthOnly"
	}
}