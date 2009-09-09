#include "DX9Render.h"

DX9Texture::DX9Texture() : texture(NULL)
{
	//...
}

DX9Texture::~DX9Texture()
{
	if (texture)
		texture->Release();
}