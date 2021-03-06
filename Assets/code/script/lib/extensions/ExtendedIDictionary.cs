
/********************************************************************
created:	2011-10-20
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;

public static class ExtendedIDictionary
{	
	public static Value Get<Key, Value>(this IDictionary<Key, Value> dict, Key key)
	{
		return dict.Get(key, default(Value));
	}

	public static Value Get<Key, Value>(this IDictionary<Key, Value> dict, Key key, Value defaultValue)
	{
		Value v;
		if(dict.TryGetValue(key, out v))
		{
			return v;
		}

		return defaultValue;
	}

	public static Value SetDefault<Key, Value>(this IDictionary<Key, Value> dict, Key key)
	{
		return dict.SetDefault(key, default(Value));
	}

	public static Value SetDefault<Key, Value>(this IDictionary<Key, Value> dict, Key key, Value defaultValue)
	{
		Value v;
		if (!dict.TryGetValue(key, out v))
		{
			v	= defaultValue;
			dict.Add(key, v);
		}

		return v;
	}

	public static Value SetDefault<Key, Value>(this IDictionary<Key, Value> dict, Key key, Func<Value> creater)
	{
		Value v;
		if (!dict.TryGetValue(key, out v))
		{
			v	= creater();
			dict.Add(key, v);
		}

		return v;
	}

	public static Value SetDefault<Key, Value>(this IDictionary<Key, Value> dict, Key key, Func<Key, Value> creater)
	{
		Value v;
		if (!dict.TryGetValue(key, out v))
		{
			v	= creater(key);
			dict.Add(key, v);
		}

		return v;
	}

	public static void AddRange<Key, Value>(this IDictionary<Key, Value> dictTo, IDictionary<Key, Value> dictFrom) where Key : IComparable
	{
		foreach(var pair in dictFrom)
		{
			dictTo[pair.Key]	= pair.Value;
		}
	}
}
