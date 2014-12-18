// В этом файле находиться всех шейдеров, используемых в игре, а в ней
// фиксированный графический конвеер не используется(абсолютно весь вывод 
// графики через шейдеры). Я специально не компилировал, чтоб страждующие 
// могли побаловаться, но будьте осторожны можно легко угробить игру
// (сделайте резервнюу копию). Кстати это единственный C-подобный код,
// используемый в игре. Просто паскалеподобных высокоуровневых шейдерных
// языков не существует в принципе. Да ещё DirectX, поддерживает только 
// HLSL(High Level Shader Language). Ещё я знаю только Cg(продукт nVIDIA, но
// только для GeForce), и GLSL для OpenGL.

texture t0;

sampler ClampSampler = sampler_state
{ 
    Texture = <t0>; 
    AddressU = Clamp; 
    AddressV = Clamp; 
    MinFilter = Point;    
    MipFilter = Point; 
    MagFilter = Point; 
};

sampler WrapSampler = sampler_state
{ 
    Texture = <t0>; 
    AddressU = Wrap; 
    AddressV = Wrap;
    MipFilter = Point; 
    MinFilter = Point; 
    MagFilter = Point; 
};

sampler LinearClampSampler = sampler_state
{ 
    Texture = <t0>; 
    AddressU = Clamp; 
    AddressV = Clamp; 
    MipFilter = Linear; 
    MinFilter = Linear; 
    MagFilter = Linear; 
};

// Так игра 2D-шная, то вершинный шейдер один на всё, да и то простейший.
// Всё, что он делает это без изменений отправляет входные данные напрямую к 
// пиксельному шейдеру

void vNormal(in  float4 iPos: POSITION,
             in  float4 iCol: COLOR0,
             in  float4 iTex: TEXCOORD0,
             out float4 oPos: POSITION,
             out float4 oCol: COLOR0,
             out float4 oTex: TEXCOORD0)
{
	oPos = iPos;
	oCol = iCol;
	oTex = iTex;
}

// Три простейших пиксельных шейдера, отвечающие за "нориальный" вывод графики,
// последний шейдер ещё с линейной фильтрацией(анизотропная наверное будет слишком круто 
// для этой игры?)
 
void pNormal(in  float2 iTex: TEXCOORD0,
             in  float4 iCol: COLOR0,
             out float4 oCol: COLOR0)
{
	oCol = tex2D(ClampSampler, iTex)*iCol;
}

void pGrid(in  float2 iTex: TEXCOORD0,
           in  float4 iCol: COLOR0,
           out float4 oCol: COLOR0)
{
	oCol = tex2D(WrapSampler, iTex)*iCol;
}

void pAngle(in  float2 iTex: TEXCOORD0,
            in  float4 iCol: COLOR0,
            out float4 oCol: COLOR0)
{
	oCol = tex2D(LinearClampSampler, iTex)*iCol;
}

// Шейдер "рисования" фонового рисунка в главном меню

void pTest(in  float2 iTex: TEXCOORD0,
           in  float4 iCol: COLOR0,
           out float4 oCol: COLOR0)
{
     oCol = tex2D(ClampSampler, iTex);
     if (oCol.r > iCol.w) oCol = 0; else
     if (oCol.g > iCol.w) oCol = 0; else
     if (oCol.b > iCol.w) oCol = 0;
}

// Два шейдера для вывода цветной текстуры в чёрнобелом варианте.
// Второй с фильтрацией. Как видите ничего сложного: скалярное 
// произведение двух векторов.

float3 C = { 0.2125f, 0.7154f, 0.0721f };

void pBlackAndWhite(in  float2 iTex: TEXCOORD0,
                    in  float4 iCol: COLOR0,
                    out float4 oCol: COLOR0)
{
     oCol = tex2D(ClampSampler, iTex);
     oCol.rgb = dot(oCol.rgb, C);
     oCol.a = oCol.a*iCol.a;
}

void pBlackAndWhiteSmooth(in  float2 iTex: TEXCOORD0,
                          in  float4 iCol: COLOR0,
                          out float4 oCol: COLOR0)
{
     oCol = tex2D(LinearClampSampler, iTex);
     oCol.rgb = dot(oCol.rgb, C);
     oCol.a = oCol.a*iCol.a;
}

// А вот это водичка...всего три строчки :) Теперь понимаете почему
// она "синусная"? Можете сделать "косинусной" - всё равно ничего не 
// поменятся :) Можете побаловаться с коэффициентами, только опять же 
// осторожно :)

extern float a;
extern float b;

void pWaves(in  float2 iTex: TEXCOORD0,
            in  float4 iCol: COLOR0,
            out float4 oCol: COLOR0)
{
      iTex.y += 0.0015*sin(50*iTex.x+b)*iCol.a;
	iTex.x += 0.003*sin(50*iTex.y+a)*iCol.a;
	oCol = tex2D(LinearClampSampler, iTex);
}

technique Normal
{
      pass P0
	{
		VertexShader = compile vs_1_1 vNormal();
		PixelShader = compile ps_1_1 pNormal();
      }
}

technique Grid
{
	pass P0
	{
		VertexShader = compile vs_1_1 vNormal();
		PixelShader = compile ps_1_1 pGrid();
	}
}

technique Angle
{
	pass P0
	{
		VertexShader = compile vs_1_1 vNormal();
		PixelShader = compile ps_1_1 pAngle();
	}
}

technique Test
{
	pass P0
	{
		VertexShader = compile vs_1_1 vNormal();
		PixelShader = compile ps_1_4 pTest();
	}
}

technique BlackAndWhite
{
	pass P0
	{
		VertexShader = compile vs_1_1 vNormal();
		PixelShader = compile ps_1_1 pBlackAndWhite();
	}
}

technique BlackAndWhiteSmooth
{
	pass P0
	{
		VertexShader = compile vs_1_1 vNormal();
		PixelShader = compile ps_1_1 pBlackAndWhiteSmooth();
	}
}

technique Blur
{
	pass P0
	{
		VertexShader = compile vs_1_1 vNormal();
		PixelShader = compile ps_2_0 pWaves();
	}
}