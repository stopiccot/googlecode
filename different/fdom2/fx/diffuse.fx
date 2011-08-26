matrix World;
matrix View;
matrix Projection;

float3 color;

Texture2D Texture;
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
    float4 Pos   : COLOR;
    float3 N     : NORMAL;
    float2 Tex   : TEXCOORD;
    float3 Light : NORMAL2;
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
    return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
PS_OUTPUT PS( PS_INPUT input )
{
    PS_OUTPUT output = (PS_OUTPUT)0;
	output.Col0 = float4(color, 1.0f);
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


