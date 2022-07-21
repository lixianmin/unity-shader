
/********************************************************************
created:	2013-10-26
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text;

class MBGameNBody: MonoBehaviour
{
	void Start()
	{

	}

	void Update()
	{
		ShootFrequency	= Mathf.Max(0.0001f, ShootFrequency);
		if(Time.time - _lastTime > ShootFrequency)
		{
			var go		= GameObject.Instantiate(Prototype) as GameObject;
			go.SetActive(true);
			go.GetComponent<Rigidbody>().AddForce(Vector3.right * 400);

			var model	= go.GetComponent<MBNBodyModel>();

			model.VertexCount	= Random.Range(2, 10);
			model.VertexDensity	= Random.Range(0, 1000.0f);

			var color1	= new Color(Random.value, Random.value, Random.value);
			// var texture1= TextureCandidates[Random.Range(0, TextureCandidates.Length)];
			var enabled	= Random.value > 0.5f;
			foreach(var renderer in model.Line1.GetRenderers())
			{
				renderer.enabled	= enabled;
				renderer.material.SetColor("_TintColor", color1);
				// renderer.material.mainTexture	= texture1;
			}

			var color2	= new Color(Random.value, Random.value, Random.value);
			// var texture2= TextureCandidates[Random.Range(0, TextureCandidates.Length)];

			if(enabled)
			{
				enabled	= Random.value > 0.5f;
			}
			else
			{
				enabled	= true;
			}
			
			foreach(var renderer in model.Line2.GetRenderers())
			{
				renderer.enabled	= enabled;
				renderer.material.SetColor("_TintColor", color2);
				// renderer.material.mainTexture	= texture2;
			}


			_lastTime	= Time.time;
		}
	}

	public GameObject	Prototype		= null;
	public float		ShootFrequency	= 1.0f;
	public Texture[]	TextureCandidates	= null;

	private float		_lastTime;
}
