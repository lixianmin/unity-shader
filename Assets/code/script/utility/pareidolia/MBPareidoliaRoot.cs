
/********************************************************************
created:	2013-10-28
author:		lixianmin

purpose:	pareidolia
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

class MBPareidoliaRoot : MonoBehaviour
{
	void Awake()
	{
		_audio	= GetComponent<AudioSource>();
	}

	void Update()
	{
		_audio.GetSpectrumData(_samples, 0, FFTWindow.Hanning);

		var sum		= 0.0f;
		var count	= _samples.Length;
		for(int i= 0; i< count; ++i)
		{
			var sampleItem	= Mathf.Min(1.0f, _samples[i] * (i + 1));
			sum		+= sampleItem;
			_samples[i]	= sampleItem;
		}

		_currentLevel	= sum / count;

		_nearestLevels[_idxNearestLevels]	= _currentLevel;
		_idxNearestLevels	= (_idxNearestLevels + 1) % _nearestLevels.Length;
		_smoothLevel	= _nearestLevels.Average();
	}

	public float 	CurrentLevel	{ get { return _currentLevel; }}
	public float 	SmoothLevel		{ get { return _smoothLevel; }}
	public float[]	Samples			{ get { return _samples; }}

	private AudioSource	_audio;
	private float		_currentLevel;
	private float[]		_samples		= new float[64];

	private float		_smoothLevel;
	private int			_idxNearestLevels;
	private float[]		_nearestLevels	= new float[16];
}
