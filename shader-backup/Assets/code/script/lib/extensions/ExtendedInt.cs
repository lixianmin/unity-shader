/********************************************************************
*		created:	2012-10-29                  	    			*
*		author :	raochao			    	    					*
*						    		    							*
*		purpose:	Extended Int						    	    *
*						    	            						*
*		Copyright (C) 2012 - All Rights Reserved    	    		*
*********************************************************************/
using UnityEngine;
using System.Collections;

public static class ExtendedUInt
{
	public static Color ToColor3(this uint color)
	{
		float r = (float)(color >> 16) / 255.0f;
		float g = (float)((color >> 8) & 0xFF) / 255.0f;
		float b = (float)(color & 0xFF) / 255.0f;
		
		return new Color(r, g, b);
	}
	
	public static Color ToColor4(this uint color)
	{
		float a = (float)(color >> 24) / 255.0f;
		float r = (float)(color >> 16 & 0xFF) / 255.0f;
		float g = (float)((color >> 8) & 0xFF) / 255.0f;
		float b = (float)(color & 0xFF) / 255.0f;
		
		return new Color(r, g, b, a);
	}
}

public static class ExtendedInt
{
	public static Color ToColor3(this int color)
	{
		float r = (float)(color >> 16) / 255.0f;
		float g = (float)((color >> 8) & 0xFF) / 255.0f;
		float b = (float)(color & 0xFF) / 255.0f;
		
		return new Color(r, g, b);
	}
	
	public static Color ToColor4(this int color)
	{
		float a = (float)(color >> 24) / 255.0f;
		float r = (float)(color >> 16 & 0xFF) / 255.0f;
		float g = (float)((color >> 8) & 0xFF) / 255.0f;
		float b = (float)(color & 0xFF) / 255.0f;
		
		return new Color(r, g, b, a);
	}
}
