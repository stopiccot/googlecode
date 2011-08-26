#include "RenderTarget.h"
#include "log.h"

RenderTarget RenderTarget::screen;
const RenderTarget RenderTarget::null;

//==========================================================================
// Default constructor to null everything
//==========================================================================
RenderTarget::RenderTarget() : width(0), height(0), count(0), cubeMap(false), multisample(false),
	texture(Texture::null), stencil(Texture::null), renderTargetView(NULL), depthStencilView(NULL) 
{
	//...
}

RenderTarget::RenderTarget(int width, int height, int count) : width(width), height(height), count(count), 
	cubeMap(false), multisample(false), texture(Texture::null), stencil(Texture::null), renderTargetView(NULL), depthStencilView(NULL)
{
	//...
}

//==========================================================================
// Copy constructor, desctructor and operator = for updating COM refernces
//==========================================================================
RenderTarget::RenderTarget(const RenderTarget& renderTarget) : renderTargetView(NULL), depthStencilView(NULL)
{
	copy(renderTarget);
}

void RenderTarget::operator = (const RenderTarget& renderTarget)
{
	copy(renderTarget);
}

RenderTarget::~RenderTarget()
{
	SAFE_RELEASE(renderTargetView);
	SAFE_RELEASE(depthStencilView);
}

void RenderTarget::copy(const RenderTarget& renderTarget)
{
	this->texture     = renderTarget.texture;
	this->stencil     = renderTarget.stencil;
	this->width       = renderTarget.width;
	this->height      = renderTarget.height;
	this->count       = renderTarget.count;
	this->cubeMap     = renderTarget.cubeMap;
	this->multisample = renderTarget.multisample;

	if (renderTarget.renderTargetView)
		this->renderTargetView = renderTarget.renderTargetView,
		this->renderTargetView->AddRef();

	if (renderTarget.depthStencilView)
		this->depthStencilView = renderTarget.depthStencilView,
		this->depthStencilView->AddRef();
}

//==========================================================================
// Creates new render target
//==========================================================================
RenderTarget RenderTarget::Create(int width, int height)
{
	return RenderTarget::Create(width, height, false);
}

RenderTarget RenderTarget::Create(int width, int height, bool stencil) 
{
	RenderTarget result(width, height, 1);

	result.texture = Texture::Create(width, height, 1, 1, true, false, false, D3D10.getSampleDesc());

	if (result.texture == Texture::null)
	{
		MessageBox(D3D10.getHWND(), L"RenderTarget::Create\nFailed to create texture", L"D3D10", MB_OK);
	}

	HRESULT hr = D3D10.getDevice()->CreateRenderTargetView(result.texture.getTexture(), NULL, &(result.renderTargetView));

	if (FAILED(hr))
	{
		MessageBox(D3D10.getHWND(), L"RenderTarget::Create", L"D3D10", MB_OK);
	}

	if (stencil) result.enableStencil();

	return result;
}

//==========================================================================
// Creates cubemap render target
//==========================================================================
RenderTarget RenderTarget::CreateCube(int width, int height)
{
	RenderTarget result(width, height, 6);
	result.cubeMap = true;

	DXGI_SAMPLE_DESC noMultisample = {1, 0};

	int mipLevels = 6;
	result.texture = Texture::Create(width, height, mipLevels, 6, true, false, true, noMultisample);

	if (result.texture == Texture::null)
	{
		MessageBox(D3D10.getHWND(), L"RenderTarget::CreateCube - Texture::Create failed", L"D3D10", MB_OK | MB_ICONERROR);
		return RenderTarget::null;
	}

	D3D10_RENDER_TARGET_VIEW_DESC desc;
	desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
	desc.ViewDimension = D3D10_RTV_DIMENSION_TEXTURE2DARRAY;
	desc.Texture2DArray.FirstArraySlice = 0;
	desc.Texture2DArray.ArraySize = result.count;
	desc.Texture2DArray.MipSlice = 0;

	HRESULT hr = D3D10.getDevice()->CreateRenderTargetView(result.texture.getTexture(), &desc, &(result.renderTargetView));
	
	if (FAILED(hr))
	{
		MessageBox(D3D10.getHWND(), L"RenderTarget::CreateCube", L"D3D10", MB_OK | MB_ICONERROR);
		return RenderTarget::null;
	}

	return result;
}

//==========================================================================
// Special constructor for screen render target
//==========================================================================
HRESULT RenderTarget::initScreenRenderTarget() 
{
	this->width   = D3D10.getScreenX();
	this->height  = D3D10.getScreenY(); 
	this->count   = 1;
	this->cubeMap = false;

	ID3D10Texture2D* tex = NULL;

	HRESULT hr = D3D10.getSwapChain()->GetBuffer(0, __uuidof(ID3D10Texture2D), (LPVOID*)&tex);

	if(FAILED(hr)) return hr;

	hr = D3D10.getDevice()->CreateRenderTargetView(tex, NULL, &(this->renderTargetView));

	tex->Release();

	return hr;
}
//==========================================================================
// Adds stencil buffer to render target
//==========================================================================   
HRESULT RenderTarget::enableStencil()
{
	DXGI_SAMPLE_DESC noMultisample = {1, 0};

	stencil = Texture::Create(width, height, 1, this->count, false, true, this->cubeMap, this->cubeMap ? noMultisample : D3D10.getSampleDesc());

	if (stencil == Texture::null)
	{
		MessageBox(D3D10.getHWND(),L"CreateDepthStencilView\nstencil == Texture::null", L"d3d10", MB_OK);
		return E_FAIL;
	}

	HRESULT hr;

	D3D10_DEPTH_STENCIL_VIEW_DESC descDSV;
	descDSV.Format             = DXGI_FORMAT_D32_FLOAT;

	if (!this->cubeMap)
	{
		descDSV.ViewDimension      = D3D10_DSV_DIMENSION_TEXTURE2DMS;
		descDSV.Texture2D.MipSlice = 0;
	}
	else
	{
		descDSV.ViewDimension = D3D10_DSV_DIMENSION_TEXTURE2DARRAY;
		descDSV.Texture2DArray.MipSlice        = 0;
		descDSV.Texture2DArray.FirstArraySlice = 0;
		descDSV.Texture2DArray.ArraySize       = 6;
	}

	if (FAILED(hr = D3D10.getDevice()->CreateDepthStencilView(stencil.getTexture(), &descDSV, &depthStencilView))) 
	{
		MessageBox(D3D10.getHWND(),L"CreateDepthStencilView", L"d3d10", MB_OK);
		return hr;
	}

	return S_OK;
}

//==========================================================================
// Clear render target with specified color
//==========================================================================
RenderTarget& RenderTarget::clear(float R, float G, float B)
{
	float ClearColor[4] = { R, G, B, 1.0f };

	D3D10.getDevice()->ClearRenderTargetView(renderTargetView, ClearColor);

	if (depthStencilView)
		D3D10.getDevice()->ClearDepthStencilView(depthStencilView, D3D10_CLEAR_DEPTH, 1.0f, 0);

	return *this;
}

//==========================================================================
// Properties
//==========================================================================
Texture RenderTarget::getTexture() const
{
	return this->texture;
}

Texture RenderTarget::getStencilTexture() const
{
	return this->stencil;
}

ID3D10RenderTargetView* RenderTarget::getRenderTargetView() const
{
	return this->renderTargetView;
}

ID3D10DepthStencilView* RenderTarget::getDepthStencilView() const
{
	return this->depthStencilView;
}