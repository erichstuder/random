#include <Arduino.h>
#include "lcd.h"
#include "temperatureSensor.h"

void setup(void){}

void loop(void){
	lcd_printTemperatureCelsius(getTemperatureKelvin());
}
