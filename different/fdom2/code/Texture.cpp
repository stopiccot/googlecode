#include "Texture.h"
#include "log.h"

const Texture Texture::null;

//==========================================================================
// Default constructor to null everything
//==========================================================================
Texture::Texture() : texture(NULL), resourceView(NULL) { }

//==========================================================================
// Copy constructor, desctructor and operator = for updating COM refernces
//==========================================================================
Texture::Texture(const Texture& texture) : texture(NULL), resourceView(NULL)
{
	this->copyReferences(texture.texture, texture.resourceView);
}

Texture& Texture::operator = (const Texture& texture)
{
	this->copyReferences(texture.texture, texture.resourceView);
	return *this;
}

Texture::~Texture()
{
	SAFE_RELEASE(resourceView);
	SAFE_RELEASE(texture);
}

void Texture::copyReferences(ID3D10Texture2D *texture, ID3D10ShaderResourceView* resourceView)
{
	if (texture) 
		this->texture = texture,
		texture->AddRef();

	if (resourceView)
		this->resourceView = resourceView,
		resourceView->AddRef();
}

//==========================================================================
// LoadFromFile - selfdescribing
//==========================================================================
Texture Texture::LoadFromFile(LPCTSTR fileName)
{
	Texture result;

	HRESULT hr = D3DX10CreateShaderResourceViewFromFile( D3D10.getDevice(), fileName, NULL, NULL, &(result.resourceView), NULL);

	if (FAILED(hr)) 
	{
		switch(hr)
		{
			case D3D10_ERROR_FILE_NOT_FOUND:
			{
				MessageBox(D3D10.getHWND(), fileName, L"Texture::LoadFromFile - D3D10_ERROR_FILE_NOT_FOUND", MB_ICONERROR | MB_OK);
				break;
			}
			default:
			{
				MessageBox(D3D10.getHWND(), fileName, L"Texture::LoadFromFile - FAILED", MB_ICONERROR | MB_OK);
				break;
			}
		}
		return Texture::null;
	}

	ID3D10Resource *resource = NULL;

	result.resourceView->GetResource( &resource );
	resource->QueryInterface(__uuidof(ID3D10Texture2D), (void**)&(result.texture));
	resource->Release();

	return result;
}

//==========================================================================
// Creates a blank texture that can be also used as renderTarget
//==========================================================================
Texture Texture::Create(int width, int height)
{
	return Texture::Create(width, height, 1, 1, true, false, false, D3D10.getSampleDesc());
}

Texture Texture::Create(int width, int height, int mipLevels, int count, bool renderTarget, bool stencilBuffer, bool cubeMap, DXGI_SAMPLE_DESC sampleDesc)
{
	// Cubemap must six edges
	if (cubeMap && count != 6) return Texture::null;

	// Being both render target and stencil buffer is not allowed
	if (renderTarget && stencilBuffer) return Texture::null;

	bool multisample = !(sampleDesc.Count == 1 && sampleDesc.Quality == 0);

	D3D10_TEXTURE2D_DESC desc; ZeroMemory(&desc, sizeof(desc));

	desc.Width           = width;
	desc.Height          = height;
	desc.MipLevels       = mipLevels;
	desc.ArraySize       = count;
	desc.Usage           = D3D10_USAGE_DEFAULT;

	// CreateTexture2D fails if use D32_FLOAT with multisample enabled so we use R32_TYPELESS
	if (!stencilBuffer)
		desc.Format      = DXGI_FORMAT_R8G8B8A8_UNORM;
	else
		desc.Format      = DXGI_FORMAT_R32_TYPELESS;

	desc.BindFlags       = D3D10_BIND_SHADER_RESOURCE
	                     | (renderTarget  ? D3D10_BIND_RENDER_TARGET : 0)
						 | (stencilBuffer ? D3D10_BIND_DEPTH_STENCIL : 0);

	desc.MiscFlags       = 0
	                     | (mipLevels > 1 ? D3D10_RESOURCE_MISC_GENERATE_MIPS : 0)
		                 | (cubeMap       ? D3D10_RESOURCE_MISC_TEXTURECUBE   : 0);
	desc.CPUAccessFlags  = 0;
	desc.SampleDesc      = sampleDesc;

	Texture result;

	HRESULT hr = D3D10.getDevice()->CreateTexture2D(&desc, NULL, &(result.texture));

	if (FAILED(hr)) return Texture::null;

	D3D10_SHADER_RESOURCE_VIEW_DESC srvDesc; ZeroMemory(&srvDesc, sizeof(srvDesc));

	srvDesc.Format = stencilBuffer ? DXGI_FORMAT_R32_FLOAT : DXGI_FORMAT_R8G8B8A8_UNORM;

	if (stencilBuffer && multisample)
		return result; // DX10.1 feature

	if (count == 1)
	{
		if (multisample)
		{
			srvDesc.ViewDimension = D3D10_SRV_DIMENSION_TEXTURE2DMS;
		}
		else
		{
			srvDesc.ViewDimension = D3D10_SRV_DIMENSION_TEXTURE2D;
			srvDesc.Texture2D.MipLevels = mipLevels;
			srvDesc.Texture2D.MostDetailedMip = 0;
		}
	}
	else
	{
		if (cubeMap)
		{
			srvDesc.ViewDimension = D3D10_SRV_DIMENSION_TEXTURECUBE;
			srvDesc.TextureCube.MipLevels = mipLevels;
			srvDesc.TextureCube.MostDetailedMip = 0;
		}
		else
			if (multisample)
			{
				srvDesc.ViewDimension = D3D10_SRV_DIMENSION_TEXTURE2DMSARRAY;
				srvDesc.Texture2DMSArray.ArraySize = count;
				srvDesc.Texture2DMSArray.FirstArraySlice = 0;
			}
			else
			{
				srvDesc.ViewDimension = D3D10_SRV_DIMENSION_TEXTURE2DARRAY;
				srvDesc.Texture2DArray.ArraySize = count;
				srvDesc.Texture2DArray.FirstArraySlice = 0;
				srvDesc.Texture2DArray.MipLevels = mipLevels;
				srvDesc.Texture2DArray.MostDetailedMip = 0;
			}
	}

	hr = D3D10.getDevice()->CreateShaderResourceView(result.texture, &srvDesc, &(result.resourceView));
	if (FAILED(hr)) return Texture::null;

	return result;
}

//==========================================================================
// == and != for easy comparison
//==========================================================================
bool Texture::operator == (const Texture& texture)
{
	return this->texture == texture.texture;
}

bool Texture::operator != (const Texture& texture)
{
	return !(*this == texture);
}

//==========================================================================
// Properties
//==========================================================================
ID3D10ShaderResourceView* Texture::getShaderResourceView() const
{
	return this->resourceView;
}

ID3D10Texture2D* Texture::getTexture() const
{
	return this->texture;
}

//==========================================================================
// Methods
//==========================================================================
void Texture::generateMips()
{
	D3D10.getDevice()->GenerateMips(resourceView);
}