
/********************************************************************
created:	2013-10-28
author:		lixianmin

purpose:	pareidolia
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

class MBPareidoliaLineRenderer: MonoBehaviour
{
	void Awake()
	{
		_lineRenderer	= GetComponent<LineRenderer>();
	}

	void Start()
	{
		_pareidoliaRoot	= transform.root.GetComponent<MBPareidoliaRoot>();
		if(null != _pareidoliaRoot)
		{
			var count	= _pareidoliaRoot.Samples.Length;
			_lineRenderer.SetVertexCount(count);

			var origin	= transform.position;
			_linePositions	= new Vector3[count];
			for(int i= 0; i< count; ++i)
			{
				_linePositions[i]	= new Vector3(origin.x + i - count / 2, origin.y, origin.z);
			}
		}
	}

	void Update()
	{
		if(null != _pareidoliaRoot)
		{
			var samples	= _pareidoliaRoot.Samples;
			for(int index= 0; index < samples.Length; ++index)
			{
				var y	= samples[index] * 20.0f;
				var position	= new Vector3(_linePositions[index].x, y, _linePositions[index].z);
				_lineRenderer.SetPosition(index, position);
			}
		}
	}

	private MBPareidoliaRoot	_pareidoliaRoot;
	private LineRenderer		_lineRenderer;
	private Vector3[]			_linePositions;
}
