
// /********************************************************************
// created:	2011-11-10
// author:		lixianmin

// purpose:	Extensions for GUITexture
// Copyright (C) - All Rights Reserved
// *********************************************************************/
// using UnityEngine;
// using System.Linq;

// public static class ExtendedGUITexture
// {
// 	public static void SetPixelInsetX(this GUITexture guiTexture, float x)
// 	{
// 		var old	= guiTexture.pixelInset;
// 		guiTexture.pixelInset	= new Rect(x, old.y, old.width, old.height);
// 	}

// 	public static void SetPixelInsetY(this GUITexture guiTexture, float y)
// 	{
// 		var old	= guiTexture.pixelInset;
// 		guiTexture.pixelInset	= new Rect(old.x, y, old.width, old.height);
// 	}

// 	public static void SetPixelInsetWidth(this GUITexture guiTexture, float width)
// 	{
// 		var old	= guiTexture.pixelInset;
// 		guiTexture.pixelInset	= new Rect(old.x, old.y, width, old.height);
// 	}

// 	public static void SetPixelInsetHeight(this GUITexture guiTexture, float height)
// 	{
// 		var old	= guiTexture.pixelInset;
// 		guiTexture.pixelInset	= new Rect(old.x, old.y, old.width, height);
// 	}

// 	public static bool IsInScreen(this GUITexture guiTexture)
// 	{
// 		var area	= guiTexture.pixelInset;
// 		return area.xMax >= 0 && area.yMax >= 0 && area.xMin < Screen.width && area.yMin < Screen.height;
// 	}

// 	public static void EnableWhenEnterScreen(this GUITexture guiTexture)
// 	{
// 		if(!guiTexture.enabled)
// 		{
// 			var area	= guiTexture.pixelInset;
// 			if(area.xMax >= 0 && area.yMax >= 0 && area.xMin < Screen.width && area.yMin < Screen.height)
// 			{
// 				guiTexture.enabled	= true;
// 			}
// 		}
// 	}
// }
