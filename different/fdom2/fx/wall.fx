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
	MultisampleEnable = TRUE;
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

struct VS_INPUT
{
	float4 Pos  : POSITION;
	float2 Tex  : TEXCOORD;
	float3 Norm : NORMAL;
};

struct PS_INPUT
{
    float4 svPos    : SV_POSITION;
    float4 Pos      : COLOR0;
    float2 svPoszw  : TEXCOORD3;
    float2 Tex      : TEXCOORD0;
    float3 LightTS  : TEXCOORD1;
    float3 CameraTS : TEXCOORD2;
    float3 T        : TANGENT;
    float3 B        : BINORMAL;
    float3 N        : NORMAL;
};

struct GS_CUBEMAP_INPUT
{
	float4 Pos      : POSITION;
	float2 Tex      : TEXCOORD0;
	float3 Norm     : NORMAL;
};

struct PS_CUBEMAP_INPUT
{
	float4 svPos    : SV_POSITION;
	float2 Tex      : TEXCOORD0;
	float3 Norm     : NORMAL;
	uint   RTIndex  : SV_RenderTargetArrayIndex;
};

cbuffer cbPerFrame
{
	matrix    World;
	matrix    View;
	matrix    Projection;
	float3    camPos;
	float3    lightPos;
	bool      EnableMapping;
};

cbuffer cbPerCubeRender
{
	matrix viewCM[6];
};

//--------------------------------------------------------------------------------------
// vsDefault - default vertex shader
//--------------------------------------------------------------------------------------
PS_INPUT vsDefault(VS_INPUT input)
{
    PS_INPUT output = (PS_INPUT)0;
    output.Pos      = mul(input.Pos, World);
    output.svPos    = mul(mul(mul(input.Pos, World), View), Projection);
    //output.svPos.z  = length(output.Pos.xyz);// * output.svPos.w;
    output.N        = input.Norm;
	output.Tex      = input.Tex;	
    return output;
}

//--------------------------------------------------------------------------------------
// gsCalculateTBN - for each trigangle calculate's TBN
// TODO: precalculate TBN for all models outside shader
//--------------------------------------------------------------------------------------
[maxvertexcount(3)]
void gsCalculateTBN(triangle PS_INPUT input[3], inout TriangleStream<PS_INPUT> stream)
{
	float3 a1 = input[1].Pos - input[0].Pos, a2 = input[2].Pos - input[0].Pos;
	float2 t1 = input[1].Tex - input[0].Tex, t2 = input[2].Tex - input[0].Tex;
	
	float3 T = normalize(t2.y * a1 - t1.y * a2);
	float3 B = normalize(t1.x * a2 - t2.x * a1);
	float3 N = normalize(cross(T, B));
	
	float3x3 Matrix = float3x3(T, B, N);
	
	for (int i = 0; i < 3; i++)
	{
		input[i].T = T; input[i].B = B; input[i].N = N;
		
		input[i].LightTS  = mul(Matrix, lightPos - input[i].Pos);
		input[i].CameraTS = mul(Matrix, camPos   - input[i].Pos);
					
		stream.Append(input[i]);
	}
	
	stream.RestartStrip();
}

//--------------------------------------------------------------------------------------
// vsCubeMap - vertex shader for cubemap render
//--------------------------------------------------------------------------------------
GS_CUBEMAP_INPUT vsCubeMap(VS_INPUT input)
{
	GS_CUBEMAP_INPUT output = (GS_CUBEMAP_INPUT)0;
	output.Pos  = mul(input.Pos, World);
	output.Tex  = input.Tex;
	output.Norm = mul(input.Norm, World);
	return output;
}

//--------------------------------------------------------------------------------------
// gsRenderCubeMap - render to cubemap
//--------------------------------------------------------------------------------------
[maxvertexcount(18)]
void gsCubeMap(triangle GS_CUBEMAP_INPUT input[3], inout TriangleStream<PS_CUBEMAP_INPUT> stream)
{
	PS_CUBEMAP_INPUT output = (PS_CUBEMAP_INPUT)0;
	
	for (int i = 0; i < 6; i++)
	{
		for (int k = 0; k < 3; k++)
		{
			output.svPos   = mul(mul(input[k].Pos, viewCM[i]), Projection);
			output.Norm    = input[k].Norm;
			output.Tex     = input[k].Tex;
			output.RTIndex = i;
			stream.Append(output);
		}
		stream.RestartStrip();
	}
}

//--------------------------------------------------------------------------------------
// psCubeMap - ...
//--------------------------------------------------------------------------------------
float4 psCubeMap(PS_CUBEMAP_INPUT input) : SV_Target
{
	float4 result = Texture.Sample(sam, input.Tex);
	result.a = 1.0;
	return result;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
struct PS_OUTPUT
{
	float4 Col0: SV_Target0;
	float4 Col1: SV_Target1;
	float4 Col2: SV_Target2;
};

float4 coneStep(float2 inputTex, float3 camera, float3 light)
{
	float depth = 10.0;
	camera.z *= depth;
	
	float3 pos = float3(inputTex, 1.0);
	float3 dir = camera / camera.z;
	float3 len = length(dir.xy);
	
	float4 tex = Texture3.Sample(sam, pos.xy);
	
	float3 prevPos = pos;
	
	[unroll(10)]
	while (pos.z - tex.z > 0.01)
	{
		prevPos = pos;
		float coneRatio = 1.2 * tex.r;
		float d = coneRatio * (pos.z - tex.z) / depth / (len + coneRatio);
		pos -= d * dir;
		tex = Texture3.Sample(sam, pos.xy);
	}
	
	float3 middle = (prevPos + pos) / 2.0;
	[unroll(10)]
	for (int i = 0; i < 5; ++i)
	{
		if (middle.z > Texture3.Sample(sam, middle.xy).z)
			prevPos = middle;
		else
			pos = middle;
			
		middle = (prevPos + pos) / 2.0;
	}
	
	float3 normal = normalize(2 * Texture2.Sample(sam, middle.xy) - 1);
	normal = float3(-normal.y, -normal.x, normal.z);
	return dot(light, normal) * Texture.Sample(sam, middle.xy);
}

float4 parallaxMapping(float2 inputTex, float3 camera, float3 light)
{
	float depth = 0.15;
	
	float3 dir = 0.0075 * camera;
	
	dir.z *= 2.0;
	
	float3 pos = float3(inputTex, 0.0);
	
	[unroll(25)]
	while ( pos.z > -depth * Texture3.Sample(sam, pos.xy).b )
		pos -= dir;		
	
	float3 prevPos = pos + dir, middle = (prevPos + pos) / 2.0;
		
	[unroll(5)]
	for (int i = 0; i < 5; ++i)
	{
		if (middle.z > -depth * Texture3.Sample(sam, middle.xy).b)
			prevPos = middle;
		else
			pos = middle;
			
		middle = (prevPos + pos) / 2.0;
	}
	
	float3 normal = 2.0 * Texture2.Sample(sam, middle.xy) - 1.0;
	return 0.5 * (1.0 + dot(light, normal)) * Texture.Sample(sam, middle.xy);
}

float4 normalMapping(float2 inputTex, float3 camera, float3 light)
{
	float3 normal = 2.0 * Texture2.Sample(sam, inputTex) - 1.0;
	return 0.5 * (1.0 + dot(light, normal)) * Texture.Sample(sam, inputTex);
}

PS_OUTPUT PS(PS_INPUT input)
{
    PS_OUTPUT output = (PS_OUTPUT)0;
    
    float3 camera = normalize(input.CameraTS);
    float3 light  = normalize(input.LightTS);
    
    light.y = -light.y;
        
    if (EnableMapping)
		output.Col0 = parallaxMapping(input.Tex, camera, light);
	else
		output.Col0 = normalMapping(input.Tex, camera, light);
		
	float ccc = length(input.Pos - lightPos) / 50.0;
	output.Col0 *= max(1.6 - ccc, 0.25);
	output.Col0.a = 1.0;
	
	output.Col1 = output.Col0;
			
    return output;
}

PS_OUTPUT psShadowMap(PS_INPUT input)
{
	 PS_OUTPUT output = (PS_OUTPUT)0;	
	 float f = input.svPos.z / 100.0;
	 output.Col0 = float4(f, f, f, 1.0);
	 return output;
}

float fog(float3 pos)
{
	return max(1.6 - length(pos - lightPos) / 40.0, 0.15);
}

PS_OUTPUT psNormalMapping(PS_INPUT input)
{
	PS_OUTPUT output = (PS_OUTPUT)0;
	float3 camera = normalize(input.CameraTS);
	float3 light  = normalize(input.LightTS);
	
	light.y = -light.y;
	
	output.Col0 = fog(input.Pos) * normalMapping(input.Tex, camera, light);
	
	output.Col0.a = 1.0;
	
	return output;
}

PS_OUTPUT psNoMapping(PS_INPUT input)
{
	PS_OUTPUT output = (PS_OUTPUT)0;
	float3 camera = normalize(input.CameraTS);
	float3 light  = normalize(input.LightTS);
	
	light.y = -light.y;
	
	output.Col0 = fog(input.Pos) * Texture.Sample(sam, input.Tex);
	output.Col0.a = 1.0;
	
	return output;
}

//--------------------------------------------------------------------------------------
technique10 Render
{
    pass P0
    {
        SetVertexShader(   CompileShader( vs_4_0, vsDefault()      ));
        SetGeometryShader( CompileShader( gs_4_0, gsCalculateTBN() ));
        SetPixelShader(    CompileShader( ps_4_0, PS()             ));
        SetRasterizerState(CullBack);
        SetDepthStencilState(EnableDepth, 0);
    }
}

technique10 ParallaxMapping
{
	pass P0
    {
        SetVertexShader(   CompileShader( vs_4_0, vsDefault()         ));
        SetGeometryShader( CompileShader( gs_4_0, gsCalculateTBN()    ));
        SetPixelShader(    CompileShader( ps_4_0, psNormalMapping() ));
        SetRasterizerState(CullBack);
        SetDepthStencilState(EnableDepth, 0);
    }
}

technique10 RenderCubeMap
{
	pass P0
	{
		SetVertexShader(   CompileShader( vs_4_0, vsCubeMap() ));
        SetGeometryShader( CompileShader( gs_4_0, gsCubeMap() ));
        SetPixelShader(    CompileShader( ps_4_0, psCubeMap() ));
        SetRasterizerState(CullBack);
        SetDepthStencilState(EnableDepth, 0);
	}
}

technique10 RenderShadowMap
{
	pass p0
	{
		SetVertexShader(   CompileShader( vs_4_0, vsDefault()   ));
        SetGeometryShader( NULL                                  );
        SetPixelShader(    CompileShader( ps_4_0, psShadowMap() ));
        SetRasterizerState(CullBack);
        SetDepthStencilState(EnableDepth, 0);
	}
}