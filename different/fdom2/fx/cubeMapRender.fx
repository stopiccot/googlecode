matrix World;
matrix View;
matrix Projection;

Texture2D Texture;
Texture2D Texture2;
Texture2D Texture3;

SamplerState sam
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
};

RasterizerState CullBack
{
	
	CullMode          = BACK;
	MultisampleEnable = FALSE;
};

RasterizerState CullNone
{
	FillMode          = SOLID;
	CullMode          = NONE;
	MultisampleEnable = FALSE;
};

DepthStencilState EnableDepth
{
    DepthEnable    = TRUE;
    DepthWriteMask = ALL;
};

DepthStencilState DisableDepth
{
    DepthEnable    = FALSE;
    DepthWriteMask = 0;
};

float3 camPos;
float3 lightPos;

struct VS_INPUT
{
	float4 Pos      : POSITION;
	float2 Tex      : TEXCOORD;
	float3 Norm     : NORMAL;
};

struct GS_INPUT
{
	float4 svPos    : SV_POSITION;
	float2 Tex      : TEXCOORD0;
	float4 Pos      : COLOR0;
    float3 N        : COLOR1;
};

struct PS_INPUT
{
    float4 svPos    : SV_POSITION;
    float2 Tex      : TEXCOORD0;
    float4 Pos      : COLOR0;
    float3 N        : COLOR1;
    float3 color    : COLOR2;
    uint   RTIndex  : SV_RENDERTARGETARRAYINDEX;
};

struct PS_OUTPUT
{
	float4 Col      : SV_Target;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
GS_INPUT VS( VS_INPUT input )
{
    GS_INPUT output = (GS_INPUT)0;
    output.Pos      = input.Pos;
    output.svPos    = input.Pos;
    output.N        = input.Norm;
	output.Tex      = input.Tex;	
    return output;
}

//--------------------------------------------------------------------------------------
// Geometry Shader
//--------------------------------------------------------------------------------------
[maxvertexcount(18)]
void GS(triangle GS_INPUT input[3], inout TriangleStream<PS_INPUT> stream)
{
	PS_INPUT output = (PS_INPUT)0;
				
	for (int i = 0; i < 6; i++)
	{
		for (int k = 0; k < 3; k++)
		{
			output.svPos   = input[k].svPos;
			output.Tex     = input[k].Tex;
			output.Pos     = input[k].Pos;
			output.N       = input[k].N;
			if (i == 0) output.color = float3(1.0, 0.0, 0.0);
			if (i == 1) output.color = float3(1.0, 1.0, 0.0);
			if (i == 2) output.color = float3(0.0, 1.0, 0.0);
			if (i == 3) output.color = float3(0.0, 1.0, 1.0);
			if (i == 4) output.color = float3(0.0, 0.0, 1.0);
			if (i == 5) output.color = float3(1.0, 0.0, 1.0);
			output.RTIndex = i;
			
			stream.Append(output);
		}
	
		stream.RestartStrip();
	}
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------


PS_OUTPUT PS(PS_INPUT input)
{
    PS_OUTPUT output = (PS_OUTPUT)0;
    
	output.Col = float4(input.color, 1.0);
				
    return output;
}


//--------------------------------------------------------------------------------------
technique10 Render
{
    pass P0
    {
        SetVertexShader( CompileShader( vs_4_0, VS() ) );
        SetGeometryShader( CompileShader( gs_4_0, GS() ) );
        SetPixelShader( CompileShader( ps_4_0, PS() ) );
        SetRasterizerState(CullNone);
        SetDepthStencilState(DisableDepth, 0);
    }
}



