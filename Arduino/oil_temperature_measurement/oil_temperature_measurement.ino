//made for Arduino Uno
#include "sensor.h"
#include "display.h"

static uint8_t GoHomePin = 12;

void setup(){
	Serial.begin(9600);
	display::init();
	pinMode(GoHomePin, INPUT_PULLUP);
}

void loop(){
	float temperatureCelsius = sensor::getTemperature_Celsius();

	if(digitalRead(GoHomePin)){
		display::setTemperatureDegree(temperatureCelsius);
		Serial.println("System On");
	}
	else{
		display::goHome();
		Serial.println("System Off");
	}
	Serial.print("Temperatur: ");
	Serial.println(temperatureCelsius);
	Serial.println("");
	delay(1000);
}
