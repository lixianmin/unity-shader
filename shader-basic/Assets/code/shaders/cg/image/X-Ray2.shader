// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-19
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/image/X Ray2"
{
	Properties
	{
		_Color ("Main Color", Color)	= (1.0, 1.0, 1.0, 1.0) 
		_MainTex("Main Texture", 2D)	= "white" {}
		_Depth("Depth Texture", 2D)		= "white" {}
	}

	SubShader
	{
		LOD	300

		CGINCLUDE
		#pragma exclude_renderers d3d11 xbox360
		#pragma fragmentoption ARB_precision_hint_fastest

		#include "UnityCG.cginc"

		half4		_Color;
		sampler2D	_MainTex;
		sampler2D	_Depth;

		struct v2f
		{
			float4	position	: POSITION;
			float2	texcoord	: TEXCOORD0;
			float	eyeDepth	: TEXCOORD1;	
		};

		v2f vert(appdata_base v)
		{
			v2f output;
			output.position		= UnityObjectToClipPos(v.vertex);
			output.texcoord		= v.texcoord;
			// output.eyeDepth		= COMPUTE_DEPTH_01;
			output.eyeDepth		= output.position.z/output.position.w;

			return output;
		}

		half4 common_fragment(v2f input)
		{
			half depth			= tex2D(_Depth, input.texcoord).r;
			half sceneEyeDepth	= DECODE_EYEDEPTH(depth);

			if(input.eyeDepth < depth)
			{
				discard;
			}

			half4	output		= 2.0 * _Color * tex2D(_MainTex, input.texcoord);
			// output	= input.eyeDepth;
			// output	= depth;
			return output;
		}

		ENDCG

		Pass 
		{
			Name "FORWARDBASE"

			ZWrite	Off
			ZTest	Always

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag

			half4 frag(v2f input):COLOR
			{
				return common_fragment(input);
			}

			ENDCG
		}
	}

	Fallback Off
}
