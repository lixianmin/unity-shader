
/********************************************************************
created:	2013-10-18
author:		lixianmin

purpose:	only for test
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

class MBTestNBody: MonoBehaviour
{
	void Start()
	{
		var names		= Enum.GetNames(typeof(NBodyType));
		_nbodyTypeNames	= new string[names.Length - 1];
		Array.Copy(names, _nbodyTypeNames, _nbodyTypeNames.Length);

		if(null == Model || null == TextureCandidates)
		{
			enabled	= false;
		}
		else 
		{
			// Model.LineTexture1	= TextureCandidates[_idxTexture1];
			// Model.LineTexture2	= TextureCandidates[_idxTexture2];
		}
	}

	void OnGUI()
	{
		Model.Type	= (NBodyType)GUILayout.SelectionGrid((int)Model.Type , _nbodyTypeNames, 3);

		_sbText.Length		= 0;
		_sbText.AppendFormat(null, "Scale : {0}", Model.Scale.ToString("f2"));
		GUILayout.Label(_sbText.ToString());
		Model.Scale	= GUILayout.HorizontalSlider (Model.Scale, 0.0f, 10.0f);

		_sbText.Length		= 0;
		_sbText.AppendFormat(null, "Speed : {0}", Model.Speed.ToString("f2"));
		GUILayout.Label(_sbText.ToString());
		Model.Speed	= GUILayout.HorizontalSlider (Model.Speed, 0.0f, 10.0f);

		_sbText.Length		= 0;
		_sbText.AppendFormat(null, "Vertex Count : {0}", Model.VertexCount.ToString());
		GUILayout.Label(_sbText.ToString());
		Model.VertexCount	= (int)GUILayout.HorizontalSlider (Model.VertexCount, 2, 100);

		_sbText.Length		= 0;
		_sbText.AppendFormat(null, "Vertex Density : {0}", Model.VertexDensity.ToString("f2"));
		GUILayout.Label(_sbText.ToString());
		Model.VertexDensity	= GUILayout.HorizontalSlider (Model.VertexDensity, 0, 1000.0f);

		_sbText.Length		= 0;
		_sbText.AppendFormat(null, "Head Scale : {0}", Model.Head.scale.ToString("f2"));
		GUILayout.Label(_sbText.ToString());
		Model.Head.scale	= GUILayout.HorizontalSlider (Model.Head.scale, 0, 10.0f);

		_sbText.Length		= 0;
		_sbText.AppendFormat(null, "Line Texture1 : {0}", _idxTexture1.ToString());
		GUILayout.Label(_sbText.ToString());
		var idxTexture1	= (int)GUILayout.HorizontalSlider (_idxTexture1, 0.0f, TextureCandidates.Length - 1);
		if(_idxTexture1 != idxTexture1)
		{
			foreach(var renderer in Model.Line1.GetRenderers())
			{
				renderer.material.mainTexture	= TextureCandidates[idxTexture1];
			}

			_idxTexture1	= idxTexture1;
		}

		_sbText.Length		= 0;
		_sbText.AppendFormat(null, "Line Texture2 : {0}", _idxTexture2.ToString());
		GUILayout.Label(_sbText.ToString());
		var idxTexture2	= (int)GUILayout.HorizontalSlider (_idxTexture2, 0.0f, TextureCandidates.Length - 1);
		if(_idxTexture2 != idxTexture2)
		{
			foreach(var renderer in Model.Line2.GetRenderers())
			{
				renderer.material.mainTexture	= TextureCandidates[idxTexture2];
			}

			_idxTexture2	= idxTexture2;
		}

		_sbText.Length		= 0;
		_sbText.AppendFormat(null, "Line Start Width : {0}", Model.Line1.StartWidth.ToString("f2"));
		GUILayout.Label(_sbText.ToString());
		Model.Line1.StartWidth	= GUILayout.HorizontalSlider (Model.Line1.StartWidth, 0, 10.0f);
		Model.Line2.StartWidth	= Model.Line1.StartWidth;

		_sbText.Length		= 0;
		_sbText.AppendFormat(null, "Line End Width : {0}", Model.Line1.EndWidth.ToString("f2"));
		GUILayout.Label(_sbText.ToString());
		Model.Line1.EndWidth	= GUILayout.HorizontalSlider (Model.Line1.EndWidth, 0, 10.0f);
		Model.Line2.EndWidth	= Model.Line1.EndWidth;
	}

	public MBNBodyModel	Model	= null;
	public Texture[]	TextureCandidates	= null;

	private string[]		_nbodyTypeNames;
	private StringBuilder	_sbText	= new StringBuilder();
	private int	_idxTexture1	= 2;
	private int	_idxTexture2	= 3;
}
