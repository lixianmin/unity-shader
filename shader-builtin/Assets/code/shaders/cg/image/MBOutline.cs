
/****************************************************************************
created:	2013-03-11
author:		lixianmin

Copyright(C) - All Rights Reserved
***************************************************************************/

using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
class MBOutline: MonoBehaviour
{
	void Start()
	{
		if(!SystemInfo.supportsImageEffects)
		{
			enabled	= false;
			return;
		}

		if(!PureWhiteMaterial.shader.isSupported)
		{
			enabled	= false;
			return;
		}

		if(!OutlineMaterial.shader.isSupported)
		{
			enabled	= false;
			return;
		}

		_camera	= GetComponent<Camera>();
	}

	private bool _RenderWithShader(Shader shader, string layerName, RenderTexture destination)
	{
		if (!enabled || !gameObject.active)
		{
			return false;
		}

		if (null == _goRenderTextureCamera)
		{
			_goRenderTextureCamera	= new GameObject("OutlineImageEffect");
			_goRenderTextureCamera.AddComponent<Camera>();
			_goRenderTextureCamera.GetComponent<Camera>().enabled	= false;
			_goRenderTextureCamera.hideFlags		= HideFlags.HideAndDontSave;
		}

		var renderTextureCamera				= _goRenderTextureCamera.GetComponent<Camera>();
		renderTextureCamera.CopyFrom(_camera);
		renderTextureCamera.backgroundColor	= Color.black;
		renderTextureCamera.clearFlags		= CameraClearFlags.SolidColor;
		renderTextureCamera.cullingMask		= 1 << LayerMask.NameToLayer(layerName);
		renderTextureCamera.targetTexture	= destination;
		renderTextureCamera.RenderWithShader(shader, null);
		renderTextureCamera.targetTexture	= null;

		return true;
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		var width	= (int)_camera.pixelWidth;
		var height	= (int)_camera.pixelHeight;

		var rtPureWhite	= RenderTexture.GetTemporary(width, height);
		var rtBuffer	= RenderTexture.GetTemporary(width, height);

		var isRenderOk	= _RenderWithShader(PureWhiteMaterial.shader, "HostPlayer", rtPureWhite);

		if(isRenderOk)
		{
			OutlineMaterial.SetTexture("_ScreenTex", source);
			OutlineMaterial.color	= OutlineColor;

			Graphics.Blit(rtPureWhite, rtBuffer, OutlineMaterial, 0);
			Graphics.Blit(rtBuffer, destination, OutlineMaterial, 1);
		}

		RenderTexture.ReleaseTemporary(rtBuffer);
		RenderTexture.ReleaseTemporary(rtPureWhite);
	}		

	void OnDestroy()
	{
		DestroyImmediate(_goRenderTextureCamera);
		DestroyImmediate(_pureWhiteMaterial);
		DestroyImmediate(_outlineMaterial);
	}

	private Material	_pureWhiteMaterial;
	public Material	PureWhiteMaterial
	{
		get 
		{
			if(null == _pureWhiteMaterial)
			{
				_pureWhiteMaterial	= new Material("Shader\"Hidden/___PureWhite___\"{ SubShader{ Pass { Color(1, 1, 1, 1)}}}");
				_pureWhiteMaterial.hideFlags		= HideFlags.HideAndDontSave;
				_pureWhiteMaterial.shader.hideFlags	= HideFlags.HideAndDontSave;
			}

			return _pureWhiteMaterial;
		}
	}

	private Material	_outlineMaterial;
	public Material OutlineMaterial
	{
		get 
		{
			if(null == _outlineMaterial)
			{
				_outlineMaterial	= new Material(Shader.Find("cg/image/Outline"));
				_outlineMaterial.hideFlags			= HideFlags.HideAndDontSave;
			}

			return _outlineMaterial;
		}
	}

	public	Color		OutlineColor	= Color.green;

	private GameObject	_goRenderTextureCamera;
	private Camera		_camera;
}
