matrix World;
matrix View;
matrix Projection;

float3 lightPos;
float3 camPos;

RasterizerState CullNone
{
	CullMode          = NONE;
	MultisampleEnable = TRUE;
};

RasterizerState CullBack
{
	CullMode          = BACK;
	MultisampleEnable = TRUE;
};

Texture2D Texture;
SamplerState samLinear
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

TextureCube envTexture;
SamplerState samLinearClamp
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};

struct VS_INPUT
{
	float4 Pos   : POSITION;
	float2 Tex   : TEXCOORD;
	float3 Norm  : NORMAL;
};

struct PS_INPUT
{
    float4 svPos : SV_POSITION;
    float3 Pos   : TEXCOORD2;
    float3 Norm  : NORMAL;
    float2 Tex   : TEXCOORD;
    //float3 ViewR : TEXCOORD2;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT input )
{
    PS_INPUT output = (PS_INPUT)0;
    output.Tex      = input.Tex;
    output.Norm     = mul(input.Norm, World);
    output.Pos      = mul((float3)input.Pos,  World);
    output.svPos    = mul(mul(mul(input.Pos,  World), View), Projection);
	return output;
}

PS_INPUT VS2( VS_INPUT input )
{
    PS_INPUT output = (PS_INPUT)0;
    float4 pos      = input.Pos + float4(2.0, 0.0, 0.0, 0.0);
    output.svPos    = mul(mul(mul(pos, World), View), Projection);
    return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
struct PS_OUTPUT
{
	float4 Col0 : SV_Target0;
	float4 Col1 : SV_Target1;
};

PS_OUTPUT PS(PS_INPUT input)
{
	PS_OUTPUT output = (PS_OUTPUT)0;
	float3 viewR  = reflect( normalize(lerp(normalize(input.Norm),normalize(input.Pos), 0.6) ), float3(-1.0, 0.0, 0.0));
	viewR.x = -viewR.x;
    output.Col0 = envTexture.Sample(samLinearClamp, viewR);
    output.Col0.a = 1.0f;
    output.Col1 = float4(0.0, 0.0, 0.0, 0.0);
    return output;
}

PS_OUTPUT PS2(PS_INPUT input)
{
	PS_OUTPUT output = (PS_OUTPUT)0;
    output.Col0 = float4(1.0, 0.5, 0.0, 0.2);
    output.Col1 = float4(0.0, 0.0, 0.0, 0.0);
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
    /*
    pass P1
    {
		SetVertexShader(CompileShader( vs_4_0, VS2() ));
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader( ps_4_0, PS2() ));
        SetRasterizerState(CullBack);
    }
    */
}


