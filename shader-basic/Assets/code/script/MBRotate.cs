
/********************************************************************
created:	2013-04-06
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/

using UnityEngine;
using System.Collections;

class MBRotate: MonoBehaviour
{
	void Start()
	{
		_transform	= transform;
	}

	void Update()
	{
		Speed	= Mathf.Max(0.0f, Speed);
		_transform.RotateAround(_transform.position, Vector3.up, Time.deltaTime * Speed);
	}

	public float	Speed	= 180.0f;

	private Transform	_transform;
}
