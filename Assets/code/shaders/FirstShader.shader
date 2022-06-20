// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Test/FirstShader"
{
	Properties
	{
		_ColorMix("Color Mix", Range( 0 , 1)) = 0.5529412
		_Color1("Color 1", Color) = (1,0.6745098,0.427451,0)
		_Color0("Color 0", Color) = (0.4980392,0.4980392,0.4980392,0.4980392)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Specular("Specular", Range( 0 , 1)) = 0
		[NoScaleOffset]_BrushedMetal("BrushedMetal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BrushedMetal;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _ColorMix;
		uniform float _Specular;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_BrushedMetal8 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _BrushedMetal, uv_BrushedMetal8 ) );
			float4 lerpResult1 = lerp( _Color0 , _Color1 , _ColorMix);
			o.Albedo = lerpResult1.rgb;
			float3 temp_cast_1 = (_Specular).xxx;
			o.Specular = temp_cast_1;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
-267;-1057;1920;1036;987.4166;517.7805;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;5;-557,166;Inherit;False;Property;_ColorMix;Color Mix;0;0;Create;True;0;0;0;False;0;False;0.5529412;0.5529412;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-503,-215;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0.4980392,0.4980392,0.4980392,0.4980392;0.4980392,0.4980392,0.4980392,0.4980392;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-543,-45;Inherit;False;Property;_Color1;Color 1;1;0;Create;True;0;0;0;False;0;False;1,0.6745098,0.427451,0;1,0.6745098,0.427451,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-554,247;Inherit;False;Property;_Specular;Specular;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-572,339;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-157,148;Inherit;True;Property;_BrushedMetal;BrushedMetal;5;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;ca58b3b5763fc4206b8df0a6d00940d6;ca58b3b5763fc4206b8df0a6d00940d6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1;-229,-103;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;136,-196;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Test/FirstShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;1;2;5;0
WireConnection;0;0;1;0
WireConnection;0;1;8;0
WireConnection;0;3;7;0
WireConnection;0;4;6;0
ASEEND*/
//CHKSM=AF2351B35F5B4687732CF77D9D2B4B4425E54CDD