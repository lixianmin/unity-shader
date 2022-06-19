using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Image Effects/Custom/ScreenDoor")]
public class ScreenDoor: ImageEffectBase
{
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_CloseRatio", CloseRatio);
		material.SetColor("_CloseColor", CloseColor);
		Graphics.Blit(source, destination, material);
	}
	
	public float	CloseRatio	= 0;
	public Color	CloseColor	= Color.black;
}
