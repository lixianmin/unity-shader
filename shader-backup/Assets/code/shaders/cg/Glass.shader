// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cg/Glass"
{
	Properties
	{
		_Color ("Main Color", Color)	= (0.5, 0.5, 0.5, 0.5) 
		_MainTex("Main Texture", 2D)	= "white" {}
	}

	CGINCLUDE
	#pragma exclude_renderers d3d11 xbox360
	#pragma fragmentoption ARB_precision_hint_fastest

	#include "UnityCG.cginc"

	struct v2f
	{
		float4 position	: POSITION;
		float2 texcoord	: TEXCOORD0;
	};

	half4		_Color;
	sampler2D	_MainTex;
	float4		_MainTex_ST;

	v2f vert(appdata_base input)
	{
		v2f output;
		output.position	= UnityObjectToClipPos(input.vertex);
		output.texcoord	= TRANSFORM_TEX(input.texcoord, _MainTex);
		return output;
	}

	half4 frag(v2f input): COLOR
	{
		half4 output	= 2.0 * _Color * tex2D(_MainTex, input.texcoord);
		return output;
	}

	ENDCG

	SubShader
	{
		Tags { "Queue"="Transparent" }

		Blend	SrcAlpha OneMinusSrcAlpha
		ZWrite	Off

		Pass 
		{
			Cull Front

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 
			ENDCG
		}

		Pass 
		{
			Cull Back 

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 
			ENDCG
		}
	}

	Fallback Off
}
