#include "DX9Render.h"

bool DX9VertexBuffer::lock(void **data)
{
	if (!access)
		return false;

	HRESULT hr = buffer->Lock(0, count * Render->getVertexSize(vertexType), data, 0);
	return SUCCEEDED(hr);
}

bool DX9VertexBuffer::unlock()
{
	HRESULT hr = buffer->Unlock();
	return SUCCEEDED(hr);
}