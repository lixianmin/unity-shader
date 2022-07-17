// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-04-17
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/Wave"
{
	Properties 
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 1.0) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125
		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}

		_WaveHeight("Wave Height", Range(0, 1.0))	= 0.1
		_Speed("Wave speed", Range(0, 5))			= 1.0
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

		float		_WaveHeight;
		float		_Speed;

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
			output.texcoord	= TRANSFORM_TEX(input.texcoord, _MainTex);

			float thisX		= input.vertex.x;
			float thisZ		= input.vertex.z;
			float sinFactor, cosFactor;
			sincos((thisX * thisX + thisZ * thisZ) + (_Time.y * _Speed), sinFactor, cosFactor);

			float4 vertex		= input.vertex;
			vertex.y			+= _WaveHeight * sinFactor;
			float deltaFactor	= _WaveHeight * cosFactor;

			float3 xTangent		= float3(0.0, 1.0, deltaFactor * vertex.y);
			float3 zTangent 	= float3(1.0, deltaFactor * vertex.x, 0.0);
			float3 normal		= normalize(cross(xTangent, zTangent));

			output.position		= UnityObjectToClipPos(vertex);
			output.worldPosition= mul(unity_ObjectToWorld, vertex);
			output.worldNormal	= normalize(mul(float4(normal, 0.0), unity_WorldToObject).xyz);

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

	// Fallback "Diffuse"
}
