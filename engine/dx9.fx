texture texture0;
float4x4 projection;
float4x4 world;

sampler DX9Sampler = sampler_state
{ 
    Texture = <texture0>; 
    AddressU = Wrap;
    AddressV = Wrap;
    MipFilter = Linear; 
    MinFilter = Linear; 
    MagFilter = Linear; 
};

struct VS_INPUT
{
	float4 Pos: POSITION;
	float2 Tex: TEXCOORD;
};

struct VS_OUTPUT
{
	float4 Pos: POSITION;
	float2 Tex: TEXCOORD;
};

VS_OUTPUT vs(VS_INPUT input)
{
	VS_OUTPUT output;
	output.Pos = mul(mul(input.Pos, world), projection);
	output.Tex = input.Tex;
	return output;
}

float4 ps(VS_OUTPUT input): COLOR0
{
	return tex2D(DX9Sampler, input.Tex);
}     

#ifndef D3D10
technique Render
{
	pass P0
	{
		CULLMODE = 0x1;
		VertexShader = compile vs_2_0 vs();
		PixelShader  = compile ps_2_0 ps();
	}
}
#else
technique10 Render
{
	pass P0
	{
		SetVertexShader( CompileShader(vs_4_0, vs()) );
		SetGeometryShader(NULL);
		SetPixelShader(  CompileShader(ps_4_0, ps()) );
	}
}
#endif