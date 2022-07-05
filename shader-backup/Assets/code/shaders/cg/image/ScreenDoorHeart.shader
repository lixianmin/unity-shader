
/********************************************************************
created:	2013-01-08
author:		lixianmin

coordinate:
				|
				|	
		--------|-----------> x
				|	
				|	
				| y	

Copyright (C) - All Rights Reserved
 *********************************************************************/

Shader "ImageEffect/ScreenDoorHeart" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D)	= "white" {}
		_CloseRatio("Close Ratio", range(0, 1.0))	= 1
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
			#pragma glsl
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

				// flip uv in opengl. -_____-!!
				#if	!UNITY_UV_STARTS_AT_TOP
				texcoord.y		= 1 - texcoord.y;
				#endif
				
				half4	output	= _CloseColor;
				half	x		= texcoord.x;
				half	y		= texcoord.y * _ScreenParams.y / _ScreenParams.x + 0.19;
				half	t		= saturate(_CloseRatio);
				bool	isInSquare	= x + y > t && x + y< 2-t && x - y < 1 - t && x-y > t - 1;
				if(isInSquare)
				{
					output	= tex2D(_MainTex, i.uv);
				}
				else
				{
					half	squaredRadius	= 0.5 * (t-1) * (t-1);
					half	a	= 0.5 * t;
					half	b	= 1 - a;
					
					if((x-a)*(x-a) + (y-a)*(y-a) < squaredRadius || (x-b)*(x-b) + (y-a)*(y-a) < squaredRadius)
					{
						output	= tex2D(_MainTex, i.uv);
					}
				}

				return output;
			}

			ENDCG
		}
	}

	Fallback Off
}
