#include "AbstractRender.h"

AbstractRender *Render = 0;
RenderTarget *RenderTarget::screen = 0;

LRESULT CALLBACK windowProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch(msg)
    {
        case WM_DESTROY:
		{
            PostQuitMessage(0);
            break;
		}
    }
    return DefWindowProc(hWnd, msg, wParam, lParam);
}

HRESULT AbstractRender::createWindow(int width, int height, bool fullscreen)
{
	this->resolution.width = width;
	this->resolution.height = height;
	this->fullscreen = fullscreen;

	WNDCLASS wnd; ZeroMemory(&wnd, sizeof(WNDCLASS));
			
	wnd.lpszClassName = L"engine";
	wnd.lpfnWndProc   = windowProc;
	wnd.hCursor       = LoadCursor(NULL, IDC_ARROW);

	RegisterClass(&wnd);

	DWORD style = fullscreen ? WS_POPUP : WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX;

	RECT rect = {0, 0, width, height};
	AdjustWindowRect(&rect, style, false);

	this->hWindow = CreateWindow( L"engine", L"engine", style, CW_USEDEFAULT, CW_USEDEFAULT, 
			rect.right - rect.left, rect.bottom - rect.top,
			NULL, NULL, GetModuleHandle(0), NULL );

	ShowWindow(hWindow, SW_SHOW);

	return S_OK;
}

HRESULT AbstractRender::init(int width, int height, bool fullscreen)
{
	HRESULT hr = createWindow(width, height, fullscreen);
	if (FAILED(hr))
	{
		//log() << "Failed to create window\n";
		return hr;
	}

	hr = initDevice();
	if (FAILED(hr))
	{
		//log () << "Failed to init device\n";
		return hr;
	}

	RenderTarget::screen = getScreenRenderTarget();
	if (RenderTarget::screen == NULL)
	{
		//log() << "Failed to create RenderTarget::screen\n";
		return E_FAIL;
	}

	setRenderTarget(RenderTarget::screen);

	return S_OK;
}

int AbstractRender::getVertexSize(int vertexType)
{
	switch (vertexType)
	{
		case VertexType::XYZUV:
			return sizeof(VertexXYZUV);
		default:
			return 0;
	}
}

float4x4 AbstractRender::getProjectionMatrix2D()
{
	float4x4 result;

	result.m[0][0] =  2.0f / (float)resolution.width;
	result.m[1][1] = -2.0f / (float)resolution.height;
	result.m[2][2] =  0.0f;
	result.m[3][0] = -1.0f;
	result.m[3][1] =  1.0f;

	return result;
}

Texture::~Texture()
{
	//...
}

RenderTarget::~RenderTarget()
{
	if (texture)
		delete texture;
}