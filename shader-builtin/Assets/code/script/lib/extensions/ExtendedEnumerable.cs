
/********************************************************************
created:	2011-11-11
author:		lixianmin

purpose:	extension methods for Enumerable
Copyright (C) - All Rights Reserved
*********************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public static class ExtendedEnumerable
{
	public static void ForEach<T>(this IEnumerable<T> collection, Action<T> action)
	{
		if(null == collection)
		{
			return;
		}

		foreach (var item in collection)
		{
			action(item);
		}
	}
}
