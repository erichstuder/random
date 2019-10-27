#include "dummy.h"
#include "driver.h"

unsigned char add(unsigned char a, unsigned char b){
	return driverAdd(a,b);
}