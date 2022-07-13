
/********************************************************************
created:	2013-01-08
author:		lixianmin

Copyright (C) - All Rights Reserved
 *********************************************************************/

Shader "glsl/image/ScreenDoorHeart" 
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
			GLSLPROGRAM
			#include "UnityCG.glslinc"

			uniform sampler2D	_MainTex;
			// half 		_CloseRatio;
			// half4		_CloseColor;
			varying vec4		texcoord0;

#ifdef VERTEX
			void main ()
			{
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				texcoord0	= gl_TextureMatrix[0] * gl_MultiTexCoord0;
			}

#endif

#ifdef FRAGMENT

			void main(void)
			{
				vec4 baseColor	= texture2D(_MainTex, vec2(texcoord0));

				vec2 p		= (2.0 * gl_FragCoord.xy - _ScreenParams.xy) / _ScreenParams.y;
				p.y			-= 0.25;
				p.x			-= 0.25;

				// animate
				float tt	= mod(_Time.y, 2.0) / 2.0;
				float ss	= pow(tt, 0.2) * 0.5 + 0.5;
				ss			-= ss * 0.2 * sin(tt * 6.2831 * 5.0) * exp(-tt * 6.0);
				p			*= vec2(0.5, 1.5) + ss * vec2(0.5, -0.5);

				float angle	= atan(p.x, p.y) / 3.141593;
				float radius= length(p) * 2.0;

				// shape
				float h = abs(angle);
				float d = (13.0 * h - 22.0 * h*h + 10.0 * h*h*h) / (6.0 - 5.0 * h);

				// color
				// float f = step(radius,d) * pow(1.0- radius/d, 0.25);
				float f = smoothstep(radius - 0.2, radius, d) * pow(1.0 - radius/d, 0.25);

				gl_FragColor = mix(baseColor, vec4(f, 0.0, 0.0, 1.0), f);
				// gl_FragColor	= vec4(d, .0, .0, 1.0);
			}

			// void main(void)
			// {
			//     vec2 p	= (2.0 * gl_FragCoord.xy - _ScreenParams.xy) / _ScreenParams.y;
			//     p.y		-= 0.25;

			//     // animate
			//     float tt	= mod(_Time.y, 2.0) / 2.0;
			//     float ss	= pow(tt, 0.2) * 0.5 + 0.5;
			//     ss		-= ss * 0.2 * sin(tt * 6.2831 * 5.0) * exp(-tt * 6.0);
			//     p		*= vec2(0.5, 1.5) + ss * vec2(0.5, -0.5);


			//     float angle	= atan(p.x, p.y) / 3.141593;
			//     float radius	= length(p);

			//     // shape
			//     float h = abs(angle);
			//     float d = (13.0 * h - 22.0 * h*h + 10.0 * h*h*h) / (6.0 - 5.0 * h);

			//     // color
			//     float f = step(radius,d) * pow(1.0- radius/d, 0.25 );

			//     gl_FragColor = vec4(f, 0.0, 0.0, 1.0);
			// }


#endif
			ENDGLSL
		}
	}

	Fallback Off
}
