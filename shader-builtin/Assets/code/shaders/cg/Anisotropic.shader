// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-02-15
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/Anisotropic"
{
	Properties
	{
		_Color ("Diffuse Material Color", Color)		= (1,1,1,1) 
      	_SpecColor ("Specular Material Color", Color)	= (1,1,1,1) 
      	_AlphaX ("Roughness in Brush Direction", Range(-1, 1))				= 1.0
      	_AlphaY ("Roughness orthogonal to Brush Direction", Range(-1, 1))	= 1.0
	}

	SubShader
	{
		Tags
		{
			"Queue"				= "Geometry" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Opaque"
		}

		LOD	300

		CGINCLUDE
		#pragma exclude_renderers d3d11 xbox360
		#pragma fragmentoption ARB_precision_hint_fastest

		#include "../basic.cginc"

		half4		_Color;
		half		_AlphaX;
		half		_AlphaY;

		struct v2f
		{
			float4	position		: POSITION;
			float3	worldPosition	: TEXCOORD0;
			float3	worldNormal 	: NORMAL;
			float3	worldTangent	: TANGENT;
		};

		v2f vert(appdata_tan input)
		{
			v2f output;
			output.position		= UnityObjectToClipPos(input.vertex);
			output.worldPosition= mul(unity_ObjectToWorld, input.vertex).xyz;
			output.worldNormal	= UnityObjectToWorldNormal(input.normal);
			output.worldTangent	= UnityObjectToWorldDir(input.tangent.xyz);

			return output;
		}

		half4 common_fragment(v2f input, bool usingAmbient)
		{
			CREATE_LIGHTING_VARIABLES(input.worldPosition, input.worldNormal);

			half3	B			= cross(input.worldNormal, input.worldTangent);
			half	dotNL		= dot(N, L);
			half4	diffuse		= 2.0 * _Color * (usingAmbient * UNITY_LIGHTMODEL_AMBIENT + attenuation * _LightColor0 * max(0, dotNL));

			half4	specular	= half4(0, 0, 0, 0); // 这个玩意现在只能支持4个参数了
			if(dotNL > 0)
			{
				half dotNH		= dot(N, H);
				half dotNV		= dot(N, V);
				half dotHTAlphaX= dot(H, input.worldTangent) / _AlphaX;
				half dotHBAlphaY= dot(H, V) / _AlphaY;
				specular		= 2.0 * _SpecColor * attenuation * sqrt(max(0, dotNL / dotNV)) * exp(-2.0 * (dotHTAlphaX * dotHTAlphaX + dotHBAlphaY * dotHBAlphaY) / (1.0 + dotNH));

			}

			half4	output		= diffuse + specular;
			output.a			= 1.0;
			return output;
		}

		ENDCG

		Pass 
		{
			Name "FORWARDBASE"

			Tags 	
			{ 
				"LightMode"	= "ForwardBase" // pass for 4 vertex lights, ambient light & first pixel light
			}

			Cull 	Back

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag 

			half4 frag(v2f input): COLOR
			{
				return common_fragment(input, true);
			}

			ENDCG
		}

		Pass 
		{
			Name "FORWARDADD"
			Tags
			{ 
				"LightMode"	= "ForwardAdd" 
			}

			Cull 	Back
			Blend	One	One

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			half4 frag(v2f input): COLOR
			{
				return common_fragment(input, false);
			}

			ENDCG
		}
	}

	Fallback Off
}
