
/********************************************************************
created:	2012-06-25
author:		lixianmin

purpose:	Extensions for System.Object
Copyright (C) - All Rights Reserved
*********************************************************************/

using UnityEngine;
using System.Text;
using System.Reflection;
using System.Collections;

public static class ExtendedObject
{
	public static void PrintFields(this object obj)
	{
		if(null == obj)
		{
			return;
		}

		var sb		= new StringBuilder();
		GetFieldDescription(obj, sb);

		var text	= sb.ToString();
		Debug.Log(text);
	}

	public static void GetFieldDescription(object obj, StringBuilder sb)
	{
		var type	= obj.GetType();
		sb.Append("{");
		sb.Append(type.FullName);
		sb.Append("} ");

		var fields	= type.GetFields(BindingFlags.Public | BindingFlags.Instance);
		foreach(var field in fields)
		{
			sb.Append(field.Name);
			sb.Append("= ");

			var fieldData	= type.InvokeMember(field.Name, BindingFlags.GetField, null, obj, null);
			var enumerated	= fieldData as IEnumerable;
			if(null != enumerated)
			{
				sb.Append("{");
				foreach(var item in enumerated)
				{
					sb.Append(item);
					sb.Append(", ");
				}
				sb.Append("} ");
			}
			else
			{
				sb.Append(fieldData);
			}

			sb.Append(", ");
		}
	}
}

