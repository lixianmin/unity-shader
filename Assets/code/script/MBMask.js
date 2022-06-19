
/********************************************************************
created:	2013-03-09
author:		lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/

@script RequireComponent(Camera)

var drawRect:Rect = Rect(0, 0, 256, 256);
var maskTexture:Texture;
var renderTextureSize:Vector2 = Vector2(256, 256);
var renderTextureFormat:RenderTextureFormat = RenderTextureFormat.ARGB32;
private var renderTarget:RenderTexture;
private var setAlphaShader:String =
    "Shader \"Hidden/Masked Texture\" {" +
    " Properties {" +
    "  _Mask (\"Mask (RGBA)\", 2D) = \"white\" {}" +
    " }" +
    " SubShader {" +
    "  ZTest Always Cull Off ZWrite Off" +
    "  Pass {" +
    "   SetTexture [_MainTex] {" +
    "    combine texture" +
    "   }" +
    "  }" +
    "     Pass {" +
    "   ColorMask A" +
    "   Color(1,1,1,1)" +
    "   SetTexture [_Mask] {" +
    "    combine previous *texture alpha" +
    "   }" +
    "  }" +
    " }" +
    "}";
private var maskMat:Material;
private function GetMaskMaterial():Material {
    if (!maskMat) {
        maskMat = Material(setAlphaShader);
        maskMat.hideFlags = HideFlags.HideAndDontSave;
    }
    return maskMat;
}
private function init():void {
    if (camera) {
        if (!camera.targetTexture) {
            if (!renderTarget) {
                renderTarget = new RenderTexture(renderTextureSize.x, renderTextureSize.y, renderTextureFormat);
                renderTarget.hideFlags = HideFlags.DontSave;
            }
            camera.targetTexture = renderTarget;
            camera.aspect = 1.0;
        } else {
            renderTarget = camera.targetTexture;
            renderTextureSize.x = camera.targetTexture.width;
            renderTextureSize.y = camera.targetTexture.height;
            renderTextureFormat = camera.targetTexture.depth;
        }
    }
   
    GetMaskMaterial();
    if (maskMat) {
        maskMat.SetTexture("_Mask", maskTexture);
    }
}

function Start() {
    init();
}
function OnGUI() {
    if (renderTarget) {
        GUI.DrawTexture(drawRect, renderTarget);
    }
}
function OnEnable() {
    camera.enabled = true;
}
function OnDisable() {
    camera.enabled = false;
}
function OnRenderImage(source:RenderTexture, dest:RenderTexture) {
    if (maskMat) {
        source.SetGlobalShaderProperty("_MainTex");
        Graphics.Blit(source, dest, maskMat);
    }
}
 
function getMaskMaterial():Material {
    return maskMat;
}
