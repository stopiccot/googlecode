#pragma warning (disable: 4244)
#include "log.h"
#include "Direct3D10.h"
#include "Effect.h"
#include "UberMesh.h"
#include "RenderTarget.h"
#include "Texture.h"
#include "..\Level.h"
#include "Camera.h"

#pragma warning (disable: 4244)

D3DXMATRIX projectionMatrix;
float zoom = 1.0f;

struct Vertex2D
{
    D3DXVECTOR3 Pos;
    D3DXVECTOR4 Col;
	D3DXVECTOR2 Tex;
};

Vertex2D data2D[4];

ID3D10Buffer *buffer2D = NULL;

void init2D()
{
	D3D10_BUFFER_DESC bd;
	
	bd.Usage = D3D10_USAGE_DYNAMIC;
	bd.ByteWidth = sizeof( Vertex2D ) * 4;
	bd.BindFlags = D3D10_BIND_VERTEX_BUFFER;
	bd.CPUAccessFlags = D3D10_CPU_ACCESS_WRITE;
	bd.MiscFlags = 0;
	
	D3D10_SUBRESOURCE_DATA InitData;
	InitData.pSysMem = data2D;

	HRESULT hr;
	
	hr = D3D10.getDevice()->CreateBuffer( &bd, &InitData, &buffer2D );
}

void Render2D(const Texture& texture, Effect2D& effect, int x, int y, int w, int h)
{
	Vertex2D* data = NULL;

	HRESULT hr = buffer2D->Map(D3D10_MAP_WRITE_DISCARD , NULL, (void**)&data);

	data[0].Pos.x = data[2].Pos.x =  2.0f * float(x)   / D3D10.getScreenX() - 1.0f;
	data[1].Pos.x = data[3].Pos.x =  2.0f * float(x+w) / D3D10.getScreenX() - 1.0f;
	data[0].Pos.y = data[1].Pos.y = -2.0f * float(y)   / D3D10.getScreenY() + 1.0f;
	data[2].Pos.y = data[3].Pos.y = -2.0f * float(y+h) / D3D10.getScreenY() + 1.0f;

	data[0].Tex.x = data[2].Tex.x = 0.0f;
	data[1].Tex.x = data[3].Tex.x = 1.0f;
	data[0].Tex.y = data[1].Tex.y = 0.0f;
	data[2].Tex.y = data[3].Tex.y = 1.0f;

	for( int i = 0; i < 4; i++ )
	{
		data[i].Col.x = data[i].Col.y = data[i].Col.z = data[i].Col.w = 1.0f;
		data[i].Pos.z = 0.0f;
	}

	buffer2D->Unmap();

	static UINT stride = sizeof(Vertex2D);
    static UINT offset = 0;

	Technique t = effect.getTechnique("Render");

	effect.texture1->SetResource( texture.getShaderResourceView() );

	D3D10.getDevice()->IASetInputLayout( t.layout );
	D3D10.getDevice()->IASetVertexBuffers(0, 1, &buffer2D, &stride, &offset );
	D3D10.getDevice()->IASetPrimitiveTopology( D3D10_PRIMITIVE_TOPOLOGY_TRIANGLESTRIP );
    
	D3D10_TECHNIQUE_DESC techDesc;

	t.tech->GetDesc(&techDesc);

    for( UINT i = 0; i < techDesc.Passes; ++i )
        t.tech->GetPassByIndex(i)->Apply(i),
		D3D10.getDevice()->Draw(4, 0);
}

void Render2D(const Texture& texture1, const Texture& texture2, Effect2D& effect, int x, int y, int w, int h)
{
	effect.texture2->SetResource( texture2.getShaderResourceView() );
	Render2D(texture1,effect,x,y,w,h);	
}

Camera camera(10.0, 0.0, 10.0f);
bool   keys[4];
BOOL   EnableMapping = TRUE;

void callback(UINT message, WPARAM wParam, LPARAM lParam)
{
	switch( message )
	{
		case WM_TIMER:
		{
			camera.update(keys);
			break;
		}
		case WM_KEYDOWN:
		{
			switch (wParam)
			{
				case 32: 
					EnableMapping = !EnableMapping; 
				break;
				case 37: case 65: keys[0] = true; break;
				case 38: case 87: keys[1] = true; break;
				case 39: case 68: keys[2] = true; break;
				case 40: case 83: keys[3] = true; break;
			}
			break;
		}
		case WM_KEYUP:
		{
			switch (wParam)
			{
				case 37: case 65: keys[0] = false; break;
				case 38: case 87: keys[1] = false; break;
				case 39: case 68: keys[2] = false; break;
				case 40: case 83: keys[3] = false; break;
			}
			break;
		}
		case WM_MOUSEWHEEL:
		{
			zoom += 0.1f;
			D3DXMatrixPerspectiveFovLH( &projectionMatrix, (float)D3DX_PI * 0.5f, float(D3D10.getScreenX()) / float(D3D10.getScreenY()), 0.1f, 10000.0f );
			projectionMatrix.m[0][0] *= zoom;
			projectionMatrix.m[1][1] *= zoom;

			break;
		}
	}
}

int WINAPI wWinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow )
{
	D3D10.init(1280, 800, true, true);
	D3D10.setCallback(callback);

	init2D();

	Effect2D twoDim        = Effect2D::Create(L"fx\\2d.fx");
	Effect3D diffuseEffect = Effect3D::Create(L"fx\\diffuse.fx");
	Effect3D bottleEffect  = Effect3D::Create(L"fx\\bottle.fx");
	Effect3D healingEffect = Effect3D::Create(L"fx\\healing.fx");
	Effect3D cubeEffect    = Effect3D::Create(L"fx\\cubeMapRender.fx");

	ID3D10ShaderResourceView *lobbySRV = NULL;
	HRESULT hr = D3DX10CreateShaderResourceViewFromFile( D3D10.getDevice(), L"textures\\lobby.dds", NULL, NULL, &lobbySRV, NULL );

	ID3D10EffectShaderResourceVariable *cubeTex = bottleEffect.effect->GetVariableByName("envTexture")->AsShaderResource();
	
	UberMesh *sphere   = new UberMesh(L"models\\sphere4.txt");
	UberMesh *sphere2  = new UberMesh(L"models\\sphere2.txt");
		
	UberMesh *cross    = new UberMesh(L"models\\healing.txt");
	UberMesh *triangle = new UberMesh(L"models\\triangle.txt");	
	
	
	Texture whiteTexture  = Texture::LoadFromFile(L"textures\\white.png");
	Texture background    = Texture::LoadFromFile(L"textures\\background_gradient.png");

	const int DOWN_CONST = 16;
	RenderTarget renderTarget = RenderTarget::Create(D3D10.getScreenX(), D3D10.getScreenY());
	RenderTarget WideRT       = RenderTarget::Create(D3D10.getScreenX(), 9 * D3D10.getScreenX() / 16, true);
	RenderTarget lightRT      = RenderTarget::Create(256, 256, true);
	RenderTarget cubeTarget   = RenderTarget::CreateCube(256, 256);
	cubeTarget.enableStencil();
	renderTarget.enableStencil();

	initLevel();

	camera.reset();
	//camera.noclip();

	D3DXMATRIX cubeMapProj, lightProj;
	D3DXVECTOR3 eyeCM, atCM, upCM;
	D3DXMATRIX viewCM[6];

	// Initialize the projection matrix
    D3DXMatrixPerspectiveFovLH( &projectionMatrix, (float)D3DX_PI * 0.5f, float(D3D10.getScreenX()) / float(D3D10.getScreenY()), 0.1f, 10000.0f );
		
	D3DXMatrixPerspectiveFovLH( &cubeMapProj,      (float)D3DX_PI * 0.5f, 1.0f, 0.1f, 10000.0f );
	D3DXMatrixPerspectiveFovLH( &lightProj,        (float)D3DX_PI * 0.5f, 1.0, 0.1f, 10000.0f );
	ShowCursor(false);

	ShaderVector3 color     = diffuseEffect.getVector3("color");
	ShaderVector3 hLightPos = healingEffect.getVector3("lightPos");

	ShaderVector3 bottleCamPos = bottleEffect.getVector3("camPos");
	
	D3DXVECTOR3 light(0.0f, 0.0f, -2.0f);

    MSG msg = {0};
	while (WM_QUIT != msg.message)
        if( PeekMessage( &msg, NULL, 0, 0, PM_REMOVE ) )
            TranslateMessage(&msg),
            DispatchMessage(&msg);
        else
        {
			D3DXVECTOR3 healPos[] = {
				D3DXVECTOR3(20.0, -2.0, 30.0),
				D3DXVECTOR3(15.0, -2.0, 35.0),
				D3DXVECTOR3(20.0, -2.0, 25.0),
			};

			if (EnableMapping = true)
			{
				eyeCM.x = 30.0 + 10.0 * sin(GetTickCount() / 2000.0);
				eyeCM.y = 2.0 * cos(GetTickCount() / 10000.0) - 1.0	;
				eyeCM.z = 50.0 + 10.0 * cos(GetTickCount() / 2000.0);
				upCM.x  = 0.0;  upCM.y  =  1.0; upCM.z  = 0.0;

				atCM = eyeCM; atCM.x += 1.0;
				D3DXMatrixLookAtLH(&viewCM[0], &eyeCM, &atCM, &upCM);

				atCM = eyeCM; atCM.x -= 1.0;
				D3DXMatrixLookAtLH(&viewCM[1], &eyeCM, &atCM, &upCM);

				atCM = eyeCM; atCM.z += 1.0;
				D3DXMatrixLookAtLH(&viewCM[4], &eyeCM, &atCM, &upCM);

				atCM = eyeCM; atCM.z -= 1.0;
				D3DXMatrixLookAtLH(&viewCM[5], &eyeCM, &atCM, &upCM);

				upCM.x  = 0.0;  upCM.y  =  0.0; upCM.z  = -1.0;
				atCM = eyeCM; atCM.y += 1.0;
				D3DXMatrixLookAtLH(&viewCM[2], &eyeCM, &atCM, &upCM);

				upCM.x  = 0.0;  upCM.y  =  0.0; upCM.z  = 1.0;
				atCM = eyeCM; atCM.y -= 1.0;
				D3DXMatrixLookAtLH(&viewCM[3], &eyeCM, &atCM, &upCM);

				sphere->setPosition(eyeCM.x, eyeCM.y, eyeCM.z);

				ID3D10ShaderResourceView* const pSRV[4] = { NULL, NULL, NULL, NULL };
				D3D10.getDevice()->PSSetShaderResources( 0, 4, pSRV );

				// Render to cubemap
				D3D10.setRenderTarget(cubeTarget.clear(0.2, 0.0, 0.0));
				renderLevelCubeMap(viewCM, &cubeMapProj);

				for (int i = 0; i < sizeof(healPos) / sizeof(D3DXVECTOR3); ++i)
				{
					cross->setRotate(0.0, (1500 * i  + GetTickCount()) / 500.0, 0.0 );
					cross->setPosition(healPos[i].x, healPos[i].y, healPos[i].z);
					cross->Render(healingEffect, "Render");
				}
			}

			// Light render target
			D3DXVECTOR3 lightPos   = D3DXVECTOR3( 20.0,  5.0, 20.0 );
			/*
			D3D10.setRenderTarget(
				lightRT.clear(0.1f, 0.1f, 0.1f)
			);

			D3DXVECTOR3 lightPosAt;// = D3DXVECTOR3(  0.0,  0.0, 0.0 );
			lightPosAt.x = lightPos.x + sin( GetTickCount() / 1000.0 );
			lightPosAt.y = lightPos.y - 0.75;
			lightPosAt.z = lightPos.z + cos( GetTickCount() / 1000.0 );
			D3DXVECTOR3 lightPosUp = D3DXVECTOR3(  0.0,  1.0, 0.0  );
			D3DXMATRIX lightView;
			D3DXMatrixLookAtLH(&lightView, &lightPos, &lightPosAt, &lightPosUp);
			renderLevel(lightView, lightProj, lightPos, true);

			hLightPos = camera.getPos();

			color.set(0.0, 0.0, 1.0);
		
			healingEffect.setViewProjection(lightView, lightProj);
			*/				
			/*
			for (int i = 0; i < sizeof(healPos) / sizeof(D3DXVECTOR3); ++i)
			{
				cross->setRotate(0.0, (1500 * i  + GetTickCount()) / 500.0, 0.0 );
				cross->setPosition(healPos[i].x, healPos[i].y, healPos[i].z);
				cross->Render(healingEffect, "Render");
			}
			*/
			// Update matrices
			diffuseEffect.setViewProjection(camera.getViewMatrix(), projectionMatrix);
			healingEffect.setViewProjection(camera.getViewMatrix(), projectionMatrix);
			bottleEffect.setViewProjection(camera.getViewMatrix(), projectionMatrix);
			cubeEffect.setViewProjection(camera.getViewMatrix(), projectionMatrix);

			// Render to screen
			D3D10.setRenderTarget(
				//WideRT.clear(0.0f, 0.0f, 0.0f)
				RenderTarget::screen.clear(0.4f, 0.1f, 0.1f)
			);
			
			Render2D(background, twoDim, 0, -D3D10.getScreenY() / 50, D3D10.getScreenX(), D3D10.getScreenY());

			// Render level
			renderLevel(camera.getViewMatrix(), projectionMatrix, camera.getPos(), false);

			color.set(1.0, 1.0, 1.0);
			sphere->setPosition(lightPos.x, lightPos.y, lightPos.z);
			sphere->setScale(0.3, 0.3, 0.3);
			sphere->Render(diffuseEffect, "Render");

			hLightPos = camera.getPos();

			color.set(0.0, 0.0, 1.0);
			/*				
			D3DXVECTOR3 healPos[] = {
				D3DXVECTOR3(10.0, -2.0, 30.0),
				D3DXVECTOR3(15.0, -2.0, 35.0),
				D3DXVECTOR3(20.0, -2.0, 25.0),
			};
			*/

			for (int i = 0; i < sizeof(healPos) / sizeof(D3DXVECTOR3); ++i)
			{
				cross->setRotate(0.0, (1500 * i  + GetTickCount()) / 500.0, 0.0 );
				cross->setPosition(healPos[i].x, healPos[i].y, healPos[i].z);
				cross->Render(healingEffect, "Render");
			}
			
			if (EnableMapping)
			{
				cubeTarget.getTexture().generateMips();
				cubeTex->SetResource(cubeTarget.getTexture().getShaderResourceView());
				bottleCamPos = camera.getPos();
				sphere2->setPosition(eyeCM);
				sphere2->setScale(1.5, 1.5, 1.5);
				sphere2->Render(bottleEffect, "Render");
			}

			/*D3D10.setRenderTarget(
				RenderTarget::screen.clear(0.0f, 0.0f, 0.0f)
			);

			Render2D(WideRT.getTexture(),  twoDim, 0, 0, 1920, 1200);
			Render2D(lightRT.getTexture(), twoDim, 0, 0, 256, 256);*/

			D3D10.getSwapChain()->Present(0, 0);
        }

	ShowCursor(true);
    return ( int )msg.wParam;
}