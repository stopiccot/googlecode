#ifndef CAMERA_H

	#define CAMERA_H

	#include "Direct3D10.h"

	class Camera
	{
			D3DXMATRIX matrix;
			D3DXVECTOR3 eye, at, up;
			float fi, ksi;
			bool fly;

		public:
			Camera();
			Camera(float x, float y, float z);
			
			D3DXVECTOR3 getPos();
			void setPos(const D3DXVECTOR3& pos);
			void setPos(float x, float y, float z);
			D3DXMATRIX getViewMatrix();			

			void update(bool keys[4]);
			void reset();
			void noclip();
	};

#endif