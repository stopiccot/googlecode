Texture2D texture0;
float4x4 projection;
float4x4 world;

SamplerState DX10Sampler
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};

struct VS_INPUT
{
	float4 Pos: POSITION;
	float2 Tex: TEXCOORD;
};

struct VS_OUTPUT
{
	float4 Pos: SV_POSITION;
	float2 Tex: TEXCOORD;
};

VS_OUTPUT vs(VS_INPUT input)
{
	VS_OUTPUT output;
	output.Pos = mul(mul(input.Pos, world), projection);
	output.Tex = input.Tex;
	return output;
}

float4 ps(VS_OUTPUT input): SV_Target0
{
	return texture0.Sample(DX10Sampler, input.Tex);
}

technique10 Render
{
	pass P0
	{
		SetVertexShader( CompileShader(vs_4_0, vs()) );
		SetGeometryShader(NULL);
		SetPixelShader(  CompileShader(ps_4_0, ps()) );
	}
}