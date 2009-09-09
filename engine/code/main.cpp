#include "PythonBinding.h"
#include "AbstractRender.h"

__declspec(dllimport) AbstractRender *getDX9Render();
typedef AbstractRender *GetDX10Render();

int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow)
{
	if (true)
	{
		//OutputDebugString(L"using dx9 render");

		Render = getDX9Render();
	}
	else
	{
		//OutputDebugString(L"using dx10 render");

		HMODULE dx10 = LoadLibrary(L"dx10.dll");
		if (dx10)
		{
			GetDX10Render *getDX10Render = (GetDX10Render*)GetProcAddress(dx10, "getDX10Render");
			if (getDX10Render)
				Render = getDX10Render();
		}
	}

	if (Render)
	{
		Render->init(800, 600, false);

		MSG msg = {0};
		while (WM_QUIT != msg.message)
			if ( PeekMessage(&msg, NULL, 0, 0, PM_REMOVE) )
			{
				TranslateMessage(&msg);
				DispatchMessage(&msg);
			}
			else
			{
				if (Render->beginRender())
				{
					Render->endRender();
				}
			}
	}

	return 0;
}