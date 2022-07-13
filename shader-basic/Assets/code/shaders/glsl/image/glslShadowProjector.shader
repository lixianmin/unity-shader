
/****************************************************************************
created:	2013-04-04
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "glsl/image/ShadowProjector"
{
	Properties
	{
		_Color ("Main Color", Color)			= (1.0, 1.0, 1.0, 1.0) 
		_ShadowTex("Projected Image", 2D)		= "white" {}
	}

	SubShader
	{
		GLSLINCLUDE


		uniform vec4		_Color;

		uniform sampler2D	_ShadowTex;
		uniform mat4		_Projector;		// from object space to projector space 

		varying vec4	projPosition;

		ENDGLSL

		Pass
		{
			Cull 	Back
			// Blend	SrcAlpha	OneMinusSrcAlpha
			Blend	One	One

			GLSLPROGRAM

			#ifdef VERTEX
			void main()
			{
				gl_Position		= gl_ModelViewProjectionMatrix * gl_Vertex;
				projPosition	= _Projector * gl_Vertex;
			}
			#endif

			#ifdef FRAGMENT
			void main()
			{
				if ( projPosition.w > 0.0 )
				{
					gl_FragColor	= texture2D(_ShadowTex, projPosition.xy / projPosition.w);
				}
				else 
				{
					gl_FragColor	= vec4(0.0);
				}
			}
			#endif

			ENDGLSL
		}
	}
}
