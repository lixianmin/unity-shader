// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cg/OrderIndependentBlending"
{
	Properties
	{
		_Color ("Main Color", Color)	= (0.5, 0.5, 0.5, 0.5) 
		_MainTex("Main Texture", 2D)	= "white" {}
	}

	SubShader
	{
		Tags { "Queue"="Transparent" }

		Cull	Off 
		ZWrite	Off

		Pass 
		{

			Blend	Zero	OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex	: POSITION;
				float4 color	: COLOR;
				float2 texcoord	: TEXCOORD0;
			};

			half4		_Color;
			sampler2D	_MainTex;
			float4		_MainTex_ST;

			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex	= UnityObjectToClipPos(v.vertex);
				o.texcoord	= TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			half4 frag(v2f i): COLOR
			{
				half4 output	= 2.0 * _Color * tex2D(_MainTex, i.texcoord);
				return output;
			}

			ENDCG
		}

		Pass 
		{
			Blend	SrcAlpha	One

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex	: POSITION;
				float4 color	: COLOR;
				float2 texcoord	: TEXCOORD0;
			};

			half4		_Color;
			sampler2D	_MainTex;
			float4		_MainTex_ST;

			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex	= UnityObjectToClipPos(v.vertex);
				o.texcoord	= TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			half4 frag(v2f i): COLOR
			{
				half4 output	= 2.0 * _Color * tex2D(_MainTex, i.texcoord);
				return output;
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}
