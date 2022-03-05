#include "lcd.h"
#include <Arduino.h>
#include <LiquidCrystal.h>

const uint8_t rs = 10, rw = 9, enable = 8, d4 = 7, d5 = 6, d6 = 5, d7 = 4;

LiquidCrystal lcd(rs, rw, enable, d4, d5, d6, d7);

static void lcd_printTemperatureCelsius_Implementation(float temperatureKelvin){
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
void (*lcd_printTemperatureCelsius) (float temperatureKelvin) = lcd_printTemperatureCelsius_Implementation;
