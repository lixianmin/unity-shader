
/********************************************************************
created:	2012-06-01
author:		lixianmin

Copyright (C) - All Rights Reserved
 *********************************************************************/
using UnityEngine;
using System;
using System.Collections.Generic;

public class GameObjectPool
{
	private GameObjectPool()
	{

	}

	public static GameObjectPool Create(GameObject prefab)
	{
		if(null == prefab)
		{
			return null;
		}

		var name	= prefab.name;
		GameObjectPool pool;
		if(!_mPools.TryGetValue(name, out pool))
		{
			pool	= new GameObjectPool();
			_mPools.Add(name, pool);
		}

		pool._prefab	= prefab;
		return pool;
	}

	public GameObject Spawn(Action<GameObject> initAction)
	{
		if(null != _prefab)
		{
			return Spawn(_prefab.transform.position, initAction) ;
		}

		DebugEx.LogError("_prefab is null");
		return null;
	}

	public GameObject Spawn(Vector3 position, Action<GameObject> initAction)
	{
		while(_objs.Count > 0)
		{
			var last	= _objs.Pop();
			if(null == last)
			{
				continue;
			}

			var transform		= last.transform;
			transform.position	= position;
			last.SetActive(true);
			return last;
		}

		if(null != _prefab)
		{
			var obj		= GameObject.Instantiate(_prefab, position, _prefab.transform.rotation) as GameObject;
			obj.name	= _prefab.name;
			obj.SetActive(true);

			if(null != initAction)
			{
				initAction(obj);
			}

			return obj;
		}

		DebugEx.LogError("_prefab is null");
		return null;
	}

	public void Destroy(GameObject obj)
	{
		if(null != obj)
		{
			obj.SetActive(false);
			_objs.Push(obj);

			// DebugEx.Log("pool={0}, obj.name={1}", GetHashCode(), obj.name);
		}
	}

	public static GameObjectPool GetPool(GameObject obj)
	{
		if(null != obj)
		{
			GameObjectPool pool;
			if(_mPools.TryGetValue(obj.name, out pool))
			{
				return pool;
			}
		}

		return null;
	}

	public void Clear()
	{
		foreach(var obj in _objs)
		{
			GameObject.Destroy(obj);
		}
	}

	public override string ToString()
	{
		return string.Format("_prefab.name={0}", null != _prefab ? _prefab.name : "NullPrefab");
	}

	// public static void HeavyDestroy(GameObject obj)
	// {
	//     if(null == obj)
	//     {
	//         return;
	//     }

	//     var pool	= GetPool(obj);
	//     if(null != pool)
	//     {
	//         pool.Destroy(obj);
	//     }
	//     else 
	//     {
	//         GameObject.Destroy(obj);
	//     }
	// }

	private static Dictionary<string, GameObjectPool>	_mPools	= new Dictionary<string, GameObjectPool>();
	private GameObject			_prefab;
	private Stack<GameObject>	_objs	= new Stack<GameObject>();
}

/********************************************************************
created:	2012-08-25
author:		lixianmin

Copyright (C) - All Rights Reserved
 *********************************************************************/

public class MBPoolDestroyer: MonoBehaviour
{
	// Use Init() to replace Awake(), because Awake() will not be called when the gameObject is not active
	public void Init()
	{
		_gameObject	= gameObject;
		_pool		= GameObjectPool.GetPool(_gameObject);
	}

	public void DestroyByPool()
	{
		if(null != _pool)
		{
			_pool.Destroy(_gameObject);
		}
		else 
		{
			GameObject.Destroy(_gameObject);
		}
	}

	private GameObjectPool	_pool;
	private GameObject		_gameObject;
}

/********************************************************************
created:	2012-08-25
author:		lixianmin

Copyright (C) - All Rights Reserved
 *********************************************************************/
public static class GameObjectExtensionDestroyByPool
{
	public static void DestroyByPool(this GameObject go)
	{
		if(null == go)
		{
			return;
		}

		var script	= go.GetComponent<MBPoolDestroyer>();
		if(null == script)
		{
			script	= go.AddComponent<MBPoolDestroyer>();
			script.Init();
		}

		script.DestroyByPool();
	}
}
