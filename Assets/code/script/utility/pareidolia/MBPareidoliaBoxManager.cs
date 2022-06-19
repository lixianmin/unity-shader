
/********************************************************************
created:	2013-10-29
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

class MBPareidoliaBoxManager: MonoBehaviour
{
	void Start()
	{
		_transform	= transform;
		_InitBoxes();
	}

	private void _InitBoxes()
	{
		const int count	= 1000;
		_boxes	= new GameObject[count];
		for(int index= 0; index < count; ++index)
		{
			var cloned		= GameObject.Instantiate(BoxPrototype) as GameObject;
			cloned.SetActive(true);
			var trans		= cloned.transform;
			trans.parent	= _transform;
			trans.localPosition	= Vector3.zero;

			_boxes[index]	= cloned;
		}
	}

	public GameObject	BoxPrototype	= null;

	private Transform		_transform;
	private GameObject[]	_boxes;
}
