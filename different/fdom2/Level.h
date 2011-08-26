#ifndef LEVEL_H

	#define LEVEL_H

	#include "code\Direct3D10.h"
	#include "code\UberMesh.h"
	#include "code\Camera.h"
	
	void initLevel();
	void renderLevel(const D3DXMATRIX &view, const D3DXMATRIX &projection, const D3DXVECTOR3 &eye, bool b);
	void renderLevelCubeMap(D3DXMATRIX *view, D3DXMATRIX *projection);
	void boundCamera(D3DXVECTOR3& vec);
#endif