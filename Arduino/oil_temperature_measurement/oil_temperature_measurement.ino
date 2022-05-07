//made for Arduino Uno
#include "sensor.h"
#include "display.h"

void setup(){
	Serial.begin(9600);
	display::init();
}

void loop(){
	float temperatureCelsius = sensor::getTemperature_Celsius();
	display::setTemperatureDegree(temperatureCelsius);
	Serial.print("Temperatur: ");
	Serial.println(temperatureCelsius);
	Serial.println("");
	delay(1000);
}
