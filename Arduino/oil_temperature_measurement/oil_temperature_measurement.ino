//made for Arduino Uno
#include "sensor.h"
#include "display.h"

void setup(){
	//TODO: Serial allenfalls so ändern, dass es zwar immer läuft aber nicht notwendig ist.
	Serial.begin(9600);
}

void loop(){
	float temperatureCelsius = sensor::getTemperature_Celsius();
	display::setTemperatureDegree(temperatureCelsius);
	Serial.println(temperatureCelsius);
	delay(1000);
}
