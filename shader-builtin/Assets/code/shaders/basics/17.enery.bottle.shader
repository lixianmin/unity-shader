// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase/17.enery.bottle"
{
	Properties
	{
		_Value("Value", Range( 0 , 1)) = 0.5529412
		_FresnelPower("FresnelPower", Float) = 5
		[HDR]_EnergyColor("EnergyColor", Color) = (0.5257774,1,0.0235849,0)
		[HDR]_FresnelColor("FresnelColor", Color) = (0.7924528,0.5142992,0.03364185,0)
		_NoiseScale1("NoiseScale1", Float) = 1.5
		_NoiseScale2("NoiseScale2", Float) = 1.6

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
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
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				half3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half4 _EnergyColor;
			uniform half _Value;
			uniform half _NoiseScale1;
			uniform half _NoiseScale2;
			uniform half _FresnelPower;
			uniform half4 _FresnelColor;
			//https://www.shadertoy.com/view/XdXGW8
			float2 GradientNoiseDir( float2 x )
			{
				const float2 k = float2( 0.3183099, 0.3678794 );
				x = x * k + k.yx;
				return -1.0 + 2.0 * frac( 16.0 * k * frac( x.x * x.y * ( x.x + x.y ) ) );
			}
			
			float GradientNoise( float2 UV, float Scale )
			{
				float2 p = UV * Scale;
				float2 i = floor( p );
				float2 f = frac( p );
				float2 u = f * f * ( 3.0 - 2.0 * f );
				return lerp( lerp( dot( GradientNoiseDir( i + float2( 0.0, 0.0 ) ), f - float2( 0.0, 0.0 ) ),
						dot( GradientNoiseDir( i + float2( 1.0, 0.0 ) ), f - float2( 1.0, 0.0 ) ), u.x ),
						lerp( dot( GradientNoiseDir( i + float2( 0.0, 1.0 ) ), f - float2( 0.0, 1.0 ) ),
						dot( GradientNoiseDir( i + float2( 1.0, 1.0 ) ), f - float2( 1.0, 1.0 ) ), u.x ), u.y );
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				half3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
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
				half2 appendResult29 = (half2(_Time.y , 0.0));
				half2 texCoord31 = i.ase_texcoord1.xy * float2( 1,1 ) + appendResult29;
				half gradientNoise25 = GradientNoise(texCoord31,_NoiseScale1);
				gradientNoise25 = gradientNoise25*0.5 + 0.5;
				half2 appendResult12 = (half2(_Time.y , 0.0));
				half2 texCoord10 = i.ase_texcoord1.xy * float2( 1,1 ) + appendResult12;
				half gradientNoise14 = GradientNoise(texCoord10,_NoiseScale2);
				gradientNoise14 = gradientNoise14*0.5 + 0.5;
				half smoothstepResult32 = smoothstep( step( (-1.5 + (i.ase_texcoord1.xy.y - 0.0) * (2.5 - -1.5) / (1.0 - 0.0)) , ( (-2.0 + (_Value - 0.0) * (2.0 - -2.0) / (1.0 - 0.0)) + gradientNoise25 ) ) , step( (-1.5 + (i.ase_texcoord1.xy.y - 0.0) * (2.5 - -1.5) / (1.0 - 0.0)) , ( (-2.0 + (_Value - 0.0) * (2.0 - -2.0) / (1.0 - 0.0)) + gradientNoise14 ) ) , 0.5);
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				half3 ase_worldNormal = i.ase_texcoord2.xyz;
				half fresnelNdotV33 = dot( ase_worldNormal, ase_worldViewDir );
				half fresnelNode33 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV33, _FresnelPower ) );
				
				
				finalColor = ( ( _EnergyColor * ( 1.0 - smoothstepResult32 ) ) + ( fresnelNode33 * _FresnelColor ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
-254;-1035;1920;950;2022.552;329.0544;1;True;True
Node;AmplifyShaderEditor.TimeNode;30;-1969.999,-699.9768;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;7;-2004.852,205.804;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;29;-1764.877,-678.1787;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-1799.73,227.6021;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1633.135,-700.1708;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-2100.266,-249.3468;Inherit;False;Property;_Value;Value;0;0;Create;True;0;0;0;False;0;False;0.5529412;0.499;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1427.931,-474.3086;Inherit;False;Property;_NoiseScale1;NoiseScale1;4;0;Create;True;0;0;0;False;0;False;1.5;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1666.526,218.7718;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-1579.177,532.76;Inherit;False;Property;_NoiseScale2;NoiseScale2;5;0;Create;True;0;0;0;False;0;False;1.6;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-1297.221,-850.6492;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-2;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;25;-1245.199,-653.4391;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.88;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;14;-1337.294,273.1269;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.77;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;28;-1484.995,-1007.337;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;17;-1375.72,77.25358;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-2;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;19;-1404.915,-133.5648;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1042.235,198.8893;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1004.995,-692.3372;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;-1128.928,-75.48692;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1.5;False;4;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;27;-1096.588,-1008.744;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1.5;False;4;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;21;-770.2349,-47.11066;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;26;-746.9952,-704.337;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;32;-492.2349,-239.1107;Inherit;True;3;0;FLOAT;0.5;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-588.2349,148.8893;Inherit;False;Property;_FresnelPower;FresnelPower;1;0;Create;True;0;0;0;False;0;False;5;3.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;33;-374.2349,29.88934;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;37;-190.2349,-215.1107;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-186.2349,-391.1107;Inherit;False;Property;_EnergyColor;EnergyColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0.5257774,1,0.0235849,0;1,0.2156863,0.007843138,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;35;-358.2349,271.8893;Inherit;False;Property;_FresnelColor;FresnelColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0.7924528,0.5142992,0.03364185,0;0.1214263,5.148474,0.5497323,0.4980392;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;3.765137,106.8893;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;36.76514,-198.1107;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;285.7651,-19.11066;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;503.9834,-146.6636;Half;False;True;-1;2;ASEMaterialInspector;100;1;ase/17.enery.bottle;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;29;0;30;2
WireConnection;12;0;7;2
WireConnection;31;1;29;0
WireConnection;10;1;12;0
WireConnection;24;0;16;0
WireConnection;25;0;31;0
WireConnection;25;1;41;0
WireConnection;14;0;10;0
WireConnection;14;1;42;0
WireConnection;17;0;16;0
WireConnection;18;0;17;0
WireConnection;18;1;14;0
WireConnection;22;0;24;0
WireConnection;22;1;25;0
WireConnection;20;0;19;2
WireConnection;27;0;28;2
WireConnection;21;0;20;0
WireConnection;21;1;18;0
WireConnection;26;0;27;0
WireConnection;26;1;22;0
WireConnection;32;1;26;0
WireConnection;32;2;21;0
WireConnection;33;3;34;0
WireConnection;37;0;32;0
WireConnection;36;0;33;0
WireConnection;36;1;35;0
WireConnection;39;0;38;0
WireConnection;39;1;37;0
WireConnection;40;0;39;0
WireConnection;40;1;36;0
WireConnection;0;0;40;0
ASEEND*/
//CHKSM=1A09E767B6E6980411A593992C3A0FF2C190776A