#include "lowPower_0.h"
#include "lowPower_common.h"
#include <Arduino.h>
#include "pinDefinitions.h"

namespace lowPower{
	void setup(){
		// HW-Setup:
		// - cut 3.3V Jumper
		// - supply with 3.3V at the according pin
		// - remove usb cable for supply measurements
		
		lowPower::turnOffPowerLed();
		lowPower::disableSensors();

		//configure the wake-up pin (low triggers wake-up)
		//D8 is connected to P0.21
		pinMode(D8, INPUT_PULLUP);
		NRF_P0->PIN_CNF[21] |= GPIO_PIN_CNF_SENSE_Low << GPIO_PIN_CNF_SENSE_Pos;
	}

	void loop(){
		digitalWrite(LED_PWR, LOW);
		delay(1000);
		digitalWrite(LED_PWR, HIGH);
		delay(2000);
		digitalWrite(LED_PWR, LOW);

		// Supply measurement: 8uA @3.3V
		// This could be the lowest current achievable with the Arduino Nano 33 BLE
		NRF_POWER->SYSTEMOFF = 1;

		// Findings:
		// - The wake-up pin triggers a startu-up including the boot-loader.
	}
}