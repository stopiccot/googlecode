#include "Effect.h"

//============================================================================
// Null constructor
//============================================================================
Effect::Effect() : effect(NULL), texture1(NULL), texture2(NULL)
{
	//...
}

//============================================================================
// init - same as constructor
//============================================================================
void Effect::init(LPCWSTR name)
{
	std::vector<char> hlsl;

	{
		FILE* file = _wfopen(name, L"rb");

		fseek(file, 0, SEEK_END);
		long fileSize = ftell(file);
		fseek(file, 0, SEEK_SET);

		hlsl.resize(fileSize);
		fread(&hlsl[0], 1, fileSize, file);

		fclose(file);
	}

	DWORD dwShaderFlags = D3D10_SHADER_ENABLE_STRICTNESS;

	#if defined( DEBUG ) || defined( _DEBUG )
		// dwShaderFlags |= D3D10_SHADER_DEBUG; // Fails with new D3DCompiler_47.dll from Windows 8.1 SDK
	#endif

	ID3D10Blob *errorBlob = NULL;
	ID3D10Blob *effectBlob = NULL;

	HRESULT hr = D3DCompile(&hlsl[0], hlsl.size(), "fx", NULL, NULL, NULL, "fx_4_0", dwShaderFlags, 0, &effectBlob, &errorBlob);
	if (FAILED(hr))
	{
		if (errorBlob)
		{
			char* text = (char*)errorBlob->GetBufferPointer();
			MessageBoxA(NULL, text, "directx", MB_OK);
		}
		else
		{
			MessageBox(D3D10.getHWND(), L"Failed to create effect", L"FDOM", MB_OK | MB_ICONERROR);
		}
	}

	hr = D3D10CreateEffectFromMemory(effectBlob->GetBufferPointer(), effectBlob->GetBufferSize(), 0, D3D10.getDevice(), NULL, &effect);
	if (FAILED(hr))
	{
		MessageBox(D3D10.getHWND(), L"Failed to create effect", L"FDOM", MB_OK | MB_ICONERROR);
	}

	texture1 = effect->GetVariableByName("Texture")->AsShaderResource();
	texture2 = effect->GetVariableByName("Texture2")->AsShaderResource();
}

//============================================================================
// initTechnique
//============================================================================
bool Effect::initTechnique(const char *name)
{
	Technique technique;

	technique.tech = effect->GetTechniqueByName(name);

	if (technique.tech == NULL)
	{
		MessageBox(D3D10.getHWND(), L"Effect::initTechnique failed", L"D3D10", MB_OK | MB_ICONERROR);
		return false;
	}

	int numElements  = 0;
	D3D10_INPUT_ELEMENT_DESC *layout = getLayout(numElements);

	D3D10_PASS_DESC passDesc;
	technique.tech->GetPassByIndex(0)->GetDesc(&passDesc);

	// Initialize technique's input layout
	HRESULT hr = D3D10.getDevice()->CreateInputLayout(layout, numElements, passDesc.pIAInputSignature,
		passDesc.IAInputSignatureSize, &(technique.layout));

	if (FAILED(hr))
	{
		MessageBox(D3D10.getHWND(), L"Effect::initTechnique failed", L"D3D10", MB_OK | MB_ICONERROR);
		return false;
	}

	// Add new technique to effect's technique map
	techniques[name] = technique;
	return true;
}

//============================================================================
// getTechnique
//============================================================================
Technique Effect::getTechnique(const char *name)
{
	Technique tech = techniques[name];

	if (tech.tech == NULL && tech.layout == NULL)
	{
		initTechnique(name);
		tech = techniques[name];
	}
		
	return tech;
}

//============================================================================
// Destructor
//============================================================================
Effect::~Effect()
{
	effect->Release();

	for (std::map<const char *,ShaderVariable*>::const_iterator it = variables.begin(); it != variables.end(); ++it)
	{
		(*it).second->free();
		delete (*it).second;
	}
}

//============================================================================
// null constructor - can't be called outside
//============================================================================
Effect3D::Effect3D() : Effect(), worldMatrix(NULL), viewMatrix(NULL), projectionMatrix(NULL)
{
	// no code here
}

//============================================================================
// Copy constructor, desctructor and operator = for updating COM refernces
//============================================================================
Effect3D::Effect3D(const Effect3D& effect) : Effect(), 
	worldMatrix(NULL), viewMatrix(NULL), projectionMatrix(NULL), cameraPos(NULL)
{
	copy(effect);
}

Effect3D& Effect3D::operator = (const Effect3D& effect)
{
	this->effect   = NULL;
	this->texture1 = NULL;
	this->texture2 = NULL;

	copy(effect);
	return *this;
}

void Effect3D::copy(const Effect3D& effect)
{
	worldMatrix      = effect.worldMatrix;
	viewMatrix       = effect.viewMatrix;
	projectionMatrix = effect.projectionMatrix;
	cameraPos        = effect.cameraPos;

	if (effect.effect)
	{
		this->effect = effect.effect;
		this->effect->AddRef();
	}

	if (effect.texture1)
		this->texture1 = effect.texture1;

	if (effect.texture2)
		this->texture2 = effect.texture2;
}

//============================================================================
// Effect3D::Create
//============================================================================
Effect3D Effect3D::Create(LPCWSTR fileName)
{
	Effect3D result;
	result.init(fileName);
	result.initTechnique("Render");
	return result;
}

//============================================================================
// Effect3D::init
//============================================================================
void Effect3D::init(LPCWSTR name)
{
	Effect::init(name);

	worldMatrix      = effect->GetVariableByName("World")->AsMatrix();
	viewMatrix       = effect->GetVariableByName("View")->AsMatrix();
	projectionMatrix = effect->GetVariableByName("Projection")->AsMatrix();
	cameraPos        = effect->GetVariableByName("cameraWS")->AsVector();
}

//============================================================================
// Effect3D::getLayout
//============================================================================
D3D10_INPUT_ELEMENT_DESC* Effect3D::getLayout(int &n)
{
	static D3D10_INPUT_ELEMENT_DESC layout[] =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0,  0, D3D10_INPUT_PER_VERTEX_DATA, 0 },
		{ "NORMAL",   0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 12, D3D10_INPUT_PER_VERTEX_DATA, 0 },
		{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT,    0, 24, D3D10_INPUT_PER_VERTEX_DATA, 0 },
	};

	n = sizeof(layout) / sizeof(D3D10_INPUT_ELEMENT_DESC);

	return &layout[0];
}

//============================================================================
// Effect3D::~Effect3D
//============================================================================
Effect3D::~Effect3D()
{
	//...
}

//============================================================================
// null constructor - can't be called outside
//============================================================================
Effect2D::Effect2D() : Effect()
{
	// no code here
}

//============================================================================
// Copy constructor, desctructor and operator = for updating COM refernces
//============================================================================
Effect2D::Effect2D(const Effect2D& effect) : Effect()
{
	copy(effect);
}

Effect2D& Effect2D::operator = (const Effect2D& effect)
{
	this->effect   = NULL;
	this->texture1 = NULL;
	this->texture2 = NULL;

	copy(effect);
	return *this;
}

void Effect2D::copy(const Effect2D& effect)
{
	if (effect.effect)
	{
		this->effect = effect.effect;
		this->effect->AddRef();
	}

	if (effect.texture1)
		this->texture1 = effect.texture1;

	if (effect.texture2)
		this->texture2 = effect.texture2;
}

//============================================================================
// Effect2D::Create
//============================================================================
Effect2D Effect2D::Create(LPCWSTR fileName)
{
	Effect2D result;
	result.init(fileName);
	result.initTechnique("Render");
	return result;
}

//============================================================================
// Effect2D::init
//============================================================================
void Effect2D::init(LPCWSTR name)
{
	Effect::init(name);

	// specific Effect2D init here...
}

//============================================================================
// Effect2D::getLayout
//============================================================================
D3D10_INPUT_ELEMENT_DESC* Effect2D::getLayout(int &n)
{
	static D3D10_INPUT_ELEMENT_DESC layout[] =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT,    0,  0, D3D10_INPUT_PER_VERTEX_DATA, 0 },
		{ "COLOR",    0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0, 12, D3D10_INPUT_PER_VERTEX_DATA, 0 },
		{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT,       0, 28, D3D10_INPUT_PER_VERTEX_DATA, 0 },
	};

	n = sizeof(layout) / sizeof(D3D10_INPUT_ELEMENT_DESC);

	return layout;
}

//============================================================================
// Effect2D::~Effect2D
//============================================================================
Effect2D::~Effect2D()
{
	//...
}

ShaderVector3 Effect::getVector3(const char *name)
{
	ShaderVariable* var = this->variables[name];
	if (var)
	{
		return *(dynamic_cast<ShaderVector3*>(var));
	}
	else
	{
		ShaderVector3 *vector3 = new ShaderVector3(new DirectX::XMVECTORF32(), this->effect->GetVariableByName(name)->AsVector());
		this->variables[name] = vector3;
		return *vector3;
	}
}

void Effect::flushShaderVariables() const
{
	for (std::map<const char *,ShaderVariable*>::const_iterator it = variables.begin(); it != variables.end(); ++it)
		(*it).second->apply();
}

void Effect::setTexture(const Texture &texture)
{
	this->texture1->SetResource( texture.getShaderResourceView() );
}

void Effect::setTextures(const Texture &texture1, const Texture &texture2)
{
	this->texture1->SetResource( texture1.getShaderResourceView() );
	this->texture2->SetResource( texture2.getShaderResourceView() );
}

void Effect3D::setViewProjection(const DirectX::XMMATRIX &viewMatrix, const DirectX::XMMATRIX &projectionMatrix)
{
	this->viewMatrix->SetMatrix((float*)&viewMatrix);
	this->projectionMatrix->SetMatrix((float*)&projectionMatrix);
}

void Effect3D::setCameraPos(float x, float y, float z)
{
	float data[3] = {x, y, z};
	this->cameraPos->SetFloatVector(data);
}

void Effect3D::setCameraPos(DirectX::XMVECTORF32 &camPos)
{
	setCameraPos(camPos.f[0], camPos.f[1], camPos.f[2]);
}
