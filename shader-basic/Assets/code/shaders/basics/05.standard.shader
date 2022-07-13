
Shader "basics/05.standard"
{
	Properties
	{
		_Color ("Color", Color) = (1, 1, 1, 1)		
        _MainTex ("Main Texture (RGB)", 2D) = "white" {}

		_Bumpiness ("Bumpiness", Range(-2, 2)) = 1				// 法线强度, 缩放凹凸
		[NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}		// 法线贴图

        _Specular("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8, 256)) = 20
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
                float4 vertex       : POSITION;
                float3 normalOS     : NORMAL;
                float4 tangentOS    : TANGENT;
                float2 texcoord     : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS	: SV_POSITION;
                float4 positionOS   : TEXCOORD0;
                float2 texcoord     : TEXCOORD1;
                SHADOW_COORDS(2)    // 保存阴影坐标, 其中2是TEXCOORD2的意思
            };

            half4 	    _Color;
            sampler2D 	_MainTex;
            float4		_MainTex_ST;

            half4       _Specular;
            half        _Gloss;

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = UnityObjectToClipPos(input.vertex);
                output.positionOS = input.vertex;
                output.texcoord = TRANSFORM_TEX(input.texcoord, _MainTex);

                // cd /Applications/Unity/Hub/Editor/2022.1.7f1c1/Unity.app/Contents/CGIncludes
                Attributes v = input;   // TRANSFER_SHADOW宏要求必须有v.vertex的定义
                TRANSFER_SHADOW(output)
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                half4 positionWS = mul(unity_ObjectToWorld, input.positionOS);
                half3 normalWS = UnityObjectToWorldNormal(input.positionOS);    // 已标准化

                half3 lightDirWS = normalize(UnityWorldSpaceLightDir(positionWS));
                half3 viewDirWS = normalize(UnityWorldSpaceViewDir(positionWS));

                // diffuse: NL
                half4 albedo = _Color * tex2D(_MainTex, input.texcoord);
                half NL = dot(normalWS, lightDirWS);
                half4 diffuse = _LightColor0 * albedo * saturate(NL);

                // specuarl: NH
                half3 H = normalize(lightDirWS + viewDirWS);
                half NH = dot(normalWS, H);
                half4 specular = _LightColor0 * _Specular * pow(saturate(NH), _Gloss);
                
                // 环境光: Window->Rendering->Lighting->Environment->Source->Gradient
                half4 color = unity_AmbientSky * albedo;
                color += diffuse + specular;

                // 补4个点光源
                color.rgb += Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                            unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[4].rgb,
                            unity_4LightAtten0, positionWS.rgb, normalWS) * _Color;

                return color;
            }

            ENDCG
        }
	}

	Fallback "Diffuse"
}