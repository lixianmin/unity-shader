
/********************************************************************
created:	2013-10-27
author:		lixianmin

purpose:	nbody model config	
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

partial class MBNBodyModel
{
	[System.Serializable]
	public class LineInfo : BasicInfo
	{
		public void Init(NBodyChoreography nbody, int group)
		{
			_nbody	= nbody;
			_group	= group;
		}

		protected override void _DoUpdate()
		{
			StartWidth	= Mathf.Max(0, StartWidth);
			EndWidth	= Mathf.Max(0, EndWidth);
		}

		public override IEnumerable<Renderer> GetRenderers()
		{
			if(null != _nbody)
			{
				foreach(var particle in _nbody)
				{
					if((particle.Index & 1) == _group)
					{
						var renderer= particle.ModelTransform.GetComponent<LineRenderer>();
						if(null != renderer)
						{
							yield return renderer;
						}
					}
				}
			}
		}

		public float	StartWidth	= 1.0f;
		public float	EndWidth	= 1.0f;

		private NBodyChoreography	_nbody;
		private int	_group;
	}
}
