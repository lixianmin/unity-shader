// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-03-17
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "cg/image/RenderDepth"
{
	SubShader
	{
		Tags
		{ 
			"RenderType"	= "Opaque"
		}

		Pass
		{
			Fog { Mode Off }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 depth : TEXCOORD0;
			};

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos	= UnityObjectToClipPos (v.vertex);
				UNITY_TRANSFER_DEPTH(o.depth);
				return o;
			}

			half4 frag(v2f i) : COLOR
			{
				UNITY_OUTPUT_DEPTH(i.depth);
			}

			ENDCG
		}
	}
}
