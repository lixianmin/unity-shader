
/********************************************************************
created:	2013-4-6
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;

public class PureColorMaterial
{
	public static Material Create(Color color)
	{
		var contents	= new System.Text.StringBuilder("Shader \"Hidden/___PureColorMaterial___\" { SubShader{ Pass { Color(", 128);
		contents.Append(color.r.ToString());
		contents.Append(",");
		contents.Append(color.g.ToString());
		contents.Append(",");
		contents.Append(color.b.ToString());
		contents.Append(",");
		contents.Append(color.a.ToString());
		contents.Append(") }}}");

		return new Material(contents.ToString());
	}
}
