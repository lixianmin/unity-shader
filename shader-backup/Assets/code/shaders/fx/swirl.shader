// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-05-12
author:		lixianmin

reference: http://glsl.heroku.com/e#7604.0
Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "fx/Swirl"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 

		_Speed("Speed", Range(0.01, 10.0))			= 1.0
		_Size("Size", Range(0.0, 1.0))				= 1.0
	}

	SubShader
	{
		Tags
		{
			"Queue"				= "Transparent" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Transparent"
		}

		LOD	200

		CGINCLUDE
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma target 3.0
		#pragma glsl

		#include "UnityCG.cginc"

		uniform half4		_Color;

		uniform float		_Speed;
		uniform float		_Size;

		struct v2f
		{
			float4	position		: SV_POSITION;
			float4	vertex			: TEXCOORD1;
		};

		ENDCG

		Pass 
		{
			Blend	SrcAlpha OneMinusSrcAlpha
			Cull 	Off
			ZTest	LEqual
			ZWrite	Off

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position		= UnityObjectToClipPos(input.vertex);
				output.vertex		= input.vertex;

				return output;
			}

			half4 frag(v2f input):COLOR
			{
				float2 coordinate	= float2(0.5 - input.vertex.x, 0.5 + input.vertex.y);
				half4 color		= half4(0.0, 0.0, 0.0, 0.0);
				float d			= coordinate.x ;
				float time		= _Time.y * _Speed;

				float x, y;
				for(int n=1; n<= 60; n++)
				{
					sincos(time*n*0.1, x, y);
					float factor= 2.0*d / n;
					x	*= factor;
					y	*= factor;

					float dist	= distance(coordinate, float2(0.5 + x, 0.5 + y)) /_Size;
					half c		= 0.01 * n/ pow(dist, 2.0);
					color.b		+= c;
					color.r		+= c;
					color.g		+= (color.r + color.g) / half(n);
				}

				half4 output;
				output.rgb	= 2.0 * _Color.rgb * color;
				output.a	= (output.r + output.g + output.b) / 3.0;
				// output.a	= dot(output.rgb, fixed3(0.22, 0.707, 0.071));
				// output.a	= (output.g - output.r);
				output.a	= pow(output.a, 1.2);
				// output.a	= 1.0;
				// clip(output.a - 0.1);


				return output;
			}

			ENDCG
		}
	}
}
