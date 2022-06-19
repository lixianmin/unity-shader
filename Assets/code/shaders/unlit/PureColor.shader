
/****************************************************************************
created:	2013-03-02
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

Shader "Unlit/PureColor"
{
	Properties
	{
		_Color ("Main Color", Color)	= (0.5, 0.5, 0.5, 0.5) 
	}

	SubShader
	{
		Tags 
		{ 
			"Queue"				= "Geometry" 
			"IgnoreProjector"	= "True"
			"RenderType"		= "Opaque"
		}

		LOD	200

		Pass 
		{
			Lighting	Off
			Cull		Back
			Color		[_Color]
		}
	}
}
