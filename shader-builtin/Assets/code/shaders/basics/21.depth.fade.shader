// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "21.depth.fade"
{
	Properties
	{
		_Distance("_Distance", Range( 0 , 1)) = 0.2
		_FresnelPower("FresnelPower", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
		};

		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Distance;
		uniform float _FresnelPower;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth9 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth9 = saturate( abs( ( screenDepth9 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Distance ) ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV13 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode13 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV13, _FresnelPower ) );
			float temp_output_7_0 = ( ( 1.0 - saturate( distanceDepth9 ) ) * fresnelNode13 );
			float3 temp_cast_0 = (temp_output_7_0).xxx;
			o.Emission = temp_cast_0;
			o.Alpha = temp_output_7_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
-272;-1035;1920;1014;1001.247;344.9271;1.009998;True;True
Node;AmplifyShaderEditor.RangedFloatNode;4;-798.438,-70.20779;Inherit;False;Property;_Distance;_Distance;0;0;Create;True;0;0;0;False;0;False;0.2;0.112;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;9;-535.9581,-83.3377;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;12;-250.8186,-82.32769;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-613.408,249.9616;Inherit;False;Property;_FresnelPower;FresnelPower;1;0;Create;True;0;0;0;False;0;False;0;9.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;13;-365.9584,172.1918;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-74.06899,-78.2877;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;79.25004,37.86204;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;10;380.3996,-71.42989;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;21.depth.fade;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;0;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;4;0
WireConnection;12;0;9;0
WireConnection;13;3;14;0
WireConnection;15;0;12;0
WireConnection;7;0;15;0
WireConnection;7;1;13;0
WireConnection;10;2;7;0
WireConnection;10;9;7;0
ASEEND*/
//CHKSM=343CBCC8F839CF4990001800EEAA55FB955895D8