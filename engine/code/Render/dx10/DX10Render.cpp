#include "DX10Render.h"

//========================================================================
// The only exported function for creation of DX10Render
//========================================================================
AbstractRender *getDX10Render()
{
	return new DX10Render();
}

//========================================================================
// For specified ID3D10Device returns IDXGIFactory used to create it
//========================================================================
IDXGIFactory *getDeviceFactory(ID3D10Device *device)
{
	IDXGIDevice  *dxgiDevice  = 0;
	IDXGIAdapter *dxgiAdapter = 0;
	IDXGIFactory *dxgiFactory = 0;

	if (SUCCEEDED( device->QueryInterface(__uuidof(IDXGIDevice), (void**)&dxgiDevice) ))
	{
		if (SUCCEEDED( dxgiDevice->GetParent(__uuidof(IDXGIAdapter), (void**)&dxgiAdapter) ))
		{
			dxgiAdapter->GetParent(__uuidof(IDXGIFactory), (void**)&dxgiFactory);
			dxgiAdapter->Release();
		}
		dxgiDevice->Release();
	}
	return dxgiFactory;
}

//========================================================================
// Initialize hardware for rendering. Member of AbstractRender
//========================================================================
HRESULT DX10Render::initDevice()
{
	UINT createDeviceFlags = 0;
	#ifdef _DEBUG
		createDeviceFlags |= D3D10_CREATE_DEVICE_DEBUG;
	#endif

	HRESULT hr = D3D10CreateDevice(NULL, D3D10_DRIVER_TYPE_HARDWARE, NULL, createDeviceFlags, D3D10_SDK_VERSION, &this->device);
	if (FAILED(hr)) return hr;

	DXGI_SWAP_CHAIN_DESC sd;
	ZeroMemory(&sd, sizeof(sd));
	sd.BufferCount = 1;
	sd.BufferDesc.Width  = this->resolution.width;
	sd.BufferDesc.Height = this->resolution.height;
	sd.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
	sd.BufferDesc.RefreshRate.Numerator   = 60;
	sd.BufferDesc.RefreshRate.Denominator = 1;
	sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	sd.OutputWindow       = this->hWindow;
	sd.SampleDesc.Count   = 4;
	sd.SampleDesc.Quality = 4;
	sd.Windowed = !this->fullscreen;

	IDXGIFactory *factory = getDeviceFactory(device);
	if (factory == NULL) return E_FAIL;

	hr = factory->CreateSwapChain(device, &sd, &swapChain);
	if (FAILED(hr)) return hr;

	factory->Release();

	return S_OK;
}

//========================================================================
// Returns default RenderTarget. Member of AbstractRender
//========================================================================
RenderTarget *DX10Render::getScreenRenderTarget()
{
	DX10RenderTarget *renderTarget = new DX10RenderTarget();
	
	ID3D10Texture2D *texture;
	HRESULT hr = swapChain->GetBuffer(0, __uuidof(ID3D10Texture2D), (void**)&texture);
	if (FAILED(hr)) 
	{
		delete renderTarget;
		return NULL;
	}

	hr = device->CreateRenderTargetView(texture, NULL, &renderTarget->renderTargetView);
	if (FAILED(hr))
	{
		delete renderTarget;
		return NULL;
	}

	texture->Release();

	renderTarget->width  = resolution.width;
	renderTarget->height = resolution.height;

	return renderTarget;
}

//========================================================================
// Begin frame. Member of AbstractRender
//========================================================================
bool DX10Render::beginRender()
{
	float ClearColor[4] = { 1.0f, 0.0f, 0.0f, 1.0f };
	device->ClearRenderTargetView(static_cast<DX10RenderTarget*>(RenderTarget::screen)->renderTargetView, ClearColor);

	return true;
}

//========================================================================
// End frame. Member of AbstractRender
//========================================================================
bool DX10Render::endRender()
{
	swapChain->Present(0, 0);
	return true;
}

//========================================================================
// Sets new RenderTarget. Member of AbstractRender
//========================================================================
HRESULT DX10Render::setRenderTarget(RenderTarget *target)
{
	DX10RenderTarget* renderTarget10 = static_cast<DX10RenderTarget*>(target);
	device->OMSetRenderTargets(1, &renderTarget10->renderTargetView, NULL);

	D3D10_VIEWPORT viewPort;
	viewPort.Width    = renderTarget10->width;
	viewPort.Height   = renderTarget10->height;
	viewPort.MinDepth = 0.0f;
	viewPort.MaxDepth = 1.0f;
	viewPort.TopLeftX = 0;
	viewPort.TopLeftY = 0;
	device->RSSetViewports(1, &viewPort);
	return S_OK;
}

Texture *DX10Render::loadTextureFromFile(const wchar_t *file)
{
	DX10Texture *result = new DX10Texture();

	HRESULT hr = D3DX10CreateShaderResourceViewFromFile(device, file, NULL, NULL, &result->resourceView, NULL);
	if (FAILED(hr))
	{
		switch (hr)
		{
			case D3D10_ERROR_FILE_NOT_FOUND:
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

	// Now when we have pointer to shader resource interface we can get pointer to texture itself
	ID3D10Resource *resource = NULL;

	result->resourceView->GetResource(&resource);
	resource->QueryInterface(__uuidof(ID3D10Texture2D), (void**)&result->texture);
	resource->Release();

	return result;
}

VertexBuffer *DX10Render::createVertexBuffer(int vertexCount, int vertexType, void *data, bool access)
{
	DX10VertexBuffer *result = new DX10VertexBuffer();

	D3D10_BUFFER_DESC bufferDesc;
	bufferDesc.BindFlags      = D3D10_BIND_VERTEX_BUFFER;
	bufferDesc.ByteWidth      = getVertexSize(vertexType) * vertexCount;
	bufferDesc.CPUAccessFlags = D3D10_CPU_ACCESS_WRITE;
	bufferDesc.MiscFlags      = 0;
	bufferDesc.Usage          = D3D10_USAGE_DYNAMIC;

	D3D10_SUBRESOURCE_DATA initData;
	initData.pSysMem = data;

	HRESULT hr = device->CreateBuffer(&bufferDesc, &initData, &result->buffer);
	if (FAILED(hr))
	{
		delete result;
		return NULL;
	}

	result->vertexType = vertexType;
	result->count      = vertexCount;
	result->access     = access;

	return result;
}

Effect *DX10Render::loadEffectFromFile(const wchar_t *file)
{
	DX10Effect *result = new DX10Effect();

	DWORD dwShaderFlags = 0;
	//dwShaderFlags |= D3D10_SHADER_ENABLE_STRICTNESS;
	dwShaderFlags |= D3D10_SHADER_ENABLE_BACKWARDS_COMPATIBILITY;
	#if defined( DEBUG ) || defined( _DEBUG )
		dwShaderFlags |= D3D10_SHADER_DEBUG;
	#endif

	D3D10_SHADER_MACRO D3D10_Macro[] = { {"D3D10", "1"}, {NULL, NULL} };

	ID3D10Blob *error = NULL;
	HRESULT hr = D3DX10CreateEffectFromFile(file, D3D10_Macro, NULL, "fx_4_0", dwShaderFlags, 0,
		device, NULL, NULL, &result->effect, &error, NULL);
	if (FAILED(hr))
	{
		//log() << "Failed to create effect \"" << file << "\"\n";
		if (error != NULL)
		{
			char *errorMessage = (char*)error->GetBufferPointer();
			//log() << errorMessage << "\n";
		}

		delete result;
		return NULL;
	}

	result->technique = result->effect->GetTechniqueByName("Render");
	if (result->technique == NULL)
	{
		delete result;
		return NULL;
	}

	result->device = device;
	
	D3D10_PASS_DESC passDesc; memset(&passDesc, 0, sizeof(passDesc));
	ID3D10EffectPass *pass = result->technique->GetPassByIndex(0);
	hr = pass->GetDesc(&passDesc);
	if (FAILED(hr))
	{
		delete result;
		return NULL;
	}

	{
		static D3D10_INPUT_ELEMENT_DESC layoutXYZ[] = 
		{
			{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0,  0, D3D10_INPUT_PER_VERTEX_DATA, 0 },
		};

		int numElements = sizeof(layoutXYZ) / sizeof(D3D10_INPUT_ELEMENT_DESC);
		hr = device->CreateInputLayout(layoutXYZ, numElements,
			passDesc.pIAInputSignature, passDesc.IAInputSignatureSize, &result->layoutXYZ);
		/*if (FAILED(hr))
		{
			delete result;
			return NULL;
		}*/
	}

	{
		static D3D10_INPUT_ELEMENT_DESC layoutXYZUV[] = 
		{
			{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0,  0, D3D10_INPUT_PER_VERTEX_DATA, 0 },
			{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT,    0, 12, D3D10_INPUT_PER_VERTEX_DATA, 0 },
		};

		int numElements = sizeof(layoutXYZUV) / sizeof(D3D10_INPUT_ELEMENT_DESC);
		hr = device->CreateInputLayout(layoutXYZUV, numElements,
			passDesc.pIAInputSignature, passDesc.IAInputSignatureSize, &result->layoutXYZUV);
		/*if (FAILED(hr))
		{
			delete result;
			return NULL;
		}*/
	}

	return result;
}

void DX10Effect::setFloat(const char *name, float value)
{
	//...
}

void DX10Effect::setMatrix(const char *name, float *matrix)
{
	std::map<std::string, ID3D10EffectVariable*>::iterator var = vars.find(std::string(name));
	if (var == vars.end())
	{
		ID3D10EffectVariable* dxVar = effect->GetVariableByName(name);
		if (dxVar == NULL)
			return;

		vars[std::string(name)] = dxVar;
		var = vars.find(std::string(name));
	}

	var->second->AsMatrix()->SetMatrix(matrix);
}

void DX10Effect::setTexture(const char *name, Texture *texture)
{
	std::map<std::string, ID3D10EffectVariable*>::iterator var = vars.find(std::string(name));
	if (var == vars.end())
	{
		ID3D10EffectVariable* dxVar = effect->GetVariableByName(name);
		if (dxVar == NULL)
			return;

		vars[std::string(name)] = dxVar;
		var = vars.find(std::string(name));
	}

	var->second->AsShaderResource()->SetResource(static_cast<DX10Texture*>(texture)->resourceView);
}

void DX10Effect::render(VertexBuffer *vertexBuffer)
{
	DX10VertexBuffer *vertexBuffer10 = static_cast<DX10VertexBuffer*>(vertexBuffer);

	
	switch (vertexBuffer10->vertexType)
	{
		case VertexType::XYZ:
			if (this->layoutXYZ == NULL) return;
			device->IASetInputLayout(this->layoutXYZ); break;

		case VertexType::XYZUV:
			if (this->layoutXYZUV == NULL) return;
			device->IASetInputLayout(this->layoutXYZUV); break;

		default:
			//log() << "Unknown vertex type\n";
			return;
	}

	UINT offset = 0, stride = Render->getVertexSize(vertexBuffer10->vertexType);
	device->IASetVertexBuffers(0, 1, &vertexBuffer10->buffer, &stride, &offset);
	device->IASetPrimitiveTopology(D3D10_PRIMITIVE_TOPOLOGY_TRIANGLELIST);

	technique->GetPassByIndex(0)->Apply(0);
	device->Draw(vertexBuffer10->count, 0);
}

bool DX10VertexBuffer::lock(void **data)
{
	if (!access)
		return false;

	HRESULT hr = buffer->Map(D3D10_MAP_WRITE_DISCARD, NULL, data);
	return SUCCEEDED(hr);
}

bool DX10VertexBuffer::unlock()
{
	// Хорошо было б если б оно возвращало false при анлоке незалоченного буфера
	// но директиксовский Unmap возвращает void. А свой флажок пока делать не будем
	buffer->Unmap();
	return true;
}

Font *DX10Render::createFont()
{
	DX10Font *result = new DX10Font();
	HRESULT hr = D3DX10CreateFont(device, 25, 0, FW_BOLD, 1, FALSE, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, L"Tahoma", &result->font);
	if (FAILED(hr))
	{
		delete result;
		return NULL;
	}
	return result;
}

RenderTarget *DX10Render::createRenderTarget(int width, int height)
{
	return NULL;
}

HRESULT DX10Font::render(const wchar_t *text)
{
	RECT rc = {0, 0, 200, 200};
	HRESULT hr = font->DrawText( NULL, text, -1, &rc, DT_TOP, D3DXCOLOR( 0.0f, 0.0f, 1.0f, 1.0f ) );
	return hr;
}