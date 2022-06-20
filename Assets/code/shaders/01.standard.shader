
Shader "study/01.standard"
{
	Properties
	{
		// ONE
		_AlbedoColor ("Albedo Color", Color) = (1,1,1,1)		// 返照率乘参, 所有贴图都会配一个乘参
        _Albedo ("Albedo (RGB)", 2D) = "white" {}				// 反照率
		_Bumpiness ("Bumpiness", Range(-2, 2)) = 1				// 法线强度, 缩放凹凸
		[NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}		// 法线贴图
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)// 自发光乘参, 因为自发光有时会超过1, 因此开启HDR
		[NoScaleOffset]_Emission("Emission", 2D) = "white" {}	// 自发光
		
		_Ambient("Ambient", Range( 0 , 1)) = 1					// 0:完全接受光照, 1:完全使用AO贴图
		[NoScaleOffset]_AmbientOcclusion ("Ambient Occlusion", 2D) = "white" {}	// 环境光遮挡, 控制物体对间接照明的接受程度

        _Glossiness ("Smoothness", Range(0,1)) = 0.5	// 光滑度
        [Gamma]_Metallic ("Metallic", Range(0,1)) = 0.0		// 金属质感
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
			float2 uv_Albedo;
		};

		fixed4		_AlbedoColor;
		sampler2D	_Albedo;
		half		_Bumpiness;
		sampler2D 	_Normal;
		fixed4 		_EmissionColor;
		sampler2D 	_Emission;
		
		fixed 		_Ambient;
		sampler2D 	_AmbientOcclusion;

		
		half 		_Glossiness;
		half 		_Metallic;
		

		// // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // // #pragma instancing_options assumeuniformscaling
        // UNITY_INSTANCING_BUFFER_START(Props)
        // // put more per-instance properties here
        // UNITY_INSTANCING_BUFFER_END(Props)

		// SurfaceOutputStandard = ONE + SOA
		void surf(Input input , inout SurfaceOutputStandard output)
		{
			// ONE
            fixed4 c = tex2D(_Albedo, input.uv_Albedo) * _AlbedoColor; // 讲道理每一个texture都有一个乘参
            output.Albedo = c.rgb;	//  albedo与alpha是一对, 加起来恰好是一个float4, 因此albedo是rgb
			output.Alpha = c.a;
			
			// tangent空间法线
			output.Normal = UnpackScaleNormal(tex2D(_Normal, input.uv_Albedo), _Bumpiness);
			// 自发光
			output.Emission = (tex2D(_Emission, input.uv_Albedo ) * _EmissionColor).rgb;

			// 光滑度 0:完全粗糙, 1:完全光滑
            output.Smoothness = _Glossiness;
			// 环境光遮挡 0:完全接受光照, 1:完全使用AO贴图
			output.Occlusion = lerp(fixed4( 1,1,1,1), tex2D(_AmbientOcclusion, input.uv_Albedo), _Ambient).r;

			// 金属度 0:完全粗糙, 1:完全金属
			output.Metallic = _Metallic;
		}

		ENDCG
	}

	Fallback "Diffuse"
}