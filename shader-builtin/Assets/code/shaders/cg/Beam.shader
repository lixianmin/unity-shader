// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-10-29
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/Beam"
{
	Properties 
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}
	}

	SubShader
	{
		Tags
		{
			"Queue"				= "Transparent" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Ransparent"
		}

		LOD	200

		CGINCLUDE
		#pragma exclude_renderers d3d11 xbox360
		#pragma fragmentoption ARB_precision_hint_fastest

		#include "UnityCG.cginc"

		half4		_Color;
		sampler2D	_MainTex;
		float4		_MainTex_ST;

		struct v2f
		{
			float4	position	: SV_POSITION;
			float2	texcoord	: TEXCOORD0;
		};

		ENDCG

		Pass 
		{
			Cull 	Off
			ZWrite	Off
			ZTest	LEqual
			Blend	SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma glsl
			#pragma vertex vert 
			#pragma fragment frag

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position		= UnityObjectToClipPos(input.vertex);
				output.texcoord		= TRANSFORM_TEX(input.texcoord, _MainTex);
				return output;
			}

			half4 frag(v2f input):COLOR
			{
				half4 output	= 2.0 * _Color * tex2D(_MainTex, input.texcoord);
				return output;
			}

			ENDCG
		}
	}
}
