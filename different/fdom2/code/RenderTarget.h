#ifndef RENDERTARGET_H

	#define RENDERTARGET_H

	#include "Direct3D10.h"
	#include "Texture.h"

	class RenderTarget
	{
		public:
			// Our screen and null render target
			static RenderTarget screen;
			const static RenderTarget null;

			// Constructors
			RenderTarget();
			static RenderTarget Create(int width, int height);
			static RenderTarget Create(int width, int height, bool stencil);
			static RenderTarget CreateCube(int width, int height);

			// Methods
			HRESULT enableStencil();
			RenderTarget& clear(float R, float G, float B);

			// Properties
			Texture getTexture() const;
			Texture getStencilTexture() const;
			ID3D10RenderTargetView* getRenderTargetView() const;
			ID3D10DepthStencilView* getDepthStencilView() const;

			// Copy constructor, desctructor and operator = for updating COM references
			RenderTarget(const RenderTarget& renderTarget);
			void operator = (const RenderTarget& renderTarget);
			~RenderTarget();

		private:

			RenderTarget(int width, int height, int count);

			friend class Direct3D10;

			int width, height, count;
			Texture texture, stencil;
			bool cubeMap, multisample;
			ID3D10RenderTargetView *renderTargetView;
			ID3D10DepthStencilView *depthStencilView;

			HRESULT initScreenRenderTarget();
			void copy(const RenderTarget& renderTarget);
	};

#endif