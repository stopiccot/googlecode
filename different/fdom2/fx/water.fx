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
float  time;

Texture2D Texture, Texture2;
SamplerState samLinear
{
    Filter = ANISOTROPIC;
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
    float3 Pos   : COLOR0;
    float3 Pos2  : COLOR1;
    float3 Pos3  : COLOR2;
    float3 Norm  : NORMAL;
    float2 Tex   : TEXCOORD;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT input )
{
    PS_INPUT output = (PS_INPUT)0;
    
    output.Pos3 = input.Pos;
    
    output.Pos  = output.svPos  = mul( mul( mul( input.Pos, World ), View), Projection );
    output.Norm = mul( input.Norm, World );
	output.Tex  = input.Tex;
	
	output.Pos2 = mul( mul( mul( float3(0.01, 0.0, 0.0), World ), View), Projection );
	
	return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
struct PS_OUTPUT
{
	float4 Col0: SV_Target0;
	float4 Col1: SV_Target1;
};

PS_OUTPUT PS( PS_INPUT input )
{
    PS_OUTPUT output = (PS_OUTPUT)0;
    
    float2 tex = float2(0.0, 1.0) + (input.Pos / input.svPos.w + 1.0) / float2(2.0, -2.0);
    
	float c = 1.2 * Texture.Sample(samLinear, tex).a;
	
	float ff = sin( 1000 * length( input.Pos3.x ) + 0.05 * sin( 50 * input.Pos3.x / input.Pos3.y ) + time);
	
	tex += input.Pos2 * c * ff;
	
	ff = 0.0;
		
	output.Col0 = float4(60.0 ,74.0, 14.0, 255.0) / 255.0 * Texture.Sample(samLinear, tex);
	
	return output;
}

//--------------------------------------------------------------------------------------

technique10 Render
{
    pass P0
    {
        SetVertexShader( CompileShader( vs_4_0, VS() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, PS() ) );
    }
}

