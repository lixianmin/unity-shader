// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-2-28
author:		lixianmin

reference:	http://www.catalinzima.com/samples/rim-lighting
Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "lighting/Rim"
{
	Properties
	{
		_Color ("Main Color", Color)			= (0.5, 0.5, 0.5, 0.5) 
		_SpecColor("Specular Color", Color)		= (0.5, 0.5, 0.5, 0.5) 
		_Shininess ("Shininess", Range(0.01, 1))= 0.078125
		_MainTex ("Base (RGB) Gloss (A)", 2D) 	= "white" {}

		_RimColor("Rim Color", Color)			= (.26, .19, .16, 0)
		_RimPower("Rim Power", Float)			= 3.0
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

		Pass 
		{
			Name "FORWARDBASE"
			Tags 
			{ 
				"LightMode"		= "ForwardBase" // pass for 4 vertex lights, ambient light & first pixel light
			}

			Cull Back

			CGPROGRAM
			#pragma exclude_renderers d3d11 xbox360
			#pragma fragmentoption ARB_precision_hint_fastest

			#pragma glsl
			#pragma vertex vert 
			#pragma fragment frag

			#include "../basic.cginc"

			half4		_Color;
			half		_Shininess;
			sampler2D	_MainTex;
			float4		_MainTex_ST;

			half4		_RimColor;
			half		_RimPower;

			struct v2f
			{
				float4	position	: POSITION;
				float2	texcoord	: TEXCOORD0;
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

			half4 frag(v2f input): COLOR
			{
				CREATE_LIGHTING_VARIABLES(input.worldPosition, input.worldNormal);
				half4	lighting	= lit(dot(N, L), dot(N, H), _Shininess * 128.0); 
				half4	diffuse	= 2.0 * _Color * (UNITY_LIGHTMODEL_AMBIENT + attenuation * _LightColor0 * lighting.y);
				half4	specular= 2.0 * _SpecColor * attenuation * _LightColor0 * lighting.z;

				half4	baseColor	= tex2D(_MainTex, input.texcoord);
				half4	output	= baseColor * diffuse + specular;

				half	rim		= 1.0 - saturate(dot(N, V));
				output.rgb		+= _RimColor.rgb * pow(rim, _RimPower);
				output.a		= 1.0;
				return output;
			}

			ENDCG
		}

		UsePass "lighting/BlinnPhong/FORWARDADD"
	}

	Fallback "Diffuse"
}
