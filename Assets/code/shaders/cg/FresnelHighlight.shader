// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-15
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/FresnelHighlight"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 1.0) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125
		_FresnelFactor("Fresnel Factor", Range(0, 1))	= 0.5
		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}
	}

	// SubShader
	// {
	// 	Tags
	// 	{
	// 		"Queue"				="Geometry" 
	// 		"IgnoreProjector"	= "True"
	// 		"RenderType"		= "Opaque"
	// 	}

	// 	LOD	300

	// 	CGINCLUDE
	// 	#pragma exclude_renderers d3d11 xbox360
	// 	#pragma fragmentoption ARB_precision_hint_fastest

	// 	#include "../basic.cginc"

	// 	float4		_Color;
	// 	float		_Shininess;
	// 	float		_FresnelFactor;
	// 	sampler2D	_MainTex;
	// 	float4		_MainTex_ST;

	// 	struct v2f
	// 	{
	// 		float4	position	: POSITION;
	// 		float2	texcoord	: TEXCOORD0;
	// 		float3	worldPosition;
	// 		float3	worldNormal;
	// 	};

	// 	v2f vert(appdata_base input)
	// 	{
	// 		v2f output;
	// 		output.position		= UnityObjectToClipPos(input.vertex);
	// 		output.texcoord		= TRANSFORM_TEX(input.texcoord, _MainTex);
	// 		output.worldPosition= mul(unity_ObjectToWorld, input.vertex).xyz;
	// 		output.worldNormal	= normalize(UnityObjectToWorldNormal(input.normal));

	// 		return output;
	// 	}

	// 	float4 common_fragment(v2f input, bool usingAmbient)
	// 	{
	// 		// CREATE_LIGHTING_VARIABLES(input.worldPosition, input.worldNormal);
	// 		// float	dotNL		= dot(N, L);
	// 		// float4	diffuse		= 2.0 * _Color * (usingAmbient * UNITY_LIGHTMODEL_AMBIENT + attenuation * _LightColor0 * max(0, dotNL));
	// 		float4	diffuse		= float4(0);
	// 		float4	specular	= float4(0);
	// 		// if(dotNL > 0)
	// 		// {
	// 		// 	// float w	= pow(1.0 - max(0, dot(H, V)), 5);
	// 		// 	float w	= pow(1.0 - dot(H, V), _FresnelFactor * 10);
    //         //  	specular= attenuation * _LightColor0 * lerp(_SpecColor, 1.0, w) 
	// 		// 		* pow(max(0.0, dot(reflect(-L, N), V)), _Shininess * 128);
	// 		// }

	// 		float4	baseColor	= tex2D(_MainTex, input.texcoord);
	// 		float4	output		= baseColor * diffuse + specular;
	// 		// output.a			= 1.0;
	// 		return output;
	// 	}

	// 	ENDCG

	// 	Pass 
	// 	{
	// 		Name "FORWARDBASE"

	// 		Tags 	
	// 		{ 
	// 			"LightMode"	= "ForwardBase" // pass for 4 vertex lights, ambient light & first pixel light
	// 		}

	// 		Cull 	Back

	// 		CGPROGRAM
	// 		#pragma multi_compile_fwdbase 

	// 		#pragma vertex vert 
	// 		#pragma fragment frag

	// 		float4 frag(v2f input):COLOR
	// 		{
	// 			return common_fragment(input, true);
	// 		}

	// 		ENDCG
	// 	}

	// 	Pass 
	// 	{
	// 		Name "FORWARDADD"
	// 		Tags
	// 		{ 
	// 			"LightMode"	= "ForwardAdd" 
	// 		}

	// 		Cull 	Back
	// 		Blend	One	One

	// 		CGPROGRAM

	// 		#pragma vertex vert 
	// 		#pragma fragment frag

	// 		float4 frag(v2f input):COLOR
	// 		{
	// 			return common_fragment(input, false);
	// 		}

	// 		ENDCG
	// 	}
	// }

	Fallback Off
}
