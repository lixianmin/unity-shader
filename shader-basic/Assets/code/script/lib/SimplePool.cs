
/********************************************************************
created:	2012-09-11
author:		lixianmin

Copyright (C) - All Rights Reserved
 *********************************************************************/
using UnityEngine;
using System.Collections.Generic;

public class SimplePool<T> where T: Object
{
	private SimplePool()
	{

	}

	public static SimplePool<T> Create(T prefab)
	{
		if(null == prefab)
		{
			return null;
		}

		var name	= prefab.name;
		SimplePool<T> pool;
		if(!_mPools.TryGetValue(name, out pool))
		{
			pool	= new SimplePool<T>();
			_mPools.Add(name, pool);
		}

		pool._prefab	= prefab;
		return pool;
	}

	public T Spawn(System.Action<T> initAction)
	{
		while(_objs.Count > 0)
		{
			var last	= _objs.Pop();
			if(null == last)
			{
				continue;
			}

			return last;
		}

		var obj		= Object.Instantiate(_prefab) as T;
		obj.name	= _prefab.name;
		if(null != initAction)
		{
			initAction(obj);
		}

		return obj;
	}

	public void Destroy(T obj)
	{
		if(null != obj)
		{
			_objs.Push(obj);
			// DebugEx.Log("pool={0}, obj.name={1}", GetHashCode(), obj.name);
		}
	}

	public static SimplePool<T> GetPool(T obj)
	{
		if(null != obj)
		{
			SimplePool<T> pool;
			if(_mPools.TryGetValue(obj.name, out pool))
			{
				return pool;
			}
		}

		return null;
	}

	private static Dictionary<string, SimplePool<T>>	_mPools	= new Dictionary<string, SimplePool<T>>();
	private T			_prefab;
	private Stack<T>	_objs	= new Stack<T>();
}
