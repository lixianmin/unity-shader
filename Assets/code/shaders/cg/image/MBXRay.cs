
/****************************************************************************
created:	2013-03-11
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
class MBXRay: MonoBehaviour
{
	void Start()
	{
		if(!SystemInfo.supportsImageEffects)
		{
			enabled	= false;
			return;
		}

		if(!RenderDepthMaterial.shader.isSupported)
		{
			enabled	= false;
			return;
		}

		_camera	= GetComponent<Camera>();
	}

	private bool _RenderWithShader(Shader shader, int cullingMask, RenderTexture destination)
	{
		if (!enabled || !gameObject.active)
		{
			return false;
		}

		if (null == _goRenderTextureCamera)
		{
			_goRenderTextureCamera	= new GameObject("__RenderTextureCamera__");
			_goRenderTextureCamera.AddComponent<Camera>();
			_goRenderTextureCamera.GetComponent<Camera>().enabled	= false;
			_goRenderTextureCamera.hideFlags= HideFlags.HideAndDontSave;
		}

		var renderTextureCamera				= _goRenderTextureCamera.GetComponent<Camera>();
		renderTextureCamera.CopyFrom(_camera);
		renderTextureCamera.backgroundColor	= Color.black;
		renderTextureCamera.clearFlags		= CameraClearFlags.SolidColor;
		renderTextureCamera.cullingMask		= cullingMask;
		// renderTextureCamera.depthTextureMode= DepthTextureMode.Depth;
		renderTextureCamera.targetTexture	= destination;
		renderTextureCamera.RenderWithShader(shader, null);
		renderTextureCamera.targetTexture	= null;

		return true;
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		var width		= (int)_camera.pixelWidth;
		var height		= (int)_camera.pixelHeight;

		var rttHostDepth	= RenderTexture.GetTemporary(width, height, 0, RenderTextureFormat.Depth);
		var rttOthersDepth	= RenderTexture.GetTemporary(width, height, 0, RenderTextureFormat.Depth);

		var cullingMask	= (1 << LayerMask.NameToLayer("HostPlayer"));
		_RenderWithShader(RenderDepthMaterial.shader, cullingMask, rttHostDepth);
		_RenderWithShader(RenderDepthMaterial.shader, ~cullingMask, rttOthersDepth);
		XRayMaterial.SetTexture("_HostDepth", rttHostDepth);
		XRayMaterial.SetTexture("_OthersDepth", rttOthersDepth);
		Graphics.Blit(source, destination, XRayMaterial);

		RenderTexture.ReleaseTemporary(rttHostDepth);
		RenderTexture.ReleaseTemporary(rttOthersDepth);
	}

	void OnDestroy()
	{
		DestroyImmediate(_goRenderTextureCamera);
		DestroyImmediate(_renderDepthMaterial);
	}

	private Material	_renderDepthMaterial;
	public Material	RenderDepthMaterial
	{
		get 
		{
			if(null == _renderDepthMaterial)
			{
				_renderDepthMaterial	= new Material(Shader.Find("cg/image/RenderDepth"));
				_renderDepthMaterial.hideFlags		= HideFlags.HideAndDontSave;
				_renderDepthMaterial.shader.hideFlags	= HideFlags.HideAndDontSave;
			}

			return _renderDepthMaterial;
		}
	}

	public	Material	XRayMaterial;

	private GameObject		_goRenderTextureCamera;
	private Camera			_camera;
	private	RenderTexture	_rttDepth;
}
