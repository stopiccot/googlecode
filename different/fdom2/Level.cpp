#include "Level.h"
#include "code\Direct3D10.h"
#include "code\Effect.h"
#include "code\Texture.h"
#include <iostream>

int w, h;
int level[100][100];

Texture wallColor, wallNormals, wallHeight, floorColor, floorNormals, floorHeight;
UberMesh *plane, *axis;

//Effect3D *parallax, *solidColor;

ShaderVector3 lightPos, camPos, color;
ID3D10EffectScalarVariable* enableMapping;
ID3D10EffectShaderResourceVariable *texture3;
ID3D10EffectMatrixVariable *cubeViewMatrices;

int nFloors = 0, nWalls = 0;

ID3D10Buffer *floorVertex, *floorIndex, *wallVertex, *wallIndex;

Effect3D parallax, solidColor;

void initLevel()
{
	// Load textures
	wallColor     = Texture::LoadFromFile(L"textures\\wall_color_512.png");
	wallNormals   = Texture::LoadFromFile(L"textures\\wall_normals_512.png");
	wallHeight    = Texture::LoadFromFile(L"textures\\wall_depth_512.png");
	floorColor    = Texture::LoadFromFile(L"textures\\floor_color_256.png");
	floorNormals  = Texture::LoadFromFile(L"textures\\floor_normals_512.png");
	floorHeight   = Texture::LoadFromFile(L"textures\\floor_depth_512.png");

	plane         = new UberMesh(L"models\\wall.txt");
	axis          = new UberMesh(L"models\\axis.txt");
	plane->setScale(5.0, 1.0, 5.0);
	axis->setScale(0.5f, 0.5f, 0.5f);

	parallax      = Effect3D::Create(L"fx\\wall.fx");
	solidColor    = Effect3D::Create(L"fx\\diffuse.fx");
	lightPos      = parallax.getVector3("lightPos");
	camPos        = parallax.getVector3("camPos");
	enableMapping = parallax.effect->GetVariableByName("EnableMapping")->AsScalar();
	texture3      = parallax.effect->GetVariableByName("Texture3")->AsShaderResource();

	cubeViewMatrices = parallax.effect->GetVariableByName("viewCM")->AsMatrix();


	color        = solidColor.getVector3("color");

	// Read level from file
	ZeroMemory(&level, sizeof(level));
	
	FILE *input;
	_wfopen_s(&input, L"map.txt", L"r");
	fscanf(input, "%d %d", &w, &h);
    
	for (int i = 1; i <= h; ++i)
		for (int j = 1; j <= w; ++j)
		{
			char c; fread((void*)&c, 1, 1, input);
			if (c == 10) fread((void*)&c, 1, 1, input);
			switch (c)
			{
				case 'W':
				{
					level[i][j] = 0;
					break;
				}
				case '0': case '1': case '2': case '3': case '4' : case '5':
				{
					level[i][j] = (c - '0') + 1;
					break;
				}
			}
		}

	fclose(input);

	// Compute nFloors an nWalls
	for (int i = 1; i <= h; ++i)
		for (int j = 1; j <= w; ++j)
			if (level[i][j] > 0)
			{
				nFloors++;
				if (level[i-1][j] == 0) nWalls++;
				if (level[i+1][j] == 0) nWalls++;
				if (level[i][j-1] == 0) nWalls++;
				if (level[i][j+1] == 0) nWalls++;
			}

	{
		D3D10_BUFFER_DESC vb;
		
		vb.Usage          = D3D10_USAGE_DEFAULT;
		vb.ByteWidth      = 4 * nFloors * sizeof(Vertex3D); // 4 vertex per floor cell
		vb.BindFlags      = D3D10_BIND_VERTEX_BUFFER;
		vb.CPUAccessFlags = 0;
		vb.MiscFlags      = 0;

		D3D10_BUFFER_DESC ib;

		ib.Usage          = D3D10_USAGE_DEFAULT;
		ib.ByteWidth      = 6 * nFloors * sizeof(DWORD);
		ib.BindFlags      = D3D10_BIND_INDEX_BUFFER;
		ib.CPUAccessFlags = 0;
		ib.MiscFlags      = 0;

		Vertex3D* vData = new Vertex3D[ 4 * nFloors ];
		DWORD* iData    = new DWORD[ 6 * nFloors ];

		int v = 0, k = 0;

		for (int i = 1; i <= h; ++i)
			for (int j = 1; j <= w; ++j)
				if (level[i][j] > 0)
				{
					for (int m = 0; m < 4; m++)
					{
						vData[v + m].Pos.y  = -5.0;
						vData[v + m].Norm.x =  0.0;
						vData[v + m].Norm.y =  1.0;
						vData[v + m].Norm.z =  0.0;
					}

					vData[ v ].Pos.x = 10.0 * i - 5.0; 
					vData[ v ].Pos.z = 10.0 * j - 5.0;
					vData[ v ].Tex.x = 1.0;
					vData[ v ].Tex.y = 0.0;

					vData[v+1].Pos.x = 10.0 * i - 5.0;
					vData[v+1].Pos.z = 10.0 * j + 5.0;
					vData[v+1].Tex.x = 1.0;
					vData[v+1].Tex.y = 1.0;

					vData[v+2].Pos.x = 10.0 * i + 5.0;
					vData[v+2].Pos.z = 10.0 * j - 5.0;
					vData[v+2].Tex.x = 0.0;
					vData[v+2].Tex.y = 0.0;

					vData[v+3].Pos.x = 10.0 * i + 5.0;
					vData[v+3].Pos.z = 10.0 * j + 5.0;
					vData[v+3].Tex.x = 0.0;
					vData[v+3].Tex.y = 1.0;

					iData[k + 0] = v; 
					iData[k + 1] = v + 1;
					iData[k + 2] = v + 2;
					iData[k + 3] = v + 2;
					iData[k + 4] = v + 1;
					iData[k + 5] = v + 3;

					v += 4;
					k += 6;
			}
	
		D3D10_SUBRESOURCE_DATA InitData;
		HRESULT hr;

		InitData.pSysMem = vData;
		hr = D3D10.getDevice()->CreateBuffer(&vb, &InitData, &floorVertex);
		if (FAILED(hr)) MessageBox(D3D10.getHWND(), L"vb", L"Level.cpp", MB_OK);

		InitData.pSysMem = iData;
		hr = D3D10.getDevice()->CreateBuffer(&ib, &InitData, &floorIndex);
		if (FAILED(hr)) MessageBox(D3D10.getHWND(), L"ib", L"Level.cpp", MB_OK);

		delete [] vData;
		delete [] iData;
	}
	{
		D3D10_BUFFER_DESC vb;
		
		vb.Usage          = D3D10_USAGE_DEFAULT;
		vb.ByteWidth      = 4 * nWalls * sizeof(Vertex3D); // 4 vertex per floor cell
		vb.BindFlags      = D3D10_BIND_VERTEX_BUFFER;
		vb.CPUAccessFlags = 0;
		vb.MiscFlags      = 0;

		D3D10_BUFFER_DESC ib;

		ib.Usage          = D3D10_USAGE_DEFAULT;
		ib.ByteWidth      = 6 * nWalls * sizeof(DWORD);
		ib.BindFlags      = D3D10_BIND_INDEX_BUFFER;
		ib.CPUAccessFlags = 0;
		ib.MiscFlags      = 0;

		Vertex3D* vData = new Vertex3D[ 4 * nWalls ];
		DWORD* iData    = new DWORD[ 6 * nWalls ];

		int v = 0, k = 0;

		for (int i = 1; i <= h; ++i)
			for (int j = 1; j <= w; ++j)
				if (level[i][j] > 0)
				{
					if (level[i-1][j] == 0)
					{
						for (int m = 0; m < 4; m++)
						{
							vData[v + m].Pos.x  = 10.0 * i - 5.0;
							vData[v + m].Norm.x = 1.0;
							vData[v + m].Norm.y = 0.0;
							vData[v + m].Norm.z = 0.0;
						}

						vData[ v ].Pos.y = 5.0; 
						vData[ v ].Pos.z = 10.0 * j - 5.0;
						vData[ v ].Tex.x = 0.0;
						vData[ v ].Tex.y = 0.0;

						vData[v+1].Pos.y = 5.0;
						vData[v+1].Pos.z = 10.0 * j + 5.0;
						vData[v+1].Tex.x = 1.0;
						vData[v+1].Tex.y = 0.0;

						vData[v+2].Pos.y = -5.0;
						vData[v+2].Pos.z = 10.0 * j - 5.0;
						vData[v+2].Tex.x = 0.0;
						vData[v+2].Tex.y = 1.0;

						vData[v+3].Pos.y = -5.0;
						vData[v+3].Pos.z = 10.0 * j + 5.0;
						vData[v+3].Tex.x = 1.0;
						vData[v+3].Tex.y = 1.0;

						iData[k + 0] = v;
						iData[k + 1] = v + 1;
						iData[k + 2] = v + 2;
						iData[k + 3] = v + 2;
						iData[k + 4] = v + 1;
						iData[k + 5] = v + 3;

						v += 4;
						k += 6;
					}
					if (level[i+1][j] == 0)
					{
						for (int m = 0; m < 4; m++)
						{
							vData[v + m].Pos.x  = 10.0 * i + 5.0;
							vData[v + m].Norm.x = 1.0;
							vData[v + m].Norm.y = 0.0;
							vData[v + m].Norm.z = 0.0;
						}

						vData[ v ].Pos.y = 5.0; 
						vData[ v ].Pos.z = 10.0 * j + 5.0;
						vData[ v ].Tex.x = 0.0;
						vData[ v ].Tex.y = 0.0;

						vData[v+1].Pos.y = 5.0;
						vData[v+1].Pos.z = 10.0 * j - 5.0;
						vData[v+1].Tex.x = 1.0;
						vData[v+1].Tex.y = 0.0;

						vData[v+2].Pos.y = -5.0;
						vData[v+2].Pos.z = 10.0 * j + 5.0;
						vData[v+2].Tex.x = 0.0;
						vData[v+2].Tex.y = 1.0;

						vData[v+3].Pos.y = -5.0;
						vData[v+3].Pos.z = 10.0 * j - 5.0;
						vData[v+3].Tex.x = 1.0;
						vData[v+3].Tex.y = 1.0;

						iData[k + 0] = v;
						iData[k + 1] = v + 1;
						iData[k + 2] = v + 2;
						iData[k + 3] = v + 2;
						iData[k + 4] = v + 1;
						iData[k + 5] = v + 3;

						v += 4;
						k += 6;
					}
					if (level[i][j-1] == 0)
					{
						for (int m = 0; m < 4; m++)
						{
							vData[v + m].Pos.z  = 10.0 * j - 5.0;
							vData[v + m].Norm.x = 0.0;
							vData[v + m].Norm.y = 0.0;
							vData[v + m].Norm.z = 1.0;
						}

						vData[ v ].Pos.y = 5.0; 
						vData[ v ].Pos.x = 10.0 * i + 5.0;
						vData[ v ].Tex.x = 0.0;
						vData[ v ].Tex.y = 0.0;

						vData[v+1].Pos.y = 5.0;
						vData[v+1].Pos.x = 10.0 * i - 5.0;
						vData[v+1].Tex.x = 1.0;
						vData[v+1].Tex.y = 0.0;

						vData[v+2].Pos.y = -5.0;
						vData[v+2].Pos.x = 10.0 * i + 5.0;
						vData[v+2].Tex.x = 0.0;
						vData[v+2].Tex.y = 1.0;

						vData[v+3].Pos.y = -5.0;
						vData[v+3].Pos.x = 10.0 * i - 5.0;
						vData[v+3].Tex.x = 1.0;
						vData[v+3].Tex.y = 1.0;

						iData[k + 0] = v;
						iData[k + 1] = v + 1;
						iData[k + 2] = v + 2;
						iData[k + 3] = v + 2;
						iData[k + 4] = v + 1;
						iData[k + 5] = v + 3;

						v += 4;
						k += 6;
					}					
					if (level[i][j+1] == 0)
					{
						for (int m = 0; m < 4; m++)
						{
							vData[v + m].Pos.z  = 10.0 * j + 5.0;
							vData[v + m].Norm.x = 0.0;
							vData[v + m].Norm.y = 0.0;
							vData[v + m].Norm.z = 1.0;
						}

						vData[ v ].Pos.y = 5.0; 
						vData[ v ].Pos.x = 10.0 * i - 5.0;
						vData[ v ].Tex.x = 0.0;
						vData[ v ].Tex.y = 0.0;

						vData[v+1].Pos.y = 5.0;
						vData[v+1].Pos.x = 10.0 * i + 5.0;
						vData[v+1].Tex.x = 1.0;
						vData[v+1].Tex.y = 0.0;

						vData[v+2].Pos.y = -5.0;
						vData[v+2].Pos.x = 10.0 * i - 5.0;
						vData[v+2].Tex.x = 0.0;
						vData[v+2].Tex.y = 1.0;

						vData[v+3].Pos.y = -5.0;
						vData[v+3].Pos.x = 10.0 * i + 5.0;
						vData[v+3].Tex.x = 1.0;
						vData[v+3].Tex.y = 1.0;

						iData[k + 0] = v;
						iData[k + 1] = v + 1;
						iData[k + 2] = v + 2;
						iData[k + 3] = v + 2;
						iData[k + 4] = v + 1;
						iData[k + 5] = v + 3;

						v += 4;
						k += 6;
					}					
				}
	
		D3D10_SUBRESOURCE_DATA InitData;
		HRESULT hr;

		InitData.pSysMem = vData;
		hr = D3D10.getDevice()->CreateBuffer(&vb, &InitData, &wallVertex);
		if (FAILED(hr)) MessageBox(D3D10.getHWND(), L"vb", L"Level.cpp", MB_OK);

		InitData.pSysMem = iData;
		hr = D3D10.getDevice()->CreateBuffer(&ib, &InitData, &wallIndex);
		if (FAILED(hr)) MessageBox(D3D10.getHWND(), L"ib", L"Level.cpp", MB_OK);
		
		delete [] vData;
		delete [] iData;
	}
}

void renderLevelCubeMap(D3DXMATRIX *view, D3DXMATRIX *projection)
{
	D3D10_VIEWPORT OldVP;
    UINT cRT = 1;
	D3D10.getDevice()->RSGetViewports( &cRT, &OldVP );

	D3D10_VIEWPORT vp;
	vp.Width  = 256;
	vp.Height = 256;
	vp.MinDepth = 0.0f;
	vp.MaxDepth = 1.0f;
	vp.TopLeftX = 0;
	vp.TopLeftY = 0;
	D3D10.getDevice()->RSSetViewports( 1, &vp );

	static UINT stride = sizeof(Vertex3D);
	static UINT offset = 0;

	Technique tech = parallax.getTechnique("RenderCubeMap");
	D3D10.getDevice()->IASetInputLayout(tech.layout);
	D3D10.getDevice()->IASetPrimitiveTopology(D3D10_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

	cubeViewMatrices->SetMatrixArray((float*)view, 0, 6);

	parallax.setViewProjection(view[0], *projection);

	D3DXMATRIX E;
	D3DXMatrixIdentity(&E);
	parallax.worldMatrix->SetMatrix((float*)&E);

	parallax.flushShaderVariables();

	D3D10_TECHNIQUE_DESC techDesc;
	tech.tech->GetDesc(&techDesc);
	//==========================================================================
	enableMapping->SetBool(0);
	parallax.setTextures(floorColor, floorNormals);
	texture3->SetResource(floorHeight.getShaderResourceView());
	D3D10.getDevice()->IASetVertexBuffers(0, 1, &floorVertex, &stride, &offset);
	D3D10.getDevice()->IASetIndexBuffer(floorIndex, DXGI_FORMAT_R32_UINT, 0);
	for( UINT i = 0; i < techDesc.Passes; ++i )
	{
		tech.tech->GetPassByIndex(i)->Apply(i);
		D3D10.getDevice()->DrawIndexed(6 * nFloors, 0, 0);
	}
	
	//==========================================================================
	enableMapping->SetBool(1);
	parallax.setTextures(wallColor, wallNormals);
	texture3->SetResource(wallHeight.getShaderResourceView());
	D3D10.getDevice()->IASetVertexBuffers(0, 1, &wallVertex, &stride, &offset);
	D3D10.getDevice()->IASetIndexBuffer(wallIndex, DXGI_FORMAT_R32_UINT, 0);

	for( UINT i = 0; i < techDesc.Passes; ++i )
	{
		tech.tech->GetPassByIndex(i)->Apply(i);
		D3D10.getDevice()->DrawIndexed(6 * nWalls, 0, 0);
	}

	D3D10.getDevice()->RSSetViewports( 1, &OldVP );
}

void renderLevel(const D3DXMATRIX &view, const D3DXMATRIX &projection, const D3DXVECTOR3 &eye, bool b)
{
	static UINT stride = sizeof(Vertex3D);
	static UINT offset = 0;

	Technique tech = parallax.getTechnique("Render");
	D3D10.getDevice()->IASetInputLayout(tech.layout);
	D3D10.getDevice()->IASetPrimitiveTopology(D3D10_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

	parallax.setViewProjection(view, projection);
	lightPos = eye;
	camPos   = eye;

	enableMapping->SetBool(0);

	D3DXMATRIX E;
	D3DXMatrixIdentity(&E);
	parallax.worldMatrix->SetMatrix((float*)&E);

	parallax.flushShaderVariables();

	D3D10_TECHNIQUE_DESC techDesc;
	tech.tech->GetDesc(&techDesc);
	//==========================================================================
	enableMapping->SetBool(0);
	parallax.setTextures(floorColor, floorNormals);
	texture3->SetResource(floorHeight.getShaderResourceView());
	D3D10.getDevice()->IASetVertexBuffers(0, 1, &floorVertex, &stride, &offset);
	D3D10.getDevice()->IASetIndexBuffer(floorIndex, DXGI_FORMAT_R32_UINT, 0);

	for( UINT i = 0; i < techDesc.Passes; ++i )
	{
		tech.tech->GetPassByIndex(i)->Apply(i);
		D3D10.getDevice()->DrawIndexed(6 * nFloors, 0, 0);
	}
	//==========================================================================
	enableMapping->SetBool(1);
	parallax.setTextures(wallColor, wallNormals);
	texture3->SetResource(wallHeight.getShaderResourceView());
	D3D10.getDevice()->IASetVertexBuffers(0, 1, &wallVertex, &stride, &offset);
	D3D10.getDevice()->IASetIndexBuffer(wallIndex, DXGI_FORMAT_R32_UINT, 0);

	for( UINT i = 0; i < techDesc.Passes; ++i )
	{
		tech.tech->GetPassByIndex(i)->Apply(i);
		D3D10.getDevice()->DrawIndexed(6 * nWalls, 0, 0);
	}
}

int _x, _y;

float clamp(float a, float x, float b)
{
	if (x < a) return a;
	else if (x > b) return b;
	else return x;
}

D3DXVECTOR3 lastVec;

void boundCamera(D3DXVECTOR3& vec)
{
	int x = floor( vec.x / 10.0 + 0.5 );
	int y = floor( vec.z / 10.0 + 0.5 );

	if (level[x][y] == 0)
	{
		vec = lastVec;
	}
	else
	{
		float c  = 4.4f;
		float c2 = 4.9f;

		if (level[x-1][ y ] == 0 ||
			level[x-1][y+1] == 0 && vec.z > 10.0 * y + c2 ||
			level[x-1][y-1] == 0 && vec.z < 10.0 * y - c2)
			vec.x = max(10.0 * x - c, vec.x);

		if (level[x+1][ y ] == 0 ||
			level[x+1][y+1] == 0 && vec.z > 10.0 * y + c2 ||
			level[x+1][y-1] == 0 && vec.z < 10.0 * y - c2)
			vec.x = min(10.0 * x + c, vec.x);

		if (level[ x ][y-1] == 0 ||
			level[x+1][y-1] == 0 && vec.x > 10.0 * x + c2 ||
			level[x-1][y-1] == 0 && vec.x < 10.0 * x - c2)
			vec.z = max(10.0 * y - c, vec.z);
		
		if (level[ x ][y+1] == 0 || 
			level[x+1][y+1] == 0 && vec.x > 10.0 * x + c2 ||
			level[x-1][y+1] == 0 && vec.x < 10.0 * x - c2)
			vec.z = min(10.0 * y + c, vec.z);

		lastVec = vec;
	}
}