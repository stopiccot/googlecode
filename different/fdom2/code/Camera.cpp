#include "Camera.h"
#include "..\Level.h"

Camera::Camera() : fly(false), fi(0.0f), ksi(0.0f) { }

Camera::Camera(float x, float y, float z) : fly(false), fi(0.0f), ksi(0.0f)
{
	this->setPos(x, y, z);
}

DirectX::XMVECTORF32 Camera::getPos()
{
	return eye;
}

void Camera::setPos(float x, float y, float z)
{
	eye.f[0] = x;
	eye.f[1] = y;
	eye.f[2] = z;
}

void Camera::setPos(const DirectX::XMVECTORF32 &pos)
{
	eye = pos;
}

DirectX::XMMATRIX Camera::getViewMatrix()
{
	return matrix;
}

void Camera::update(bool keys[4])
{
	POINT p; GetCursorPos(&p);
		
	fi  -= (p.x - D3D10.getScreenX() / 2) / 1000.0f;
	ksi -= (p.y - D3D10.getScreenY() / 2) / 1000.0f;

	if (ksi >  DirectX::XM_PI / 2.0f ) ksi =  DirectX::XM_PI / 2.0f;
	if (ksi < -DirectX::XM_PI / 2.0f ) ksi = -DirectX::XM_PI / 2.0f;

	DirectX::XMVECTORF32 newEye = eye;

	float c = 0.5f;
	if (keys[0]) // A
	{
		newEye.f[0] += c * cos(fi + DirectX::XM_PI / 2.0f);
		newEye.f[2] += c * sin(fi + DirectX::XM_PI / 2.0f);
	}
	if (keys[1]) // W
	{
		newEye.f[0] += c * cos(fi);
		newEye.f[2] += c * sin(fi);
		if (fly) newEye.f[1] += c * sin(ksi);
	}
	if (keys[2]) // D
	{
		newEye.f[0] += c * cos(fi - DirectX::XM_PI / 2.0f);
		newEye.f[2] += c * sin(fi - DirectX::XM_PI / 2.0f);
	}
	if (keys[3]) // S
	{
		newEye.f[0] -= c * cos(fi);
		newEye.f[2] -= c * sin(fi);
		if (fly) newEye.f[1] -= c * sin(ksi);
	}
	
	if (!fly)
		boundCamera(newEye);

	eye = newEye;

	at.f[0] = eye.f[0] + cos(fi) * cos(ksi);
	at.f[1] = eye.f[1] + sin(ksi);
	at.f[2] = eye.f[2] + sin(fi) * cos(ksi);

	up.f[0] = cos(fi) * cos(ksi + DirectX::XM_PI / 2.0f);
	up.f[1] = sin(ksi + DirectX::XM_PI / 2.0f);
	up.f[2] = sin(fi) * cos(ksi + DirectX::XM_PI / 2.0f);
	
	matrix = DirectX::XMMatrixLookAtLH(eye, at, up);
	
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