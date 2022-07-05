
/********************************************************************
created:	2012-03-09
author:		lixianmin

purpose:	Destroy when become invisible
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;

[RequireComponent(typeof(Renderer))]
public class MBRenderInvisibleDestroyer: MonoBehaviour
{
	public enum DestroyType
	{
		Parent,
		Myself,
	}

	void OnBecameInvisible()
	{
		switch(destroyType)
		{
		case DestroyType.Myself:
			{
				Destroy(gameObject);
				// print("DestroyType.Myself");
			}
			break;
		case DestroyType.Parent:
			{
				Destroy(transform.parent.gameObject);
				// print("DestroyType.Parent");
			}
			break;
		}
	}

	public DestroyType	destroyType;
}

