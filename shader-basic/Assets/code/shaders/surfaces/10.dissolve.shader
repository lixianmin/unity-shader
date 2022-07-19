Shader "surfaces/10.dissolve"
{
    Properties
    {
        _NoiseTex("Noise", 2D) = "white"{} //Noise贴图
        _RampTex("Ramp", 2D) = "black"{} //渐变贴图
        _Dissolve("Dissolve", Range(0, 1)) = 0 //消融程度
        _Emission("Emission", float) = 1 //自发光强度

        _MainTex("Albedo", 2D) = "white"{}
        _Specular("Specular", 2D) = "black"{}
        _Normal("Normal", 2D) = "bump"{}
        _AO("AO", 2D) = "white"{}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="AlphaTest" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf StandardSpecular addshadow fullforwardshadows
        #pragma target 3.0

        sampler2D _NoiseTex;
        sampler2D _RampTex;
        fixed _Dissolve;
        float _Emission;

        sampler2D _MainTex;
        sampler2D _Specular;
        sampler2D _Normal;
        sampler2D _AO;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed Noise = tex2D(_NoiseTex, IN.uv_NoiseTex).r;
            fixed dissolve = _Dissolve * 2 - 1; //将范围从[0,1]重新映射为[-1,1]
            clip(Noise - dissolve - 0.5); //Alpha Test函数，结果小于0的像素会被剔除

            fixed border = 1 - saturate(saturate(((Noise - dissolve)) * 8 - 4)); //将计算结果的范围重新映射到[-4,4]，裁切到[0,1]然后反相
            o.Emission = tex2D(_RampTex, fixed2(border, 0.5)) * _Emission; //自发光

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb; //漫反射

            fixed4 specular = tex2D(_Specular, IN.uv_MainTex);
            o.Specular = specular.rgb; //高光
            o.Smoothness = specular.a; //光泽度
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_MainTex)); //法线
            o.Occlusion = tex2D(_AO, IN.uv_MainTex); //AO
        }
        ENDCG
    }

    FallBack "Diffuse"
}
