
/********************************************************************
created:	2012-09-07
author:		lixianmin

Copyright (C) - All Rights Reserved
 *********************************************************************/

Shader "ImageEffect/ScreenDoorSwitch" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D)					= "white" {}
		_CloseRatio("Close Ratio", Range(0, 1.0))	= 0
		_CloseColor("Close Color", Color)			= (0, 0, 0, 1)
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
				half	t		= saturate(_CloseRatio) * 1.5;
				if(t < 1.0)
				{
					if(texcoord.y > 0.5 * (1 - texcoord.x / t ) && texcoord.y < 0.5 * (1+(1-texcoord.x) / t ))
					{
						half4 baseColor	= tex2D(_MainTex, i.uv);
						output	= baseColor;
					}
				}
				else if(texcoord.y > (0.5 + (t -1.5)*texcoord.x) && texcoord.y < (0.5 + (texcoord.x -1) * (t - 1.5)))
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
