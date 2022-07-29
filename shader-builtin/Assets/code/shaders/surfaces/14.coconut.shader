
Shader "surfaces/14.coconut"
{
	Properties
	{
		_Color1("Outside Color", Color) = (1, 1, 1, 1)
		_Color2("Section Color", Color) = (1, 1, 1, 1)
		_Color3("Inner Color", Color) = (1, 1, 1, 1)

		_EdgeWidth("Edge Width", Range(0.1, 0.9)) = 0.9
		_Height("Height Value", Float) = 0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry" }
		Cull Back

		CGPROGRAM
		#pragma surface surf Standard

		struct Input
		{
            float3 worldPos;
		};

		half4		_Color1;
		half4		_Color2;
		half4		_Color3;

		half		_EdgeWidth;
		half		_Height;

		// pass1: outside front
		void surf(Input input , inout SurfaceOutputStandard output)
		{
			if (input.worldPos.y > _Height)
				discard;

            output.Albedo = _Color1.rgb;
			output.Alpha = _Color1.a;
		}

		ENDCG

		// pass2: outside back
		Pass
		{
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			half4	_Color2;
			half	_Height;

			struct v2f
			{
				float4 pos			: SV_POSITION;
				float4 positionWS	: TEXCOORD0;
			};

			v2f vert(appdata_base input)
			{
				v2f output;
				output.pos = UnityObjectToClipPos(input.vertex);
				output.positionWS = mul(unity_ObjectToWorld, input.vertex);

				return output;
			}

			half4 frag(v2f input): SV_Target
			{
				if (input.positionWS.y > _Height)
					discard;

				return _Color2;
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}