
/****************************************************************************
created:	2022-07-15
author:		lixianmin

https://zhuanlan.zhihu.com/p/73524739  Unity Shader——水桶里的圆形波纹水面

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "basics/07.water.wave"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_MainColor("Main Coloe (RGBA)", Color) = (1, 1, 1, 1)
		_WaveHeight("Wave Height",Range(0, 0.2)) = 0.01
		_WaveFrequency("Wave Frequency",Range(1, 200)) = 50
		_WaveSpeed("Wave Speed",Range(0, 10)) = 1
	}

	SubShader
	{
		Tags { "RenderType" = "Transparent"  "Queue" = "Transparent" }

        Pass 
        {
            ZWrite  Off // 凡透明的, 都需要关写深度
            Blend   SrcAlpha One    // 这样的话, 
            // Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            
            struct v2f
            {
                float4 positionCS   :SV_POSITION;
	            float2 uv           :TEXCOORD0;
            };

            sampler2D   _MainTex;
            float4      _MainTex_ST;
            fixed4      _MainColor;

            float   _WaveHeight;
            float   _WaveFrequency;
            float   _WaveSpeed;


            v2f vert (appdata_base v)
            {
                v2f o;
                o.positionCS = UnityObjectToClipPos(v.vertex.xyz);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                float2 uvCenter = _MainTex_ST.xy * 0.5;     // xy是uv的tiling, xy*0.5代表中心点

				half uvDistance = distance(i.uv, uvCenter); // 到center的距离
				clip(uvCenter - uvDistance);                // 裁剪一个圆形出来

				half2 uvDir = normalize(i.uv - uvCenter);   // uvDir指明波纹扩散的方向, 下面的sin()系列计算一直是标量, 直到乘以uvDir
                // 以下是正弦波函数
                // 1. _WaveHeight用于控制振幅 (amplitude) 
                // 2. _WaveFrequency用于控制频率, 值越大, 波纹频率越高
                // 3. uvDistance用于表示距离中心点不同距离的地方频率不同, 否则表现出正弦波的震荡性
                // 4. _Time.y*_WaveSpeed用于控制初始相位, 这个值随时间一直变, 就意味着正弦波在移动
                // 4. uvDir定义波纹扩散的方向, 在乘以uvDir之前, 正弦波的计算一直是标量
				half2 uv = i.uv + _WaveHeight * sin(_WaveFrequency * uvDistance - _Time.y*_WaveSpeed) * uvDir;

				half4 color;
				color.rgb = tex2D(_MainTex, uv) * _MainColor;
				color.a = _MainColor.a;

                // color.xyz = half3(0, 0, 0);
                // color.x = uvCenter.y;
				return color;
            }

            ENDCG
        }
    }

    Fallback "Transparent"
}