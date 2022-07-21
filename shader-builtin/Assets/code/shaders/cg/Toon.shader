// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-08
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/Toon"
{
	Properties
	{
		_Color ("Diffuse Color", Color)				= (1,1,1,1) 
		_UnlitColor ("Unlit Diffuse Color", Color)	= (0.5,0.5,0.5,1) 
		_DiffuseThreshold ("Threshold for Diffuse Colors", Range(0,1))	= 0.1 
		_OutlineColor ("Outline Color", Color)		= (0,0,0,1)
		_LitOutlineThickness ("Lit Outline Thickness", Range(0,1))		= 0.1
		_UnlitOutlineThickness ("Unlit Outline Thickness", Range(0,1))	= 0.4

		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 0.5) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125
	}

	// SubShader 
	// {
	// 	CGINCLUDE

	// 	#include "../basic.cginc"

	// 	float4	_Color; 
	// 	float4	_UnlitColor;
	// 	float	_DiffuseThreshold;
	// 	float4	_OutlineColor;
	// 	float	_LitOutlineThickness;
	// 	float	_UnlitOutlineThickness;
	// 	half	_Shininess;

	// 	struct v2f
	// 	{
	// 		float4 position		: SV_POSITION;
	// 		float3 worldPosition: TEXCOORD0;
	// 		float3 worldNormal	: TEXCOORD1;
	// 	};

	// 	v2f vert(appdata_base input) 
	// 	{
	// 		v2f output;

	// 		output.position		= UnityObjectToClipPos(input.vertex);
	// 		// output.worldPosition= mul(unity_ObjectToWorld, input.vertex).xyz;
	// 		// output.worldNormal	= normalize(float3(mul(float4(input.normal, 0), unity_WorldToObject)));
	// 		output.worldPosition= mul(unity_ObjectToWorld, input.vertex).xyz;
	// 		output.worldNormal	= normalize(UnityObjectToWorldNormal(input.normal));

	// 		return output;
	// 	}

	// 	ENDCG
	// 	Pass 
	// 	{      
	// 		Tags { "LightMode" = "ForwardBase" } 
	// 		// pass for ambient light and first light source

	// 		CGPROGRAM

	// 		#pragma vertex vert  
	// 		#pragma fragment frag 
		
	// 		float4 frag(v2f input) : COLOR
	// 		{
	// 			CREATE_LIGHTING_VARIABLES(input.worldPosition, input.worldNormal);
	// 			half4	lighting	= lit(dot(N, L), dot(N, H), _Shininess * 128.0); 

	// 			// default: unlit 
	// 			float3 fragmentColor= float3(_UnlitColor); 

	// 			// low priority: diffuse illumination
	// 			if (attenuation * lighting.y >= _DiffuseThreshold)
	// 			{
	// 				fragmentColor	= float3(_LightColor0) * float3(_Color); 
	// 			}

	// 			// higher priority: outline
	// 			if (dot(N, V) < lerp(_UnlitOutlineThickness, _LitOutlineThickness, lighting.y))
	// 			{
	// 				fragmentColor	= float3(_LightColor0) * float3(_OutlineColor); 
	// 			}

	// 			// highest priority: highlights
	// 			// dot(N, L) > 0.0 // light source on the right side? 这个在lit()方法中会做测试

	// 			if (attenuation *  lighting.z > 0.5) // more than half highlight intensity? 
	// 			{
	// 				fragmentColor = _SpecColor.a * float3(_LightColor0) * float3(_SpecColor) + (1.0 - _SpecColor.a) * fragmentColor;
	// 			}

	// 			return float4(fragmentColor, 1.0);
	// 		}

	// 		ENDCG
	// 	}

	// 	Pass 
	// 	{      
	// 		Tags { "LightMode" = "ForwardAdd" } 
	// 		// pass for additional light sources
	// 		Blend SrcAlpha OneMinusSrcAlpha 
	// 		// blend specular highlights over framebuffer

	// 		CGPROGRAM

	// 		#pragma vertex vert  
	// 		#pragma fragment frag 
		
	// 		float4 frag(v2f input) : COLOR
	// 		{
	// 			CREATE_LIGHTING_VARIABLES(input.worldPosition, input.worldNormal);
	// 			half4	lighting	= lit(dot(N, L), dot(N, H), _Shininess * 128.0); 
			
	// 			float4 fragmentColor= float4(0);
	// 			if (attenuation *  lighting.z > 0.5) // more than half highlight intensity? 
	// 			{
	// 				fragmentColor	= float4(_LightColor0.rgb, 1.0) * _SpecColor;
	// 			}

	// 			return fragmentColor;
	// 		}

	// 		ENDCG
	// 	}
	// }

	Fallback Off
}
