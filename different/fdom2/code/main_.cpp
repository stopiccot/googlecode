#include "log.h"
#include "Direct3D10.h"
#include "Effect.h"
#include "UberMesh.h"
#include "RenderTarget.h"
#include "Texture.h"

//--------------------------------------------------------------------------------------
// Global Variables
//--------------------------------------------------------------------------------------
//HINSTANCE                   g_hInst = NULL;

D3DXMATRIX                  g_World;
D3DXMATRIX                  g_View;
D3DXMATRIX                  g_Projection;


//--------------------------------------------------------------------------------------
// Forward declarations
//--------------------------------------------------------------------------------------
HRESULT InitWindow( HINSTANCE hInstance, int nCmdShow );
HRESULT InitDevice();
void CleanupDevice();
void Render();

class Tiger
{
		static int nTanks;
	public:
		static UberMesh *cannon, *tower, *body;
	
		Tiger()
		{
			if ( !Tiger::nTanks )
			{
				Tiger::cannon = new UberMesh(L"D:\\cannon.txt");
				Tiger::tower  = new UberMesh(L"D:\\tower.txt");
				Tiger::body   = new UberMesh(L"D:\\body.txt");
			}

			Tiger::nTanks++;
		}

		void Render(const Effect3D& effect)
		{
			D3DXMATRIX translateMatrix, rotateMatrix;

			effect.viewMatrix->SetMatrix( ( float* )&g_View );
			effect.projectionMatrix->SetMatrix( ( float* )&g_Projection );
			effect.worldMatrix->SetMatrix( ( float* )&g_World );

			Tiger::body->Render(effect);
		}
};

int Tiger::nTanks = 0;
UberMesh *Tiger::cannon = NULL, *Tiger::tower = NULL, *Tiger::body = NULL;

float function(float delta)
{
	float d = ((float)GetTickCount() + delta) / 100.0f;
	int n = (int)(d * 2.0f / acos(-1.0f)) % 8;

	if ( n <= 1 )
		return 3.0f - 1.5f * (float)sin(d);
	else
		return 3.0f;
}

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

	data[0].Pos.x = data[2].Pos.x =  2.0f * float(x)   / D3D10.GetScreenX() - 1.0f;
	data[1].Pos.x = data[3].Pos.x =  2.0f * float(x+w) / D3D10.GetScreenX() - 1.0f;
	data[0].Pos.y = data[1].Pos.y = -2.0f * float(y)   / D3D10.GetScreenY() + 1.0f;
	data[2].Pos.y = data[3].Pos.y = -2.0f * float(y+h) / D3D10.GetScreenY() + 1.0f;

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

	effect.texture->SetResource( texture.GetShaderResourceView() );

	D3D10.getDevice()->IASetInputLayout( effect.inputLayout );
	D3D10.getDevice()->IASetVertexBuffers(0, 1, &buffer2D, &stride, &offset );
	D3D10.getDevice()->IASetPrimitiveTopology( D3D10_PRIMITIVE_TOPOLOGY_TRIANGLESTRIP );
    
	D3D10_TECHNIQUE_DESC techDesc;

    effect.technique->GetDesc(&techDesc);

    for( UINT i = 0; i < techDesc.Passes; ++i )
        effect.technique->GetPassByIndex(i)->Apply(i),
		D3D10.getDevice()->Draw(4, 0);
}

void Render2D(const Texture& texture1, const Texture& texture2, Effect2D& effect, int x, int y, int w, int h)
{
	effect.texture2->SetResource( texture2.GetShaderResourceView() );
	Render2D(texture1,effect,x,y,w,h);	
}

struct Wheel
{
	D3DXVECTOR3 Pos;
	D3DXVECTOR2 Out;
	D3DXVECTOR2 In;
	float R, angleIn, angleOut;
};

Wheel wheel[ 10 ];
int nWheels = 0;

UberMesh* track;
UberMesh* cylinder, *wheel2;

void InitTracks()
{
	wheel[0].Pos.x  = -31.0; wheel[0].Pos.y  =  6.0; wheel[0].Pos.z   =  0.0; wheel[0].R  = 3.0;
	wheel[1].Pos.x  = -25.0; wheel[1].Pos.y  =  8.0; wheel[1].Pos.z   =  0.0; wheel[1].R  = 4.0;
	wheel[2].Pos.x  = -20.0; wheel[2].Pos.y  =  8.0; wheel[2].Pos.z   = -1.0; wheel[2].R  = 4.0;
	wheel[3].Pos.x  = -15.0; wheel[3].Pos.y  =  8.0; wheel[3].Pos.z   =  0.0; wheel[3].R  = 4.0;
	wheel[4].Pos.x  = -10.0; wheel[4].Pos.y  =  8.0; wheel[4].Pos.z   = -1.0; wheel[4].R  = 4.0;
	wheel[5].Pos.x  =  -5.0; wheel[5].Pos.y  =  8.0; wheel[5].Pos.z   =  0.0; wheel[5].R  = 4.0;
	wheel[6].Pos.x  =   0.0; wheel[6].Pos.y  =  8.0; wheel[6].Pos.z   = -1.0; wheel[6].R  = 4.0;
	wheel[7].Pos.x  =   5.0; wheel[7].Pos.y  =  8.0; wheel[7].Pos.z   =  0.0; wheel[7].R  = 4.0;
	wheel[8].Pos.x  =  10.0; wheel[8].Pos.y  =  8.0; wheel[8].Pos.z   = -1.0; wheel[8].R  = 4.0;
	wheel[9].Pos.x  =  16.0; wheel[9].Pos.y  =  6.0; wheel[9].Pos.z   =  0.0; wheel[9].R  = 3.0;

	nWheels = 10;
}

//float ddd = 0.0f;

#define sqr(X) ((X)*(X))

const float Pi = float(acos( -1.0 ));

void RenderTracks(const Effect3D& effect)
{
	float ddd = 0.0f;//Pi / 5 * ( GetTickCount() % 600 ) / 600.0f;

	// Moving wheels
	// for ( int i = 1; i < nWheels - 1; i++ )
	//	wheel[i].Pos.y = 8.0 + 0.3 * sin( float(i * GetTickCount() / 1000.0f) );
	
	// Calculate
	for ( int i = 0; i < nWheels; i++ )
	{
		{
			D3DXMATRIX t, s, r;
			D3DXMatrixTranslation( &t, wheel[i].Pos.x, -wheel[i].Pos.y, wheel[i].Pos.z );

			if ( i == 0 )
			{
				D3DXMatrixRotationZ( &r, ddd );
				D3DXMatrixScaling( &s, wheel[i].R, wheel[i].R, 2.5);
			}
			else
			{
				D3DXMatrixRotationZ( &r, 0.0 );
				D3DXMatrixScaling( &s, 1.9 * wheel[i].R, 1.9 * wheel[i].R, 1.0f);
			}

			//D3DXMatrixScaling( &s, 1.9 * wheel[i].R, 1.9 * wheel[i].R, 1.0f);
			
			g_World = (s * r) * t;

			effect.worldMatrix->SetMatrix( ( float* )&g_World );
			if ( i == 0 )
			{
				wheel2->Render(effect);
			}
			else
				cylinder->Render(effect);
		}

		int j = i + 1; 
		if ( j == nWheels ) 
			j = 0;

		float l  = sqrt(sqr(wheel[i].Pos.x - wheel[j].Pos.x) + sqr(wheel[i].Pos.y - wheel[j].Pos.y));
		float r  = wheel[j].R - wheel[i].R;
		float dx = wheel[i].Pos.x - wheel[j].Pos.x;
		float dy = wheel[i].Pos.y - wheel[j].Pos.y;

		float a1 = asin(r / l);
		float a2 = asin(abs(dy) / l);

		float a = ( dx > 0 ? 1 : 3 ) * Pi / 2.0f;

		float sgn = dx * dy >= 0 ? 1.0f : -1.0f;

		a = a - a1 - sgn * a2;

		wheel[i].Out.x = wheel[i].Pos.x + wheel[i].R * cos(a);
		wheel[i].Out.y = wheel[i].Pos.y - wheel[i].R * sin(a);
		wheel[j].In.x  = wheel[j].Pos.x + wheel[j].R * cos(a);
		wheel[j].In.y  = wheel[j].Pos.y - wheel[j].R * sin(a);

		wheel[i].angleOut = wheel[j].angleIn = a;
	}

	// Last wheel
	if ( wheel[nWheels-1].angleOut <wheel[nWheels-1].angleIn )
		wheel[nWheels-1].angleOut += 2 * Pi;

	float Length = 0.0;

	for ( int i = 0; i < nWheels; i++ )
	{
		int j = i + 1; if ( j == nWheels ) j = 0;

		Length += (wheel[i].angleOut - wheel[i].angleIn) * wheel[i].R;
		Length += sqrt(sqr(wheel[i].Out.x - wheel[j].In.x) + sqr(wheel[i].Out.y - wheel[i].In.y));
	}

	// Render
	{
		int i = 0, j = -1, nn = 0;

		D3DXVECTOR2 p1, p2 = wheel[0].Out;
		D3DXMATRIX m,s;
		D3DXMATRIX r, r2;
		D3DXMatrixRotationY(&r, Pi / 2.0 );

		float step = Length / 129.0f; //0.85f;

		float ddd = 0.0f;//step - ( GetTickCount() % 300 ) / 300.0f * step;

		float delta = ddd; while( ddd > step ) ddd -= step;

		bool flag = false;

		while (j != 0)
		{
			j = i + 1; 
			
			if ( j == nWheels ) 
				j = 0;

			float length = sqrt(sqr(wheel[i].Out.x - wheel[j].In.x) + sqr(wheel[i].Out.y - wheel[j].In.y));

			float l = step - delta; delta = 0.0;

			while ( length > l )
			{
				p1 = p2;
				p2.x = wheel[i].Out.x - l * sin( wheel[i].angleOut );
				p2.y = wheel[i].Out.y - l * cos( wheel[i].angleOut );

				l += step;

				// Render

				D3DXMatrixScaling( &s, 0.7f, 0.7f, 0.7f);
				D3DXMatrixTranslation( &m, (p1.x + p2.x) / 2.0f, -(p1.y + p2.y) / 2.0f,  0.0f);
				D3DXMatrixRotationZ(&r2, wheel[i].angleOut + Pi / 2.0f );
				g_World = ( ( s * r ) * r2 ) * m;
				effect.worldMatrix->SetMatrix( ( float* )&g_World );
				if ( flag ) track->Render(effect); else flag = true;
				nn++;
			}

			delta = length - ( l - step );

			i = j;

			float a = wheel[i].angleIn + ( step - delta ) / wheel[i].R; delta = 0.0;

			while(a < wheel[i].angleOut)
			{

				p1 = p2;
				p2.x = wheel[i].Pos.x + wheel[i].R * cos(a);
				p2.y = wheel[i].Pos.y - wheel[i].R * sin(a);

				a += step / wheel[i].R;

				// Render

				D3DXMatrixScaling( &s, 0.7f, 0.7f, 0.7f);
				D3DXMatrixTranslation( &m, (p1.x + p2.x) / 2.0f, -(p1.y + p2.y) / 2.0f,  0.0f);
				D3DXMatrixRotationZ(&r2, a - 1.5 * step / wheel[i].R + Pi / 2.0f );
				g_World = ( ( s * r ) * r2 ) * m;
				effect.worldMatrix->SetMatrix( ( float* )&g_World );
				track->Render(effect);
				nn++;
				
			}

			if ( j == 0 )
			{
				p1 = p2;
				p2.x = wheel[i].Pos.x + wheel[i].R * cos(a);
				p2.y = wheel[i].Pos.y - wheel[i].R * sin(a);

				// Render

				D3DXMatrixScaling( &s, 0.35f, 0.25f, 0.25f);
				D3DXMatrixTranslation( &m, (p1.x + p2.x) / 2.0f, -(p1.y + p2.y) / 2.0f,  0.0f);
				D3DXMatrixRotationZ(&r2, a - 1.5 * step / wheel[i].R + Pi / 2.0f );
				g_World = ( ( s * r ) * r2 ) * m;
				effect.worldMatrix->SetMatrix( ( float* )&g_World );
				track->Render(effect);
				nn++;
			}
			
			delta = step - ( a - wheel[i].angleOut ) * wheel[i].R;

			//return;
		}
		return;
	}
}

//--------------------------------------------------------------------------------------
// Entry point to the program. Initializes everything and goes into a message processing 
// loop. Idle time is used to render the scene.
//--------------------------------------------------------------------------------------
int WINAPI wWinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow )
{
	ZeroMemory(wheel, sizeof(wheel));
	InitTracks();

	D3D10.init( 1200, 800, false, true );
	init2D();

	Effect3D effect(L"directx.fx");
	Effect2D effect2(L"2d.fx");

   	UberMesh* cannon = new UberMesh(L"D:\\cannon.txt");
	UberMesh* tower  = new UberMesh(L"D:\\tower.txt");
	UberMesh* body   = new UberMesh(L"D:\\body.txt");

	track  = new UberMesh(L"D:\\track_new.txt");
	cylinder = new UberMesh(L"D:\\cyl.txt");
	wheel2 = new UberMesh(L"D:\\maya2009.txt");

	Tiger* t1 = new Tiger();
	Tiger* t2 = new Tiger();

	Texture texture = Texture::LoadFromFile(L"D:\\gray_camouflage.jpg");
	Texture image   = Texture::LoadFromFile(L"D:\\fil.png");

	RenderTarget renderTarget0 = RenderTarget::Create(1200, 800),
		         renderTarget1 = RenderTarget::Create(1200, 800);

	renderTarget0.EnableStencil();

	effect.texture->SetResource( texture.GetShaderResourceView() );
	effect2.texture->SetResource( image.GetShaderResourceView() );

    // Initialize the view matrix
    //D3DXVECTOR3 Eye( -37.0f, -5.0f, -10.0f );
    //D3DXVECTOR3 At( -35.0f, 0.0f, 0.0f );
	D3DXVECTOR3 Eye( 0.0f, 5.0f, -5.0f );
	D3DXVECTOR3 At( 0.0f, 0.0f, 0.0f );
    D3DXVECTOR3 Up( 0.0f, 1.0f, 0.0f );
    D3DXMatrixLookAtLH( &g_View, &Eye, &At, &Up );

    // Initialize the projection matrix
    D3DXMatrixPerspectiveFovLH( &g_Projection, ( float )D3DX_PI * 0.5f, 1200.0f / 800.0f, 0.1f, 10000.0f );

    // Main message loop
    MSG msg = {0};
    while( WM_QUIT != msg.message )
    {
        if( PeekMessage( &msg, NULL, 0, 0, PM_REMOVE ) )
        {
            TranslateMessage( &msg );
            DispatchMessage( &msg );
        }
        else
        {
			//D3D10.SetRenderTargets(renderTarget0.Clear(0.0f, 0.0f, 0.0f), renderTarget1.Clear(0.0f, 0.0f, 0.0f));
			D3D10.SetRenderTarget(RenderTarget::screen.Clear(0.1f, 0.1f, 0.5f));

			effect.viewMatrix->SetMatrix( ( float* )&g_View );
			effect.projectionMatrix->SetMatrix( ( float* )&g_Projection );
			D3DXMatrixIdentity(&g_World);
			effect.worldMatrix->SetMatrix( (float*)&g_World);
			
			effect.texture->SetResource( NULL );

			RenderTracks(effect);

			//D3DXMATRIX translateMatrix, rotateMatrix;
			//
			//{
			//	effect.viewMatrix->SetMatrix( ( float* )&g_View );
			//	effect.projectionMatrix->SetMatrix( ( float* )&g_Projection );

			//	D3DXMatrixRotationY( &rotateMatrix, (float)GetTickCount() / 10000.0f );

			//	effect.texture->SetResource( NULL );


			//	for ( int i = -20; i < 20; i++ )
			//	{
			//		D3DXMatrixTranslation( &translateMatrix, 0.0f, 0.0f , 3.5f * i);
			//		g_World = translateMatrix * rotateMatrix;
			//		effect.worldMatrix->SetMatrix( ( float* )&g_World );
			//		//track->Render(effect);
			//		cylinder->Render(effect);
			//	}

			//	effect.texture->SetResource( texture.GetShaderResourceView() );
			//}

			{
				/*
				D3DXMatrixRotationY( &rotateMatrix, (float)GetTickCount() / 10000.0f );
				D3DXMatrixTranslation( &translateMatrix, 0.0f, -0.2f, 0.0f );
				
				g_World = translateMatrix * rotateMatrix;

				effect.worldMatrix->SetMatrix( ( float* )&g_World );

				body->render(&effect);
				
				D3DXMatrixRotationY( &rotateMatrix, (float)GetTickCount() / 10000.0f + (float)GetTickCount() / 2000.0f );
				
				effect.worldMatrix->SetMatrix( ( float* )&rotateMatrix );

				tower->render(&effect);

				D3DXMatrixTranslation( &translateMatrix, function(0.0), -0.15f, 1.6f );
				
				g_World = translateMatrix * rotateMatrix;

				effect.worldMatrix->SetMatrix( ( float* )&g_World );
					
				Tiger::cannon->render(&effect);

				D3DXMatrixTranslation( &translateMatrix, function(100.0), -0.15f, -1.6f );
				
				g_World = translateMatrix * rotateMatrix;

				effect.worldMatrix->SetMatrix( ( float* )&g_World );

				Tiger::cannon->render(&effect);
				*/
			}

			//D3D10.SetRenderTarget(RenderTarget::screen.Clear(0.1f, 0.1f, 0.5f));
			
			//Render2D(renderTarget0.GetTexture(), renderTarget1.GetTexture(), effect2, 0, 0, 1200, 800);

			D3D10.getSwapChain()->Present( 0, 0 );
        }
    }

    return ( int )msg.wParam;
}