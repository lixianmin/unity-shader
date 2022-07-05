
/****************************************************************************
created:	2013-4-5
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

using UnityEngine;

// [ExecuteInEditMode]
class MBProjectorShadow: MonoBehaviour
{
	void Start()
	{
		if(!SystemInfo.supportsRenderTextures)
		{
			enabled	= false;
			return;
		}

		_transform		= transform;

		var size		= 256;
		var texture		= new RenderTexture(size, size, 0, RenderTextureFormat.Default);
		_rttShadow		= new RTTProxy(texture);

		var projector	= GetComponent<Projector>();
		_matProjector	= projector.material;

		_matShadow		= PureColorMaterial.Create(Color.red);
		// _matShadow		= new Material(Shader.Find("projector/LookAtLight"));

		if(null != LightGameObject)
		{
			_lightTransform	= LightGameObject.transform;
		}
	}

	void Update()
	{
		if(null != _lightTransform)
		{
			_transform.position		= _transform.root.position - _lightTransform.forward * 10;
			_transform.rotation		= _lightTransform.rotation;
		}
	}

	void OnRenderObject()
	{
		if(null == _rttShadow || null == _matShadow)
		{
			return;
		}

		_SetUpShadowCamera();

		var cullingMask			= (1 << LayerMask.NameToLayer("HostPlayer"));
		_rttShadow.RenderWithShader(_matShadow.shader, cullingMask);
		_matProjector.SetTexture("_ShadowTex", _rttShadow.texture);
	}

	// void OnRenderImage(RenderTexture source, RenderTexture destination)
	// {
	//     Graphics.Blit(_rttShadow.texture, destination);
	// }

	void OnDestroy()
	{
		_rttShadow.Destroy();
		DestroyImmediate(_matShadow);
	}

	private void _SetUpShadowCamera()
	{
		var mainCamera			= Camera.main;
		if(null == mainCamera)
		{
			return;
		}

		var camera				= _rttShadow.camera;
		camera.CopyFrom(mainCamera);
		camera.backgroundColor	= Color.black;
		camera.clearFlags		= CameraClearFlags.SolidColor;

		var cameraTransform		= camera.transform;
		cameraTransform.position= _transform.position;
		cameraTransform.rotation= _transform.rotation;
	}

	public	GameObject		LightGameObject;
	private	Transform		_lightTransform;

	private	Transform		_transform;
	private	Material		_matProjector;
	private Material		_matShadow;
	private RTTProxy		_rttShadow;
}
