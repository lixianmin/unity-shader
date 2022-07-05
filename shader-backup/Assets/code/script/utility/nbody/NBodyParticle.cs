
/********************************************************************
created:	2013-10-18
author:		lixianmin

purpose:	planar choreography
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;

class NBodyParticle
{
	public NBodyParticle(NBodyChoreography graphy, int index)
	{
		_graphy		= graphy;
		_phase		= 2.0f * Mathf.PI * index/ graphy.NumParticles;
		Index		= index;
	}

	public Vector3 SetPosition(float t) 
	{
		var b		= t + _phase;
		var x		= _graphy.FourierSumX(b);
		var y		= _graphy.FourierSumY(b);
		Position	= new Vector3(x, y, 0.0f);

		var vertexCount	= _graphy.VertexCount;
		if(Positions.Length != vertexCount)
		{
			Positions	= new Vector3[vertexCount];
		}

		Positions[0]	= Position;
		var lineFactor	= _graphy.LineFactor;

		for(int i= 1; i< vertexCount; ++i)
		{
			var factor	= b + lineFactor * i;
			x	= _graphy.FourierSumX(factor);
			y	= _graphy.FourierSumY(factor);
			Positions[i]= new Vector3(x, y, 0.0f);
		}

		return Position;
	}

	public Vector3		Position	{ get; private set; }
	public int			Index		{ get; private set; }
	public Transform	ModelTransform;

	public Vector3[]	Positions = new Vector3[0];

	private NBodyChoreography	_graphy;
	public float 				_phase;
}

