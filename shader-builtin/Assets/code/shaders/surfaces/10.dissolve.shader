Shader "surfaces/10.dissolve"
{
    Properties
    {
        [Toggle(DISSOLVE_KIND)]_DissolveKind("Dissolve Type", Int) = 1
        [Toggle(ENABLE_CLIP)] _EableClip("Enable Clip", Int) = 1
        _Dissolve("Dissolve", Range(0, 1)) = 0  // 消融程度
        _NoiseTex("Noise", 2D) = "white"{}      // Noise贴图
        _RampTex("Ramp", 2D) = "black"{}        // 渐变贴图
        _Emission("Emission", float) = 1        // 自发光强度

        _MainTex("Albedo", 2D) = "white"{}
        _Specular("Specular", 2D) = "black"{}
        _Normal("Normal", 2D) = "bump"{}
        _AO("AO", 2D) = "white"{}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="AlphaTest" }
        LOD     200
        // Cull    Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf StandardSpecular addshadow fullforwardshadows
        #pragma target 3.0
        #pragma shader_feature_local DISSOLVE_KIND
        #pragma shader_feature_local ENABLE_CLIP

        sampler2D   _NoiseTex;
        sampler2D   _RampTex;
        half        _Dissolve;
        float       _Emission;

        sampler2D   _MainTex;
        sampler2D   _Specular;
        sampler2D   _Normal;
        sampler2D   _AO;

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

        void surf (Input input, inout SurfaceOutputStandardSpecular output)
        {
            half noise = tex2D(_NoiseTex, input.uv_NoiseTex).r;

            #ifdef ENABLE_CLIP
                clip(noise - _Dissolve*1.001);  // 目标是完会消融, 因此乘以1.001以解决精度不足导致的遗留残渣
            #endif
            
            #ifdef DISSOLVE_KIND
                // Unity Shader入门精要 P1550
                // half border = 1 - smoothstep(0, 0.1, noise - _Dissolve);
                half border = smoothstep(0, noise, _Dissolve);
                // step()用于确保当_Dissolve=0的时候返回的Emission值是0
                output.Emission = tex2D(_RampTex, half2(border, 0.5)) * step(0.001, _Dissolve) * _Emission; //自发光
            #else
                // https://zhuanlan.zhihu.com/p/71523394
                half dissolve = _Dissolve * 2 - 1;  // 将范围从[0,1]映射为[-1,1]
                half border = 1 - saturate((noise - dissolve) * 8 - 4); //将计算结果的范围重新映射到[-4,4]，裁切到[0,1]然后反向
                output.Emission = tex2D(_RampTex, half2(border, 0.5)) * _Emission; //自发光
            #endif
            
            half4 c = tex2D (_MainTex, input.uv_MainTex);
            output.Albedo = c.rgb; // 返照率

            half4 specular = tex2D(_Specular, input.uv_MainTex);
            output.Specular = specular.rgb; //高光
            output.Smoothness = specular.a; //光泽度
            output.Normal = UnpackNormal(tex2D(_Normal, input.uv_MainTex)); //法线
            output.Occlusion = tex2D(_AO, input.uv_MainTex); //AO
        }
        ENDCG
    }

    FallBack "Diffuse"
}
