// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'


/****************************************************************************
created:	2013-04-06
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "projector/LookAtLight"
{
	Properties
	{
		_Color ("Main Color", Color)		= (1.0, 1.0, 1.0, 1.0) 
   	}

	SubShader
	{
		Pass
		{      
			Tags
			{ 
				"LightMode"	= "ForwardBase"
			}

			CGPROGRAM
			#pragma exclude_renderers d3d11 xbox360

			#pragma glsl
			#pragma vertex vert  
			#pragma fragment frag 

			uniform float4x4	unity_WorldToLight;
			half4 _Color;

			struct v2f
			{
				float4 position		: SV_POSITION;
				float4 test			: TEXCOORD0;
			};

			v2f vert(float4 vertex : POSITION) 
			{
				v2f output;	
				float4 lightSpacePosition	= mul(unity_WorldToLight, mul(unity_ObjectToWorld, vertex));
				output.position		= mul(UNITY_MATRIX_P, lightSpacePosition);
				output.test	= lightSpacePosition;
				return output;
			}

			half4 frag(v2f input) : COLOR
			{
				// return _Color;
				// return half4(0.0, 1.0, 0.0, 1.0);
				return input.test;
			}

			ENDCG
		}
	} 
}
