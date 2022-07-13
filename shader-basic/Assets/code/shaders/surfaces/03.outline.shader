
Shader "surfaces/03.outline"
{
	Properties
	{
		[Header(The Outline Part)]
        [Space(10)]
        _OutlineColor ("Outline Color", Color) = (0,1,1,1)
        _OutlineWidth ("Outline Width", Range(0, 0.1)) = 0.01

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
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+10" }
		Cull Back

		//---------- The Outline Part ----------
		// 可以在surface shader之外单独加一个pass
        Pass
        {
            ZTest LEqual    // 保持正确的渲染顺序
            ZWrite Off      // 这个必须是off, 如果是On则物体本身就会被遮挡住. 但ZWrite关闭的话, 轮廓线就会被其它物体遮挡, 解决的办法就是调整Queue=Geometry+100s  

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : POSITION;
            };

            fixed   _OutlineWidth;
            fixed4  _OutlineColor;

            v2f vert(appdata_base v)
            {
                // 在Object坐标系中延法线方向延长vertex, 不能在world坐标系中延长, 原因是world坐标系的原点在很远的地方啊
                v2f o;
                v.vertex.xyz += v.normal * _OutlineWidth;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
        
            fixed4 frag(v2f i) : SV_Target
            {
                return _OutlineColor;
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