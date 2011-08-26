//--------------------------------------------------------------------------------------
// File: Tutorial04.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
matrix World;
matrix View;
matrix Projection;

float3 lightPos;
float3 camPos;

Texture2D Texture;
SamplerState sam
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

DepthStencilState DisableDepth
{
    DepthEnable = FALSE;
    DepthWriteMask = 0;
};

//--------------------------------------------------------------------------------------
struct VS_INPUT
{
	float4 Pos  : POSITION;
	float3 Col  : COLOR;
	float2 Tex  : TEXCOORD;
};

struct PS_INPUT
{
    float4 svPos : SV_POSITION;
    float3 Col   : COLOR;
    float2 Tex   : TEXCOORD;
};

struct PS_OUTPUT
{
	float4 Col0: SV_Target0;
	float4 Col1: SV_Target1;
	float4 Col2: SV_Target2;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT input )
{
    PS_INPUT output = (PS_INPUT)0;
    output.svPos = input.Pos;
    output.Col   = input.Col;
	output.Tex   = input.Tex;
    return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
PS_OUTPUT PS( PS_INPUT input )
{
	PS_OUTPUT output = (PS_OUTPUT)0;
    
	output.Col0 = float4(input.Col, 1.0) * Texture.Sample(sam, input.Tex);
    return output;
}


//--------------------------------------------------------------------------------------
technique10 Render
{
    pass P0
    {
        SetVertexShader(CompileShader( vs_4_0, VS() ));
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader( ps_4_0, PS() ));
        SetDepthStencilState(DisableDepth, 0);
    }
}


