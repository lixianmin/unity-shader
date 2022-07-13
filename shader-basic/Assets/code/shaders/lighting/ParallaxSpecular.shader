// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


/****************************************************************************
created:	2013-3-02
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "lighting/ParallaxSpecular"
{
	Properties
	{
		_Color ("Main Color", Color)				= (1.0, 1.0, 1.0, 1.0) 
		_SpecColor("Specular Color", Color)			= (0.5, 0.5, 0.5, 1.0) 
		_Shininess ("Shininess", Range(0.01, 1))	= 0.078125

		_MainTex("Base (RGB) Glass (A)", 2D)		= "white" {}
		_BumpMap("Normal Map", 2D)		 			= "bump" {}
		_ParallaxMap ("Heightmap (in A)", 2D)		= "black" {}
		_Parallax ("Max Height", Float)				= 0.01
     	_MaxTexCoordOffset ("Max Texture Coordinate Offset", Float)	= 0.01
	}

	SubShader
	{
		Tags
		{
			"Queue"				="Geometry" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Opaque"
		}

		LOD	200

		CGINCLUDE
		#pragma exclude_renderers d3d11 xbox360
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma target 3.0

		#include "../basic.cginc"

		half4		_Color;
		half		_Shininess;
		sampler2D	_MainTex;
		float4		_MainTex_ST;

		sampler2D	_BumpMap;
		float4		_BumpMap_ST;

		sampler2D	_ParallaxMap; 
		float4		_ParallaxMap_ST;
		float		_Parallax;
		float		_MaxTexCoordOffset;

		struct v2f
		{
			float4	position		: POSITION;
			float2	texcoord		: TEXCOORD0;
			float4	worldPosition	: TEXCOORD1;
			float3	worldNormal		: TEXCOORD2;
			float3	worldTangent	: TEXCOORD3;
			float3	worldBinormal	: TEXCOORD4;
			float3	viewDirInScaledSurfaceCoords	: TEXCOORD5;
		};

		v2f vert(appdata_tan input)
		{
			v2f output;
			output.position		= UnityObjectToClipPos(input.vertex);
			output.texcoord		= TRANSFORM_TEX(input.texcoord, _MainTex);
			output.worldPosition= mul(unity_ObjectToWorld, input.vertex);
			output.worldNormal	= normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);

			output.worldTangent	= normalize(mul(unity_ObjectToWorld, float4(input.tangent.xyz, 0.0)).xyz);
			output.worldBinormal= normalize(cross(output.worldNormal, output.worldTangent) * input.tangent.w); // tangent.w is specific to Unity

			// appropriately scaled tangent and binormal to map distances from object space to texture space
			float3 binormal		= cross(input.normal, input.tangent.xyz) * input.tangent.w; 
			float3 viewDirInObjectCoords = (mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0)) - input.vertex).xyz;
			float3x3 localSurface2ScaledObjectT	= float3x3(input.tangent.xyz, binormal, input.normal); // vectors are orthogonal

			// we multiply with the transpose to multiply with the "inverse" (apart from the scaling)
			output.viewDirInScaledSurfaceCoords		= mul(localSurface2ScaledObjectT, viewDirInObjectCoords); 

			return output;
		}

		float3 GetEncodedNormal(v2f input)
		{
			// parallax mapping: compute height and find offset in texture coordinates for the intersection of the view ray with the surface at this height
			float height	= _Parallax * (-0.5 + tex2D(_ParallaxMap, _ParallaxMap_ST.xy * input.texcoord.xy + _ParallaxMap_ST.zw).x);
			float2 texCoordOffsets	= clamp(height * input.viewDirInScaledSurfaceCoords.xy / input.viewDirInScaledSurfaceCoords.z, -_MaxTexCoordOffset, +_MaxTexCoordOffset);

			// normal mapping: lookup and decode normal from bump map in principle we have to normalize worldTangent, worldBinormal, and worldNormalagain; however, the potential problems are small since we use this matrix only to compute "normalDirection", which we normalize anyways

			float3x3 local2WorldTranspose = float3x3(input.worldTangent, input.worldBinormal, input.worldNormal);
			float4	bumpedNormal	= tex2D(_BumpMap, _BumpMap_ST.xy * (input.texcoord.xy + texCoordOffsets) + _BumpMap_ST.zw);
			float3	encodedNormal	= normalize(mul(UnpackNormal(bumpedNormal), local2WorldTranspose));

			return encodedNormal;
		}

		half4 common_fragment(v2f input, half usingAmbient)
		{
			float3	encodedNormal	= GetEncodedNormal(input);
			CREATE_LIGHTING_VARIABLES(input.worldPosition, encodedNormal);
			half4	lighting	= lit(dot(N, L), dot(N, H), _Shininess * 128.0); 

			half4	diffuse		= 2.0 * _Color * (usingAmbient * UNITY_LIGHTMODEL_AMBIENT + attenuation * _LightColor0 * lighting.y);
			half4	specular	= 2.0 * _SpecColor * attenuation * _LightColor0 * lighting.z;

			half4	baseColor	= tex2D(_MainTex, input.texcoord);
			half4	output		= baseColor * diffuse + specular;
			return output;
		}

		ENDCG

		Pass 
		{
			Name "FORWARDBASE"
			Tags 	
			{ 
				"LightMode"	= "ForwardBase" // pass for ambient light & first light source
			}

			Cull 	Back

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 

			half4 frag(v2f input): COLOR
			{
				half usingAmbient	= 1.0;
				return common_fragment(input, usingAmbient);
			}

			ENDCG
		}

		Pass 
		{
			Name "FORWARDADD"
			Tags
			{ 
				"LightMode"	= "ForwardAdd" 
			}

			Cull 	Back
			Blend	One	One

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			half4 frag(v2f input): COLOR
			{
				half usingAmbient	= 0.0;
				return common_fragment(input, usingAmbient);
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}
