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

//========================================================================
// unroll std::list to array
//========================================================================
template <typename T> T* makeArray(std::list<T> &list)
{
	int size = (int)list.size() + 1;
	T *result = new T[size]; memset(result, 0, sizeof(T) * size);

	int i = 0;
	for (std::list<T>::iterator it = list.begin(); it != list.end(); ++it)
		result[i++] = *it;

	return result;
}

//========================================================================
// class: PythonTypeFactory
//========================================================================
class PythonModuleFactory;

template <typename T> class PythonTypeFactory
{
		std::list<PyMemberDef> members;
		std::list<PyMethodDef> methods;
		PythonModuleFactory &module;
		PyTypeObject pyTypeObject;

		// One instance of T used for copying vfptr data from it;
		static T cppObject;

		// User-defined constructor
		static initproc constructor;

		//========================================================================
		// Built in constructor for T. Because memory is allocated by Python
		// runtime it does not initialize vfptr table. So we must do it.
		//========================================================================
		static int init(T *self, PyObject *args, PyObject *kwds)
		{
			// Store python data
			Py_ssize_t ob_refcnt = self->ob_refcnt;
			_typeobject *ob_type = self->ob_type;

			// Copy data from C++ created instance of T to initialize vfptr table
			memcpy(self, &cppObject, sizeof(T));

			// Restore python data as it was overwritten by memcpy
			self->ob_refcnt = ob_refcnt;
			self->ob_type   = ob_type;

			// After this call user defined constructor
			return (constructor != NULL) ? constructor((PyObject*)self, args, kwds) : 0;
		}

	public:

		//========================================================================
		// Starts building new python type
		//========================================================================
		PythonTypeFactory<T>(PythonModuleFactory &module, const char *name) : module(module)
		{
			PyTypeObject _pyTypeObject = {
				PyObject_HEAD_INIT(NULL)
				0,              // ob_size - obsolete 2.x feature 
				name,           // tp_name
				sizeof(T),      // tp_basicsize
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE, // tp_flags
				name,           // tp_doc
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			};

			pyTypeObject = _pyTypeObject;
		}

		//========================================================================
		// Sets base class by searching throung already created types in this class
		//========================================================================
		PythonTypeFactory<T> &setParentClass(const char *name = "")
		{
			for (std::list<PyTypeObject>::iterator it = module.types.begin(); it != module.types.end(); ++it)
				if (strcmp(name, it->tp_name) == 0)
				{
					pyTypeObject.tp_base = &(*it);
					break;
				}

			return *this;
		}

		PythonTypeFactory<T> &addConstructor(initproc constructor)
		{
			PythonTypeFactory<T>::constructor = constructor;
			return *this;
		}

		PythonTypeFactory<T> &addMethod(const char *name, PyCFunction method, const char *doc = "")
		{
			PyMethodDef pyMethodDef = { name, method, METH_VARARGS, doc };
			methods.push_back(pyMethodDef);
			return *this;
		}

		PythonTypeFactory<T> &addMember(const char *name, int type, int offset, char *doc = "")
		{
			PyMemberDef pyMemberDef = { const_cast<char*>(name), type, offset, 0, doc };
			members.push_back(pyMemberDef);
			return *this;
		}

		PythonTypeFactory<T> &addFloat(const char *name, int offset, char *doc = "")
		{
			return this->addMember(name, T_FLOAT, offset, doc);
		}

		PythonModuleFactory& build()
		{
			pyTypeObject.tp_init = (initproc)PythonTypeFactory<T>::init;
			
			if (members.size() > 0)
				pyTypeObject.tp_members = makeArray(members),
				members.clear();

			if (methods.size() > 0)
				pyTypeObject.tp_methods = makeArray(methods),
				methods.clear();

			if (pyTypeObject.tp_new == 0)
				pyTypeObject.tp_new = PyType_GenericNew;

			module.types.push_back(pyTypeObject);
			if (PyType_Ready(&module.types.back()) < 0) {
				// error
			}

			// Store pointer to module before deleting factory
			PythonModuleFactory *module = &this->module;
			delete this;
			
			return *module;
		}
};

template <typename T> T PythonTypeFactory<T>::cppObject;
template <typename T> initproc PythonTypeFactory<T>::constructor;

#define addModuleType(X) addType<X>(#X)

class PythonModuleFactory
{
		template <typename T> friend class PythonTypeFactory;

		const char *name;
		std::list<PyMethodDef> methods;
		std::list<PyTypeObject> types;

	public:

		PythonModuleFactory(const char *name);
		
		PythonModuleFactory &addFunction(const char *name, PyCFunction function, const char *doc = "");

		template <typename T> PythonTypeFactory<T> &addType(const char *name)
		{
			// Because of templated we can't store all TypeFactories in std::vector
			// so we create it on heap. Now we must to do all memory managment.
			return *(new PythonTypeFactory<T>(*this, name));
		}

		void build();
};
#endif 