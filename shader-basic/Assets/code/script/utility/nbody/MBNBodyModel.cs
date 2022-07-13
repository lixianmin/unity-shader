
/********************************************************************
created:	2013-10-22
author:		lixianmin

purpose:	nbody model config	
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

partial class MBNBodyModel: MonoBehaviour
{
	void Awake()
	{
		_CheckCreatePrototype();
		_transform	= transform;
		_startTime	= Time.time;

		_type		= Type;
		_CreateNBodyChoreography(Type);
	}

	private void _CreateNBodyChoreography(NBodyType type)
	{
		_nbody	= NBodyChoreography.Create(type);
		if(null != _nbody)
		{
			var numParticles	= _nbody.NumParticles;
			var models	= new GameObject[numParticles];
			var index	= 0;
			// collect duplicated models
			foreach(Transform child in _transform)
			{
				if(child.name == _kPrototypeName)
				{
					models[index++]	= child.gameObject;
				}
			}

			// create new models
			while(index < numParticles)
			{
				var goModel		= GameObject.Instantiate(_goPrototype) as GameObject;
				goModel.name	= _kPrototypeName;
				goModel.transform.parent	= _transform;
				goModel.SetActive(true);
				models[index++]	= goModel;
			}

			// connect model to particle
			foreach(var particle in _nbody)
			{
				var goModel		= models[particle.Index];
				particle.ModelTransform		= goModel.transform;
			}

			_nbody.VertexCount	= VertexCount;
			_nbody.VertexDensity= VertexDensity;
			_nbody.Scale		= Scale;

			_InitHeadInfo();
			_InitLineInfo();
		}
	}

	private void _InitHeadInfo()
	{
		Head.Init(_nbody);

		foreach(var renderer in Head.GetRenderers())
		{
			renderer.enabled= Head.enabled;
			renderer.sharedMaterial	= Head.material;

			var localScale	= Scale * Head.scale;
			renderer.transform.localScale	= new Vector3(localScale, localScale, localScale);
		}
	}

	private void _InitLineInfo()
	{
		Line1.Init(_nbody, 0);
		Line2.Init(_nbody, 1);

		foreach(var particle in _nbody)
		{
			var renderer	= particle.ModelTransform.GetComponent<LineRenderer>();
			if(null != renderer)
			{
				var material		= (particle.Index & 1) == 0 ? Line1.material : Line2.material;
				renderer.material	= material;
			}
		}
	}

	void Update()
	{
#if UNITY_EDITOR
		_UpdateInEditor();

		Head.Update();
		Line1.Update();
		Line2.Update();
#endif

		if(null != _nbody)
		{
			_UpdatePositions();
		}
	}

	private void _UpdatePositions()
	{
		var t = (Time.time - _startTime)* Speed * 0.1f;
		var localToWorldMatrix	= _transform.localToWorldMatrix;
		foreach(var particle in _nbody)
		{
			var trans	= particle.ModelTransform;
			if(null == trans)
			{
				continue;
			}

			trans.localPosition	= particle.SetPosition(t);
			var lineRenderer	= trans.GetComponent<LineRenderer>();
			if(null != lineRenderer)
			{
				var positions	= particle.Positions;
				var count		= positions.Length;
				lineRenderer.SetVertexCount(count);

				if((particle.Index & 1) == 0)
				{
					lineRenderer.SetWidth(Line1.StartWidth * Scale, Line1.EndWidth * Scale);
				}
				else 
				{
					lineRenderer.SetWidth(Line2.StartWidth * Scale, Line2.EndWidth * Scale);
				}

				for(int index = 0; index < count; ++index)
				{
					var position= localToWorldMatrix.MultiplyPoint3x4(positions[index]);
					lineRenderer.SetPosition(index, position);
				}
			}
		}
	}

	private void _CheckCreatePrototype()
	{
		if(null == _goPrototype)
		{
			_goPrototype			= GameObject.CreatePrimitive(PrimitiveType.Quad);
			_goPrototype.name		= _kPrototypeName;
			_goPrototype.hideFlags	= HideFlags.HideAndDontSave;
			_goPrototype.SetActive(false);
			GameObject.DestroyImmediate(_goPrototype.GetComponent<Collider>());

			const float localScale	= 0.07f;
			_goPrototype.transform.localScale	= new Vector3(localScale, localScale, localScale);

			var meshRenderer		= _goPrototype.GetComponent<MeshRenderer>();
			meshRenderer.castShadows	= false;
			meshRenderer.receiveShadows	= false;

			var lineRenderer		= _goPrototype.AddComponent<LineRenderer>();
			lineRenderer.castShadows	= false;
			lineRenderer.receiveShadows	= false;
		}
	}

	private void _UpdateInEditor()
	{
		_CheckTypeChanged();

		if(null != _nbody)
		{
			Speed			= Mathf.Max(0, Speed);
			VertexCount		= Mathf.Max(2, VertexCount);
			VertexDensity	= Mathf.Repeat(VertexDensity, 1000.0f);

			_nbody.VertexCount	= VertexCount;
			_nbody.VertexDensity= VertexDensity;

			_CheckScaleChanged();
		}
	}

	private void _CheckScaleChanged()
	{
		Scale	= Mathf.Max(0.0001f, Scale);
		if(_scale != Scale)
		{
			_nbody.Scale	= Scale;
			var changed		= Scale / _scale;
			foreach(var renderer in Head.GetRenderers())
			{
				renderer.transform.localScale	*= changed;
			}

			_scale	= Scale;
		}
	}

	private void _CheckTypeChanged()
	{
		if(_type != Type)
		{
			_type = Type;
			_CreateNBodyChoreography(Type);
		}
	}

	public NBodyType	Type		= NBodyType.TenOnPentagram;
	public float 	Scale			= 5.0f;
	public float	Speed			= 3.0f;
	public int		VertexCount		= 2;
	public float	VertexDensity	= 10.0f;

	public HeadInfo	Head	= null;
	public LineInfo	Line1	= null;
	public LineInfo	Line2	= null;

	private float		_startTime;
	private NBodyType	_type;
	private Transform	_transform;
	private float		_scale	= 1.0f;

	private NBodyChoreography	_nbody;
	private static GameObject	_goPrototype;
	private const string		_kPrototypeName	= "__nbody_model__";
}
