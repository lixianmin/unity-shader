
/****************************************************************************
created:	2013-03-19
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
class MBXRay2: MonoBehaviour
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

		if(!XRayMaterial.shader.isSupported)
		{
			enabled	= false;
			return;
		}

		_camera	= GetComponent<Camera>();
	}

	private bool _RenderWithShader(Shader shader, CameraClearFlags clearFlags, int cullingMask, RenderTexture destination)
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
		renderTextureCamera.clearFlags		= clearFlags;
		renderTextureCamera.cullingMask		= cullingMask;
		// renderTextureCamera.depthTextureMode= DepthTextureMode.Depth;
		renderTextureCamera.targetTexture	= destination;
		renderTextureCamera.RenderWithShader(shader, null);
		renderTextureCamera.targetTexture	= null;

		return true;
	}

	void OnPostRender()
	{
		var width		= (int)_camera.pixelWidth;
		var height		= (int)_camera.pixelHeight;

		var rttDepth	= RenderTexture.GetTemporary(width, height, 0, RenderTextureFormat.Depth);
		_RenderWithShader(RenderDepthMaterial.shader, CameraClearFlags.SolidColor, -1, rttDepth);

		XRayMaterial.SetTexture("_Depth", rttDepth);
		var cullingMask	= (1 << LayerMask.NameToLayer("HostPlayer"));
		_RenderWithShader(XRayMaterial.shader, CameraClearFlags.Nothing, cullingMask, null);

		RenderTexture.ReleaseTemporary(rttDepth);
	}

	void OnDestroy()
	{
		DestroyImmediate(_goRenderTextureCamera);
		DestroyImmediate(_renderDepthMaterial);
		DestroyImmediate(_xRayMaterial);
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

	private Material	_xRayMaterial;
	public Material	XRayMaterial
	{
		get 
		{
			if(null == _xRayMaterial)
			{
				_xRayMaterial	= new Material(Shader.Find("cg/image/X Ray2"));
				_xRayMaterial.hideFlags			= HideFlags.HideAndDontSave;
				_xRayMaterial.shader.hideFlags	= HideFlags.HideAndDontSave;
			}

			return _xRayMaterial;
		}
	}

	private GameObject		_goRenderTextureCamera;
	private Camera			_camera;
	private	RenderTexture	_rttDepth;
}
