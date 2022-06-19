// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-11
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/image/Outline"
{
	Properties
	{
		_Color("Outline Color", Color)	= (1, 1, 1, 1)
		_MainTex ("Source Texture from Graphics.Blit", 2D)		= "white" {}
		_ScreenTex("Screen Texture", 2D)= "white" {}
	}

	CGINCLUDE

	#include "UnityCG.cginc"
	#include "image_effect.cginc"
	#pragma exclude_renderers xbox360 gles

	half4		_Color;
	sampler2D	_MainTex;
	float4		_MainTex_TexelSize;
	sampler2D	_ScreenTex;

	struct v2f
	{
		float4 position : POSITION;
		float2 texcoord	: TEXCOORD0;
	};

	v2f vert(appdata_img input)
	{
		v2f output;
		output.position	= UnityObjectToClipPos(input.vertex);
		output.texcoord	= MultiplyUV(UNITY_MATRIX_TEXTURE0, input.texcoord);

		return output;
	}


	ENDCG

	SubShader
	{
		ZTest	Always
		Cull	Off
		ZWrite	Off
		Fog		{ Mode off }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			half4 frag(v2f input) : COLOR 
			{
				half edgeSquared= SobelFilter(_MainTex, input.texcoord, _MainTex_TexelSize);
				half isEdge		= edgeSquared > 0.07 * 0.07;
				half4 output	= isEdge ? _Color : half4(0);
				return output;
			}

			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			half4 frag(v2f input) : COLOR 
			{
				half4 outline	= tex2D(_MainTex, input.texcoord);
				half4 screen	= tex2D(_ScreenTex, input.texcoord);
				half4 output	= lerp(screen, outline, outline.a);

				return output;
			}

			ENDCG
		}
	}

	FallBack Off
}
