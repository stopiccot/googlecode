#ifndef PYTHON_BINDING_H
#define PYTHON_BINDING_H

// To compile define environmental variable PYTHON containig path to Python
// installation. In "$(PYTHON)\libs" create two folders "x86", "x64" and place 
// there corresponding lib-files. To compile in debug mode modify pyconfig.h 
// header not to define Py_DEBUG and always link to "python26.lib".
// Simple renaming "python26.lib" to "python26_d.lib" is not working.
#include <Python.h>
#include "structmember.h"
#include <list>
//#include "log.h"

struct PythonClass
{
	PyObject_HEAD
};

class PythonModuleFactory;

#define addTypeMethod(method, name) addMethod((PyCFunction)method, name, name)
#define addTypeConstructor(constructor) addConstructor((initproc)constructor, "")

class PythonTypeFactory
{
		friend class PythonModuleFactory;

		const char *name;
		PyTypeObject pyTypeObject;
		PythonModuleFactory &parentModule;
		std::list<PyMemberDef> members;
		std::list<PyMethodDef> methods;

		PythonTypeFactory(PythonModuleFactory &parentModule, const char *name, int size, const char *doc);

	public:

		PythonTypeFactory& addConstructor(initproc constructor, const char *doc = "");
		PythonTypeFactory& addMethod(PyCFunction method, const char *methodName, const char *doc = "");
		PythonTypeFactory& addMember(char *memberName, int type, int offset, char *doc = "");
		PythonTypeFactory& addFloat(char *name, int offset, char *doc = "");
		PythonModuleFactory& build();
};

#define addModuleMethod(method) addMethod((PyCFunction)method, (#method))
#define addModuleType(type) addType((#type), sizeof(type), (#type))

class PythonModuleFactory
{
		const char *moduleName;
		std::list<PyMethodDef> methods;
		std::list<PythonTypeFactory> types;

	public:

		PythonModuleFactory(const char *moduleName);
		PythonModuleFactory& addMethod(PyCFunction method, const char *methodName, const char *doc = "");
		PythonTypeFactory& addType(const char *typeName, int size, const char *doc = "");
		void build();
};

#endif 