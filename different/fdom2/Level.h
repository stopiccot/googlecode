#ifndef LEVEL_H

	#define LEVEL_H

	#include "code\Direct3D10.h"
	#include "code\UberMesh.h"
	#include "code\Camera.h"
	
	void initLevel();
	void renderLevel(const DirectX::XMMATRIX &view, const DirectX::XMMATRIX &projection, const DirectX::XMVECTORF32 &eye, bool b);
	void renderLevelCubeMap(DirectX::XMMATRIX *view, DirectX::XMMATRIX *projection);
	void boundCamera(DirectX::XMVECTORF32& vec);
#endif