
/****************************************************************************
created:	2013-03-31
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "glsl/BlinnPhong"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 1.0) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125
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

		#include "basic.glslinc"

		uniform vec4		_Color;
		uniform float		_Shininess;
		uniform vec4		_SpecColor;
		uniform sampler2D	_MainTex;
		uniform vec4		_MainTex_ST;

		varying vec4 worldPosition;
		varying vec3 worldNormal;
		varying vec4 texcoord0;

		#ifdef VERTEX
		void main()
		{
			gl_Position		= gl_ModelViewProjectionMatrix * gl_Vertex;
			worldPosition	= _Object2World * gl_Vertex;
			worldNormal		= normalize(vec3(vec4(gl_Normal, 0) * _World2Object));
			texcoord0		= gl_MultiTexCoord0;
		}
		#endif

		#ifdef FRAGMENT
		void common_fragment(float usingAmbient)
		{
			CREATE_LIGHTING_VARIABLES(worldPosition, worldNormal);
			vec4 lighting	= vec4(1.0, max(0.0, dot(N, L)), pow(max(0.0, dot(N, H)), _Shininess * 128.0), 1.0);
			vec4 diffuse	= 2.0 * _Color * (usingAmbient * gl_LightModel.ambient + attenuation * _LightColor0 * lighting.y);
			vec4 specular	= 2.0 * _SpecColor * attenuation * _LightColor0 * lighting.z;
		
			vec4 baseColor	= texture2D(_MainTex, vec2(texcoord0));
			gl_FragColor	= baseColor * diffuse + specular;
		}
		#endif

		ENDGLSL

		Pass 
		{
			Name "FORWARDBASE"

			Tags 
			{ 
				"LightMode"	= "ForwardBase" // pass for 4 vertex lights, ambient light & first pixel light
			}

			Cull 	Back

			GLSLPROGRAM

			#ifdef FRAGMENT
			void main()
			{
				float usingAmbient	= 1.0;
				common_fragment(usingAmbient);
			}
			#endif
			ENDGLSL
		}

		Pass
		{
			Name "FORWARDADD"
			Tags
			{ 
				"LightMode"	= "ForwardAdd" 
			}

			Cull 	Back
			Blend	One	One

			GLSLPROGRAM
			#ifdef FRAGMENT
			void main()
			{
				float usingAmbient	= 0.0;
				common_fragment(usingAmbient);
			}
			#endif
		
			ENDGLSL
		}
	}

	Fallback "Diffuse"
}
