#ifndef EFFECT_HEADER

	#define EFFECT_HEADER

	#include "Direct3D10.h"
	#include "Texture.h"
	#include "ShaderVariable.h"
	#include <map>
	using namespace std;

	struct Technique
	{
		ID3D10EffectTechnique *tech;
		ID3D10InputLayout *layout;
	};

	class Effect
	{
		protected:
			Effect();

			map<const char *, ShaderVariable*> variables;
			mutable map<const char *, Technique> techniques;

			virtual D3D10_INPUT_ELEMENT_DESC* getLayout(int &n) = 0;
			virtual void init(LPCWSTR name);
			bool initTechnique(const char *name);

		public:

			Technique getTechnique(const char *name);

			void flushShaderVariables() const;

			ID3D10Effect *effect;
			
			ID3D10EffectShaderResourceVariable* texture1;
			ID3D10EffectShaderResourceVariable* texture2;
			void setTexture(const Texture &texture);
			void setTextures(const Texture &texture1, const Texture &texture2);

			Effect(LPCWSTR fileName);
			virtual ~Effect();

			ShaderVector3 getVector3(const char *name);
	};

	class Effect3D : public Effect
	{
			D3D10_INPUT_ELEMENT_DESC* getLayout(int &n);
			
			void init(LPCWSTR name);
			void copy(const Effect3D& effect);

		public:
			// null constructor and copy constructors
			Effect3D();
			Effect3D(const Effect3D& effect);
			Effect3D& operator = (const Effect3D& effect);

			// Constructor
			static Effect3D Create(LPCWSTR fileName);

			// Variables
			ID3D10EffectMatrixVariable* worldMatrix;
			ID3D10EffectMatrixVariable* viewMatrix;
			ID3D10EffectMatrixVariable* projectionMatrix;
			ID3D10EffectVectorVariable* cameraPos;

			// Methods
			void setViewProjection(const D3DXMATRIX &viewMatrix, const D3DXMATRIX &projectionMatrix);
			void setCameraPos(float x, float y, float z);
			void setCameraPos(D3DXVECTOR3& camPos);
			
			virtual ~Effect3D();
	};

	class Effect2D : public Effect
	{
			D3D10_INPUT_ELEMENT_DESC* getLayout(int &n);

			void init(LPCWSTR name);
			void copy(const Effect2D& effect);

		public:
			// null constructor and copy constructors
			Effect2D();
			Effect2D(const Effect2D& effect);
			Effect2D& operator = (const Effect2D& effect);

			// Constructor
			static Effect2D Create(LPCWSTR fileName);

			virtual ~Effect2D();
	};

#endif