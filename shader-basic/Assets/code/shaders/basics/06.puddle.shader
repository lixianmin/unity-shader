
/****************************************************************************
created:	2022-07-15
author:		lixianmin

https://zhuanlan.zhihu.com/p/85182753  Shader效果：水果上蠕动的蛆虫——代码讲解篇

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "basics/06.puddle"
{
	Properties
	{
		[Header(Color Properties)]
		_MainTex ("Main Texture", 2D) = "gray" {}

		// 波纹属性
		[Space(20)]
		[Header(Ripple Properties)]
		_Normal ("Normal", 2D) = "bump" {}
		_NormalIntensity ("Normal Intensity", Range(0, 1)) = 0
		_NormalSpeedX ("Normal Speed X", Range(0,1)) = 0
		_NormalSpeedY ("Normal Speed Y", Range(0,1)) = 0

		// 水坑属性
		[Space(20]
		[Header(Puddle Properties)]
		[NoScaleOffset]_NormalMask ("Normal Mask", 2D) = "white" {}
		_Depth ("Depth", Range(-1, 1)) = 0

		// 反射属性
		[Space(20)]
		[Header(Reflection Properties)]
		[NoScaleOffset]_Cubemap ("Cubemap", Cube) = "" {}
		_Reflection ("Reflection", Range(0, 1)) = 0
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque"  "Queue" = "Geometry" }

        Pass 
        {


            CGPROGRAM
            
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            
            struct v2f
            {
                float4 pos              : SV_POSITION;
                float4 mainNormalCoord  : TEXCOORD0; // 颜色和法线的纹理坐标
                float2 maskCoord        : TEXCOORD1; // Mask的纹理坐标

                float4 worldPos         : TEXCOORD2; // 世界空间顶点坐标
                float3 worldNormal      : TEXCOORD3; // 世界空间法线坐标
            };

            sampler2D   _MainTex;
            float4      _MainTex_ST;

            sampler2D   _Normal;
            float4      _Normal_ST;
            fixed       _NormalIntensity;
            fixed       _NormalSpeedX;
            fixed       _NormalSpeedY;

            sampler2D   _NormalMask;
            fixed       _Depth;

            samplerCUBE _Cubemap;
            fixed       _Reflection;


            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex.xyz);

                // 计算贴图的纹理坐标
                o.mainNormalCoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.mainNormalCoord.zw = TRANSFORM_TEX(v.texcoord, _Normal);
                o.mainNormalCoord.zw += float2(_NormalSpeedX, _NormalSpeedY) * _Time.x; // 加入法线扰动
                o.maskCoord = v.texcoord.xy;    // mask坐标

                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // 计算法线强度
                half mask = tex2D(_NormalMask, i.maskCoord);
                half2 bump = UnpackNormalWithScale(tex2D(_Normal, i.mainNormalCoord.zw), _NormalIntensity * mask * 0.01);

                // 计算颜色
                float2 mainCoord = i.mainNormalCoord.xy + bump;
                half4 color = tex2D(_MainTex, mainCoord);
                color.rgb += (mask * _Depth);   // 调整一下颜色深度

                // 计算反射
                float3 viewDir = UnityWorldSpaceViewDir(i.worldPos.xyz);
                viewDir = normalize(viewDir);
                half3 refDir = reflect(-viewDir.xyz, i.worldNormal);
                half4 ref = texCUBE(_Cubemap, refDir);

                // 颜色与反射混合
                return lerp(color, ref, mask * _Reflection);
            }

            ENDCG
        }
    }
    // Fallback "Mobile/Diffuse"
}