
/********************************************************************
created:	2013-05-07
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(Camera))]
class MBCloudGenerator: MonoBehaviour
{
	void Start()
	{
		_cameraTransform= Camera.main.transform;

		_cloud			= GameObject.Instantiate(CloudPrototype) as GameObject;
		_cloudMesh		= _cloud.GetComponent<MeshFilter>().mesh;
		_cloud.SetActive(true);

		_combines		= new CombineInstance[CloudCount];
		_positions		= new Vector3[CloudCount];
		_scales			= new Vector3[CloudCount];

		var rawMesh		= CloudPrototype.GetComponent<MeshFilter>().mesh;

		for(int i= 0; i< CloudCount; ++i)
		{
			_combines[i].mesh	= rawMesh;
			_positions[i]		= new Vector3(Random.Range(-Radius, Radius), Random.Range(0.0f, 5.0f), Random.Range(-Radius, Radius));

			var scale			= Random.Range(1.0f, 4.0f);
			_scales[i]			= new Vector3(scale, scale, 1.0f);
		}
	}

	void Update()
	{
		_cloudMesh.Clear();

		var rotation	= _cameraTransform.rotation;

		for(int i= 0; i< _combines.Length; ++i)
		{
			_combines[i].transform	= Matrix4x4.TRS(_positions[i], rotation, _scales[i]);
		}

		_cloudMesh.CombineMeshes(_combines);
	}

	public	GameObject	CloudPrototype	= null;
	public	int			CloudCount		= 4;
	public	float		Radius			= 10.0f;

	private GameObject			_cloud;
	private Mesh				_cloudMesh;
	private Transform			_cameraTransform;

	private CombineInstance[]	_combines;
	private Vector3[]			_positions;
	private Vector3[]			_scales;
}
