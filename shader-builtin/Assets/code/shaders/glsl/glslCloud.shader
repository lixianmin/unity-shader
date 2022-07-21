
/****************************************************************************
created:	2013-05-06
author:		lixianmin

reference: http://www.mrdoob.com/lab/javascript/webgl/clouds/
Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "glsl/Cloud"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}

		_FogColor("Fog Color", Color)				= (0.27, 0.52, 0.71, 1.0)
		_FogNear("Fog Near", Float)					= -10
		_FogFar("Fog Far", Float)					= 300
	}

	SubShader
	{
		Tags
		{
			"Queue"				= "Transparent" 
			"RenderType"		= "Transparent"
			"IgnoreProjector"	= "True"
		}

		LOD	100

		GLSLINCLUDE

		#include "basic.glslinc"

		uniform sampler2D	_MainTex;
		uniform vec4		_MainTex_ST;
		
		uniform vec3		_FogColor;
		uniform float		_FogNear;
		uniform float		_FogFar;

		varying vec4		texcoord0;
		varying vec4		vertex;

		ENDGLSL

		Pass 
		{
			Blend	SrcAlpha	OneMinusSrcAlpha

			Cull 	Off
			ZTest	LEqual
			ZWrite	Off

			GLSLPROGRAM
#ifdef VERTEX
			void main()
			{
				// gl_Position		= gl_ProjectionMatrix * (gl_ModelViewMatrix * vec4(0.0, 0.0, 0.0, 1.0) + vec4(gl_Vertex.xyz, 0.0));
				gl_Position		= gl_ModelViewProjectionMatrix * gl_Vertex;
				texcoord0		= gl_MultiTexCoord0;
				vertex			= gl_Vertex;
			}
#endif

#ifdef FRAGMENT
			void main()
			{
				float depth		= gl_FragCoord.z / gl_FragCoord.w;
				float fogFactor = smoothstep(_FogNear, _FogFar, depth);

				gl_FragColor	= texture2D(_MainTex, vec2(texcoord0));
				gl_FragColor.a *= pow( gl_FragCoord.z, 5.0);
				gl_FragColor	= mix( gl_FragColor, vec4(_FogColor, gl_FragColor.a), fogFactor );
			}
#endif
			ENDGLSL
		}
	}
}
