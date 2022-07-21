
/********************************************************************
created:	2011-11-11
author:		lixianmin

purpose:	extended debug
Copyright (C) - All Rights Reserved
*********************************************************************/
using UnityEngine;

public static class DebugEx
{
	private static string _FormatMessage(string message)
	{
		return string.Concat("frame= ", Time.frameCount.ToString(), ", time = ", Time.time.ToString(), ", ", message);
	}

	public static void Log(object message)
	{
		Debug.Log(_FormatMessage(message.ToString()));
	}

	public static void LogError(object message)
	{
		Debug.LogError(_FormatMessage(message.ToString()));
	}

	public static void Log(string format, params object[] args)
	{
		string message	= string.Format(format, args);
		Debug.Log(_FormatMessage(message));
	}

	[System.Diagnostics.Conditional("UNITY_EDITOR")]
	public static void LogDebug(string format, params object[] args)
	{
		if(Debug.isDebugBuild)
		{
			string message	= string.Format(format, args);
			Debug.Log(_FormatMessage(message));
		}
	}

	public static void LogError(string format, params object[] args)
	{
		string message	= string.Format(format, args);
		Debug.LogError(_FormatMessage(message));
	}

	public static void Assert(bool isTrue)
	{
		if(Debug.isDebugBuild && !isTrue)
		{
			Debug.LogError(_FormatMessage("An error occurred"));
		}
	}
	
	public static void Assert(bool isTrue, string format, params object[] args)
	{
		if(Debug.isDebugBuild && !isTrue)
		{
			var message	= string.Format(format, args);
			Debug.LogError(_FormatMessage(message));
		}
	}
}
