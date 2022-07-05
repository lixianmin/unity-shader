
/********************************************************************
created:	2013-10-24
author:		lixianmin

purpose:	only for test
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

class MBTestPareidolia: MonoBehaviour
{
	void Awake()
	{
		Application.runInBackground	= true;
		_pareidoliaRoot	= transform.root.GetComponent<MBPareidoliaRoot>();

	}

	void Update()
	{
		if(null == _pareidoliaRoot)
		{
			return;
		}

		var currentLevel	= _pareidoliaRoot.CurrentLevel;
		var smoothLevel		= _pareidoliaRoot.SmoothLevel;

		TheLight.intensity	= smoothLevel * 20;

		// var scale	= 5.0f + smoothLevel* 100.0f;
		// TheBall.transform.localScale	= new Vector3(scale, scale, scale);

		// DebugEx.Log(smoothLevel);
		if(currentLevel > 0.15f)
		{
			// Camera.main.backgroundColor	= Color.white;
			// TheBall.SetActive(true);
		}
		else 
		{
			// Camera.main.backgroundColor	= Color.black;
			TheBall.SetActive(false);
		}

		// var model	= TheNBody.GetComponent<MBNBodyModel>();
		// model.Scale	= 1.0f + smoothLevel * 40;
	}

	public Light		TheLight	= null;
	public GameObject	TheBall		= null;
	public GameObject	TheNBody	= null;

	private MBPareidoliaRoot	_pareidoliaRoot;
}
