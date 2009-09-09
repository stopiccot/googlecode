#include "DX9Render.h"

void DX9Effect::setFloat(const char *name, float value)
{
	//...
}

void DX9Effect::setMatrix(const char *name, float *matrix)
{
	HRESULT hr = effect->SetMatrix(name, (D3DXMATRIX*)matrix);
	if (FAILED(hr))
	{
		//log() << "DX9Effect::setMatrix() failed\n";
	}
}

void DX9Effect::setTexture(const char *name, Texture *texture)
{
	HRESULT hr = effect->SetTexture(name, static_cast<DX9Texture*>(texture)->texture);
	if (FAILED(hr))
	{
		//log() << "DX9Effect::setTexture() failed\n";
	}
}

void DX9Effect::render(VertexBuffer *vertexBuffer)
{
	DX9VertexBuffer *vertexBuffer9 = static_cast<DX9VertexBuffer*>(vertexBuffer);

	HRESULT hr = device->SetStreamSource(0, vertexBuffer9->buffer, 0, Render->getVertexSize(vertexBuffer9->vertexType));
	if (FAILED(hr))
	{
		//log() << "Device::SetStreamSource() failed\n";
		return;
	}

	switch (vertexBuffer9->vertexType)
	{
		case VertexType::XYZUV:
			device->SetVertexDeclaration(DX9Effect::vertexDeclarationXYZUV); break;
		default:
			//log() << "Unknown vertex type\n";
			return;
	}
	

	hr = effect->SetTechnique("Render");
	if (FAILED(hr))
	{
		//log() << "effect::SetTechnique() failed\n";
		return;
	}

	UINT numPasses;
	hr = effect->Begin(&numPasses, 0);
	for (UINT i = 0; i < numPasses; ++i)
	{
		hr = effect->BeginPass(i);
		hr = device->DrawPrimitive(D3DPT_TRIANGLELIST, 0, vertexBuffer9->count);
		hr = effect->EndPass();
	}
	hr = effect->End();
}