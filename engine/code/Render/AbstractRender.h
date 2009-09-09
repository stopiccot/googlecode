#ifndef ABSTRACT_RENDER_H
#define ABSTRACT_RENDER_H

#include "VertexTypes.h"
#include <windows.h>
//#include "log.h"

#ifdef DX9_EXPORTS // AbstractRender API is implemented in dx9.dll
	#define RENDER_API __declspec(dllexport)
#else
	#define RENDER_API __declspec(dllimport)
#endif

class RENDER_API Texture
{
	public:
		virtual ~Texture() {};
};

class RENDER_API RenderTarget
{
	protected:
		// Texture to which rendering is done. NULL for RenderTarget::screen
		Texture *texture;
	public:
		// Size in pixels
		int width, height;
	
		static RenderTarget *screen;
};

class RENDER_API VertexBuffer
{
	protected:
		// Type of vertexes contained in buffer
		// see VertexTypes.h for details
		int vertexType;
		// Number of vertexes in buffer
		int count;
		// Can be data contained in buffer accessed?
		bool access;
	public:
		virtual bool lock(void **data) = 0;
		virtual bool unlock() = 0;
};

class RENDER_API Effect
{
	protected:
	public:
		virtual void setTexture(const char *name, Texture *texture) = 0;
		virtual void setFloat(const char *name, float value) = 0;
		virtual void setMatrix(const char *name, float *matrix) = 0;
		virtual void render(VertexBuffer *vertexBuffer) = 0;
};

struct RENDER_API Resolution
{
	int width;
	int height;
};

class RENDER_API AbstractRender
{
	protected:

		bool fullscreen;
		HWND hWindow;
		Resolution resolution;

		// Creates window
		HRESULT createWindow(int width, int height, bool fullscreen);

		// Internal function for render initialization
		// is called right after window was created
		virtual HRESULT initDevice() = 0;

		// This internal function must return default render target
		// is called by init right after initDevice()
		virtual RenderTarget *getScreenRenderTarget() = 0;

	public:
		
		HRESULT init(int width, int height, bool fullscreen);

		// Returns vertex struct size in bytes for specified vertexType
		// return 0 if unexisting vertexType is passed
		int getVertexSize(int vertexType);

		virtual bool beginRender() = 0;
		virtual bool endRender() = 0;

		float4x4 getProjectionMatrix2D();

		virtual HRESULT setRenderTarget(RenderTarget *target) = 0;
		virtual Texture *loadTextureFromFile(const wchar_t *file) = 0;
		virtual VertexBuffer *createVertexBuffer(int vertexCount, int vertexType, void *data, bool access = false) = 0;
		virtual Effect *loadEffectFromFile(const wchar_t *file) = 0;
};

// Global render variable
extern RENDER_API AbstractRender *Render;

#endif