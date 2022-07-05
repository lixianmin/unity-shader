
/****************************************************************************
created:	2013-04-10
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/Billboard"
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
			"Queue"				= "Geometry" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Opaque"
		}

		LOD	200

		CGINCLUDE
		#pragma exclude_renderers d3d11 xbox360
		#pragma fragmentoption ARB_precision_hint_fastest

		#include "UnityCG.cginc"

		half4		_Color;
		sampler2D	_MainTex;

		struct v2f
		{
			float4	position		: SV_POSITION;
			float2	texcoord		: TEXCOORD0;
		};

		ENDCG

		Pass 
		{
			Cull 	Back

			CGPROGRAM
			#pragma glsl
			#pragma vertex vert 
			#pragma fragment frag

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position	= mul(UNITY_MATRIX_P, mul(UNITY_MATRIX_MV, float4(0.0, 0.0, 0.0, 1.0))
									  + float4(input.vertex.x, input.vertex.y, 0.0, 0.0));
				output.texcoord = float4(input.vertex.x + 0.5, input.vertex.y + 0.5, 0.0, 0.0);

				return output;
			}
		
			half4 frag(v2f input):COLOR
			{
				half4	baseColor	= tex2D(_MainTex, input.texcoord);
				half4	output		= 2.0 * _Color * baseColor;
				return output;
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}
