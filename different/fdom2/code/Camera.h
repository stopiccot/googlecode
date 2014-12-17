#ifndef CAMERA_H

	#define CAMERA_H

	#include "Direct3D10.h"

	class Camera
	{
			DirectX::XMMATRIX matrix;
			DirectX::XMVECTORF32 eye, at, up;
			float fi, ksi;
			bool fly;

		public:
			Camera();
			Camera(float x, float y, float z);
			
			DirectX::XMVECTORF32 getPos();
			void setPos(const DirectX::XMVECTORF32& pos);
			void setPos(float x, float y, float z);
			DirectX::XMMATRIX getViewMatrix();

			void update(bool keys[4]);
			void reset();
			void noclip();
	};

#endif