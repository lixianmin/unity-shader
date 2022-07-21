// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "cg/Plasma"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D)	= "white" {}
	}

	SubShader
	{
		Tags { "Queue"="Geometry" }

		Cull	Back	
		ZTest	LEqual
		ZWrite	On

		Fog { Mode Off }

		Pass 
		{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest

			#pragma vertex vert	
			#pragma fragment frag 

			#include "UnityCG.cginc"

			sampler2D	_MainTex;
			float4		_MainTex_ST;

			struct v2f
			{
				float4	position	: POSITION;
				float2	texcoord	: TEXCOORD0;
			};

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position		= UnityObjectToClipPos(input.vertex);
				output.texcoord		= TRANSFORM_TEX(input.texcoord, _MainTex);

				return output;
			}

			half4 frag(v2f input): SV_TARGET
			{
				float2 ca	= float2(0.2, 0.2);   
				float2 cb	= float2(0.7, 0.9);   
				float da	= distance(input.texcoord, ca);   
				float db	= distance(input.texcoord, cb);   

				float c1	= sin(da * _CosTime.y * 16 + _Time.x);   
				float c2	= cos(input.texcoord.x * 8 + _Time.z);   
				float c3	= cos(db * 14) + _CosTime.x;  
				float p		= (c1 + c2 + c3) / 3;   

				half4	output	= tex2D(_MainTex, float2(p, 0.5));  
				return output;
			}

			ENDCG
		}
	}

	Fallback Off
}
