
/****************************************************************************
created:	2013-4-8
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

using UnityEngine;

[ExecuteInEditMode]
class MBPlanarShadow: MonoBehaviour
{
	void Start()
	{
		_collider	= transform.root.GetComponent<Collider>();
	}

	void Update()
	{
		if(null != _collider && null != GetComponent<Renderer>())
		{
			var bounds	= _collider.bounds;
			var center	= bounds.center;
			var translation	= new Vector3(center.x, bounds.min.y, center.z);

			var matrix	= Matrix4x4.TRS(-translation, Quaternion.identity, Vector3.one);
			GetComponent<Renderer>().sharedMaterial.SetMatrix("_World2Receiver", matrix);
			// DebugEx.Log(matrix);
		}
	}

	private Collider	_collider;
}
