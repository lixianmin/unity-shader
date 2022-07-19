Shader "surfaces/09.pierce.glass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags { "Queue" = "Geometry-1" }

        //一下为主要部分
        Stencil
        {
            Ref 1
            Comp Always
            Pass Replace
        }
        //以上为主要部分

        ColorMask 0
        ZWrite Off

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
