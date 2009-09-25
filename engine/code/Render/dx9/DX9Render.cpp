#include "DX9Render.h"

AbstractRender *getDX9Render()
{
	return new DX9Render();
}

IDirect3DVertexDeclaration9 *DX9Effect::vertexDeclarationXYZUV;

HRESULT DX9Render::initDevice()
{
	d3d = Direct3DCreate9(D3D_SDK_VERSION);
	if (d3d == NULL) return E_FAIL;

	D3DDISPLAYMODE d3ddm;
	HRESULT hr = d3d->GetAdapterDisplayMode(D3DADAPTER_DEFAULT, &d3ddm);
	if (FAILED(hr)) return hr;

	ZeroMemory(&d3dpp, sizeof(d3dpp));

	d3dpp.Windowed         = !this->fullscreen;
	d3dpp.BackBufferWidth  = this->resolution.width;
	d3dpp.BackBufferHeight = this->resolution.height;
	d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
	d3dpp.BackBufferFormat = d3ddm.Format;

	if (this->fullscreen)
	{
		d3dpp.BackBufferCount = 1;
		d3dpp.FullScreen_RefreshRateInHz = d3ddm.RefreshRate;
	}
		
	if ( FAILED(d3d->CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hWindow,
		                          D3DCREATE_SOFTWARE_VERTEXPROCESSING,
								  &d3dpp, &device) ))
	{
		//log() << "Failed to create Direct3D9Device\n";
		return E_FAIL;
	}

	D3DVERTEXELEMENT9 declarationXYZUV[] = {
		{0,  0, D3DDECLTYPE_FLOAT3, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_POSITION, 0},
		{0, 12, D3DDECLTYPE_FLOAT2, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_TEXCOORD, 0},
		D3DDECL_END()
	};

	hr = device->CreateVertexDeclaration(declarationXYZUV, &DX9Effect::vertexDeclarationXYZUV);
	if (FAILED(hr))
	{
		//log() << "Failed to create vertex declaration XYZUV\n";
		return hr;
	}

	return S_OK;
}

RenderTarget *DX9Render::getScreenRenderTarget()
{
	DX9RenderTarget *renderTarget = new DX9RenderTarget();
	if (FAILED( device->GetRenderTarget(0, &renderTarget->surface) ))
	{
		delete renderTarget;
		return NULL;
	}

	renderTarget->width  = resolution.width;
	renderTarget->height = resolution.height;

	return renderTarget;
}

bool DX9Render::beginRender()
{
	static bool lost = false;

	switch (device->TestCooperativeLevel())
	{
		case D3DERR_DEVICELOST:
		{
			if (!lost)
			{
				lost = true;
				//log() << "D3DERR_DEVICELOST" << std::endl;
				return false;
			}
			break;
		}	
		case D3DERR_DEVICENOTRESET:
		{
			if (lost)
			{
				lost = false;
				//log() << "D3DERR_DEVICENOTRESET" << std::endl;
			}
			device->Reset(&d3dpp);
			break;
		}
	}

	device->Clear(0, NULL, D3DCLEAR_TARGET, D3DCOLOR_XRGB(0, 0, 255), 1.0f, 0);

	HRESULT hr = device->BeginScene();
	return SUCCEEDED(hr);
}

bool DX9Render::endRender()
{
	device->EndScene();
	device->Present(NULL, NULL, NULL, NULL);
	
	return true;
}

HRESULT DX9Render::setRenderTarget(RenderTarget *target)
{
	device->SetRenderTarget(0, static_cast<DX9RenderTarget*>(target)->surface);
	return S_OK;
}

Texture *DX9Render::loadTextureFromFile(const wchar_t *file)
{
	DX9Texture *result = new DX9Texture();

	HRESULT hr = D3DXCreateTextureFromFile(device, file, &result->texture);
	if (FAILED(hr))
	{
		switch (hr)
		{
			case D3DXERR_INVALIDDATA:
			{
				//log() << "Texture file \"" << file << "\" does not exists" << std::endl;
				break;
			}
			default:
			{
				//log() << "Failed to load texture \"" << file << "\" does not exists" << std::endl; 
				break;
			}
		}


		delete result;
		return NULL;
	}

	return result;
}

VertexBuffer *DX9Render::createVertexBuffer(int vertexCount, int vertexType, void *data, bool access)
{
	DX9VertexBuffer *result = new DX9VertexBuffer();
	result->buffer = 0;
	int byteSize = getVertexSize(vertexType) * vertexCount;
	
	HRESULT hr = device->CreateVertexBuffer(byteSize, 0, 0, D3DPOOL_DEFAULT, &result->buffer, NULL);
	if (FAILED(hr))
	{
		delete result;
		return NULL;
	}

	// Fill newely created vertex buffer with data
	void *lockedMemory = 0;
	result->buffer->Lock(0, byteSize, &lockedMemory, 0);
	memcpy(lockedMemory, data, byteSize);
	result->buffer->Unlock();

	result->vertexType = vertexType;
	result->count      = vertexCount;
	result->access     = access; 

	return result;
}

Effect *DX9Render::loadEffectFromFile(const wchar_t *file)
{
	DX9Effect *result = new DX9Effect();

	ID3DXBuffer *error = NULL;
	HRESULT hr = D3DXCreateEffectFromFile(device, file, NULL, NULL, 0, NULL, &result->effect, &error);
	if (FAILED(hr))
	{
		//log() << "Failed to create effect \"" << file << "\"\n";
		//if (error != NULL)
			//log() << (char*)(error->GetBufferPointer()) << "\n";

		delete result;
		return NULL;
	}

	result->device = device;

	return result;
}

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