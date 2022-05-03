#include "lowPower_common.h"
#include <Arduino.h>

namespace lowPower{
	void turnOffPowerLed(){
		digitalWrite(LED_PWR, LOW);
	}

	void disableSensors(){
		digitalWrite(PIN_ENABLE_SENSORS_3V3, LOW);
		digitalWrite(PIN_ENABLE_I2C_PULLUP, LOW);

		//Some people set pins to HIGH. I don't understand why. Also it uses more current.
		//digitalWrite(PIN_ENABLE_SENSORS_3V3, HIGH);
		//digitalWrite(PIN_ENABLE_I2C_PULLUP, HIGH);
	}
}
