#ifndef DIRECT3D10_HEADER

	#define DIRECT3D10_HEADER

	#define SAFE_RELEASE(X) if (X) { X->Release(); X = NULL; }

	#include <windows.h>
	#include <d3d10_1.h>
	#include <DirectXMath.h>
	#include <d3dcompiler.h>

	#include <vector>
	#include <map>

	class RenderTarget;
	typedef void (*CALLBACKPROC)(UINT message, WPARAM wParam, LPARAM lParam);

	class Direct3D10
	{
			int screenX, screenY;

			HRESULT hr;

			static Direct3D10 instance;
			HWND hWindow;
			ID3D10Device *device;
			IDXGISwapChain *swapChain;
			DXGI_SWAP_CHAIN_DESC sd;
			
			Direct3D10();
			~Direct3D10();

			ID3D10RenderTargetView *renderTargetView;
			ID3D10DepthStencilView *depthStencilView;

		public:

			static Direct3D10& getInstance();

			// Properties
			HWND             getHWND();
			ID3D10Device*    getDevice();
			IDXGISwapChain*  getSwapChain();
			DXGI_SAMPLE_DESC getSampleDesc();
			int              getScreenX();
			int              getScreenY();

			// Methods
			HRESULT Direct3D10::createWindow(int width, int height, bool fullscreen);
			HRESULT Direct3D10::init(int width, int height, bool fullscreen, bool antialias);
			void setRenderTarget(const RenderTarget& target);
			void setRenderTargets(const RenderTarget& target0, const RenderTarget& target1);
			void setRenderTargets(const RenderTarget& target0, const RenderTarget& target1, const RenderTarget& target2);
			void setCallback(CALLBACKPROC proc);
	};

	extern Direct3D10& D3D10;

#endif