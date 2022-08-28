
/****************************************************************************
created:	2022-07-27
author:		lixianmin

https://www.bilibili.com/video/BV1AY411n7TG?spm_id_from=333.999.0.0&vd_source=060cae0323076afc7bb35d1220dc6cf7
https://blog.csdn.net/derbi123123/article/details/123560062

Copyright(C) - All Rights Reserved
***************************************************************************/
Shader "basics/12.projector.decal"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent" 
            "Queue"="Transparent" 
            "IgnoreProjector"="true" 
            "DisableBatching"="true"
        }

		Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
		Cull Back

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD0;
            };

            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {   
                half2 screenPos = i.screenPos.xy / i.screenPos.w;  // 坐标齐次化
                float depth = tex2D(_CameraDepthTexture, screenPos).r;  //视图空间的深度值

                //根据深度值重建世界坐标：直接逆着流水线求世界坐标
                //裁剪空间

                half4 clipPos = half4(screenPos.x * 2 - 1, screenPos.y * 2 - 1, -depth * 2 + 1, 1) * LinearEyeDepth(depth);
                
                //还原回相机空间
				float4 viewPos = mul(unity_CameraInvProjection, clipPos);
				//还原回世界空间 unity_MatrixInvV = UNITY_MATRIX_I_V unity_CameraToWorld

				float4 worldPos = mul(unity_MatrixInvV, viewPos);

                //转为相对于本物体的局部坐标(变换矩阵都被抵消了)

                float3 objectPos = mul(unity_WorldToObject, worldPos).xyz;

                //立方体本地坐标-0.5~0.5

                clip(0.5 - abs(objectPos));
                //本地坐标中心点为0，而UV为0.5
                objectPos += 0.5;

                fixed4 col = tex2D(_MainTex, objectPos.xy);

                return col;
            }
            ENDCG
        }
    }
}

