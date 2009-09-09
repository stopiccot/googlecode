#include "DX10Render.h"

DX10Texture::~DX10Texture()
{
	if (texture != NULL) texture->Release();
}