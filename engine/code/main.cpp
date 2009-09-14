#include "PythonBinding.h"
#include "AbstractRender.h"
#include <vector>
#include <map>

__declspec(dllimport) AbstractRender *getDX9Render();
typedef AbstractRender *GetDX10Render();

class SomeClass;

std::vector<SomeClass*> v;

class SomeClass : public PyObject
{
	public:

		float a;
		float b;

		virtual int init(PyObject *args, PyObject *kwds)
		{
			v.push_back(this);
			return 0;
		}

		static int Py_init(SomeClass *self, PyObject *args, PyObject *kwds)
		{
			return 0;
		}

		static PyObject *mmethod(PyObject *self, PyObject *args)
		{
			int i = 10;
			Py_RETURN_NONE;
		}
};

std::map<char*, Texture*> textures;

PyObject *loadTexture(PyObject *self, PyObject *args)
{
	char *name, *file;
	
	if ( !PyArg_ParseTuple(args, "ss", &name, &file) )
		return NULL;

	wchar_t u_file[MAX_PATH];
	mbstowcs(u_file, file, MAX_PATH);
	Texture *texture = Render->loadTextureFromFile(u_file);

	if (texture == NULL) return NULL;

	textures[name] = texture;

	Py_RETURN_NONE;
}

int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow)
{
	
	Py_Initialize();

	PythonModuleFactory pyStopiccotModule("stopiccot");

	pyStopiccotModule
		.addType<SomeClass>("SomeClass")
			.addConstructor((initproc)SomeClass::Py_init)
			.addMethod("mmethod", SomeClass::mmethod)
		.build()
	.build();

	PythonModuleFactory pyRenderModule("render");

	pyRenderModule
		.addFunction("loadTexture", loadTexture)
	.build();

	if (true)
	{
		Render = getDX9Render();
	}
	else
	{
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

		PyRun_SimpleString(
			"import render\n"
			"render.loadTexture(\"engine_256\", \"D:\\code\\stopiccot\\engine\\engine.png\")\n"
		);

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

	Py_Finalize();


	return 0;
}