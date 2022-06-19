// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-16
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/image/X Ray"
{
	Properties
	{
		_Color ("Main Color", Color)		= (1.0, 1.0, 1.0, 1.0) 
		_MainTex("Main Texture", 2D)		= "white" {}
		_HostDepth("Host Depth", 2D)		= "white" {}
		_OthersDepth("Others Depth", 2D)	= "white" {}
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
		sampler2D	_HostDepth;
		sampler2D	_OthersDepth;
		// sampler2D	_CameraDepthTexture;

		struct v2f
		{
			float4	position	: POSITION;
			float2	texcoord	: TEXCOORD0;
		};

		v2f vert(appdata_base input)
		{
			v2f output;
			output.position		= UnityObjectToClipPos(input.vertex);
			output.texcoord		= input.texcoord;

			return output;
		}

		half4 common_fragment(v2f input)
		{
			half hostDepth		= tex2D(_HostDepth, input.texcoord).r;
			half othersDepth	= tex2D(_OthersDepth, input.texcoord).r;

			half4	output		= tex2D(_MainTex, input.texcoord);
			if(hostDepth < 1.0 && hostDepth > othersDepth)
			{
				output.rgb		= _Color;
			}
			
			return output;
		}

		ENDCG

		Pass 
		{
			Name "FORWARDBASE"

			ZWrite	Off

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
