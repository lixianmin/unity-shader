Shader "surfaces/09.stencil.glass"
{
    Properties
    {
        // _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "Queue" = "Geometry-1" } // 先于wall渲染, 意味着glass会先把Ref写入到到stencil中

        //一下为主要部分
        Stencil
        {
            Ref 1           // reference value为1, 后面wall的reference value也是1, 并且Comp条件是NotEqual, 这意味着wall永远过不了测试
            Comp Always     // 总是通过stencil test
            Pass Replace    // 结合前面的Comp Always, 意味着强写stencil的值为1
        }
        //以上为主要部分

        ColorMask   0       // 不写颜色, 否则会覆盖glass后面的物品渲染
        ZWrite      Off     // 不写深度, 否则会阻止wall的渲染

        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            // sampler2D _MainTex;

            float4 vert(in float4 vertex: POSITION) : SV_POSITION
            {
                float4 pos = UnityObjectToClipPos(vertex);
                return pos;
            }

            void frag (out half4 color: SV_TARGET)
            {
                color = half4(0, 0, 0, 0);
            }

             ENDCG
        }
    }

    // 关闭阴影
    FallBack Off
}
