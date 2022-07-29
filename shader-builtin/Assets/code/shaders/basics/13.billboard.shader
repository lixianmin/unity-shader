
/****************************************************************************
created:	2013-04-10
author:		lixianmin

https://www.bilibili.com/video/BV19r4y117gW/?spm_id_from=333.788&vd_source=060cae0323076afc7bb35d1220dc6cf7

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "basics/13.billboard"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}
	}

	SubShader
	{
		Tags
		{
			"Queue"				= "Geometry" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Opaque"
		}

		LOD	200

		CGINCLUDE
		#pragma exclude_renderers d3d11 xbox360
		#pragma fragmentoption ARB_precision_hint_fastest

		#include "UnityCG.cginc"

		half4		_Color;
		sampler2D	_MainTex;
		float4		_MainTex_ST;

		struct v2f
		{
			float4	position		: SV_POSITION;
			float2	texcoord		: TEXCOORD0;
		};

		ENDCG

		Pass 
		{
			Cull Back

			CGPROGRAM
			#pragma glsl
			#pragma vertex vert 
			#pragma fragment frag

			v2f vert(appdata_base input)
			{
				v2f output;
				// 1. 首先, 把原点转到view空间, 因为原点不存在方向的概念, 所以它一定是朝向camera的
				// 2. 然后, 把(x, y)加到原点上, 相当于是恢复了相关顶点的位置. 这里没有处理z值, 因为朝向camera的方向z值一定是0了
				// 3. 最后, 乘以P矩阵, 完成MVP的任务
				// 4. https://stackoverflow.com/a/54187589/2926815 解释了怎么借助unity_ObjectToWorld解决scale的问题
				output.position	= mul(UNITY_MATRIX_P, mul(UNITY_MATRIX_MV, float4(0, 0, 0, 1))
					+ float4(input.vertex.x, input.vertex.y, 0, 0)
					* float4(length(unity_ObjectToWorld._m00_m10_m20),length(unity_ObjectToWorld._m01_m11_m21), 1, 1));
				output.texcoord = TRANSFORM_TEX(input.texcoord, _MainTex);

				return output;
			}
		
			half4 frag(v2f input):COLOR
			{
				half4	baseColor	= tex2D(_MainTex, input.texcoord);
				half4	output		= 2.0 * _Color * baseColor;
				return output;
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}
