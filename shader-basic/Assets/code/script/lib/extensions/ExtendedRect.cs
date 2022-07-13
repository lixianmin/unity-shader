
/********************************************************************
created:	2011-12-09
author:		lixianmin

purpose:	Extensions for Rect
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;

public static class ExtendedRect
{
	public static bool IsInScreen(this Rect area)
	{
		return area.xMax >= 0 && area.yMax >= 0 && area.xMin < Screen.width && area.yMin < Screen.height;
	}

	public static bool IsIntersect(this Rect area, Rect other)
	{
		return !(other.xMax < area.x || other.yMax < area.y || other.x > area.xMax || other.y > area.yMax);
	}
}
