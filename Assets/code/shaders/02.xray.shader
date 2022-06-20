
Shader "study/02.xray"
{
	Properties
	{
		[Header(The Blocked Part)]
        [Space(10)]
        _XRayColor ("X-Ray Color", Color) = (0,1,1,1)
        _XRayWidth ("X-Ray Width", Range(1, 2)) = 1
        _XRayBrightness ("X-Ray Brightness",Range(0, 2)) = 1

		[Header(The Normal Part)]
        [Space(10)]
		_Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		[NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry" }
		Cull Back

		//---------- The Blocked Part ----------
		// 可以在surface shader之外单独加一个pass
        Pass
        {
            ZTest Greater
            ZWrite Off

            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertexPos	: POSITION;
                float3 viewDir 		: TEXCOORD0;
                float3 worldNor 	: TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.vertexPos = UnityObjectToClipPos(v.vertex);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.worldNor = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 _XRayColor;
            fixed _XRayWidth;
            half _XRayBrightness;

            float4 frag(v2f i) : SV_Target
            {
                // Fresnel算法
                half nv = saturate(dot(i.worldNor, i.viewDir));
                nv = pow(1 - nv, _XRayWidth) * _XRayBrightness;

                fixed4 color;
                color.rgb = _XRayColor.rgb;
                color.a = nv;

                return color;
            }

            ENDCG
        }

        //---------- The Normal Part ----------

		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard fullforwardshadows 

		struct Input
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		sampler2D _Normal;

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
       // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
       // #pragma instancing_options assumeuniformscaling
       UNITY_INSTANCING_BUFFER_START(Props)
       // put more per-instance properties here
       UNITY_INSTANCING_BUFFER_END(Props)

		void surf(Input input , inout SurfaceOutputStandard output)
		{
            fixed4 c = tex2D(_MainTex, input.uv_MainTex) * _Color;
            output.Albedo = c.rgb;
			output.Alpha = c.a;

			output.Normal = UnpackNormal(tex2D(_Normal, input.uv_MainTex));

            // Metallic and smoothness come from slider variables
            output.Metallic = _Metallic;
            output.Smoothness = _Glossiness;
		}

		ENDCG
	}

	Fallback "Diffuse"
}