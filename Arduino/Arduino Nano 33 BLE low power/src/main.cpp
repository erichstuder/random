#include <Arduino.h>
#include "lowPower_0.h"
//#include <USB/PluggableUSBSerial.h>

// see:
/* nRF52840
- https://www.nordicsemi.com/Products/nRF52840
- https://infocenter.nordicsemi.com/index.jsp?topic=%2Fstruct_nrf52%2Fstruct%2Fnrf52840.html
- https://infocenter.nordicsemi.com/index.jsp?topic=%2Fps_nrf52840%2Fkeyfeatures_html5.html
- https://infocenter.nordicsemi.com/pdf/nRF52840_PS_v1.7.pdf
  - Stromverbrauch während SLEEP: 5.2.1.1
  - Power Steuerung (SLEEP, ...) : 5.3
    - Registers: 5.3.7
*/

// BT Module: u-blox NINA-B306-00B-00
// https://www.u-blox.com/en/product/nina-b30-series-open-cpu-0

// see:
// https://forum.arduino.cc/t/setting-up-the-arduino-ble-board-for-low-power-applications-compilation/669574


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



/*
void setup(){
	digitalWrite(LED_PWR, LOW);

	//High oder Low? auf jeden Fall beide gleich.
	digitalWrite(PIN_ENABLE_SENSORS_3V3, HIGH);
	digitalWrite(PIN_ENABLE_I2C_PULLUP, HIGH);

	//Serial.begin(115200);
	//while(!Serial);
}*/
/*
void loop(){
	NRF_POWER->SYSTEMOFF = 1; //diese Zeile resultiert in weniger als 10uA !!!
	//delay(60*1000);
}*/

void setup(){
	lowPower::setup();
}

void loop(){
	lowPower::loop();
}
