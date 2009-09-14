#include "PythonBinding.h"

PythonModuleFactory::PythonModuleFactory(const char *name) : name(name)
{
	//...
}

PythonModuleFactory& PythonModuleFactory::addFunction(const char *name, PyCFunction function, const char *doc)
{
	PyMethodDef pyMethodDef = { name, function, METH_VARARGS, doc };
	methods.push_back(pyMethodDef);
	return *this;
}

void PythonModuleFactory::build()
{
	PyMethodDef *pyMethods = makeArray(methods); methods.clear();
	PyObject *module = Py_InitModule(name, pyMethods);
	
	for (std::list<PyTypeObject>::iterator type = types.begin(); type != types.end(); ++type)
	{
		PyTypeObject *pyTypeObject = &(*type);
		if (PyModule_AddObject(module, type->tp_name, (PyObject*)pyTypeObject ) < 0)
		{
			throw "Exception!";
		}
	}
	
	return;
}