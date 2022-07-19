
Shader "surfaces/08.rim"
{
	Properties
	{
        [Header(Standard Part)]
        [Space(10)]
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
        [Gamma]_Metallic ("Metallic", Range(0,1)) = 0.0	// 金属质感

        [Header(Rim Part)]
        [Space(10)]
        _RimColor("Rim Color", Color)	= (.26, .19, .16, 1)
        _RimWidth("Rim Width", Float)	= 0.0
		_RimPower("Rim Power", Range(0, 5)) = 1.5
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry" }
		Cull Back

		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard fullforwardshadows 

        // 参考: https://docs.unity.cn/cn/2019.4/Manual/SL-SurfaceShaders.html
		struct Input
		{
			float2 uv_Albedo;
            // float3 worldPos;
            // float3 worldNormal; // 通常用不上, 通用做法是直接使用WorldNormalVector(input, output.Normal);
            float3 viewDir; // viewDir有可能在world空间或tangent空间中. 参考: https://forum.unity.com/threads/confusion-about-worldnormal-in-surface-shader.427413/
            INTERNAL_DATA   // 当overwrite output.Normal时是指从tangent到world的转换矩阵, 否则是空. 所以可以无脑带着
		};

		half4		_AlbedoColor;
		sampler2D	_Albedo;
		half		_Bumpiness;
		sampler2D 	_Normal;
		half4 		_EmissionColor;
		sampler2D 	_Emission;
		
		half 		_Ambient;
		sampler2D 	_AmbientOcclusion;

		half 		_Glossiness;
		half 		_Metallic;

        half4       _RimColor;
        half        _RimWidth;
        half        _RimPower;
		
		// // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		// SurfaceOutputStandard = ONE + SOA
		void surf(Input input , inout SurfaceOutputStandard output)
		{
			// ONE
            half4 c = tex2D(_Albedo, input.uv_Albedo) * _AlbedoColor; // 讲道理每一个texture都有一个乘参
            output.Albedo = c.rgb;	//  albedo与alpha是一对, 加起来恰好是一个float4, 因此albedo是rgb
			output.Alpha = c.a;
			
            // 参考: https://forum.unity.com/threads/confusion-about-worldnormal-in-surface-shader.427413/
            // 
            // 选中 Surface Shader, 并点击Show generated code 看到从surface shader生成的源代码
            // 1. 默认情况下, input.viewDir与output.Normal都是world空间的
			// 2. 但覆写output.Normal会导致input.viewDir与output.Normal变成tangent空间的值
            // 3. 不管是否覆写outpu.Normal的值, 在surface shader中, 永远可以使用WorldNormalVector()来取得world空间的向量值
            //   half3 normalWS = WorldNormalVector(input, output.Normal);
            //   half3 viewDirWS = WorldNormalVector(input, input.viewDir);
			output.Normal = UnpackScaleNormal(tex2D(_Normal, input.uv_Albedo), _Bumpiness);

			// 自发光
			output.Emission = (tex2D(_Emission, input.uv_Albedo ) * _EmissionColor).rgb;

			// 光滑度 0:完全粗糙, 1:完全光滑
            output.Smoothness = _Glossiness;
			// 环境光遮挡 0:完全接受光照, 1:完全使用AO贴图
			output.Occlusion = lerp(fixed4( 1,1,1,1), tex2D(_AmbientOcclusion, input.uv_Albedo), _Ambient).r;

			// 金属度 0:完全粗糙, 1:完全金属
			output.Metallic = _Metallic;

            // Rim属于自发光部分: rim属于视角上的边缘检测
            // 
            // // 以下是在world空间的向量计算
            // half3 normalWS = WorldNormalVector(input, output.Normal);
            // half3 viewDirWS = WorldNormalVector(input, input.viewDir);
            // half rim = 1.0 - saturate(dot(normalWS, viewDirWS) + _RimWidth);
            // 
            // // 也可以直接使用tangent空间计算
            half rim = 1.0 - saturate(dot(output.Normal, input.viewDir) + _RimWidth); 
			output.Emission.rgb += _RimColor.rgb * pow(rim, _RimPower) * _RimColor.a;
		}

		ENDCG
	}

	Fallback "Diffuse"
}