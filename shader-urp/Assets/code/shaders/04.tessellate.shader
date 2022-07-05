
Shader "core/04.tessellate"
{
	Properties
	{
		_AlbedoColor ("Albedo Color", Color) = (1,1,1,1)		// 返照率乘参, 所有贴图都会配一个乘参
        _Albedo ("Albedo (RGB)", 2D) = "white" {}				// 反照率
		_Bumpiness ("Bumpiness", Range(-2, 2)) = 1				// 法线强度, 缩放凹凸
		[NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}		// 法线贴图
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)// 自发光乘参, 因为自发光有时会超过1, 因此开启HDR
		[NoScaleOffset]_Emission("Emission", 2D) = "white" {}	// 自发光

        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0


        _Tessellation("Tessellation", Range(1, 32)) = 1         // 细分等级小于或等于0, 否则vertex会消失
        [NoScaleOffset]_HeightMap("Height Map", 2D) = "gray" {} // 高度图
        _Height("Height", Range(0, 1)) = 0                      // 模型顶点偏移距离
        _EdgeLength("Edge Length", Range(1, 32)) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry" }
		Cull Back

		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Lambert tesselate:tessellationEdgeLength vertex:height addshadow nolightmap
        #include "UnityCG.cginc"
        #include "Tessellation.cginc"

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

		half _Glossiness;
		half _Metallic;
		
        half _Tessellation;
        sampler2D _HeightMap;
        float4 _HeightMap_ST;
        half _Height;
        half _EdgeLength;

        float4 tessellation() {
            return _Tessellation;
        }

        float4 tessellationEdgeLength(appdata_full v0, appdata_full v1, appdata_full v2) {
            return UnityEdgeLengthBasedTess(v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
        }

        void height(inout appdata_full v) {
            float2 texcoord = TRANSFORM_TEX(v.texcoord, _HeightMap);
            float h = tex2Dlod(_HeightMap, float4(texcoord.xy, 0, 0)).r * _Height;
            v.vertex.xyz += v.normal * h;
        }

		void surf(Input input , inout SurfaceOutput output)
		{
            // ONE
            fixed4 c = tex2D(_Albedo, input.uv_Albedo) * _AlbedoColor; // 讲道理每一个texture都有一个乘参
            output.Albedo = c.rgb;	//  albedo与alpha是一对, 加起来恰好是一个float4, 因此albedo是rgb
			output.Alpha = c.a;
			
			// tangent空间法线
			output.Normal = UnpackScaleNormal(tex2D(_Normal, input.uv_Albedo), _Bumpiness);
			// 自发光
			output.Emission = (tex2D(_Emission, input.uv_Albedo ) * _EmissionColor).rgb;

            // Metallic and smoothness come from slider variables
            // output.Metallic = _Metallic;
            // output.Smoothness = _Glossiness;
		}

		ENDCG
	}

	Fallback "Diffuse"
}