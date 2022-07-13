#ifndef IMAGE_INCLUDED
#define IMAGE_INCLUDED

// // 灰度图
// float GetGrayColor(float4 color)
// {
//     float  result  = .3 * color.x + .59 * color.y + .11 * color.z;
//     return result;
// }

// // 浮雕
// float4 Relief(float2 texcoord)
// {
//     float2 upLeftUV		= float2(texcoord.x - 1.0/TexSize.x, texcoord.y - 1.0 / TexSize.y);
//     float4 bkColor		= float4(.5, .5, .5, 1.0);
//     float4 baseColor	= tex2D(Texture0, texcoord);
//     float4 upLeftColor	= tex2D(Texture0, upLeftUV);
//     float4 deltaColor	= baseColor - upLeftColor;
//     float  gray       	= GetGrayColor(deltaColor);
//     float4 result		= float4(gray, gray, gray, 1.0) + bkColor;
//     return result;
// }

// // 马赛克
// float4 Masaic(float2 texcoord)
// {
//     float2 masaicSize	= float2(8, 8);
//     float2 pixelCoord	= float2(texcoord.x * TexSize.x, texcoord.y * TexSize.y);
//     pixelCoord			= float2(int(pixelCoord.x / masaicSize.x) * masaicSize.x, int(pixelCoord.y / masaicSize.y) * masaicSize.y);
//     texcoord			= float2(pixelCoord.x / TexSize.x, pixelCoord.y / TexSize.y);
//     float4 baseColor	= tex2D(Texture0, texcoord);
//     float4 result		= baseColor;
//     return result;
// }

// // 马赛克2
// float4 Masaic2(float2 texcoord)
// {
//     float	radius		= 8.0f;
//     float	size		= radius * 2;
//     float2	pixelCoord	= float2(texcoord.x * TexSize.x, texcoord.y * TexSize.y);
//     float2	center		= float2(int(pixelCoord.x / size) * size + radius, int(pixelCoord.y / size) * size + radius);
//     float	squaredDistance	= distance(center, pixelCoord);
//     float4	baseColor;
//     if(squaredDistance < radius)
//     {
//         float2	uvCenter= float2(center.x / TexSize.x, center.y /TexSize.y);
//         baseColor	= tex2D(Texture0, uvCenter);
//     }
//     else
//     {
//         baseColor	= tex2D(Texture0, texcoord);
//     }

//     float4 result		= baseColor;
//     return result;
// }

// 用来做滤波操作的函数
float4 DipFilter(float3x3 theFilter, sampler2D image, float2 pixelCoord, float2 texelSize)
{
	float2 deltaFilterPos[3][3]=
	{
		{ float2(-1.0, -1.0), float2(0.0, -1.0), float2(1.0, -1.0)},
		{ float2( 0.0, -1.0), float2(0.0,  0.0), float2(1.0, 0.0)},
		{ float2(+1.0, -1.0), float2(0.0, +1.0), float2(1.0, +1.0)},
	};

	float4 finalColor	= float4(0, 0, 0, 0);
	for(int i= 0; i< 3; ++i)
	{
		for(int j= 0; j< 3; ++j)
		{
			float2 sampleCoord	= float2(pixelCoord.x + deltaFilterPos[i][j].x, pixelCoord.y + deltaFilterPos[i][j].y);
			float2 uvSample		= float2(sampleCoord.x * texelSize.x, sampleCoord.y * texelSize.y);
			finalColor	+= tex2D(image, uvSample) * theFilter[i][j];
		}
	}

	return finalColor;
}

float4 GaussianFilter(sampler2D image, float2 texcoord, float2 texelSize)
{
	float2 pixelCoord	= float2(texcoord.x / texelSize.x, texcoord.y / texelSize.y);
	float3x3 theFilter	= 1/16.0 * float3x3(1, 2, 1,
										   2, 4, 2,
										   1, 2, 1);
	return DipFilter(theFilter, image, pixelCoord, texelSize);
}

// float4 LaplacianFilter(sampler2D image, float2 texcoord, float2 texelSize)
// {
//     float2 pixelCoord	= float2(texcoord.x / texelSize.x, texcoord.y / texelSize.y);
//     float3x3 theFilter	= float3x3(-1, -1, -1,
//                                    -1, 9, -1,
//                                    -1, -1, -1);
//     return DipFilter(theFilter, image, pixelCoord, texelSize);
// }

float SobelFilter(sampler2D image, float2 texcoord, float2 texelSize)
{
	float offset= texelSize.x;

	// Sample neighbor pixels
	float s00	= tex2D(image, texcoord + float2(-offset, -offset)).r;
	float s01	= tex2D(image, texcoord + float2(0,	   -offset)).r;
	float s02	= tex2D(image, texcoord + float2(+offset, -offset)).r;

	float s10	= tex2D(image, texcoord + float2(-offset, 0)).r;
	float s12	= tex2D(image, texcoord + float2(+offset, 0)).r;

	float s20	= tex2D(image, texcoord + float2(-offset, +offset)).r;
	float s21	= tex2D(image, texcoord + float2(0,		  +offset)).r;
	float s22	= tex2D(image, texcoord + float2(+offset, +offset)).r;

	// Sobel filter in X direction
	float sobelX	= s00 + 2 * s10 + s20 - s02 - 2 * s12 - s22;
	// Sobel filter in Y direction
	float sobelY	= s00 + 2 * s01 + s02 - s20 - 2 * s21 - s22;

	// Find edge, skip sqrt() to improve performance...
	float edgeSquared	= (sobelX * sobelX + sobelY * sobelY);
	return edgeSquared;

	// // ... and threshold against a squared value instead
	// float isEdge	= edgeSquared > 0.07 * 0.07;
}