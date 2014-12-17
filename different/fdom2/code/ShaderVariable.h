#ifndef SHADER_VARIABLE_H
	#define SHADER_VARIABLE_H

	#include "Direct3D10.h"

	class Effect;

	class ShaderVariable
	{
		public:
			// null shader variable for comparison
			const static ShaderVariable null;
			bool operator == (const ShaderVariable& shaderVar);
			bool operator != (const ShaderVariable& shaderVar);

			// Constructor
			ShaderVariable();
			
			// Copy constructor, desctructor and operator = for updating COM references
			ShaderVariable(const ShaderVariable& shaderVar);
			ShaderVariable& operator = (const ShaderVariable& shaderVar);
			virtual ~ShaderVariable();

			// methods
			virtual void apply();
			virtual void free();

		protected:
			ID3D10EffectVariable *var;
	};

	class ShaderVector3 : public ShaderVariable
	{
			DirectX::XMVECTORF32 *vector;

			friend class Effect;

		public:
			// Constructors
			ShaderVector3();
			ShaderVector3(DirectX::XMVECTORF32 *pointer, ID3D10EffectVariable *var);

			// methods to set value
			const DirectX::XMVECTORF32& operator = (const DirectX::XMVECTORF32& vector);
			void set(float x, float y, float z);

			void apply();
			void free();			
	};

#endif