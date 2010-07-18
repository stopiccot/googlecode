#include <windows.h>
#include <gl/gl.h>             
#include <gl/glu.h>     

/*
	To Enable CRINKLER

	Tools -> Options.. -> Projects And Solutions -> VC++ Directories
	add $(ProjectDir) directory on top

	CRINKLER Options
	C/C++ -> Optimization -> Whole Program Optimization = No
	C/C++ -> Code Generation -> Buffer Security Check   = No
	Linker -> Manifest File -> Generate Manifest        = No
*/

#define SCREEN_X      1280
#define SCREEN_Y      1024
#define SCREEN_ASPECT (1280.0f / 1024.0f)


void __forceinline RenderCube(float alpha) 
{
	glBegin(GL_QUADS);
		glColor4f(0.0f,1.0f,0.0f, alpha );
		glVertex3f( 1.0f, 1.0f,-1.0f);
		glVertex3f(-1.0f, 1.0f,-1.0f);
		glVertex3f(-1.0f, 1.0f, 1.0f);
		glVertex3f( 1.0f, 1.0f, 1.0f);
	    glColor4f(1.0f,0.5f,0.0f, alpha );   
		glVertex3f( 1.0f,-1.0f, 1.0f);
        glVertex3f(-1.0f,-1.0f, 1.0f);
	    glVertex3f(-1.0f,-1.0f,-1.0f);
		glVertex3f( 1.0f,-1.0f,-1.0f);
		glColor4f(1.0f,0.0f,0.0f, alpha );   
		glVertex3f( 1.0f, 1.0f, 1.0f);
		glVertex3f(-1.0f, 1.0f, 1.0f);
		glVertex3f(-1.0f,-1.0f, 1.0f);
		glVertex3f( 1.0f,-1.0f, 1.0f);
		glColor4f(1.0f,1.0f,0.0f, alpha );   
		glVertex3f( 1.0f,-1.0f,-1.0f);
		glVertex3f(-1.0f,-1.0f,-1.0f);
		glVertex3f(-1.0f, 1.0f,-1.0f);
	    glVertex3f( 1.0f, 1.0f,-1.0f);
		glColor4f(0.0f,0.0f,1.0f, alpha );   
		glVertex3f(-1.0f, 1.0f, 1.0f);
	    glVertex3f(-1.0f, 1.0f,-1.0f);
		glVertex3f(-1.0f,-1.0f,-1.0f);
		glVertex3f(-1.0f,-1.0f, 1.0f);
		glColor4f(1.0f,0.0f,1.0f, alpha );
		glVertex3f( 1.0f, 1.0f,-1.0f);
		glVertex3f( 1.0f, 1.0f, 1.0f);
		glVertex3f( 1.0f,-1.0f, 1.0f);
		glVertex3f( 1.0f,-1.0f,-1.0f);
	glEnd();  
}

double sin(double n)
{	__asm	{	fld n
				fsin	}	}


void Rotate(float f)
{
	glRotatef( 5 * f, 1, 0, 0 );
	glRotatef( 2 * f, 0, 1, 0 );
	glRotatef( 1 * f, 0, 0, 1 );
}


int WINAPI main(HINSTANCE hInstance, HINSTANCE hPreviuos, LPSTR lpCmdLine, int nCmdShow)
{
	HWND hWindow = CreateWindowA( "edit", 0, WS_POPUP | WS_VISIBLE, 0, 0, SCREEN_X, SCREEN_Y, 0, 0, 0, 0 );
	HDC hDC = GetDC( hWindow );
		
	static DEVMODEA devMode;

	devMode.dmSize	     = sizeof( DEVMODE );
	devMode.dmPelsWidth	 = SCREEN_X;	
	devMode.dmPelsHeight = SCREEN_Y;  
	devMode.dmFields	 = DM_PELSWIDTH | DM_PELSHEIGHT;
	ChangeDisplaySettingsA( &devMode, CDS_FULLSCREEN );

	static	PIXELFORMATDESCRIPTOR pfd;
	pfd.cColorBits = pfd.cDepthBits = 32;
    pfd.dwFlags    = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER;	
	
	SetPixelFormat(hDC, ChoosePixelFormat(hDC, &pfd), &pfd);
	wglMakeCurrent(hDC, wglCreateContext(hDC) );

	glEnable( GL_BLEND );
	//glEnable( GL_DEPTH_TEST );
	glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

	glMatrixMode( GL_PROJECTION );
	gluPerspective( 45.0f, 800.0f / 600.0f, 0.1f, 100.0f );
	glMatrixMode( GL_MODELVIEW );

	//ShowCursor( false );
	
	static float Angle;

	int Frame = 0;
	DWORD StartTime = GetTickCount();

	do
	{
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glLoadIdentity();
		glTranslatef( 0, 0, -5 );
		
		Rotate( Angle );  
		
		#define n 30
		float k = 15.0 + 10.0 * sin( 0.02 * Angle );

		for( int i = 0; i < n; i++ )
		{
			RenderCube( 1.0 / n );
			Rotate( k / n );
		}
		Angle -= 0.7f;
		SwapBuffers(hDC);
	}
	while (!GetAsyncKeyState(VK_ESCAPE));
}