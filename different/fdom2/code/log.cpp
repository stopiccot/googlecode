#include "log.h"

ofstream &Log()
{
	static bool init = false;
	static ofstream _Log("directx.log");

	return _Log;
}