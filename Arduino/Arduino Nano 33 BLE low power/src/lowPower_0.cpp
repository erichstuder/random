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

		// Supply measurements: 
		// - with USB-Cable connected: 8uA @ 3.3V
		// - without USB-Cable:        0.4uA @ 3.3V (According to Product Specification 5.2.1.1 this is the lowest possible.)
		NRF_POWER->SYSTEMOFF = 1;

		// Findings:
		// - The wake-up pin triggers a start-up including the boot-loader.
		// - According to Product Specivication v1.7 chapter 5.3.3 "The system is reset when it wakes up from System OFF mode."
	}
}
