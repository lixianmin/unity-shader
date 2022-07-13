
/********************************************************************
created:	2013-10-29
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

class MBPareidoliaPointLight: MonoBehaviour
{
	void Awake()
	{
		_pareidoliaRoot	= transform.root.GetComponent<MBPareidoliaRoot>();
		_transform		= transform;
		_light			= GetComponent<Light>();
	}

	void Update()
	{
		if(null == _pareidoliaRoot)
		{
			return;
		}

	}

	private MBPareidoliaRoot	_pareidoliaRoot;
	private Transform	_transform;
	private Light		_light;
}
