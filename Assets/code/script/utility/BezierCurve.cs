
/********************************************************************
created:	2013-01-23
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/

using UnityEngine;
using System.Collections.Generic;

public class BezierCurve 
{
	struct DrawPoint
	{
		public float	Factor;
		public Vector3	Position;
	}

	public Vector3 InterpolatePosition(float t)
	{
		if(t <= 0.0f)
		{
			return _controlPoints[0];
		}
		else if(t >= 1.0f)
		{
			return _controlPoints[_controlPoints.Length - 1];
		}
		else 
		{
			float l_t		= 1 - t;
			int length		= _controlPoints.Length;
			float c1		= Mathf.Pow(l_t, length - 1);
			float c1_factor	= t / l_t;
			int c2			= 1;

			var position	= Vector3.zero;
			for(int i= 0; i< length; ++i)
			{
				position	+= c1 * c2 * _controlPoints[i];
				c1			*= c1_factor;
				int delta	= i + 1;
				c2			= c2 * (length - delta) / delta;
			}

			return position;
		}
	}

	// smoothness is in (-0.999f, 0.0f), the smaller, the smoother
	public Vector3[] GetDrawPoints(float smoothness)
	{
		if(ControlPoints.Length > 1)
		{
			smoothness			= Mathf.Clamp(smoothness, -0.999f, -0.1f);
			var points			= new List<Vector3>();
			var remainings		= new Stack<DrawPoint>();

			var leftDrawPoint	= new DrawPoint{ Position= ControlPoints[0], Factor= 0.0f };
			remainings.Push(new DrawPoint{ Position= ControlPoints[ControlPoints.Length - 1], Factor= 1.0f });
			
			var zero			= Vector3.zero;
			while(remainings.Count > 0)
			{
				var rightDrawPoint	= remainings.Peek();
				var midFactor		= (leftDrawPoint.Factor + rightDrawPoint.Factor) * 0.5f;
				var midPosition		= InterpolatePosition(midFactor);

				var dir1			= leftDrawPoint.Position - midPosition;
				var dir2			= rightDrawPoint.Position - midPosition;
				if(dir1 == zero || dir2 == zero)
				{
					leftDrawPoint	= remainings.Pop();
					continue;
				}
				
				dir1.Normalize();				
				dir2.Normalize();

				var theta			= Vector3.Dot(dir1, dir2);
				var isNearEnough	= theta < smoothness;
				if(isNearEnough)
				{
					points.Add(leftDrawPoint.Position);
					leftDrawPoint	= remainings.Pop();
				}
				else 
				{
					remainings.Push(new DrawPoint{Position= midPosition, Factor= midFactor});
					// DebugEx.Log("midPosition={0}, midFactor={1}, theta={2}, dir1={3}, dir2={4}", midPosition, midFactor, theta, dir1, dir2);
				}
			}

			points.Add(leftDrawPoint.Position);
			var array	= points.ToArray();
			return array;
		}

		return ControlPoints;
	}

	private Vector3[]	_controlPoints	= new Vector3[1];
	public Vector3[]	ControlPoints
	{
		get { return _controlPoints; }
		set 
		{
			_controlPoints	= null != value ? value : new Vector3[1];
			// DebugEx.Log("_controlPoints.Length={0}", _controlPoints.Length);
		}
	}
}
