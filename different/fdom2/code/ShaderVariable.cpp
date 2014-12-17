#include "ShaderVariable.h"

const ShaderVariable ShaderVariable::null;
//const ShaderVector3  ShaderVector3::null;

//==========================================================================
// Default constructor to null everything
//==========================================================================
ShaderVariable::ShaderVariable() : var(NULL) {}

//==========================================================================
// Copy constructor, desctructor and operator = for updating COM refernces
//==========================================================================
ShaderVariable::ShaderVariable(const ShaderVariable& shaderVar) : var(NULL)
{
	this->var = shaderVar.var;
}

ShaderVariable& ShaderVariable::operator = (const ShaderVariable& shaderVar)
{
	this->var = shaderVar.var;
	return *this;
}

ShaderVariable::~ShaderVariable()
{
	// ID3D10EffectEffect variable is not inherited from IUnknown 
	// so no Release() or AddRef() should be made
}

//==========================================================================
// Dummy methods
//==========================================================================
void ShaderVariable::apply() {}
void ShaderVariable::free() {}

//==========================================================================
// == and != for easy comparison
//==========================================================================
bool ShaderVariable::operator == (const ShaderVariable& shaderVar)
{
	return this->var == shaderVar.var;
}

bool ShaderVariable::operator != (const ShaderVariable& shaderVar)
{
	return !(*this == shaderVar);
}

ShaderVector3::ShaderVector3() : ShaderVariable(), vector(NULL)
{
	//...
}

ShaderVector3::ShaderVector3(DirectX::XMVECTORF32 *pointer, ID3D10EffectVariable *var)
{
	this->var = var;
	this->vector = pointer;
}

void ShaderVector3::apply()
{
	((ID3D10EffectVectorVariable*)var)->SetFloatVector((float*)this->vector);
}

void ShaderVector3::free()
{
	delete this->vector;
}

void ShaderVector3::set(float x, float y, float z)
{
	this->vector->f[0] = x;
	this->vector->f[1] = y;
	this->vector->f[2] = z;
}

const DirectX::XMVECTORF32& ShaderVector3::operator =(const DirectX::XMVECTORF32& vector)
{
	this->set(vector.f[0], vector.f[1], vector.f[2]);
	return vector;
}