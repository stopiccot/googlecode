#include "Camera.h"
#include "..\Level.h"

Camera::Camera() : fly(false), fi(0.0f), ksi(0.0f) { }

Camera::Camera(float x, float y, float z) : fly(false), fi(0.0f), ksi(0.0f)
{
	this->setPos(x, y, z);
}

D3DXVECTOR3 Camera::getPos()
{
	return eye;
}

void Camera::setPos(float x, float y, float z)
{
	eye.x = x;
	eye.y = y;
	eye.z = z;
}

void Camera::setPos(const D3DXVECTOR3 &pos)
{
	this->setPos(pos.x, pos.y, pos.z);
}

D3DXMATRIX Camera::getViewMatrix()
{
	return matrix;
}

void Camera::update(bool keys[4])
{
	POINT p; GetCursorPos(&p);
		
	fi  -= (p.x - D3D10.getScreenX() / 2) / 1000.0f;
	ksi -= (p.y - D3D10.getScreenY() / 2) / 1000.0f;

	if (ksi >  D3DX_PI / 2.0f ) ksi =  D3DX_PI / 2.0f;
	if (ksi < -D3DX_PI / 2.0f ) ksi = -D3DX_PI / 2.0f;

	D3DXVECTOR3 newEye = eye;

	float c = 0.5f;
	if (keys[0]) // A
	{
		newEye.x += c * cos(fi + D3DX_PI / 2.0f);
		newEye.z += c * sin(fi + D3DX_PI / 2.0f);
	}
	if (keys[1]) // W
	{
		newEye.x += c * cos(fi);
		newEye.z += c * sin(fi);
		if (fly) newEye.y += c * sin(ksi);
	}
	if (keys[2]) // D
	{
		newEye.x += c * cos(fi - D3DX_PI / 2.0f);
		newEye.z += c * sin(fi - D3DX_PI / 2.0f);
	}
	if (keys[3]) // S
	{
		newEye.x -= c * cos(fi);
		newEye.z -= c * sin(fi);
		if (fly) newEye.y -= c * sin(ksi);
	}
	
	if (!fly)
		boundCamera(newEye);

	eye = newEye;

	at.x = eye.x + cos(fi) * cos(ksi);
	at.y = eye.y + sin(ksi);
	at.z = eye.z + sin(fi) * cos(ksi);

	up.x = cos(fi) * cos(ksi + D3DX_PI / 2.0f);
	up.y = sin(ksi + D3DX_PI / 2.0f);
	up.z = sin(fi) * cos(ksi + D3DX_PI / 2.0f);
	
	D3DXMatrixLookAtLH(&matrix, &eye, &at, &up);
	
	reset();	
}

void Camera::reset()
{
	SetCursorPos(D3D10.getScreenX() / 2, D3D10.getScreenY() / 2);
}

void Camera::noclip()
{
	fly = true;
}