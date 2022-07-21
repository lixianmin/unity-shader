
/********************************************************************
created:	2013-10-29
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

class MBPareidoliaBeam: MonoBehaviour
{
	void Awake()
	{
		_pareidoliaRoot	= transform.root.GetComponent<MBPareidoliaRoot>();
		_transform		= transform;
		_beamMaterial	= BeamPrototype.GetComponent<Renderer>().sharedMaterial;

		_InitBeams();
	}

	private void _InitBeams()
	{
		const int beatCount	= 12;
		for(int i= 0; i< beatCount; ++i)
		{
			var go	= GameObject.Instantiate(BeamPrototype) as GameObject;
			go.SetActive(true);
			var trans		= go.transform;
			trans.parent	= _transform;
			trans.rotation	= Random.rotation;
		}
	}

	void Update()
	{
		if(null == _pareidoliaRoot)
		{
			return;
		}

		_transform.rotation	*= Quaternion.AngleAxis(Time.deltaTime * 5, Vector3.forward);

		var level		= _pareidoliaRoot.SmoothLevel;
		var alpha		= level * 1.5f;
		var oldColor	= _beamMaterial.color;
		_beamMaterial.color	= new Color(oldColor.r, oldColor.g, oldColor.b, alpha);
	}

	public GameObject	BeamPrototype	= null;

	private MBPareidoliaRoot	_pareidoliaRoot;
	private Transform	_transform;
	private Material	_beamMaterial;
}
