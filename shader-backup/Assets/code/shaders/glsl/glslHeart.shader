
/****************************************************************************
created:	2013-04-04
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "glsl/Heart"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}
	}

	SubShader
	{
		Tags
		{
			"Queue"				= "Geometry" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Opaque"
		}

		LOD	300

		GLSLINCLUDE

		#include "UnityCG.glslinc"

		uniform vec4		_Color;
		uniform sampler2D	_MainTex;
		uniform vec4		_MainTex_ST;

		varying vec4	worldPosition;
		varying vec4	position;
		varying vec4	texcoord0;

		ENDGLSL

		Pass 
		{
			Cull 	Back
			Blend	SrcAlpha	OneMinusSrcAlpha

			GLSLPROGRAM
#ifdef VERTEX
			void main()
			{
				gl_Position		= gl_ModelViewProjectionMatrix * gl_Vertex;
				position		= gl_Position;
				worldPosition	= _Object2World * gl_Vertex;
				texcoord0		= gl_MultiTexCoord0;
			}
#endif

#ifdef FRAGMENT
			void main()
			{
				// vec2 p	= (2.0 * gl_FragCoord.xy - _ScreenParams.xy) / _ScreenParams.y;
				vec2 p		= worldPosition.xy;

				// animate
				float tt	= mod(_Time.y, 2.0) / 2.0;
				float ss	= pow(tt, 0.2) * 0.5 + 0.5;
				ss			-= ss * 0.2 * sin(tt * 6.2831 * 5.0) * exp(-tt * 6.0);
				p			*= vec2(0.5, 1.5) + ss * vec2(0.5, -0.5);

				float angle	= atan(p.x, p.y) / 3.141593;
				float radius= length(p) * 2.0;

				// shape
				float h 	= abs(angle);
				float d 	= (13.0 * h - 22.0 * h*h + 10.0 * h*h*h) / (6.0 - 5.0 * h);

				// color
				// float f = step(radius,d) * pow(1.0- radius/d, 0.25);
				float f 	= smoothstep(radius - 0.2, radius, d) * pow(1.0 - radius/d, 0.25);

				gl_FragColor = vec4(f, 0.0, 0.0, 0.5);
				// gl_FragColor	= vec4(1.0, .0, .0, 1.0);
			}
#endif
			ENDGLSL
		}
	}
}
