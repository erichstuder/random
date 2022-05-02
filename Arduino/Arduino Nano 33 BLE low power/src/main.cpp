#include <Arduino.h>
#include <pinDefinitions.h>

// BT Module: u-blox NINA-B306-00B-00
// https://www.u-blox.com/en/product/nina-b30-series-open-cpu-0

// see:
// https://forum.arduino.cc/t/setting-up-the-arduino-ble-board-for-low-power-applications-compilation/669574

void setup(){
	digitalWrite(LED_PWR, LOW);
	//digitalWrite(PIN_ENABLE_SENSORS_3V3, LOW); //erhöht bei mir den Strom um ca. 1mA
	//digitalWrite(PIN_ENABLE_I2C_PULLUP, LOW); //hat bei mir praktisch keine Wirkung

	//Serial.begin(115200);
	//while(!Serial);
}

void loop(){
	delay(20*1000);
}
