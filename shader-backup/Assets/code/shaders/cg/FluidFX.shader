// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-02-26
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/FluidFX"
{
	Properties
	{
		_Color ("Main Color", Color)		= (0.5, 0.5, 0.5, 0.5) 
		_MainTex("Base (RGB) Alpha(A)", 2D)	= "white" {}

		_FluidColor1("Fluid Color 1", Color)= (1.0, 0.0, 0.0, 0.5) 
		_FluidColor2("Fluid Color 2", Color)= (0.0, 0.0, 1.0, 0.5) 
		_FluidTex("Fluid Texture(RGBA)", 2D)= "white" {}

		_FluidSpeedX("Fluid Speed X", Float)= 1.0
		_FluidSpeedZ("Fluid Speed Z", Float)= 1.0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"				= "Transparent" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Transparent"
		}
		
		// Pass { ColorMask 0 Cull	Back ZWrite	On }

		Pass 
		{
			Lighting	Off
			Cull 		Off
			ZWrite		Off
			ZTest		LEqual
			Blend		SrcAlpha	OneMinusSrcAlpha

			Fog { Mode Off }

			CGPROGRAM
			#pragma exclude_renderers d3d11 xbox360
			#pragma fragmentoption ARB_precision_hint_fastest

			#pragma vertex vert 
			#pragma fragment frag 

			#include "UnityCG.cginc"

			half4		_Color;
			half4		_FluidColor1;
			half4		_FluidColor2;

			sampler2D	_MainTex;
			float4		_MainTex_ST;
			sampler2D	_FluidTex;
			float4		_FluidTex_ST;

			half		_FluidSpeedX;
			half		_FluidSpeedZ;

			struct v2f
			{
				float4	position	: POSITION;
				float2	texcoord	: TEXCOORD0;
			};

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position		= UnityObjectToClipPos(input.vertex);
				output.texcoord		= TRANSFORM_TEX(input.texcoord, _MainTex);

				return output;
			}

			half4 frag(v2f input): COLOR
			{
				half4	baseColor	= 2.0 * _Color * tex2D(_MainTex, input.texcoord);

				half2	offset		= half2(_FluidSpeedX, _FluidSpeedZ) * _SinTime;
				half2	texcoord	= half2(input.texcoord + offset + baseColor.xy + baseColor.zw);
				half	mask		= tex2D(_FluidTex, texcoord).a;
				half4	fluidColor	= lerp(_FluidColor1 * _FluidColor1.a * 2.0, _FluidColor2 * _FluidColor2.a * 2.0, mask);

				half4	output		= baseColor;
				output.rgb			+= fluidColor.rgb;
				output.a			= 0.1 + lerp(0, 0.9, output.a);

				return output;
			}

			ENDCG
		}
	}

	Fallback Off
}
