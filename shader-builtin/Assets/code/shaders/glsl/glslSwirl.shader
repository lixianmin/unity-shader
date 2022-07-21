
/****************************************************************************
created:	2013-05-06
author:		lixianmin

reference: http://glsl.heroku.com/e#7604.0
Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "glsl/Swirl"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 1.0) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125
		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}

		_Speed("Speed", Range(0.01, 10.0))			= 1.0
		_Size("Size", Range(0.5, 20))				= 1.0
		_Density("Density", Range(0.2, 3.0))		= 0.5

		_CenterX("Center X", Range(0, 1.0))			= 0.5
		_CenterY("Center Y", Range(0, 1.0))			= 0.5
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
		uniform vec4		_MainTex_TexelSize;

		uniform float		_Speed;
		uniform float		_Density;
		uniform float		_Size;
		uniform float		_CenterX;
		uniform float		_CenterY;
		
		varying vec4 worldPosition;
		varying vec3 worldNormal;
		varying vec4 texcoord0;

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

			vec4 GetSwirlColor()
			{
				float textureWidth	= 1.0 / _MainTex_TexelSize.x;
				float textureHeight	= 1.0 / _MainTex_TexelSize.y;
				vec4  color		= vec4(0.0, 0.0, 0.0, 0.0);
				float d			= textureWidth * texcoord0.x * _Size / _Density;
				float time		= _Time.y * _Speed;

				for(int n=0; n< 60; n++)
				{
					float x		= sin(time*float(n+1)/10.0)*d/float(n+1)*time/(time/2.0);
					float y		= cos(time*float(n+1)/10.0)*d/float(n+1)*time/(time/2.0);
					float dist	= length(vec2(textureWidth * (texcoord0.x - _CenterX) - x, textureHeight * (texcoord0.y - _CenterY) - y)) / _Size;
					float c		= 0.01 * float(n+1) / pow(dist, 2.0);
					color.b		+= c;
					color.r		+= c;
					color.g		+= (color.r + color.g) / float(n+1);
				}

				return color;
			}

			vec4 GetPhongColor()
			{
				CREATE_LIGHTING_VARIABLES(worldPosition, worldNormal);
				vec4 lighting	= vec4(1.0, max(0.0, dot(N, L)), pow(max(0.0, dot(N, H)), _Shininess * 128.0), 1.0);
				vec4 diffuse	= 2.0 * _Color * (gl_LightModel.ambient + attenuation * _LightColor0 * lighting.y);
				vec4 specular	= 2.0 * _SpecColor * attenuation * _LightColor0 * lighting.z;
			
				vec4 baseColor	= texture2D(_MainTex, vec2(texcoord0));
				vec4 phongColor	= baseColor * diffuse + specular;

				return phongColor;
			}

			void main()
			{
				vec4 swirlColor	= GetSwirlColor();
				vec4 phongColor	= GetPhongColor();

				gl_FragColor.rgb= mix(phongColor.rgb, swirlColor.rgb, swirlColor.r);
				gl_FragColor.a	= phongColor.a;
			}
#endif
			ENDGLSL
		}
	}
}
