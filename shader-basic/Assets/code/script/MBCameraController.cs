
/********************************************************************
created:	2013-01-24
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/

using UnityEngine;
using System.Collections;

[RequireComponent (typeof(Camera))]
class MBCameraController: MonoBehaviour
{
	void Start()
	{
		_transform	= transform;
	}

	void Update () 
	{
		if(Input.GetMouseButton(1))
		{
			_MoveByKeyboard();
			_MoveByMouse();
		}

		_MoveByMouseWheel();
	}

	private void _MoveByKeyboard()
	{
		var augment	= keyboardMoveSpeed * Time.smoothDeltaTime;
		var moveZ	= Input.GetAxis ("Vertical") * augment;
		var moveX	= Input.GetAxis ("Horizontal") * augment;
		_transform.Translate (moveX, 0, moveZ);
	}

	private void _MoveByMouse()
	{
		var localEulerAngles= _transform.localEulerAngles;
		float rotationX 	= localEulerAngles.y + Input.GetAxis("Mouse X") * mouseSensitivityX;

		const float limited	= 60.0f;
		float rotationY		= localEulerAngles.x - Mathf.Clamp(Input.GetAxis("Mouse Y") * mouseSensitivityY, -limited, limited);

		_transform.localEulerAngles = new Vector3(rotationY, rotationX, localEulerAngles.z);
	}

	private void _MoveByMouseWheel()
	{
		var deltaScrollWheel	= Input.GetAxis("Mouse ScrollWheel") * mouseScrollWheel;
		_transform.position		+= _transform.forward * deltaScrollWheel;
	}

	public float keyboardMoveSpeed	= 5.0f;

	public float mouseSensitivityX	= 10.0f;
	public float mouseSensitivityY	= 10.0f;
	public float mouseScrollWheel	= 10.0f;

	private Transform	_transform;
}
