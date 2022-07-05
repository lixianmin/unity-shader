float4x4 World : WORLD;
float4x4 View : VIEW;
float4x4 ViewI : VIEWI;
float4x4 Projection : PROJECTION;

texture Texture : DiffuseMap< 
	string UIName = "Diffuse Map ";
	int Texcoord = 0;
	int MapChannel = 0;
>;

float Rim_Start <
	string UIName = "Rim Begin";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	float UIStep = 0.01f;
>   = 0.5f;

float Rim_End <
	string UIName = "Rim End";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	float UIStep = 0.01f;
>   = 1.0f;


float Rim_Multiplier <
	string UIName = "Rim Multipler";
	float UIMin = 0.0f;
	float UIMax = 5.0f;
	float UIStep = 0.01f;
>   = 1.0f;

float4 Rim_Color  <
	string UIName = "Rim Color";
> = float4( 1.0f, 1.0f, 1.0f, 1.0f );    // diffuse


float3 LightDirection = normalize(float3(1, -1, 1));
float3 LightColor = float3(0.9, 0.9, 0.9);
float3 AmbientColor = float3(0.4, 0.4, 0.4);


sampler TextureSampler = sampler_state
{
    Texture = (Texture);

    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    
    AddressU = Wrap;
    AddressV = Wrap;
};


struct VertexShaderInput
{
    float4 Position : POSITION0;
    float3 Normal : NORMAL0;
    float2 TexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float3 WorldPosition : TEXCOORD2;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    float4 worldPosition = mul(input.Position, World);
    float4 viewPosition = mul(worldPosition, View);
    output.Position = mul(viewPosition, Projection);
    
    output.WorldPosition = worldPosition;
	output.Normal = mul(input.Normal, World);
	output.TexCoord = input.TexCoord;
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	float3 color;
    color = tex2D(TextureSampler, input.TexCoord);
    
    float3 CameraPosition = ViewI[3];
    float3 N = normalize(input.Normal); 
    float3 V = normalize(CameraPosition - input.WorldPosition);
    float rim = smoothstep(Rim_Start , Rim_End , 1- dot(N,V));
    
	float3 L =  normalize( -LightDirection );
    float lightAmount = max(dot(N, L), 0);
    float lighting = AmbientColor + lightAmount * LightColor;
    
    return float4(color,1) * lighting  + rim*Rim_Multiplier * Rim_Color;
}

technique Rim_Lighting
{
    pass Pass1
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
        AlphaBlendEnable	= FALSE;
		ZEnable           = TRUE;
		ZWriteEnable      = TRUE;
    }
}
