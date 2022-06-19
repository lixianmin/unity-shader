
/********************************************************************
created:	2011-12-04
author:		lixianmin

Copyright (C) - All Rights Reserved
 *********************************************************************/

using UnityEngine;

public static class GDI
{
	public static void DrawRect(Rect rect, Color color, float width)
	{
#if UNITY_EDITOR
		if(Event.current.type != EventType.Repaint)
		{
			return;
		}

		var topLeft		= new Vector3(rect.x, rect.y, 0.0f);
		var topRight	= new Vector3(rect.xMax, topLeft.y, 0.0f);
		var bottomRight	= new Vector3(topRight.x, rect.yMax, 0.0f);
		var bottomLeft	= new Vector3(topLeft.x, bottomRight.y, 0.0f);

		UnityEditor.Handles.color	= color;
		UnityEditor.Handles.DrawAAPolyLine(width, new Vector3[]{topLeft, topRight, bottomRight, bottomLeft, topLeft});
#endif
	}

	public static void DrawRect(Rect rect, Color color)
	{
		DrawRect(rect, color, _defaultWidth);
	}

	public static void DrawRect(Vector2 pos1, Vector2 pos2, Color color, float width)
	{
		DrawRect(CreateRect(pos1, pos2), color, width);
	}

	public static void DrawRect(Vector2 pos1, Vector2 pos2, Color color)
	{
		DrawRect(pos1, pos2, color, _defaultWidth);
	}

	public static void DrawLine(float xPos1, float yPos1, float xPos2, float yPos2, Color color, float width)
	{
#if UNITY_EDITOR
		UnityEditor.Handles.color	= color;
		UnityEditor.Handles.DrawAAPolyLine(width, new Vector3[]{new Vector3(xPos1, yPos1, 0), new Vector3(xPos2, yPos2, 0)});
#endif
	}

	public static void DrawLine(float xPos1, float yPos1, float xPos2, float yPos2, Color color)
	{
		DrawLine(xPos1, yPos1, xPos2, yPos2, color, _defaultWidth);
	}

	public static Rect CreateRect(Vector2 pos1, Vector2 pos2)
	{
		var x	= Mathf.Min(pos1.x, pos2.x);
		var y	= Mathf.Min(pos1.y, pos2.y);
		var width	= Mathf.Abs(pos1.x - pos2.x);
		var height	= Mathf.Abs(pos1.y - pos2.y);
		return new Rect(x, y, width, height);
	}

	private const float _defaultWidth	= 3.0f;
}
