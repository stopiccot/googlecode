#ifndef DX10RENDER_H
#define DX10RENDER_H

#include "AbstractRender.h"
#include <d3d10.h>
#include <d3dx10.h>
#include <string>
#include <map>

class DX10Render : public AbstractRender
{
		ID3D10Device *device;
		IDXGISwapChain *swapChain;

		virtual HRESULT initDevice();
		virtual RenderTarget *getScreenRenderTarget();

	public:

		virtual bool beginRender();
		virtual bool endRender();
		virtual HRESULT setRenderTarget(RenderTarget *target);
		virtual Texture *loadTextureFromFile(const wchar_t *file);
		virtual VertexBuffer *createVertexBuffer(int vertexCount, int vertexType, void *data, bool access = false);
		virtual Effect *loadEffectFromFile(const wchar_t *file);
};

class DX10Effect : public Effect
{
		friend class DX10Render;
		ID3D10Device *device; // to avoid global variables and singletons
		ID3D10Effect *effect;

		ID3D10EffectTechnique *technique;
		ID3D10InputLayout *layoutXYZUV;

		std::map<std::string, ID3D10EffectVariable*> vars;

	public:

		virtual void setTexture(const char *name, Texture *texture);
		virtual void setFloat(const char *name, float value);
		virtual void setMatrix(const char *name, float *matrix);
		virtual void render(VertexBuffer *vertexBuffer);
};

class DX10Texture : public Texture
{
		friend class DX10Render;
		friend class DX10Effect;
		ID3D10Texture2D *texture;
		ID3D10ShaderResourceView *resourceView;

	public:

		virtual ~DX10Texture();
};

class DX10RenderTarget : public RenderTarget
{
		friend class DX10Render;
		ID3D10RenderTargetView *renderTargetView;

	public:
};

class DX10VertexBuffer : public VertexBuffer
{
		friend class DX10Render;
		friend class DX10Effect;
		ID3D10Buffer *buffer;

	public:

		virtual bool lock(void **data);
		virtual bool unlock();
};

extern "C" {
	__declspec(dllexport) AbstractRender *getDX10Render();
}
#endif

