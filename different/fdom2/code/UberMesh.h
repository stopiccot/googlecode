#ifndef UBERMESH_H

	#define UBERMESH_H
	#include "Direct3D10.h"
	#include "Effect.h"

	struct UberVertex
	{
		DirectX::XMFLOAT3 Pos;
		DirectX::XMFLOAT3 Norm;
		DirectX::XMFLOAT2 Tex;
	};

	struct Vertex3D
	{
		DirectX::XMFLOAT3 Pos;
		DirectX::XMFLOAT3 Norm;
		DirectX::XMFLOAT2 Tex;
	};

	class UberMesh
	{
		public:
			
			void setPosition(float x, float y, float z);
			void setPosition(const DirectX::XMVECTORF32& pos);
			void setScale(float x, float y, float z);
			void setRotate(float x, float y, float z);

			UberMesh(const wchar_t *fileName);
			void Render(Effect3D& effect, const char *technique);

			ID3D10Buffer* getVertexBuffer();
			
			UberVertex *data;

			int nVertices;

			void Random();

		private:
			DirectX::XMMATRIX translationMatrix, scaleMatrix, rotateMatrix, worldMatrix;

			ID3D10Buffer* vertexBuffer;
			UberMesh();
	};

#endif