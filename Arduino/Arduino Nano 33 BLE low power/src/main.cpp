#include <Arduino.h>
#include <USB/PluggableUSBSerial.h>

// BT Module: u-blox NINA-B306-00B-00
// https://www.u-blox.com/en/product/nina-b30-series-open-cpu-0

// see:
// https://forum.arduino.cc/t/setting-up-the-arduino-ble-board-for-low-power-applications-compilation/669574

//use my own main function
int main(void){
	init();
	initVariant();

	//Disabling UART0 (saves around 300-500µA) - @Jul10199555 contribution
	/*NRF_UART0->TASKS_STOPTX = 1;
	NRF_UART0->TASKS_STOPRX = 1;
	NRF_UART0->ENABLE = 0;

	 *(volatile uint32_t *)0x40002FFC = 0;
	*(volatile uint32_t *)0x40002FFC;
	*(volatile uint32_t *)0x40002FFC = 1; //Setting up UART registers again due to a library issue*/

/*#if defined(SERIAL_CDC)
	PluggableUSBD().begin();
	_SerialUSB.begin(115200);
#endif*/

	setup();

	for (;;) {
		loop();
		//if (arduino::serialEventRun) arduino::serialEventRun();
	}

	return 0;
}

void setup(){
	digitalWrite(LED_PWR, LOW);

	//High oder Low? auf jeden Fall beide gleich.
	digitalWrite(PIN_ENABLE_SENSORS_3V3, HIGH);
	digitalWrite(PIN_ENABLE_I2C_PULLUP, HIGH);

	//Serial.begin(115200);
	//while(!Serial);
}

void loop(){
	//NRF_POWER->SYSTEMOFF = 1; //diese Zeile resultiert in weniger als 10uA !!!
	delay(60*1000);
}
