
/********************************************************************
created:	2013-03-03
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/

using UnityEngine;
using System.Collections;

class MBCubemapCamera: MonoBehaviour
{
	void Start()
	{
		MainCamera	= Camera.main;

		if(null == MainCamera)
		{
			enabled	= false;
		}
		else
		{
			TheCubemap	= new Cubemap(1024, TextureFormat.ARGB32, false);
			// InvokeRepeating("_RecreateCubemap", 0, 5.0f);
			MainCamera.RenderToCubemap(TheCubemap);

			GetComponent<Renderer>().sharedMaterial.SetTexture("_Cube", TheCubemap);
		}
	}

	// void Update()
	// {
	//     MainCamera.RenderToCubemap(TheCubemap);
	// }

	private void _RecreateCubemap()
	{
		MainCamera.RenderToCubemap(TheCubemap);
	}

	public	Camera	MainCamera;
	public	Cubemap	TheCubemap;
}
