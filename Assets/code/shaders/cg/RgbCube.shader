// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-14
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/RgbCube"
{
	SubShader
	{
		Pass 
		{
			Cull 	Back

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag 

			#include "../basic.cginc"

			struct v2f
			{
				float4	position	: POSITION;
				half4	color;
			};

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position	= UnityObjectToClipPos(input.vertex);
				output.color	= input.vertex + half4(0.5, 0.5, 0.5, 0);
				// output.color	= 0.5 * (sin(input.vertex) + half4(1, 1, 1, 1));
				return output;
			}

			half4 frag(v2f input): COLOR
			{
				return input.color;
			}

			ENDCG
		}
	}

	Fallback Off
}
