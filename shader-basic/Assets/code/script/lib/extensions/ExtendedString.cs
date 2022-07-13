
/********************************************************************
created:	2011-11-11
author:		lixianmin

purpose:	extension methods for string
Copyright (C) - All Rights Reserved
*********************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public static class ExtendedString
{
	public static bool IsNullOrEmpty(this string s)
	{
		return string.IsNullOrEmpty(s);
	}

	public static string Join<T>(this string s, IEnumerable<T> collection)
	{
		var iter	= collection.GetEnumerator();
		if(!iter.MoveNext())
		{
			return string.Empty;
		}

		StringBuilder sb	= new StringBuilder();
		sb.Append(iter.Current);
		while(iter.MoveNext())
		{
			sb.Append(s);
			sb.Append(iter.Current);
		}

		return sb.ToString();
	}

	public static string Join<T>(this string s, IEnumerable<T> collection, Func<T, string> func)
	{
		var iter	= collection.GetEnumerator();
		if(!iter.MoveNext())
		{
			return string.Empty;
		}

		StringBuilder sb	= new StringBuilder();
		sb.Append(func(iter.Current));
		while(iter.MoveNext())
		{
			sb.Append(s);
			sb.Append(func(iter.Current));
		}

		return sb.ToString();
	}

	public static string JoinParams(this string s, params string[] args)
	{
		return s.Join<string>(args);
	}
	
	public static IEnumerable<int> IndexOfAll(this string s, char c)
	{
		if(s.IsNullOrEmpty())
			yield break;
		
		int index = 0;
		foreach(char tt in s)
		{
			if(tt == c)
				yield return index;
			++index;
		}
	}
}
