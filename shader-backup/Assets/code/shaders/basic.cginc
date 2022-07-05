#ifndef BASIC_INCLUDED
#define BASIC_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

float3 GetToLightDirection(float3 worldPosition)
{
	#ifndef USING_LIGHT_MULTI_COMPILE
		return _WorldSpaceLightPos0.xyz - worldPosition * _WorldSpaceLightPos0.w;
	#else
		#ifndef USING_DIRECTIONAL_LIGHT
		return _WorldSpaceLightPos0.xyz - worldPosition;
		#else
		return _WorldSpaceLightPos0.xyz;
		#endif
	#endif
}

// 计算光照相关的参数
// 1. 从attenuation计算中移除if语句:
//	  float attenuation = _WorldSpaceLightPos0.w > 0 ? (1.0 / length(toLight)) : 1.0;
// 2. 内置的lit()方法会通过判断NdotL的值是否为正直接截断高光，因为高光计算是使用NdotH，这样的话由于使用的标准不统一，会产生一个比较硬的边界（但这种算法其实是投射了自己的几何阴影，参考：CG教程 P207）
				// float4	lighting	= lit(dot(N, L), dot(N, H), _Shininess * 128.0); 
				// float4	lighting	= float4(1.0, max(0, dot(N, L)), pow(max(0, dot(N, H)), _Shininess * 128.0), 1.0);

#define CREATE_LIGHTING_VARIABLES(worldPosition, worldNormal) \
	float3	toLightDirection	= GetToLightDirection(worldPosition); \
	float	attenuation	= lerp(1.0, 1.0 / length(toLightDirection), _WorldSpaceLightPos0.w); \
	float3	L			= normalize(toLightDirection); \
	float3	N			= normalize(worldNormal); \
	float3	V			= normalize(_WorldSpaceCameraPos - worldPosition.xyz); \
	float3	H			= normalize(V + L);


/////////////this is the end line/////////////////
#endif
