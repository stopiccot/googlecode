#include "log.h"

std::ofstream &log()
{
	static std::ofstream _log("engine.log");
	return _log;
}