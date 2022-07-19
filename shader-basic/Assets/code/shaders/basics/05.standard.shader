
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

        // N    normalWS
        // L    lightDirWS
        // V    viewDirWS
        // H    normalize(N+V)
        half4 inner_frag(Varyings input, half using_ambient)
        {
            float3 positionWS = float4(input.T2W0.w, input.T2W1.w, input.T2W2.w, 1);
            half3 L = normalize(UnityWorldSpaceLightDir(positionWS));
            half3 V = normalize(UnityWorldSpaceViewDir(positionWS)); 
            
            // Unity标准库中定义了两个功能相同的方法 UnpackNormalWithScale(UnityCG.cginc)与UnpackScaleNormal(UnityStandardUtils.cginc)
            half3 bump = UnpackNormalWithScale(tex2D(_Normal, input.texcoord.xy), _Bumpiness);
            half3 N = normalize(half3(dot(input.T2W0.xyz, bump), dot(input.T2W1.xyz, bump), dot(input.T2W2.xyz, bump)));

            // 计算光照相关参数 https://developer.download.nvidia.cn/cg/lit.html
            // float4 lit(float NdotL, float NdotH, float m)
            // {
            //   float specular = (NdotL > 0) ? pow(max(0.0, NdotH), m);
            //   return float4(1.0, max(0.0, NdotL), specular, 1.0);
            // }
            // half4 lighting = lit(dot(N, L), dot(N, normalize(L+V)), _Gloss * 128);
            half4 lighting = half4(1.0, max(0, dot(N, L)), pow(max(0, dot(N, normalize(L+V))), _Gloss * 128), 1.0);

            // diffuse: NL
            half4 albedo = _Color * tex2D(_MainTex, input.texcoord);
            half4 diffuse = _LightColor0 * albedo * lighting.y;

            // specuarl: NH
            half4 specular = _LightColor0 * _Specular * lighting.z;
            
            // 环境光: Window->Rendering->Lighting->Environment->Source->Gradient
            half4 color = using_ambient * unity_AmbientSky * albedo;
            half4 lightShade = diffuse + specular;

            // 补4个点光源
            lightShade.rgb += Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                        unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[4].rgb,
                        unity_4LightAtten0, positionWS.rgb, N) * _Color;

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
            // 1. ForwardBase会计算ambient, 最重要的方向光, 逐顶点/SH光源和lightmaps. 
            // 2. ForwardBase只执行一次
            // 3. 设置LightMode是为了通知unity3d设置相关的光影变量, 如_LightColor0, _WorldSpaceLightPos0等
            Tags{ "LightMode"="ForwardBase"} 

            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase   // 为不同的灯光编译不同的pass, 比如顶点灯, 象素灯
            
            half4 frag(Varyings input) : SV_Target
            {
                // ambient与emission只在ForwardBase中计算, 而在ForwardAdd中不考虑, 否则就重复算了2遍
                return inner_frag(input, 1);
            }

            ENDCG
        }

        Pass
        {
            Name "FORWARDADD"
            Tags{ "LightMode"="ForwardAdd"} // 不计算ambient, 计算额外的逐pixel光源, 每个pass对应一个光源
            ZWrite Off      // 深度缓冲
            Blend One One   // 颜色缓冲: 开启blend, 否则会替换掉前面pass写的颜色缓冲值
            // Blend SrcAlpha One   

            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            // #pragma multi_compile_fwdadd_fullshadows   // 开启shadow效果, 默认multi_compile_fwdadd不支持阴影效果

            // 去掉ForwardBase中 ambient, emission, 逐顶点光照, SH光照的部分. 并添加一些对不同光源类型的支持.
            half4 frag(Varyings input) : SV_Target
            {
                // return half4(0, 0, 0, 1);
                return inner_frag(input, 0);
            }

            ENDCG
        }
	}

    // 借用内置的shader中的 ShadowCaster 把物体的深度信息渲染到shadowmap或深度纹理中
	Fallback "Mobile/Diffuse"
}