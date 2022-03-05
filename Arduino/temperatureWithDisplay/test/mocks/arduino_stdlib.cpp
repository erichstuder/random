#include "arduino_stdlib.h"

char *dtostrf(double __val, signed char __width, unsigned char __prec, char *__s){
	sprintf(__s, ("%" + std::to_string(__width) + "." + std::to_string(__prec) + "f").c_str(), __val);
	return nullptr;
}
