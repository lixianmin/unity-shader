
/********************************************************************
created:	2013-04-09
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/

using UnityEngine;
using System.Collections;

class MBTest: MonoBehaviour
{
	void Start()
	{
		_transform	= transform;
	}

	void Update()
	{
		// DebugEx.Log(gameObject.renderer.worldToLocalMatrix);
		// DebugEx.Log(gameObject.renderer.localToWorldMatrix);
	}

	private Transform	_transform;
}
