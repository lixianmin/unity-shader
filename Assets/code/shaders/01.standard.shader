
Shader "study/01.standard"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bumpiness ("Bumpiness", Range(-2, 2)) = 1
		[NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}
		[NoScaleOffset]_AO ("Ambient Occlusion", 2D) = "white" {}

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
		sampler2D _AO;


		fixed4	_Color;
		half	_Bumpiness;
		half 	_Glossiness;
		half 	_Metallic;
		

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		// SurfaceOutputStandard = ONE + SOA
		void surf(Input input , inout SurfaceOutputStandard output)
		{
            fixed4 c = tex2D(_MainTex, input.uv_MainTex) * _Color; // 讲道理每一个texture都有一个乘参
            output.Albedo = c.rgb;	//  albedo与alpha是一对, 加起来恰好是一个float4, 因此albedo是rgb
			output.Alpha = c.a;

			// tangent空间法线
			output.Normal = UnpackScaleNormal(tex2D(_Normal, input.uv_MainTex), _Bumpiness);

            // Metallic and smoothness come from slider variables
            output.Metallic = _Metallic;
            output.Smoothness = _Glossiness;
			output.Occlusion = tex2D(_AO, input.uv_MainTex);
		}

		ENDCG
	}

	Fallback "Diffuse"
}