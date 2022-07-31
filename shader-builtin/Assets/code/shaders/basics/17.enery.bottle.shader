// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ase/17.enery.bottle"
{
	Properties
	{
		_Value("Value", Range( 0 , 1)) = 0.5529412
		[HDR]_EnergyColor("EnergyColor", Color) = (0.5257774,1,0.0235849,0)
		[HDR]_FresnelColor("FresnelColor", Color) = (0.7924528,0.5142992,0.03364185,0)
		_FresnelPower("FresnelPower", Float) = 5
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
				half2 texCoord10 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				half2 panner43 = ( 1.0 * _Time.y * float2( 1,0 ) + texCoord10);
				half gradientNoise14 = GradientNoise(panner43,_NoiseScale2);
				gradientNoise14 = gradientNoise14*0.5 + 0.5;
				half smoothstepResult32 = smoothstep( step( (-1.5 + (texCoord31.y - 0.0) * (2.5 - -1.5) / (1.0 - 0.0)) , ( _Value + gradientNoise25 ) ) , step( (-1.5 + (texCoord10.y - 0.0) * (2.5 - -1.5) / (1.0 - 0.0)) , ( _Value + gradientNoise14 ) ) , 0.5);
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
-254;-1035;1920;1014;2250.366;405.5201;1.148115;True;True
Node;AmplifyShaderEditor.TimeNode;30;-1988.929,-772.7861;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1915.791,276.7091;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;29;-1783.807,-750.988;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;43;-1633.535,277.2738;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1579.177,532.76;Inherit;False;Property;_NoiseScale2;NoiseScale2;5;0;Create;True;0;0;0;False;0;False;1.6;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1617.235,-437.904;Inherit;False;Property;_NoiseScale1;NoiseScale1;4;0;Create;True;0;0;0;False;0;False;1.5;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1652.065,-772.9801;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;14;-1337.294,273.1269;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.77;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;25;-1323.833,-781.5833;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.88;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1865.82,-157.6071;Inherit;False;Property;_Value;Value;0;0;Create;True;0;0;0;False;0;False;0.5529412;0.499;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;-1000.784,-106.0668;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1.5;False;4;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;27;-994.6553,-978.1642;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1.5;False;4;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-978.1627,191.6084;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-967.1342,-705.4429;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;21;-693.0571,-47.11065;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;26;-675.6422,-867.4297;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-392.0833,-31.2443;Inherit;False;Property;_FresnelPower;FresnelPower;3;0;Create;True;0;0;0;False;0;False;5;3.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;32;-451.4617,-362.8866;Inherit;True;3;0;FLOAT;0.5;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;37;42.75484,-359.273;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;35;-125.2451,127.7268;Inherit;False;Property;_FresnelColor;FresnelColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0.7924528,0.5142992,0.03364185,0;0.1214263,5.148474,0.5497323,0.4980392;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;38;46.75484,-535.273;Inherit;False;Property;_EnergyColor;EnergyColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0.5257774,1,0.0235849,0;1,0.2156863,0.007843138,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;33;-141.2451,-114.2731;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;269.755,-342.2731;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;236.755,-37.2731;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;518.7546,-163.2731;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;736.9729,-290.826;Half;False;True;-1;2;ASEMaterialInspector;100;1;ase/17.enery.bottle;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;29;0;30;2
WireConnection;43;0;10;0
WireConnection;31;1;29;0
WireConnection;14;0;43;0
WireConnection;14;1;42;0
WireConnection;25;0;31;0
WireConnection;25;1;41;0
WireConnection;20;0;10;2
WireConnection;27;0;31;2
WireConnection;18;0;16;0
WireConnection;18;1;14;0
WireConnection;22;0;16;0
WireConnection;22;1;25;0
WireConnection;21;0;20;0
WireConnection;21;1;18;0
WireConnection;26;0;27;0
WireConnection;26;1;22;0
WireConnection;32;1;26;0
WireConnection;32;2;21;0
WireConnection;37;0;32;0
WireConnection;33;3;34;0
WireConnection;39;0;38;0
WireConnection;39;1;37;0
WireConnection;36;0;33;0
WireConnection;36;1;35;0
WireConnection;40;0;39;0
WireConnection;40;1;36;0
WireConnection;0;0;40;0
ASEEND*/
//CHKSM=4E925CD89E7A7E8C083C04D525D1CFA73586218E