
Shader "study/01.standard"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		[NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}

        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry" }
		Cull Back

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