#ifndef DX9RENDER_H
#define DX9RENDER_H

#include "AbstractRender.h"
#include <d3d9.h>
#include <d3dx9.h>

class DX9Render : public AbstractRender
{
		IDirect3D9 *d3d;
		IDirect3DDevice9 *device;
		D3DPRESENT_PARAMETERS d3dpp;

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

class DX9Effect : public Effect
{
		friend class DX9Render;
		ID3DXEffect *effect;
		IDirect3DDevice9 *device; // to avoid global variables and singletons

		static IDirect3DVertexDeclaration9 *vertexDeclarationXYZUV;

	public:

		virtual void setTexture(const char *name, Texture *texture);
		virtual void setFloat(const char *name, float value);
		virtual void setMatrix(const char *name, float *matrix);
		virtual void render(VertexBuffer *vertexBuffer);
};

class DX9Texture : public Texture
{
		friend class DX9Render;
		friend class DX9Effect;
		IDirect3DTexture9 *texture;

	public:

		DX9Texture();
		virtual ~DX9Texture();
};

class DX9RenderTarget : public RenderTarget
{
		friend class DX9Render;
		IDirect3DSurface9 *surface;

	public:

};

class DX9VertexBuffer : public VertexBuffer
{
		friend class DX9Render;
		friend class DX9Effect;
		IDirect3DVertexBuffer9 *buffer;

	public:

		virtual bool lock(void **data);
		virtual bool unlock();
};

__declspec(dllexport) AbstractRender *getDX9Render();

#endif