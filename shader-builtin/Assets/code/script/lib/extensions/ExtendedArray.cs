
/*********************************************************************
created:	2012-07-24
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/
using System;

public static class ExtendedArray
{
	public static T[] Resize<T>(this T[] array, int newSize)
	{
		if(null == array)
		{
			var newArray	= new T[newSize];
			return newArray;
		}

		if(array.Length != newSize)
		{
			var newArray	= new T[newSize];
			Array.Copy(array, newArray, Math.Min(array.Length, newSize));
			return newArray;
		}

		return array;
	}

	public static T Get<T>(this T[] array, int index)
	{
		return array.Get(index, default(T));
	}

	public static T Get<T>(this T[] array, int index, T defaultValue)
	{
		if(null != array)
		{
			var length	= array.Length;
			if(index >= 0 && index < length)
			{
				return array[index];
			}
			else 
			{
				DebugEx.LogError("index out of range, index={0}, array.Length={1}", index.ToString(), length.ToString());
			}
		}
		else 
		{
			DebugEx.LogError("array is null");
		}

		return defaultValue;
	}
}
