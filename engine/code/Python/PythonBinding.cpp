#include "PythonBinding.h"

template <typename T> T* makeArray(std::list<T> &list)
{
	int size = (int)list.size() + 1;
	T *result = new T[size]; memset(result, 0, sizeof(T) * size);

	int i = 0;
	for (std::list<T>::iterator it = list.begin(); it != list.end(); ++it)
		result[i++] = *it;

	return result;
}

PythonTypeFactory::PythonTypeFactory(PythonModuleFactory &parentModule, const char *name, int size, const char *doc) : 
	parentModule(parentModule), name(name)
{
	PyTypeObject _pyTypeObject = {
		PyObject_HEAD_INIT(NULL)
		0,    // ob_size - obsolete 2.x feature 
		name, // tp_name
		size, // tp_basicsize
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE, // tp_flags
		doc,  // tp_doc
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	};

	pyTypeObject = _pyTypeObject;
}

PythonTypeFactory& PythonTypeFactory::addConstructor(initproc constructor, const char *doc)
{
	pyTypeObject.tp_init = constructor;
	return *this;
}

PythonTypeFactory& PythonTypeFactory::addMethod(PyCFunction method, const char *methodName, const char *doc)
{
	PyMethodDef pyMethodDef = { methodName, method, METH_VARARGS, doc };
	methods.push_back(pyMethodDef);
	return *this;
}

PythonTypeFactory& PythonTypeFactory::addMember(char *memberName, int type, int offset, char *doc)
{
	PyMemberDef pyMemberDef = { memberName, type, offset, 0, doc };
	members.push_back(pyMemberDef);
	return *this;
}

PythonTypeFactory& PythonTypeFactory::addFloat(char *name, int offset, char *doc)
{
	return addMember(name, T_FLOAT, offset, doc);
}

PythonModuleFactory& PythonTypeFactory::build()
{
	pyTypeObject.tp_members = makeArray(members); members.clear();
	pyTypeObject.tp_methods = makeArray(methods); methods.clear();

	if (pyTypeObject.tp_new == 0)
		pyTypeObject.tp_new = PyType_GenericNew;

	if (PyType_Ready(&pyTypeObject) < 0)
	{
	//	log() << "PyType_Ready() for type \"" << name << "\" failed\n";
	}

	return parentModule;
}

//=======================================================================================
std::list<PythonModuleFactory> pythonModules;

PythonModuleFactory::PythonModuleFactory(const char *moduleName) : moduleName(moduleName)
{
	//...
}

PythonModuleFactory& PythonModuleFactory::addMethod(PyCFunction method, const char *methodName, const char *doc)
{
	PyMethodDef pyMethodDef = { methodName, method, METH_VARARGS, doc };
	methods.push_back(pyMethodDef);
	return *this;
}

PythonTypeFactory& PythonModuleFactory::addType(const char *typeName, int size, const char *doc)
{
	types.push_back(PythonTypeFactory(*this, typeName, size, doc));
	return types.back();
}

void PythonModuleFactory::build()
{
	PyMethodDef *pyMethods = makeArray(methods); methods.clear();
	PyObject *module = Py_InitModule(moduleName, pyMethods);
	
	for (std::list<PythonTypeFactory>::iterator type = types.begin(); type != types.end(); ++type)
		if (PyModule_AddObject(module, type->name, (PyObject*)&type->pyTypeObject) < 0)
		{
		//	log() << "PyModule_AddObject() failed\n";
		}
	
	return;
}