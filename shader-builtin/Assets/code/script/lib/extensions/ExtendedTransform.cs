
/********************************************************************
created:	2012-03-08
author:		lixianmin

purpose:	Extensions for Transform 
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections.Generic;

public static class ExtendedTransform
{
	public static void SetLocalTransform(this Transform trans, Transform other)
	{
		trans.localPosition = other.position;
		trans.localRotation = other.rotation;
		trans.localScale = other.localScale;
	}
	
	public static void SetPositionX(this Transform trans, float x)
	{
		var old	= trans.position;
		trans.position	= new Vector3(x, old.y, old.z);
	}

	public static void SetLocalPositionX(this Transform trans, float x)
	{
		var old	= trans.localPosition;
		trans.localPosition	= new Vector3(x, old.y, old.z);
	}

	public static void SetLocalScaleX(this Transform trans, float x)
	{
		var old	= trans.localScale;
		trans.localScale	= new Vector3(x, old.y, old.z);
	}
	
	public static void SetPositionY(this Transform trans, float y)
	{
		var old	= trans.position;
		trans.position	= new Vector3(old.x, y, old.z);
	}

	public static void SetLocalPositionY(this Transform trans, float y)
	{
		var old	= trans.localPosition;
		trans.localPosition	= new Vector3(old.x, y, old.z);
	}

	public static void SetLocalScaleY(this Transform trans, float y)
	{
		var old	= trans.localScale;
		trans.localScale	= new Vector3(old.x, y, old.z);
	}

	public static Transform GetChildByName(this Transform root, string name)
	{
		foreach(var child in root.WalkTree())
		{
			if(child.name == name)
			{
				return child;
			}
		}

		return null;
	}

	public static IEnumerable<Transform> WalkTree(this Transform root)
	{
		if(null != root)
		{
			yield return root;

			foreach(Transform child in root)
			{
				foreach(var grandson in child.WalkTree())
				{
					yield return grandson;
				}
			}
		}
	}

	public static void SynchronizeShape(this Transform destination, Transform source)
	{
		if(null == source || null == destination)
		{
			DebugEx.LogError("source={0}, destination={1}", source, destination);
			return;
		}

		using(var srcEnumerator	= source.WalkTree().GetEnumerator())
		using(var dstEnumerator	= destination.WalkTree().GetEnumerator())
		{
			srcEnumerator.MoveNext(); 
			dstEnumerator.MoveNext();

			while(srcEnumerator.MoveNext() && dstEnumerator.MoveNext())
			{
				var srcTransform	= srcEnumerator.Current;
				var dstTransform	= dstEnumerator.Current;
				dstTransform.localPosition	= srcTransform.localPosition;
				dstTransform.localRotation	= srcTransform.localRotation;
				dstTransform.localScale		= srcTransform.localScale;
			}
		}
	}
}

