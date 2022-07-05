
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
	public abstract class BasicInfo
	{
		public void Update()
		{
			_CheckEnabledChanged();
			_DoUpdate();
		}

		private void _CheckEnabledChanged()
		{
			if(_enabled != enabled)
			{
				foreach(var renderer in GetRenderers())
				{
					renderer.enabled	= enabled;
				}

				_enabled	= enabled;
			}	
		}

		protected abstract void _DoUpdate();
		public abstract IEnumerable<Renderer> GetRenderers();

		public bool		enabled		= true;
		public Material	material	= null;

		private bool	_enabled	= true;
	}
}
