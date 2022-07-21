Shader "glsl/GLSL Debug"
{
	// Properties
	// {
	//     _MainTex("Base (RGB) Glass (A)", 2D)	= "white" {}
	// }

	SubShader
	{
		Pass 
		{
			GLSLPROGRAM	
			#include "UnityCG.glslinc"
			// attribute vec4	Tangent;
			varying vec4	position;
			varying vec4	color;

#ifdef VERTEX
			void main()
			{
				gl_Position	= gl_ModelViewProjectionMatrix * gl_Vertex;

				// color	= gl_Vertex;
				// color	= gl_Color;
				// color	= vec4(gl_Normal, 1.0);
				// color	= gl_MultiTexCoord0;
				// color	= gl_MultiTexCoord1;
				// color	= Tangent;

				// color.r		= gl_MultiTexCoord0.x;
				// color.rgb	= (gl_Normal + 1)/2;
				color = vec4(cross(gl_Normal, gl_Normal), 1.0);
			}
#endif

#ifdef FRAGMENT
			void main()
			{
				gl_FragColor	= color;
			}
#endif
			ENDGLSL
		}
	}
	Fallback "Diffuse"
}
