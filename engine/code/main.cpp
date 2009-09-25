#include "PythonBinding.h"
#include "AbstractRender.h"

__declspec(dllimport) AbstractRender *getDX9Render();
typedef AbstractRender *GetDX10Render();

#include "Sprite.h"

PyObject *loadTexture(PyObject *self, PyObject *args)
{
	char *name, *file;
	
	if ( !PyArg_ParseTuple(args, "ss", &name, &file) )
		return NULL;

	wchar_t u_file[MAX_PATH];
	mbstowcs(u_file, file, MAX_PATH);
	Texture *texture = Render->loadTextureFromFile(u_file);

	if (texture == NULL) return NULL;

	textures[std::string(name)] = texture;

	Py_RETURN_NONE;
}

std::vector<std::string> console_out;

class Console : public PyObject
{
	public:
		static PyObject *pyWrite(PyObject *self, PyObject *args, PyObject *kwds)
		{
			char *text;
			PyArg_ParseTuple(args, "s", &text);
			console_out.push_back(std::string(text));
			Py_RETURN_NONE;
		}
};

int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow)
{
	Py_Initialize();

	PythonModuleFactory pyStopiccotModule("stopiccot");

	pyStopiccotModule
		.addModuleType(Console)
			.addMethod("write", (PyCFunction)Console::pyWrite)
		.build()
		.addModuleType(Sprite)
			.addConstructor((initproc)Sprite::pyInit)
			.addMethod("method", (PyCFunction)Sprite::pyMethod)
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

	Render->init(800, 600, false);

	if (Render)
	{
		effects["fx"] = Render->loadEffectFromFile(L"dx9.fx");
		Sprite::initVertexBuffer();

		PyRun_SimpleString(
			"import sys, stopiccot\n"
			"sys.stdout = stopiccot.Console()\n"
		);

		FILE *pyFile = fopen("python.py", "rb");
		char pyCode[10240];
		int readed = fread(pyCode, 1, sizeof(pyCode), pyFile);
		int k = 0;
		for (int i = 0; i < readed; ++i)
			if (pyCode[i] != 13)
				pyCode[k++] = pyCode[i];
		pyCode[k] = 0;

		fclose(pyFile);

		PyRun_SimpleString(pyCode);

		//float4x4 E;

		//Effect *effect  = Render->loadEffectFromFile(L"dx9.fx");
		//effect->setTexture("texture0", textures["engine_256"]);
		//effect->setMatrix("projection", (float*)&E);
		//effect->setMatrix("world", (float*)&E);


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
					//effect->render(Sprite::buffer);
					Sprite::renderAll();
					Render->endRender();
				}
			}
	}

	Py_Finalize();

	return 0;
}