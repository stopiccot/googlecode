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
SamplerState samLinear
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
};

RasterizerState CullNone
{
	CullMode = NONE;
	MultisampleEnable = TRUE;
};

//--------------------------------------------------------------------------------------
struct VS_INPUT
{
	float4 Pos  : POSITION;
	float2 Tex  : TEXCOORD;
	float3 Norm : NORMAL;
};

struct PS_INPUT
{
    float4 svPos : SV_POSITION;
    float4 Pos   : COLOR;
    float3 Norm  : NORMAL;
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
    output.svPos = mul(mul(mul(input.Pos, World), View), Projection);
    output.Pos   = mul(input.Pos, World);
    output.Norm  = mul(input.Norm, World);
    return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
PS_OUTPUT PS( PS_INPUT input )
{
	float3 L = normalize(lightPos - input.Pos);
	float3 N = normalize(input.Norm);
	
    PS_OUTPUT output = (PS_OUTPUT)0;
    
    float coeff = dot(L, N);
    
    output.Col0 = lerp(float4(1.0, 0.2, 0.0, 1.0), float4(1.0, 0.75, 0.0, 1.0), coeff );
    //output.Col0 *= max(1.5 - length(input.Pos - lightPos) / 30.0, 0.1);
	output.Col0.a = 1.0;
	
	output.Col1 = output.Col0;
	//output.Col0 = float4(0.0, 0.0, 0.0, 0.0);
        
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
        SetRasterizerState(CullNone);
    }
}


