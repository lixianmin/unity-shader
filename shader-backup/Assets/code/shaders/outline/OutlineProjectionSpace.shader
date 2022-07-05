// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-09
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/OutlineProjectionSpace"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 1.0) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125
		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}

		_OutlineColor("Outline Color", Color)		= (1, 1, 1, 1)
		_ExtrutionAmount("Extrution Amount", Range(0, 0.05))	= 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"				= "Transparent" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Transparent"
		}

		LOD 200

		Pass 
		{
			Cull	Front
			ZWrite	Off
			Blend	SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma exclude_renderers d3d11 xbox360
			#pragma fragmentoption ARB_precision_hint_fastest

			#pragma vertex vert 
			#pragma fragment frag

			#include "../basic.cginc"

			half4		_OutlineColor;
			half		_ExtrutionAmount;

			struct v2f
			{
				float4	position	: POSITION;
			};

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position		= UnityObjectToClipPos(input.vertex);

				half3 normalView	= mul((float3x3)UNITY_MATRIX_IT_MV, input.normal);
				// half2 offset		= TransformViewToProjection(normalView.xy);
				half2 offset		= half2(UNITY_MATRIX_P[0][0] * normalView.x, UNITY_MATRIX_P[1][1] * normalView.y);
				output.position.xy	+= offset * output.position.z * _ExtrutionAmount;

				return output;

			}

			half4 frag(v2f input): COLOR
			{
				half4 output	= _OutlineColor; 
				return output;
			}

			ENDCG
		}

		UsePass "lighting/BlinnPhong/FORWARDBASE"
	}
}
