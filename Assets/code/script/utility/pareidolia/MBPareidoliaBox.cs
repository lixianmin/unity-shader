
/********************************************************************
created:	2013-10-29
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

class MBPareidoliaBox: MonoBehaviour
{
	void Start()
	{
		_transform	= transform;
		_originalPosition	= _transform.position;
		_Init();

		var initTime= Random.Range(0, 30.0f);
		_transform.rotation	= Random.rotation;
		_transform.Translate(_direction * initTime);
	}

	void Update()
	{
		var speed	= 4.0f;
		_transform.Translate(_direction * Time.deltaTime * speed);
		_transform.Rotate(_direction, Time.deltaTime);
	}

	private void _Init()
	{
		_direction	= Random.onUnitSphere;
		var z		= _direction.z < 0 ? _direction.z : - _direction.z;
		_direction	= new Vector3(_direction.x, _direction.y, z);
	}

	void OnBecameInvisible()
	{
		_transform.position	= _originalPosition;
		_Init();
	}

	private Transform	_transform;
	private Vector3		_originalPosition;
	private Vector3		_direction;
}
