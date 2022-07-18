
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
		_MainColor("Main Coloe (RGBA)", Color) = (1,1,1,1)
		_WaveHeight("Wave Height",Range(0,0.1)) = 0.01
		_WaveFrequency("Wave Frequency",Range(1,100)) = 50
		_WaveSpeed("Wave Speed",Range(0,10)) = 1
	}

	SubShader
	{
		Tags { "RenderType" = "Transparent"  "Queue" = "Transparent" }

        Pass 
        {
            ZWrite Off

            CGPROGRAM
            
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            
            struct v2f
            {
                float4 pos  :SV_POSITION;
	            float2 uv   :TEXCOORD0;
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
                o.pos = UnityObjectToClipPos(v.vertex.xyz);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                float2 uvCoord = _MainTex_ST.xy*0.5;

				fixed2 uvDir = normalize(i.uv - uvCoord);
				fixed uvDis = distance(i.uv, uvCoord);

				clip(uvCoord-uvDis);

				fixed2 uv = i.uv + sin(uvDis*_WaveFrequency - _Time.y*_WaveSpeed)*_WaveHeight*uvDir;

				fixed4 color;
				color.rgb = tex2D(_MainTex, uv)*_MainColor;
				color.a = _MainColor.a;
				return color;
            }

            ENDCG
        }
    }

    Fallback "Transparent"
}