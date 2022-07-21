
/********************************************************************
created:	2013-4-5
author:		lixianmin

purpose:	RenderTexture proxy
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;

public class RTTProxy : System.IDisposable
{
	public RTTProxy(RenderTexture texture)
	{
		_texture	= texture;
	}

	public void Dispose()
	{
		Object.Destroy(_texture);
		Object.Destroy(_camera);
	}

	public void Resize()
	{
		Resize(Screen.width, Screen.height);
	}

	public void Resize(int width, int height)
	{
		DebugEx.Assert(null != _texture);
		if(_texture.width != width || _texture.height != height)
		{
			var texture			= new RenderTexture(width, height, _texture.depth, _texture.format);
			texture.wrapMode	= _texture.wrapMode;
			texture.hideFlags	= HideFlags.HideAndDontSave;

			Object.DestroyImmediate(_texture);
			_texture			= texture;
		}
	}

	public void RenderWithShader(Shader shader, int cullingMask)
	{
		var theCamera			= camera;
		theCamera.cullingMask	= cullingMask;
		theCamera.targetTexture	= _texture;
		theCamera.RenderWithShader(shader, null);
		theCamera.targetTexture	= null;
	}

	public override string ToString()
	{
		return string.Format("texture={0}", texture);
	}

	private	Camera	_camera;
	public	Camera	camera 
	{
		get 
		{
			if (null == _camera)
			{
				var goCamera		= new GameObject("__RTTProxyCameraObject__");
				// goCamera.hideFlags	= HideFlags.HideAndDontSave;
				_camera				= goCamera.AddComponent<Camera>();
				_camera.enabled		= false;
			}

			return _camera;
		}
	}

	public	RenderTexture	texture	{ get { return _texture; }}

	private	RenderTexture	_texture;
}

public static class RTTProxyEx
{
	public static void Destroy(this RTTProxy rtt)
	{
		if(null != rtt)
		{
			rtt.Dispose();
		}
	}
}
