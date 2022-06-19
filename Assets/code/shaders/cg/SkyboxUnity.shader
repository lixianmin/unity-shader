// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-14
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/SkyboxUnity"
{
	Properties
	{
		_Cube("Skybox Environment Map", Cube)	= "white" {} 
	}

	SubShader
	{
		Tags
		{
			"Queue"	="Background" 
		}

		Pass 
		{
			CGPROGRAM
			#pragma exclude_renderers d3d11 xbox360
			#pragma fragmentoption ARB_precision_hint_fastest

			#pragma vertex vert 
			#pragma fragment frag 

			#include "UnityCG.cginc"

			struct v2f
			{
				float4	position	: POSITION;
				half4	texcoord;
			};

			samplerCUBE	_Cube;

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position	= UnityObjectToClipPos(input.vertex);
				output.texcoord	= input.texcoord;

				return output;
			}

			half4 frag(v2f input): COLOR
			{
				half4 output	= texCUBE(_Cube, input.texcoord);
				return output;
			}

			ENDCG
		}
	}

	Fallback Off
}
