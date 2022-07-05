// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'


/****************************************************************************
created:	2013-4-8
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "shadow/PlanarShadow"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 1.0) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125
		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}

      	_ShadowColor ("Shadow's Color", Color) = (0,0,0,1)
   	}

    SubShader 
    {
		UsePass "lighting/BlinnPhong/FORWARDBASE"
		UsePass "lighting/BlinnPhong/FORWARDADD"

		Pass 
		{   
			Tags { "LightMode" = "ForwardBase" } 

			Offset 0.0, -1.0 // make sure shadow polygons are on top of shadow receiver

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			uniform float4		_ShadowColor;
			uniform float4x4	_World2Receiver; // transformation from // world coordinates to the coordinate system of the plane

			float4 vert(float4 vertexPos : POSITION) : SV_POSITION
			{
				float4x4 world2Receiver		= _World2Receiver;

				float4 lightDirection		= normalize(_WorldSpaceLightPos0.w * mul(unity_ObjectToWorld, vertexPos) - _WorldSpaceLightPos0);
				float4 vertexInWorldSpace	= mul(unity_ObjectToWorld, vertexPos);
				float4 world2ReceiverRow1	= float4(world2Receiver[0][1], world2Receiver[1][1], world2Receiver[2][1], world2Receiver[3][1]);

				float baseHeight			= world2Receiver[1][3];

				// = (world2Receiver* vertexInWorldSpace).y = height over plane 
				float vertexHeight			= dot(world2ReceiverRow1, vertexInWorldSpace) + baseHeight;

				// = (world2Receiver* lightDirection).y = length in y direction
				float lengthOfLightDirectionInY	= dot(world2ReceiverRow1, lightDirection);

				if (vertexHeight > 0.0 && lengthOfLightDirectionInY < 0.0)
				{
					lightDirection = lightDirection * (vertexHeight / -lengthOfLightDirectionInY );
				}
				else
				{
					// don't move vertex
					lightDirection = float4(0.0, 0.0, 0.0, 0.0); 
				}

				return mul(UNITY_MATRIX_VP, vertexInWorldSpace + lightDirection);
			}

			float4 frag(void) : COLOR 
			{
				return _ShadowColor;
			}

			ENDCG 
		}
	}

	Fallback "Diffuse"
}
