// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-2-23
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "outline/SilhouetteEnhancement"
{
	Properties
	{
		_Color ("Main Color", Color)	= (1, 1, 1, 0.2) 
		_EdgeWidth("Edge Width", Range(0.1, 2))		= 1.0
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
			Blend		SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma exclude_renderers d3d11 xbox360
			#pragma exclude_renderers xbox360

			#pragma vertex vert 
			#pragma fragment frag 
			#include "UnityCG.cginc"

			half4		_Color;
			half		_EdgeWidth;

			struct v2f
			{
				float4	vertex			: SV_POSITION;
				float4	worldPosition	: TEXCOORD1;
				float3	worldNormal		: TEXCOORD2;
			};

			v2f vert(appdata_base input)
			{
				v2f output;
				output.vertex		= UnityObjectToClipPos(input.vertex);
				output.worldPosition= mul(unity_ObjectToWorld, input.vertex);
				output.worldNormal	= normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);

				return output;
			}

			half4 frag(v2f input): COLOR
			{
				float3	N		= normalize(input.worldNormal);
				float3	V		= normalize(_WorldSpaceCameraPos - input.worldPosition.xyz);

				// half alpha		= _Color.a / abs(dot(N, V));
				half alpha		= _Color.a / pow(dot(N, V), _EdgeWidth);
				half4 output	= half4(_Color.xyz, alpha);
				return output;
			}

			ENDCG
		}
	}

	Fallback Off
}
