// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-3-02
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "projector/DropShadows"
{
	Properties
	{
    	_ShadowTex ("Projected Image", 2D) = "black" {}
   	}

	SubShader
	{
		Pass
		{      
			Blend	Zero	OneMinusSrcAlpha	// attenuate color in framebuffer by 1 minus alpha of _ShadowTex 

			CGPROGRAM

			#pragma glsl
			#pragma vertex vert  
			#pragma fragment frag 

			sampler2D	_ShadowTex; 
			float4x4	unity_Projector;	// transformation matrix from object space to projector space 

			struct v2f
			{
				float4 position		: SV_POSITION;
				float4 projPosition	: TEXCOORD0; // position in projector space
			};

			v2f vert(float4 vertex : SV_POSITION) 
			{
				v2f output;
				output.position		= UnityObjectToClipPos(vertex);
				output.projPosition	= mul(unity_Projector, vertex);
				return output;
			}

			half4 frag(v2f input) : COLOR
			{
				bool isInFrontOfProjector	= input.projPosition.w > 0.0;
				if (isInFrontOfProjector)
				{
					return tex2Dproj(_ShadowTex, input.projPosition);
					// return tex2D(_ShadowTex , float2(input.projPosition) / input.projPosition.w); 
				}
				else 
				{
					// behind projector
					return half4(0.0, 0.0, 0.0, 0.0);
				}
			}

			ENDCG
		}
	} 
}
