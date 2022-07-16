
/****************************************************************************
created:	2013-04-05
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "surfaces/rim"
{
	Properties
	{
		_MainTex("Base Texture", 2D)	= "white" {}

		_RimColor("Rim Color", Color)	= (.26, .19, .16, 0)
		_RimPower("Rim Power", Float)	= 3.0
	}

	SubShader
	{
		Tags
		{ 
			"RenderType"		= "Opaque"
			"IgnoreProjector"	= "True"
			"RenderType"		= "Opaque"
		}

		Cull Back

		CGPROGRAM
		#pragma surface surf BlinnPhong addshadow

		sampler2D	_MainTex;
		sampler2D	_BumpMap;

		float4		_RimColor;
		float		_RimPower;

		struct Input 
		{
			float2	uv_MainTex;
			float3	viewDir;
		};

		void surf(Input i, inout SurfaceOutput o)
		{
			o.Albedo	= tex2D(_MainTex, i.uv_MainTex).rgb;
			half rim	= 1.0 - saturate(dot(normalize(i.viewDir), o.Normal));
			o.Emission	= _RimColor.rgb * pow(rim, _RimPower);
		}

		ENDCG
	} 
}
