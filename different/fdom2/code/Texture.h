#ifndef TEXTURE_H

	#define TEXTURE_H

	#include "Direct3D10.h"

	class Texture
	{
		public:
			// null texture for comparison
			const static Texture null;
			bool operator == (const Texture& texture);
			bool operator != (const Texture& texture);

			// Constructors
			Texture();
			static Texture Create(int width, int height);
			static Texture Create(int width, int height, int mipLevels, int count, bool renderTarget, bool stencilBuffer, bool cubeMap, DXGI_SAMPLE_DESC sampleDesc);
			static Texture LoadFromFile(LPCWSTR fileName);

			// Properties
			ID3D10Texture2D* getTexture() const;
			ID3D10ShaderResourceView* getShaderResourceView() const;
			
			// Copy constructor, desctructor and operator = for updating COM references
			Texture(const Texture& texture);
			Texture& operator = (const Texture& texture);
			~Texture();

			// Methods
			void generateMips();
			
		private:

			ID3D10Texture2D* texture;
			ID3D10ShaderResourceView* resourceView;

			void copyReferences(ID3D10Texture2D *texture, ID3D10ShaderResourceView* resourceView);
	};

#endif