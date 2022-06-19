// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-02
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/Fresnel"
{
	Properties
	{
		_FresnelBias("Bias", Range(0, 1))			= 0.01
		_FresnelScale("Scale", Range(0, 1))			= 0.01
		_FresnelPower("Power", Range(0, 1))			= 0.01

		_EtaRatio("Eta Ratio(RGB)", Color)			= (0.1, 0.1, 0.1, 1.0)
		_Cube("Environment Map", CUBE)				= "_Skybox" { TexGen CubeReflect}
	}

	CGINCLUDE
	#pragma exclude_renderers d3d11 xbox360
	#pragma fragmentoption ARB_precision_hint_fastest

	#include "../basic.cginc"

	float		_FresnelBias;
	float		_FresnelScale;
	float		_FresnelPower;
	float4		_EtaRatio;
	samplerCUBE	_Cube;

	struct v2f
	{
		float4	position	: POSITION;
		float2	texcoord	: TEXCOORD0;
		float	reflectionFactor: TEXCOORD1;
		float3	worldReflection	: TEXCOORD2;
		float3	TRed		: TEXCOORD3;
		float3	TGreen		: TEXCOORD4;
		float3	TBlue		: TEXCOORD5;
	};

	v2f vert(appdata_base input)
	{
		v2f output;
		output.position	= UnityObjectToClipPos(input.vertex);

		float4	worldPosition	= mul(unity_ObjectToWorld, input.vertex);
		float3	N		= normalize(mul(float4(input.normal, 0), unity_WorldToObject).xyz);
		float3	I		= worldPosition.xyz - _WorldSpaceCameraPos;
		output.worldReflection	= reflect(I, N);

		output.TRed		= refract(I, N, _EtaRatio.x);
		output.TGreen	= refract(I, N, _EtaRatio.y);
		output.TBlue	= refract(I, N, _EtaRatio.z);
		output.reflectionFactor	= saturate(_FresnelBias + _FresnelScale * pow(1 + dot(I, N), _FresnelPower * 128.0 ));

		return output;
	}

	half4 frag(v2f input): COLOR
	{
		half4	reflectedColor	= texCUBE(_Cube, input.worldReflection);
		float4	refractedColor	= float4(texCUBE(_Cube, input.TRed).r, 
										 texCUBE(_Cube, input.TGreen).g,
										 texCUBE(_Cube, input.TBlue).b, 1.0);

		half4	output	= lerp(refractedColor, reflectedColor, input.reflectionFactor);
		return output;
	}

	ENDCG

	SubShader
	{
		Tags
		{
			"Queue"				= "Transparent" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Tansparent"
		}

		Lighting	Off
		LOD			200

		Pass 
		{
			Cull 	Front
			ZWrite	Off
			Blend	SrcAlpha	OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag 

			ENDCG
		}

		Pass 
		{
			Cull 	Back
			ZWrite	Off
			Blend	SrcAlpha	OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 

			ENDCG
		}

	}
}
