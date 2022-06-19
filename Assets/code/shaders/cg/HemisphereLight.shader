// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-15
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/HemisphereLight"
{
	Properties
	{
		_Color ("Diffuse Material Color", Color)	= (1,1,1,1) 
		_UpperHemisphereColor ("Upper Hemisphere Color", Color) = (1,1,1,1) 
      	_LowerHemisphereColor ("Lower Hemisphere Color", Color) = (1,1,1,1) 
      	_UpVector ("Up Vector", Vector)				= (0,1,0,0) 
	}

	// SubShader
	// {
	// 	Pass
	// 	{      
    //     	CGPROGRAM
 
    //      	#pragma vertex vert  
    //      	#pragma fragment frag 
	// 		#include "UnityCG.cginc"
 
    //      	// shader properties specified by users
    //       	float4 _Color; 
    //       	float4 _UpperHemisphereColor;
    //       	float4 _LowerHemisphereColor;
    //       	float4 _UpVector;
          
    //      	struct v2f
	// 		{
    //         	float4 position : SV_POSITION;
    //         	float4 color	: COLOR; // the hemisphere lighting computed in the vertex shader
    //      	};
 
	// 		v2f vert(appdata_base input) 
	// 		{
	// 			v2f output;
	// 			output.position		= UnityObjectToClipPos(input.vertex);

	// 			float3 worldNormal = normalize(float3(mul(float4(input.normal, 0.0), unity_WorldToObject)));
	// 			float3 upDirection = normalize(_UpVector);

	// 			float w		= 0.5 * (1.0 + dot(upDirection, worldNormal));
	// 			output.color= (w * _UpperHemisphereColor + (1.0 - w) * _LowerHemisphereColor) * _Color;

	// 			return output;
	// 		}

	// 		float4 frag(v2f input) : COLOR
	// 		{
	// 			return input.color;
	// 		}

	// 		ENDCG
	// 	}
	// }

	Fallback Off
}
