
/********************************************************************
created:	2011-11-17
author:		lixianmin

purpose:	Extensions for MonoBehaviour
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections.Generic;
using System.Linq;

public static class ExtendedMonoBehavior
{
	public static T[] GetComponentsInChildren<T>(this MonoBehaviour mb, string[] names, bool includeinactive) where T:Component
	{
		var results	= new T[names.Length];
		if(names.Length == 0)
		{
			return results;
		}

		var items	= mb.GetComponentsInChildren<T>(includeinactive);
		if(items.Length == 0)
		{
			return results;
		}

		for(int i= 0; i< names.Length; ++i)
		{
			var item	= items.FirstOrDefault(n=>n.name == names[i]);
			results[i]	= item;
		}

		return results;
	}

	public static T[] GetComponentsInChildren<T>(this MonoBehaviour mb, string[] names) where T:Component
	{
		return mb.GetComponentsInChildren<T>(names, false);
	}

	public static IEnumerable<T> GetDirectChildren<T>(this MonoBehaviour mb) where T: Component
	{
		return from item in mb.GetComponentsInChildren<T>()
			   where item.transform.parent == mb.transform 
			   orderby item.transform.position.z
			   select item;
	}
}
