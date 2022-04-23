#include "sensor.h"

void setup(){
	Serial.begin(9600);
	//while(!Serial);
}

void loop(){
	float temperatureCelsius = sensor::getTemperature_Celsius();
	Serial.println(temperatureCelsius);
	delay(1000);
}
