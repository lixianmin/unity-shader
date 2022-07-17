
/****************************************************************************
created:	2022-07-15
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

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
            float2 texcoord     : TEXCOORD0;
            float4 T2W0         : TEXCOORD1;
            float4 T2W1         : TEXCOORD2;
            float4 T2W2         : TEXCOORD3;
            SHADOW_COORDS(4)    // 保存阴影坐标, 其中4是TEXCOORD4的意思
        };

        half4 	    _Color;
        sampler2D 	_MainTex;
        float4		_MainTex_ST;

        half		_Bumpiness;
		sampler2D 	_Normal;

        half4       _Specular;
        half        _Gloss;

        // float3x3 fetchTagentTransform(float3 normalDir, float3 tangentDir)
        // {
        //     normalDir = normalize(normalDir);
        //     tangentDir = normalize(tangentDir - dot(tangentDir, normalDir) * normalDir);
            
        //     float3 binormalDir = normalize(cross(normalDir, tangentDir));
        //     float3x3 tangentTransform = float3x3(tangentDir, binormalDir, normalDir);

        //     return tangentTransform;
        // }

        Varyings vert(Attributes input)
        {
            Varyings output;
            output.positionCS = UnityObjectToClipPos(input.vertex);
            output.texcoord = TRANSFORM_TEX(input.texcoord, _MainTex);

            // 在vert()中计算切换变换矩阵, 参考《Unity Shader入门精要》P810
            // https://www.cnblogs.com/kekec/p/15799843.html
            // http://imgtec.eetrend.com/d6-imgtec/blog/2018-12/19314.html
            float3 positionWS = mul(unity_ObjectToWorld, input.vertex);
            half3 normalWS = UnityObjectToWorldNormal(input.normal);    // 已标准化
            half3 tangentWS = UnityObjectToWorldDir(input.tangent);     // 已标准化
            half3 binormalWS = cross(normalWS, tangentWS) * input.tangent.w;

            output.T2W0 = float4(tangentWS.x, binormalWS.x, normalWS.x, positionWS.x);
            output.T2W1 = float4(tangentWS.y, binormalWS.y, normalWS.y, positionWS.y);
            output.T2W2 = float4(tangentWS.z, binormalWS.z, normalWS.z, positionWS.z);

            // cd /Applications/Unity/Hub/Editor/2022.1.7f1c1/Unity.app/Contents/CGIncludes
            Attributes v = input;   // TRANSFER_SHADOW宏要求必须有v.vertex的定义
            TRANSFER_SHADOW(output)
            return output;
        }

        half4 frag(Varyings input) : SV_Target
        {
            float3 positionWS = float4(input.T2W0.w, input.T2W1.w, input.T2W2.w, 1);
            half3 lightDirWS = normalize(UnityWorldSpaceLightDir(positionWS));
            half3 viewDirWS = normalize(UnityWorldSpaceViewDir(positionWS)); 
            
            // Unity标准库中定义了两个功能相同的方法 UnpackNormalWithScale(UnityCG.cginc)与UnpackScaleNormal(UnityStandardUtils.cginc)
            half3 bump = UnpackNormalWithScale(tex2D(_Normal, input.texcoord.xy), _Bumpiness);
            half3 normalWS = normalize(half3(dot(input.T2W0.xyz, bump), dot(input.T2W1.xyz, bump), dot(input.T2W2.xyz, bump)));

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
            Name "FORWARDBASE"
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
            Name "FORWARDADD"
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

	Fallback "Mobile/Diffuse"
}