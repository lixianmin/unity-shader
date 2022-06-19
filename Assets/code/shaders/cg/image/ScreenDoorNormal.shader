
/********************************************************************
created:	2012-08-20
author:		lixianmin

Copyright (C) - All Rights Reserved
 *********************************************************************/

Shader "ImageEffect/ScreenDoorNormal" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D)	= "white" {}
		_CloseRatio("Close Ratio", range(0, 0.5))	= 0
		_CloseColor("Close Color", color)	= (0, 0, 0, 1)
	}

	SubShader 
	{
		Cull		Off
		Lighting	Off
		ZWrite		Off
		ZTest		Always
		Fog			{ Mode Off }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			#include "UnityCG.cginc"

			sampler2D	_MainTex;
			half 		_CloseRatio;
			half4		_CloseColor;

			half4 frag (v2f_img i) : COLOR
			{
				half2	texcoord= i.uv;
				half4	output	= _CloseColor;
				if(texcoord.x > _CloseRatio && texcoord.x < 1 - _CloseRatio)
				{
					half4 baseColor	= tex2D(_MainTex, i.uv);
					output	= baseColor;
				}

				return output;
			}

			ENDCG
		}
	}

	Fallback Off
}
