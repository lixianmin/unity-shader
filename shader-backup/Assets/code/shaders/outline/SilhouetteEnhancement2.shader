// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-02-09
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "outline/SilhouetteEnhancement2"
{
	Properties
	{
		_RimColor("Rim Color", Color)			= (.26, .19, .16, 0)
		_RimPower("Rim Power", Float)			= 3.0
	}

	SubShader
	{
		Tags 
		{ 
			"Queue"				= "Transparent" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Transparent"
		}

		LOD	200
		Fog { Mode Off }

		Pass
		{
			ColorMask	0
			Cull		Back
		}

		Pass 
		{
			Cull 		Back
			Lighting	Off
			ZWrite		Off
			Blend		SrcAlpha	OneMinusSrcAlpha

			CGPROGRAM
			#pragma exclude_renderers d3d11 xbox360
			#pragma fragmentoption ARB_precision_hint_fastest

			#pragma vertex vert 
			#pragma fragment frag

			#include "../basic.cginc"

			half4		_RimColor;
			half		_RimPower;

			struct v2f
			{
				float4	position		: SV_POSITION;
				float4	worldPosition	: TEXCOORD1;
				float3	worldNormal		: TEXCOORD2;
			};

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position		= UnityObjectToClipPos(input.vertex);
				output.worldPosition= mul(unity_ObjectToWorld, input.vertex);
				output.worldNormal	= normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);

				return output;
			}

			half4 frag(v2f input): COLOR
			{
				half4	output	= half4(0, 0, 0, 0);

				half3	N		= normalize(input.worldNormal);
				half3	V		= normalize(_WorldSpaceCameraPos - input.worldPosition.xyz);

				half	rim		= 1.0 - saturate(dot(N, V));
				output.rgb		= _RimColor.rgb * pow(rim, _RimPower);
				output.a		= rim;

				return output;
			}

			ENDCG
		}
	}

	Fallback Off
}
