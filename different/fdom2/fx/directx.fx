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
    Filter = ANISOTROPIC ;// ANISOTROPIC;//MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
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
	output.Tex   = input.Tex;
    return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
PS_OUTPUT PS( PS_INPUT input )
{
	float3 L = normalize(lightPos - input.Pos);
	float3 C = normalize(camPos   - input.Pos);
	float3 N = normalize(input.Norm);
	
    PS_OUTPUT output = (PS_OUTPUT)0;
    
    float4 Color = Texture.Sample(samLinear, input.Tex);
        
	output.Col0 =  saturate( dot(L, N) + 0.5 * pow(saturate(dot(L, reflect(-C, N))), 20) ) * Color;
	//output.Col0 += pow(saturate(dot(C, -reflect(L, N))), 100) * float4(0.3, 0.3, 0.3, 1.0);
    
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
    }
}


