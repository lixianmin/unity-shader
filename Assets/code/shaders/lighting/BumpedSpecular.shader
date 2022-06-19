// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-2-28
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "lighting/BumpedSpecular"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 1.0) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125

		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}
		_BumpMap("Normal Map", 2D)		 			= "bump" {}
	}

	SubShader
	{
		Tags
		{
			"Queue"				="Geometry" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Opaque"
		}

		LOD	200

		CGINCLUDE

		#include "../basic.cginc"

		half4		_Color;
		half		_Shininess;
		sampler2D	_MainTex;
		float4		_MainTex_ST;
		sampler2D	_BumpMap;
		float4		_BumpMap_ST;

		struct v2f
		{
			float4	position	: POSITION;
			float2	texcoord	: TEXCOORD0;
			float4	worldPosition	: TEXCOORD1;
			float3	worldNormal		: TEXCOORD2;
			float3	worldTangent	: TEXCOORD3;
			float3	worldBinormal	: TEXCOORD4;
		};

		v2f vert(appdata_tan input)
		{
			v2f output;
			output.position		= UnityObjectToClipPos(input.vertex);
			output.texcoord		= TRANSFORM_TEX(input.texcoord, _MainTex);
			output.worldPosition= mul(unity_ObjectToWorld, input.vertex);
			output.worldNormal	= normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);

			output.worldTangent	= normalize(mul(unity_ObjectToWorld, float4(input.tangent.xyz, 0.0)).xyz);
			output.worldBinormal= normalize(cross(output.worldNormal, output.worldTangent) * input.tangent.w); // tangent.w is specific to Unity
			return output;
		}

		half4 common_fragment(v2f input, half usingAmbient)
		{
			float3x3 local2WorldTranspose = float3x3(input.worldTangent, input.worldBinormal, input.worldNormal);
			float3	encodedNormal	= normalize(mul(UnpackNormal(tex2D(_BumpMap, input.texcoord)), local2WorldTranspose));

			CREATE_LIGHTING_VARIABLES(input.worldPosition, encodedNormal);
			half4	lighting	= lit(dot(N, L), dot(N, H), _Shininess * 128.0); 
			half4	diffuse		= 2.0 * _Color * (usingAmbient * UNITY_LIGHTMODEL_AMBIENT + attenuation * _LightColor0 * lighting.y);
			half4	specular	= 2.0 * _SpecColor * attenuation * _LightColor0 * lighting.z;

			half4	baseColor	= tex2D(_MainTex, input.texcoord);
			half4	output		= baseColor * diffuse + specular;
			// output.a	= 1.0;
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
			
			half4 frag(v2f input): COLOR
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

			half4 frag(v2f input): COLOR
			{
				half usingAmbient	= 0.0;
				return common_fragment(input, usingAmbient);
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}
