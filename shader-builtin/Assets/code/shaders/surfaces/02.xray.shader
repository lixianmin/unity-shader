
Shader "surfaces/02.xray"
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
		_AlbedoColor ("Albedo Color", Color) = (1,1,1,1)		// 返照率乘参, 所有贴图都会配一个乘参
        _Albedo ("Albedo (RGB)", 2D) = "white" {}				// 反照率
		_Bumpiness ("Bumpiness", Range(-2, 2)) = 1				// 法线强度, 缩放凹凸
		[NoScaleOffset]_Normal ("Normal", 2D) = "bump" {}		// 法线贴图
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)// 自发光乘参, 因为自发光有时会超过1, 因此开启HDR
		[NoScaleOffset]_Emission("Emission", 2D) = "white" {}	// 自发光


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
                float4 vertex		: POSITION;
                float3 viewDir 		: TEXCOORD0;
                float3 worldNormal 	: NORMAL;
            };

            fixed4 	_XRayColor;
            fixed 	_XRayWidth;
            half 	_XRayBrightness;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Fresnel算法
                half nv = saturate(dot(i.worldNormal, i.viewDir));
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

            // Metallic and smoothness come from slider variables
            output.Metallic = _Metallic;
            output.Smoothness = _Glossiness;
		}

		ENDCG
	}

	Fallback "Diffuse"
}