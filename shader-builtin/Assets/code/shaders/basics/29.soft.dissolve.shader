// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "29.soft.dissolve"
{
	Properties
	{
		_DissolveTex("DissolveTex", 2D) = "white" {}
		_DissolveIntensity("DissolveIntensity", Range( 0 , 1)) = 0.5176471
		_DissolveSoft("DissolveSoft", Range( 0 , 1)) = 0.3529412
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _DissolveSoft;
			uniform sampler2D _DissolveTex;
			uniform float4 _DissolveTex_ST;
			uniform float _DissolveIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode7 = tex2D( _MainTex, uv_MainTex );
				float temp_output_14_0_g4 = (0.51 + (_DissolveSoft - 0.0) * (1.0 - 0.51) / (1.0 - 0.0));
				float2 uv_DissolveTex = i.ase_texcoord1.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
				float smoothstepResult13_g4 = smoothstep( ( 1.0 - temp_output_14_0_g4 ) , temp_output_14_0_g4 , ( tex2D( _DissolveTex, uv_DissolveTex ).r + 1.0 + ( (0.0 + (_DissolveIntensity - 0.0) * (1.001 - 0.0) / (1.0 - 0.0)) * -2.0 ) ));
				float4 appendResult10 = (float4(tex2DNode7.rgb , ( tex2DNode7.a * smoothstepResult13_g4 )));
				
				
				finalColor = appendResult10;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
-254;-1035;1920;1014;1008;551;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-445,47;Inherit;False;Property;_DissolveIntensity;DissolveIntensity;1;0;Create;True;0;0;0;False;0;False;0.5176471;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-441,161;Inherit;False;Property;_DissolveSoft;DissolveSoft;2;0;Create;True;0;0;0;False;0;False;0.3529412;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-438,-187;Inherit;True;Property;_DissolveTex;DissolveTex;0;0;Create;True;0;0;0;False;0;False;1207268d358cd480ebd13231ed564384;1207268d358cd480ebd13231ed564384;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;7;-435,-409;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;-1;df7c91fd1c31040fba8f98b3335d5f7e;df7c91fd1c31040fba8f98b3335d5f7e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;11;-90,-20;Inherit;False;SoftDissolve;-1;;4;38c89c87942704644b60d61ae86fe520;0;3;18;SAMPLER2D;0;False;6;FLOAT;0.26;False;15;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;172,-193;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;343,-278;Inherit;True;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;588,-254;Float;False;True;-1;2;ASEMaterialInspector;100;1;29.soft.dissolve;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;11;18;4;0
WireConnection;11;6;5;0
WireConnection;11;15;6;0
WireConnection;8;0;7;4
WireConnection;8;1;11;0
WireConnection;10;0;7;0
WireConnection;10;3;8;0
WireConnection;0;0;10;0
ASEEND*/
//CHKSM=81A1B06177BBF30123648BB4D92FAD2CF06431A8