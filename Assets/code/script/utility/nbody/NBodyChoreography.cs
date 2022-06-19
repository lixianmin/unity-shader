
/********************************************************************
created:	2013-10-18
author:		lixianmin

purpose:	planar choreography
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

class NBodyChoreography : IEnumerable<NBodyParticle>, IEnumerable
{
	public static NBodyChoreography Create(NBodyType type)
	{
		var loader		= NBodyLoader.Instance;
		var configItem	= loader.GetNBodyConfigItem(type);
		if(null != configItem)
		{
			var nbody	= new NBodyChoreography(configItem);
			return nbody;
		}

		return null;
	}

	private NBodyChoreography(NBodyConfigItem configItem)
	{
		Scale			= 1.0f;
		VertexCount		= 1;
		VertexDensity	= 1.0f;

		_configItem		= configItem;
		var numParticles= _configItem.numParticles;
		_particles		= new NBodyParticle[numParticles];
		for(int index= 0; index< numParticles; ++index)
		{
			_particles[index]	= new NBodyParticle(this, index);
		}

		_SeparateArray(_configItem.xSin, out _xSinFreq, out _xSinCoeff);
		_SeparateArray(_configItem.xCos, out _xCosFreq, out _xCosCoeff);
		_SeparateArray(_configItem.ySin, out _ySinFreq, out _ySinCoeff);
		_SeparateArray(_configItem.yCos, out _yCosFreq, out _yCosCoeff);
	}

	private void _SeparateArray(double[] array, out float[] even, out float[] odd)
	{
		var halfLength	= array.Length /2;
		even	= new float[halfLength];
		odd		= new float[halfLength];
		for (int i = 0; i < halfLength; ++i)
		{
			var index	= i << 1;
			even[i]	= (float)array[index];
			odd[i]	= (float)array[index + 1];
		}
	}	

	public float FourierSumX(float factor)
	{
		return _FourierSum(factor, _xSinFreq, _xSinCoeff, _xCosFreq, _xCosCoeff);
	}

	public float FourierSumY(float factor)
	{
		return _FourierSum(factor, _ySinFreq, _ySinCoeff, _yCosFreq, _yCosCoeff);
	}

	private float _FourierSum(float factor, float[] sinFreqs, float[] sinCoeffs, float[] cosFreqs, float[] cosCoeffs)
	{
		float sum	= 0;
		for (int i = 0; i < sinCoeffs.Length; i++) 
		{
			sum += sinCoeffs[i]*Mathf.Sin(sinFreqs[i]*factor);
		}

		for (int i = 0; i < cosCoeffs.Length; i++) 
		{
			sum += cosCoeffs[i]*Mathf.Cos(cosFreqs[i]*factor);
		}

		sum	*= Scale;
		return sum;
	}

	private int _vertexCount	= 1;
	public int VertexCount
	{
		get { return _vertexCount; }
		set 
		{
			if(value != _vertexCount)
			{
				_vertexCount	= Mathf.Max(1, value);
			}
		}
	}

	private float _vertexDensity	= 1.0f;
	public float VertexDensity	// [0, 1000.0f] 
	{
		get { return _vertexDensity; }
		set 
		{
			if(value != _vertexDensity)
			{
				_vertexDensity	= Mathf.Repeat(value, 1000.0f);
				LineFactor		= 0.002f * Mathf.PI * VertexDensity;
			}
		}
	}

	public float	Scale			{ get; set; }
	public float	LineFactor		{ get; private set; }
	public int		NumParticles	{ get { return _configItem.numParticles; }}

	IEnumerator	IEnumerable.GetEnumerator() { return (this as IEnumerable).GetEnumerator(); }
	IEnumerator<NBodyParticle>	IEnumerable<NBodyParticle>.GetEnumerator()	{ return _particles.AsEnumerable().GetEnumerator(); }

	private NBodyParticle[]	_particles;
	private NBodyConfigItem	_configItem;

	private float[] 	_xSinFreq;
	private float[] 	_xCosFreq;
	private float[] 	_ySinFreq;
	private float[] 	_yCosFreq;
	private float[] 	_xSinCoeff;
	private float[] 	_xCosCoeff;
	private float[] 	_ySinCoeff;
	private float[]		_yCosCoeff;
}
