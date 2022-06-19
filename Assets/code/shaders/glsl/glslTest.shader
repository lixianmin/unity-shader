
/****************************************************************************
created:	2013-05-06
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "glsl/Test"
{
	Properties
	{
		_Color ("Main Color", Color)		= (1.0, 1.0, 1.0, 1.0) 
		_MainTex("Main Texture", 2D)		= "white" {}
		_Radius("Radius", Range(0.01, 10))	= 1.0
		_ParticleSize("Particle Size", Range(0.05, 2))		= 1.0
		_IterationCount("Iteration Count", Range(1, 200))	= 50
		_CenterX("Center X", Range(0, 1.0))	= 0.5
		_CenterY("Center Y", Range(0, 1.0))	= 0.5
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
		uniform vec4		_MainTex_TexelSize;

		uniform float		_Radius;
		uniform float		_ParticleSize;
		uniform float		_IterationCount;
		uniform float		_CenterX;
		uniform float		_CenterY;
		
		varying vec4	worldPosition;
		varying vec4	vertex;
		varying vec4	texcoord0;
		varying vec4	position;

		ENDGLSL

		Pass 
		{
			Cull 	Back
			Blend	SrcAlpha	OneMinusSrcAlpha

			GLSLPROGRAM
#ifdef VERTEX
			void main()
			{
				vertex			= gl_Vertex;
				gl_Position		= gl_ModelViewProjectionMatrix * gl_Vertex;
				position		= gl_ModelViewProjectionMatrix * gl_Vertex;
				worldPosition	= _Object2World * gl_Vertex;
				texcoord0		= gl_MultiTexCoord0;
			}
#endif

#ifdef FRAGMENT
			void main()
			{
				gl_FragColor	= vec4(position.z - 100.0, 0.0, 0.0, 1.0);
				// gl_FragColor	= vec4(gl_FragCoord.x / 1024.0, 0.0, 0.0, 1.0);
			}
#endif
			ENDGLSL
		}
	}
}
