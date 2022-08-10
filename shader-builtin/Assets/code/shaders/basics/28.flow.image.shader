// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "28.flow.image"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_FlowTex("FlowTex", 2D) = "black" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseIntensity("NoiseIntensity", Range( 0 , 1)) = 1
		_NoiseSpeed("NoiseSpeed", Vector) = (1,0,0,0)
		_FlowInterval("FlowInterval", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_COLOR

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _FlowTex;
			uniform float _FlowInterval;
			uniform float4 _FlowTex_ST;
			uniform sampler2D _NoiseTex;
			uniform float2 _NoiseSpeed;
			uniform float _NoiseIntensity;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode28 = tex2D( _MainTex, uv_MainTex );
				float2 appendResult55 = (float2(( ( _Time.y % _FlowInterval ) * sign( _FlowInterval ) ) , 0.0));
				float2 uv_FlowTex = IN.texcoord.xy * _FlowTex_ST.xy + _FlowTex_ST.zw;
				float2 panner38 = ( 1.0 * _Time.y * _NoiseSpeed + uv_FlowTex);
				float2 temp_cast_0 = (tex2D( _NoiseTex, panner38 ).r).xx;
				float2 lerpResult36 = lerp( ( appendResult55 + uv_FlowTex ) , temp_cast_0 , _NoiseIntensity);
				float4 appendResult42 = (float4(( tex2DNode28 + tex2D( _FlowTex, lerpResult36 ) ).rgb , tex2DNode28.a));
				
				half4 color = ( appendResult42 * IN.color );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
-254;-1035;1920;1014;2060.117;286.3552;1.269176;True;False
Node;AmplifyShaderEditor.RangedFloatNode;57;-1524.278,160.7435;Inherit;False;Property;_FlowInterval;FlowInterval;4;0;Create;True;0;0;0;False;0;False;5;-5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;51;-1517.558,27.16147;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;60;-1214.845,44.89983;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SignOpNode;62;-1212.307,162.9333;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1037.161,94.39777;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;40;-1415.078,571.6238;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;3;0;Create;True;0;0;0;False;0;False;1,0;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1437.601,345.3416;Inherit;False;0;30;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;38;-1101.94,441.0644;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-900.8052,98.24624;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-862.8322,630.9915;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;2;0;Create;True;0;0;0;False;0;False;1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-875.9765,402.0027;Inherit;True;Property;_NoiseTex;NoiseTex;1;0;Create;True;0;0;0;False;0;False;-1;1207268d358cd480ebd13231ed564384;1207268d358cd480ebd13231ed564384;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-722.0327,164.4795;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;26;-656.554,-194.65;Inherit;True;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;36;-498.7808,308.9224;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;30;-279.8158,240.0105;Inherit;True;Property;_FlowTex;FlowTex;0;0;Create;True;0;0;0;False;0;False;-1;cce638be049286c41bcbd0a26c356b18;081e981c00ce5448cb9688a1c25ba503;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-331.4188,-200.2557;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;35;113.9835,-29.18231;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;398.9005,26.85029;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VertexColorNode;29;391.2399,342.3207;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;50;-1221.737,-127.9671;Inherit;False;float c = frac(abs(a/b))*abs(b)@$return  (b<0) ? -c : c@;1;Create;2;True;a;FLOAT;0;In;;Inherit;False;True;b;FLOAT;0;In;;Inherit;False;fmod2;True;False;0;;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;619.8472,195.3005;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;889.4794,178.8116;Float;False;True;-1;2;ASEMaterialInspector;0;4;28.flow.image;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;60;0;51;0
WireConnection;60;1;57;0
WireConnection;62;0;57;0
WireConnection;61;0;60;0
WireConnection;61;1;62;0
WireConnection;38;0;41;0
WireConnection;38;2;40;0
WireConnection;55;0;61;0
WireConnection;33;1;38;0
WireConnection;53;0;55;0
WireConnection;53;1;41;0
WireConnection;36;0;53;0
WireConnection;36;1;33;1
WireConnection;36;2;37;0
WireConnection;30;1;36;0
WireConnection;28;0;26;0
WireConnection;35;0;28;0
WireConnection;35;1;30;0
WireConnection;42;0;35;0
WireConnection;42;3;28;4
WireConnection;50;0;51;0
WireConnection;50;1;57;0
WireConnection;27;0;42;0
WireConnection;27;1;29;0
WireConnection;0;0;27;0
ASEEND*/
//CHKSM=3A5942F6767E3BE437C9FE8EB5CA584980913B93