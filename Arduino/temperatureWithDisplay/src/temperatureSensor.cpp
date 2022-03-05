#include "temperatureSensor.h"
#include <Adafruit_MCP9808.h>

Adafruit_MCP9808 tempsensor = Adafruit_MCP9808();

float getTemperatureKelvin(void){
	while(!tempsensor.begin());
	tempsensor.setResolution(3);
	tempsensor.wake();
	return tempsensor.readTempC() + 273.15;
}
