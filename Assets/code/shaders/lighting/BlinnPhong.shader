// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-02-23
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "lighting/BlinnPhong"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 1.0) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125
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

		#include "../basic.cginc"

		half4		_Color;
		half		_Shininess;
		sampler2D	_MainTex;
		float4		_MainTex_ST;

		struct v2f
		{
			float4	position		: SV_POSITION;
			float2	texcoord		: TEXCOORD0;
			float4	worldPosition	: TEXCOORD1;
			float3	worldNormal		: TEXCOORD2;
		};

		v2f vert(appdata_base input)
		{
			v2f output;
			output.position		= UnityObjectToClipPos(input.vertex);
			output.texcoord		= TRANSFORM_TEX(input.texcoord, _MainTex);
			output.worldPosition= mul(unity_ObjectToWorld, input.vertex);
			output.worldNormal	= normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);

			return output;
		}

		half4 common_fragment(v2f input, half usingAmbient)
		{
			CREATE_LIGHTING_VARIABLES(input.worldPosition, input.worldNormal);
			half4	lighting	= half4(1.0, max(0.0, dot(N, L)), pow(max(0, dot(N, H)), _Shininess * 128.0), 1.0);
			half4	diffuse		= 2.0 * _Color * (usingAmbient * UNITY_LIGHTMODEL_AMBIENT + attenuation * _LightColor0 * lighting.y);
			half4	specular	= 2.0 * _SpecColor * attenuation * _LightColor0 * lighting.z;
			
			half4	baseColor	= tex2D(_MainTex, input.texcoord);
			half4	output		= baseColor * diffuse + specular;
			// output.a			= 1.0;
			return output;
		}

		ENDCG

		Pass 
		{
			Name "FORWARDBASE"

			Tags
			{ 
				"LightMode"	= "ForwardBase"
			}

			Cull 	Back

			CGPROGRAM
			#pragma glsl
			#pragma vertex vert 
			#pragma fragment frag

			half4 frag(v2f input):COLOR
			{
				half usingAmbient	= 1.0;
				return common_fragment(input, usingAmbient);
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
			#pragma glsl
			#pragma vertex vert 
			#pragma fragment frag

			half4 frag(v2f input):COLOR
			{
				half usingAmbient	= 0.0;
				return common_fragment(input, usingAmbient);
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}
