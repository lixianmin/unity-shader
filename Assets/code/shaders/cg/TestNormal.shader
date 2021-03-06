// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "cg/TestNormal"
{
	SubShader
	{
		Pass 
		{
			Cull Back

			CGPROGRAM
			#pragma exclude_renderers d3d11 xbox360
			#pragma vertex vert 
			#pragma fragment frag 

			#include "UnityCG.cginc"

			struct v2f
			{
				float4	position	: POSITION;		// POSITION与SV_POSITION应该是一样的
				float3  viewDir 	: TEXCOORD0;
				float3	worldNormal : TEXCOORD1;	// 这个之所以编译错误, 是因为没有绑定到TEXCOORD1
			};

			v2f vert(appdata_base input)
			{
				v2f output;
				output.position		= UnityObjectToClipPos(input.vertex);
				output.viewDir		= normalize(WorldSpaceViewDir(input.vertex));
				output.worldNormal	= UnityObjectToWorldNormal(input.normal);

				return output;
			}

			half4 frag(v2f input): COLOR
			{
				half4 output	= half4(input.worldNormal, 1.0);
				return output;
			}

			ENDCG
		}
	}

	Fallback Off
}
