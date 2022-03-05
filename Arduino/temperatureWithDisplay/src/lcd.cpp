#include "lcd.h"
#include <Arduino.h>
#include <LiquidCrystal.h>

const uint8_t rs = 10, rw = 9, enable = 8, d4 = 4, d5 = 3, d6 = 2, d7 = 1;

LiquidCrystal lcd(rs, rw, enable, d4, d5, d6, d7);

void lcd_printTemperatureCelsius(float temperatureKelvin){
	lcd.begin(16, 2);

	const uint8_t TemperatureDigits = 6; // 6: -123.4
	float temperatureCelsius = temperatureKelvin - 273.15;
	char temperatureString[TemperatureDigits+1];
	dtostrf(double(temperatureCelsius), TemperatureDigits, 1, temperatureString);

	char outputString[TemperatureDigits+4];
	const char Degree = 0xDF;
	sprintf(outputString, "%s %cC", temperatureString, Degree);
	lcd.print(outputString);
}
