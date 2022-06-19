Shader "Rockie/GLSL/Mobile/Face Expression"
{
    Properties
    {
        _MainTex("Main Texture (RGBA)", 2D) = "white" {}
        _Offset("Expression Face1(x, y) Face2(z, w)", Vector) = (0.0, 0.0, 0.0, 0.0)
        _Factor("Factor", Range(0.0, 1.0)) = 0.0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
            "LightMode" = "ForwardBase"
        }

        // Pass
        pass
        {
            ColorMask RGBA

            Lighting Off
            SeparateSpecular Off
            Cull Off
            ZTest LEqual
            ZWrite On
            Fog {Mode Off}
            AlphaTest Off
            Blend SrcAlpha OneMinusSrcAlpha

            GLSLPROGRAM

            varying vec2 neTexCoord1;
            varying vec2 neTexCoord2;

#ifdef VERTEX
            uniform vec4 _MainTex_ST;
            uniform vec4 _Offset;

            void main(void)
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
                neTexCoord1 = gl_MultiTexCoord0.xy * _MainTex_ST.xy + _Offset.xy;
                neTexCoord2 = gl_MultiTexCoord0.xy * _MainTex_ST.xy + _Offset.zw;
            }
#endif

#ifdef FRAGMENT
            uniform sampler2D _MainTex;
            uniform float _Factor;

            void main(void)
            {
                vec4 face1 = texture2D(_MainTex, neTexCoord1);
                vec4 face2 = texture2D(_MainTex, neTexCoord2);
                gl_FragColor = mix(face1, face2, _Factor);
            }
#endif

            ENDGLSL
        } // Pass
    } // SubShader

    //Fallback "Mobile/Diffuse"
} // Shader
