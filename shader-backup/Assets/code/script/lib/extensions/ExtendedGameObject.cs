
/********************************************************************
created:	2011-12-11
author:		lixianmin

purpose:	Extensions for GameObject
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System;
using System.Collections.Generic;

public static class ExtendedGameObject
{	
	public static void ForEach_Depth(this GameObject prefab, System.Action<GameObject> action)
	{
		if(null == prefab)
		{
			return;
		}
		
		if( action!=null)
		{
			action(prefab);
		}
		
		foreach( Transform t in prefab.transform)
		{
			ForEach_Depth(t.gameObject,action);
		}
	}

	public static GameObject Clone(this GameObject prefab)
	{
		if(null == prefab)
		{
			return null;
		}

		var cloned					= GameObject.Instantiate(prefab) as GameObject;
		var prefabTransform			= prefab.transform;
		cloned.transform.parent		= prefabTransform.parent;
		// in NGUI, the localScale will be adjusted automatically according to the scale of camera. so restore it.
		cloned.transform.localScale	= prefabTransform.localScale;
		return cloned;
	}

	public static GameObject ReplacedByPrefab(this GameObject go, GameObject prefab)
	{
		if(null == go || null == prefab)
		{
			return null;
		}

		var cloned					= GameObject.Instantiate(prefab) as GameObject;
		var oldTransform			= go.transform;
		cloned.transform.parent		= oldTransform.parent;
		// in NGUI, the localScale will be adjusted automatically according to the scale of camera. so restore it.
		cloned.transform.localScale	= oldTransform.localScale;
		GameObject.Destroy(go);
		return cloned;
	}

	public static GameObject GetChildByName(this GameObject go, string name)
	{
		if(null != go)
		{
			foreach(Transform child in go.transform)
			{
				if(child.name == name)
				{
					return child.gameObject;
				}

				var grandson	= child.gameObject.GetChildByName(name);
				if(null != grandson)
				{
					DebugEx.Assert(grandson.name == name);
					return grandson;
				}
			}
		}

		return null;
	}

	public static GameObject[] GetDirectChildren(this GameObject go, string[] names)
	{
		if(null != go && null != names)
		{
			var goes	= new GameObject[names.Length];
			for(int i= 0; i< names.Length; ++i)
			{
				var name	= names[i];
				foreach(Transform child in go.transform)
				{
					if(child.name == name)
					{
						goes[i]	= child.gameObject;
						break;
					}
				}
			}

			return goes;
		}

		return null;
	}

	public static IEnumerable<GameObject> GetDirectChildren(this GameObject go)
	{
		if(null != go)
		{
			foreach(Transform child in go.transform)
			{
				yield return child.gameObject;
			}
		}
	}

	public static string GetPath(this GameObject go)
	{
		GameObject current = go;
		string path = current.name;

		while(null != current.transform.parent)
		{
			current = current.transform.parent.gameObject;
			path = current.name + "/" + path;
		}

		return path;
	}

	public static void SetLayerRecursively(this GameObject go, string layer)
	{
		if(null == go)
			return;

		go.layer = LayerMask.NameToLayer(layer);
		foreach(Transform child in go.transform)
			child.gameObject.SetLayerRecursively(layer);
	}
	
	public static void SetLayerRecursively(this GameObject go, int layer)
	{
		if(null == go)
			return;

		go.layer = layer;
		foreach(Transform child in go.transform)
			child.gameObject.SetLayerRecursively(layer);
	}

	public static IEnumerable<GameObject> WalkTree(this GameObject root)
	{
		if(null != root)
		{
			yield return root;

			foreach(Transform child in root.transform)
			{
				foreach(var grandson in child.gameObject.WalkTree())
				{
					yield return grandson;
				}
			}
		}
	}

	public static void ReplaceMaterials(this GameObject root, Material material)
	{
		foreach(var child in root.WalkTree())
		{
			var childRenderer	= child.GetComponent<Renderer>();
			if(null == childRenderer || null == childRenderer.sharedMaterials)
			{
				continue;
			}

			var materials	= new Material[childRenderer.sharedMaterials.Length];
			for(int i= 0; i< materials.Length; ++i)
			{
				materials[i]= material;
			}

			childRenderer.sharedMaterials	= materials;
		}
	}

	public static void SynchronizeShape(this GameObject destination, GameObject source)
	{
		if(null == source || null == destination)
		{
			DebugEx.LogError("source={0}, destination={1}", source, destination);
			return;
		}

		destination.transform.SynchronizeShape(source.transform);
	}

	public static T SetDefaultComponent<T>(this GameObject go) where T : Component
	{
		if(null != go)
		{
			var component	= go.GetComponent<T>();
			if(null == component)
			{
				component	= go.AddComponent<T>();
			}

			return component;
		}

		return null;
	}
}
