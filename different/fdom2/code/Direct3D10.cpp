#include "Direct3D10.h"
#include "RenderTarget.h"

Direct3D10 Direct3D10::instance;
Direct3D10& D3D10 = Direct3D10::getInstance();

CALLBACKPROC callback = NULL;

LRESULT CALLBACK WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
    switch(message)
    {
        case WM_DESTROY:
		{
            PostQuitMessage(0);
            break;
		}

        default:
		{
			if (callback)
				callback(message, wParam, lParam);

            return DefWindowProc( hWnd, message, wParam, lParam );
		}
    }
    return 0;
}

void Direct3D10::setCallback(CALLBACKPROC proc)
{
	callback = proc;
}

Direct3D10::Direct3D10() : screenX(0), screenY(0)
{
	//...
}

Direct3D10::~Direct3D10()
{
	SAFE_RELEASE(swapChain);
	SAFE_RELEASE(device);
}

Direct3D10& Direct3D10::getInstance()
{
	return instance;
}

HWND Direct3D10::getHWND()
{
	return this->hWindow;
}

ID3D10Device *Direct3D10::getDevice()
{
	return this->device;
}

IDXGISwapChain *Direct3D10::getSwapChain()
{
	return this->swapChain;
}

DXGI_SAMPLE_DESC Direct3D10::getSampleDesc()
{
	return sd.SampleDesc;
}

HRESULT Direct3D10::createWindow(int width, int height, bool fullscreen)
{
	WNDCLASS wnd; ZeroMemory(&wnd, sizeof(WNDCLASS));
			
	wnd.lpszClassName = L"directx";
	wnd.lpfnWndProc   = WndProc;
	wnd.hCursor       = LoadCursor(NULL, IDC_ARROW);

	if ( !RegisterClass( &wnd ) ) return E_FAIL;
			
	RECT rc = { 0, 0, width, height };
	//AdjustWindowRect( &rc, WS_OVERLAPPEDWINDOW, FALSE );

	this->hWindow = CreateWindow( L"directx", L"directx", WS_POPUP | WS_VISIBLE,
		CW_USEDEFAULT, CW_USEDEFAULT, rc.right - rc.left, rc.bottom - rc.top, NULL, NULL, 0, NULL );

	return this->hWindow ? S_OK : E_FAIL;
}

HRESULT Direct3D10::init(int width, int height, bool fullscreen, bool antialias)
{
	screenX = width; screenY = height;

	if (FAILED(hr = createWindow(width, height, fullscreen))) return hr;

	SetTimer(this->hWindow, 0, 20, 0);

	UINT createDeviceFlags = 0;
	#ifdef _DEBUG
		createDeviceFlags |= D3D10_CREATE_DEVICE_DEBUG;
	#endif

	if (FAILED(hr = D3D10CreateDevice(NULL, D3D10_DRIVER_TYPE_HARDWARE, NULL, createDeviceFlags, D3D10_SDK_VERSION, &device)))
		return hr;
	
	ZeroMemory( &sd, sizeof( sd ) );
	sd.BufferCount = 1;
	sd.BufferDesc.Width = width;
	sd.BufferDesc.Height = height;
	sd.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
	sd.BufferDesc.RefreshRate.Numerator = 60;
	sd.BufferDesc.RefreshRate.Denominator = 1;
	sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	sd.OutputWindow = hWindow;
	sd.SampleDesc.Count   = 1;
	sd.SampleDesc.Quality = 0;
	sd.Windowed = TRUE;

	if (antialias)
		for ( UINT sampleCount = 0, quality = 0; sampleCount < 16; sampleCount++ )
		{
			device->CheckMultisampleQualityLevels(DXGI_FORMAT_R8G8B8A8_UNORM, sampleCount, &quality);
			if ( quality )
				sd.SampleDesc.Count   = sampleCount,
				sd.SampleDesc.Quality = quality - 1;
		}

	IDXGIFactory *factory = NULL;

	if (FAILED(hr = CreateDXGIFactory(__uuidof(IDXGIFactory), (void**)(&factory) ))) return hr;
	if (FAILED(hr = factory->CreateSwapChain(device, &sd, &swapChain))) return hr;

	factory->Release();

	// Initialize render target
	RenderTarget::screen.initScreenRenderTarget();
	RenderTarget::screen.enableStencil();
	setRenderTarget(RenderTarget::screen);

	ID3D10RasterizerState *rasterizerState;
	D3D10_RASTERIZER_DESC rasterizerDesc;

	rasterizerDesc.FillMode = D3D10_FILL_SOLID;
	//rasterizerDesc.FillMode = D3D10_FILL_WIREFRAME;
	rasterizerDesc.CullMode = D3D10_CULL_NONE;//BACK;
	rasterizerDesc.FrontCounterClockwise = false;
	rasterizerDesc.DepthBias = false;
	rasterizerDesc.DepthBiasClamp = 0;
	rasterizerDesc.SlopeScaledDepthBias = 0;
	rasterizerDesc.DepthClipEnable = true;
	rasterizerDesc.ScissorEnable = false;
	rasterizerDesc.MultisampleEnable = true;
	rasterizerDesc.AntialiasedLineEnable = true;

	if (FAILED(hr = device->CreateRasterizerState( &rasterizerDesc, &rasterizerState ) )) return hr;
	device->RSSetState( rasterizerState );

	//rasterizerState->Release(); // Релизить ниразу нельзя!!!

	D3D10_BLEND_DESC blendDesc; ZeroMemory(&blendDesc, sizeof(blendDesc));
	for ( int i = 0; i < 8; i++ )
	{
		blendDesc.BlendEnable[i]           = true;
		blendDesc.RenderTargetWriteMask[i] = D3D10_COLOR_WRITE_ENABLE_ALL;
	}

	blendDesc.AlphaToCoverageEnable = false;
	blendDesc.SrcBlend  = D3D10_BLEND_SRC_ALPHA;//D3D10_BLEND_ONE;
	blendDesc.DestBlend = D3D10_BLEND_INV_SRC_ALPHA;//D3D10_BLEND_ZERO;
	//blendDesc.SrcBlend       = D3D10_BLEND_ONE;
	//blendDesc.DestBlend      = D3D10_BLEND_ZERO;
	blendDesc.BlendOp        = D3D10_BLEND_OP_ADD;
	blendDesc.SrcBlendAlpha  = D3D10_BLEND_ONE;
	blendDesc.DestBlendAlpha = D3D10_BLEND_ZERO;
	blendDesc.BlendOpAlpha   = D3D10_BLEND_OP_ADD;

	ID3D10BlendState* blendState = NULL;

	if (FAILED(hr = device->CreateBlendState(&blendDesc, &blendState))) 
		return hr;	

	device->OMSetBlendState(blendState, NULL,  0xFFFFFFFF);
	

	D3D10_VIEWPORT vp;
	vp.Width = width;
	vp.Height = height;
	vp.MinDepth = 0.0f;
	vp.MaxDepth = 1.0f;
	vp.TopLeftX = 0;
	vp.TopLeftY = 0;
	device->RSSetViewports( 1, &vp );
}

void Direct3D10::setRenderTarget(const RenderTarget& target)
{
	setRenderTargets(target, RenderTarget::null, RenderTarget::null);
}

void Direct3D10::setRenderTargets(const RenderTarget& target0, const RenderTarget& target1)
{
	setRenderTargets(target0, target1, RenderTarget::null);
}

void Direct3D10::setRenderTargets(const RenderTarget& target0, const RenderTarget& target1, const RenderTarget& target2)
{
	ID3D10RenderTargetView* targets[3];
	targets[0] = target0.getRenderTargetView();
	targets[1] = target1.getRenderTargetView();
	targets[2] = target2.getRenderTargetView();
	
	int n = 0; while(targets[n] && n < 3) n++;

	device->OMSetRenderTargets(n, targets, target0.getDepthStencilView());

	D3D10_VIEWPORT viewport;
	viewport.Width    = target0.width;
	viewport.Height   = target0.height;
	viewport.MinDepth = 0.0f;
	viewport.MaxDepth = 1.0f;
	viewport.TopLeftX = 0;
	viewport.TopLeftY = 0;
	device->RSSetViewports(1, &viewport);
}

int Direct3D10::getScreenX()
{
	return this->screenX;
}

int Direct3D10::getScreenY()
{
	return this->screenY;
}