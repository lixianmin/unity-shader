
Shader "basics/05.standard"
{
	Properties
	{
		_Color ("Color", Color) = (1, 1, 1, 1)		
        _MainTex ("Main Texture (RGB)", 2D) = "white" {}

		_Bumpiness ("Bumpiness", Range(-2, 2)) = 1				// 法线强度, 缩放凹凸
		[NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}		// 法线贴图

        _Specular("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Shininess", Range(0.01, 1)) = 0.078125
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry" }
		Cull Back

        CGINCLUDE

        #include "UnityCG.cginc"
        #include "Lighting.cginc"
        #include "AutoLight.cginc"
        
        struct Attributes
        {
            float4 vertex       : POSITION;
            float3 normal       : NORMAL;
            float4 tangent      : TANGENT;  // tangent.w决定在切线空间中binormal的方向
            float2 texcoord     : TEXCOORD0;
        };

        struct Varyings
        {
            float4 positionCS	: SV_POSITION;
            float4 positionOS   : TEXCOORD0;
            float3 normalWS     : TEXCOORD1;
            float3 tangentWS    : TEXCOORD2;
            float2 texcoord     : TEXCOORD3;
            SHADOW_COORDS(4)    // 保存阴影坐标, 其中2是TEXCOORD2的意思
        };

        half4 	    _Color;
        sampler2D 	_MainTex;
        float4		_MainTex_ST;

        half		_Bumpiness;
		sampler2D 	_Normal;

        half4       _Specular;
        half        _Gloss;

        float3x3 fetchTagentTransform(float3 normalDir, float3 tangentDir)
        {
            normalDir = normalize(normalDir);
            tangentDir = normalize(tangentDir - dot(tangentDir, normalDir) * normalDir);
            
            float3 binormalDir = normalize(cross(normalDir, tangentDir));
            float3x3 tangentTransform = float3x3(tangentDir, binormalDir, normalDir);

            return tangentTransform;
        }

        Varyings vert(Attributes input)
        {
            Varyings output;
            output.positionCS = UnityObjectToClipPos(input.vertex);
            output.positionOS = input.vertex;
            output.normalWS = UnityObjectToWorldNormal(input.normal);    // 已标准化
            output.tangentWS = UnityObjectToWorldDir(input.tangent);
            output.texcoord = TRANSFORM_TEX(input.texcoord, _MainTex);

            // cd /Applications/Unity/Hub/Editor/2022.1.7f1c1/Unity.app/Contents/CGIncludes
            Attributes v = input;   // TRANSFER_SHADOW宏要求必须有v.vertex的定义
            TRANSFER_SHADOW(output)
            return output;
        }

        half4 frag(Varyings input) : SV_Target
        {
            half4 positionWS = mul(unity_ObjectToWorld, input.positionOS);
            
            half3 normalLocal = UnpackScaleNormal(tex2D(_Normal, input.texcoord), _Bumpiness);
            half3 normalWS = normalize(mul(normalLocal, fetchTagentTransform(input.normalWS, input.tangentWS)));

            half3 lightDirWS = normalize(UnityWorldSpaceLightDir(positionWS));
            half3 viewDirWS = normalize(UnityWorldSpaceViewDir(positionWS));

            // diffuse: NL
            half4 albedo = _Color * tex2D(_MainTex, input.texcoord);
            half NL = dot(normalWS, lightDirWS);
            half4 diffuse = _LightColor0 * albedo * saturate(NL);

            // specuarl: NH
            half3 H = normalize(lightDirWS + viewDirWS);
            half NH = dot(normalWS, H);
            half4 specular = _LightColor0 * _Specular * pow(saturate(NH), _Gloss * 128);
            
            // 环境光: Window->Rendering->Lighting->Environment->Source->Gradient
            half4 color = unity_AmbientSky * albedo;
            half4 lightShade = diffuse + specular;

            // 补4个点光源
            lightShade.rgb += Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                        unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[4].rgb,
                        unity_4LightAtten0, positionWS.rgb, normalWS) * _Color;

            // 使用预定义宏计算阴影系数
            UNITY_LIGHT_ATTENUATION(shadowmask, input, positionWS.rgb)
            lightShade.rgb *= shadowmask;    // 阴影合成, 身上会因此有自阴影
            color += lightShade;

            return color;
        }

        ENDCG

        Pass
        {
            Tags{ "LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase   // 为不同的灯光编译不同的pass, 比如顶点灯, 象素灯
            
            ENDCG
        }

        Pass
        {
            Tags{ "LightMode"="ForwardAdd"}
            ZWrite Off
            Blend One One   // 开启blend, 否则会替换掉面的pass

            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows   // 开始shadows? 

            ENDCG
        }
	}

	Fallback "Diffuse"
}