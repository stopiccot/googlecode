#include "UberMesh.h"
#include <iostream>

UberMesh::UberMesh(const wchar_t *fileName) : vertexBuffer(NULL)
{
	setScale(1.0f, 1.0f, 1.0f);
	setRotate(0.0f, 0.0f, 0.0f);
	setPosition(0.0f, 0.0f, 0.0f);

	FILE *input;

	_wfopen_s(&input, fileName, L"r");

	fscanf(input, "%d", &nVertices);

	data = new UberVertex[nVertices];

	for ( int i = 0; i < nVertices; i++ )
		fscanf(input, "%f %f %f %f %f %f %f %f", 
			&(data[i].Pos.x), &(data[i].Pos.y), &(data[i].Pos.z), 
			&(data[i].Tex.x), &(data[i].Tex.y), 
			&(data[i].Norm.x), &(data[i].Norm.y), &(data[i].Norm.z));

	fclose(input);

	D3D10_BUFFER_DESC bd;
	
	bd.Usage          = D3D10_USAGE_DEFAULT;
	bd.ByteWidth      = sizeof( UberVertex ) * nVertices;
	bd.BindFlags      = D3D10_BIND_VERTEX_BUFFER;
	bd.CPUAccessFlags = 0;
	bd.MiscFlags      = 0;
	
	D3D10_SUBRESOURCE_DATA InitData;
	InitData.pSysMem = data;

	HRESULT hr;
	
	hr = D3D10.getDevice()->CreateBuffer( &bd, &InitData, &(this->vertexBuffer) );

	if( FAILED( hr ) )
	{
		MessageBox(NULL, L"CreateBuffer", L"d3d10", MB_OK );
	}

	delete [] data;
}

UberMesh::UberMesh()
{
	//...
}

ID3D10Buffer* UberMesh::getVertexBuffer()
{
	return this->vertexBuffer;
}

void UberMesh::Render(Effect3D& effect, const char *technique)
{
	effect.flushShaderVariables();

	static UINT stride = sizeof(UberVertex);
    static UINT offset = 0;

	const Technique tech = effect.getTechnique(technique);

	D3D10.getDevice()->IASetInputLayout(tech.layout);
	D3D10.getDevice()->IASetVertexBuffers(0, 1, &vertexBuffer, &stride, &offset);
	D3D10.getDevice()->IASetPrimitiveTopology(D3D10_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

	D3D10_TECHNIQUE_DESC techDesc;

	effect.worldMatrix->SetMatrix((float*)&worldMatrix);
	tech.tech->GetDesc(&techDesc);

	for (UINT i = 0; i < techDesc.Passes; ++i)
		tech.tech->GetPassByIndex(i)->Apply(i),
		D3D10.getDevice()->Draw(nVertices, 0);
}

void UberMesh::setPosition(float x, float y, float z)
{
	translationMatrix = DirectX::XMMatrixTranslation(x, y, z);
	worldMatrix = scaleMatrix * rotateMatrix * translationMatrix;
}

void UberMesh::setPosition(const DirectX::XMVECTORF32& pos)
{
	setPosition(pos.f[0], pos.f[1], pos.f[2]);
}

void UberMesh::setScale(float x, float y, float z)
{
	scaleMatrix = DirectX::XMMatrixScaling(x, y, z);
	worldMatrix = scaleMatrix * rotateMatrix * translationMatrix;
}

void UberMesh::setRotate(float x, float y, float z)
{
	DirectX::XMMATRIX X, Y, Z;

	X = DirectX::XMMatrixRotationX(x);
	Y = DirectX::XMMatrixRotationY(y);
	Z = DirectX::XMMatrixRotationZ(z);
	rotateMatrix = X * Y * Z;

	worldMatrix = scaleMatrix * rotateMatrix * translationMatrix;
}