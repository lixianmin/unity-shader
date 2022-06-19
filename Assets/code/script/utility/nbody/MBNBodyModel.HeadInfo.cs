
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
	public class HeadInfo : BasicInfo
	{
		public void Init(NBodyChoreography nbody)
		{
			_nbody	= nbody;
		}

		protected override void _DoUpdate()
		{
			_CheckScaleChanged();
		}

		public override IEnumerable<Renderer> GetRenderers()
		{
			if(null != _nbody)
			{
				foreach(var particle in _nbody)
				{
					var renderer= particle.ModelTransform.GetComponent<MeshRenderer>();
					if(null != renderer)
					{
						yield return renderer;
					}
				}
			}
		}

		private void _CheckScaleChanged()
		{
			scale	= Mathf.Max(0.0001f, scale);
			if(_scale != scale)
			{
				var changed	= scale / _scale;
				foreach(var renderer in GetRenderers())
				{
					renderer.transform.localScale	*= changed;
				}

				_scale	= scale;
			}
		}

		public float	scale	= 1.0f;
		private float	_scale	= 1.0f;

		private NBodyChoreography	_nbody;
	}
}
