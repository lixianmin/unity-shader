
Shader "basics/05.standard"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)		
        _MainTex ("Main Texture (RGB)", 2D) = "white" {}
		_Bumpiness ("Bumpiness", Range(-2, 2)) = 1				// 法线强度, 缩放凹凸
		[NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}		// 法线贴图
        _Gloss ("Shineness", Range(0.1,10)) = 4
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry"  "LightMode"="ForwardBase"}
		Cull Back

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase   // 为不同的灯光编译不同的pass, 比如顶点灯, 象素灯
            
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
        
            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float4 tangentOS    : TANGENT;
                float2 texcoord     : TEXCOORD0;
            }

            struct Varyings
            {
                float4 positionCS	: SV_POSITION;
                float4 positionOS   : TEXCOORD0;
                SHADOW_COORDS(2)    // 保存阴影坐标, 其中2是TEXCOORD2的意思
            };

            half4 	_Color;
            half 	_MainTex;
            half    _Gloss;

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = UnityObjectToClipPos(input.positionOS);
                output.positionOS = input.positionOS;
                // o.viewDir = normalize(WorldSpaceViewDir(v.vertex));

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                half4 positionWS = UnityObjectToWorldPos(input.positionOS);
                half3 normalWS = UnityObjectToWorldNormal(input.positionOS);    // 已标准化

                half3 lightDirWS = normalize(WorldSpaceLightDir(input.positionOS));
                half3 viewDirWS = normalize(WorldSpaceViewDir(input.positionOS));

                // NL
                half3 diffuse = _LightColor0 * _MainTex * saturate(dot(normalWS, lightDirWS));

                // NH
                half3 halfDirWS = normalize(lightDirWS + viewDirWS);
                half3 specular = _LightColor0 * _MainTex * pow(saturate(normalWS, halfDirWS), _Gloss);
                

                half4 color;
                color.rgb = untiy_AmbientSky + diffuse + specular;
                color.a = 1;

                return color;
            }

            ENDCG
        }
	}

	Fallback "Diffuse"
}