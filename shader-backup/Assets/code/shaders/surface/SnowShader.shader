// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'


/****************************************************************************
created:	2013-04-17
author:		lixianmin

reference: http://unitygems.com/noobs-guide-shaders-3-realistic-snow/

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "surface/SnowShader"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Bump ("Bump", 2D) = "bump" {}

		_SnowColor ("Snow Color", Color)			= (1.0,1.0,1.0,1.0)
		_SnowLevel ("Snow Level", Range(0, 1))		= 0.2
		_SnowDepth ("Snow Depth", Range(0, 1))		= 0.1
		_Wetness ("Wetness", Range(0, 1))			= 0.3
		_SnowDirection ("Snow Direction", Vector)	= (0, 1, 0)
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma target 3.0
		#pragma debug
		#pragma glsl
		#pragma surface surf BlinnPhong vertex:vert 

		sampler2D	_MainTex;
		sampler2D	_Bump;
		float		_SnowLevel;
		float4		_SnowColor;
		float4		_SnowDirection;
		float		_SnowDepth; 
		float		_Wetness;

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal; INTERNAL_DATA
		};

		void vert (inout appdata_full v) 
		{
			float3 snowDirection= normalize(mul(unity_WorldToObject, float4(_SnowDirection.xyz, 0))).xyz;
			half difference		= dot(v.normal, snowDirection) - (1.0 - 2.0 * _SnowLevel);

			if(difference >= 0)
			{
				v.vertex.xyz += normalize(v.normal + snowDirection) * _SnowDepth;
			}
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{ 
			half4 c		= tex2D (_MainTex, IN.uv_MainTex);
            o.Normal	= UnpackNormal (tex2D (_Bump, IN.uv_Bump));

			half difference	= dot(WorldNormalVector(IN, o.Normal), normalize(_SnowDirection.xyz)) - (1.0 - 2.0 * _SnowLevel);
            difference	= saturate(difference / _Wetness);
            o.Albedo	= lerp(c, _SnowColor.rgb, difference);
            o.Alpha		= c.a;
		}

		ENDCG
	} 

	FallBack "Diffuse"
}
