#include "lowPower_1.h"
#include "lowPower_common.h"
#include <Arduino.h>
#include "pinDefinitions.h"

//use my own main function
int main(void){
	init();
	initVariant();

	// #if defined(SERIAL_CDC)
	// 	PluggableUSBD().begin();
	// 	_SerialUSB.begin(115200);
	// #endif

	setup();

	for (;;) {
		loop();
		//if (arduino::serialEventRun) arduino::serialEventRun();
	}

	return 0;
}

namespace lowPower_1{
	void setup(){
		// HW-Setup:
		// - cut 3.3V Jumper
		// - supply with 3.3V at the according pin
		// - remove usb cable for supply measurements
		
		lowPower::turnOffPowerLed();
		lowPower::disableSensors();

		//Disable Peripherals:

		//NRF_AAR->TASKS_STOP = 1; //no influence on current
		//NRF_ACL //cannot be disabled
		//NRF_CCM->TASKS_STOP = 1; //no influence on current
		//NRF_COMP->TASKS_STOP = 1; //no influence on current
		//NRF_CRYPTOCELL->ENABLE &= ~CRYPTOCELL_ENABLE_ENABLE_Msk; //no influence on current
		//NRF_ECB->TASKS_STOPECB = 1; //no influence on current
		//NRF_EGU0 //cannot be disabled
		//NRF_GPIO //cannot be disabled
		//NRF_GPIOTE //cannot be disabled
		//NRF_I2S->TASKS_STOP = 1; //no influence on current
		//NRF_LPCOMP->TASKS_STOP = 1; //no influence on current
		//NRF_MWU //cannot be disabled
		//NRF_QDEC->TASKS_STOP = 1; //no influence on current
		//NRF_QSPI->TASKS_DEACTIVATE = 1; //no influence on current
		//NRF_RADIO->TASKS_STOP = 1; NRF_RADIO->TASKS_DISABLE = 1; //no influence on current
		//NRF_RNG->TASKS_STOP = 1; //no influence on current
		//NRF_RTC0->TASKS_STOP = 1; //no influence on current
		NRF_RTC1->TASKS_STOP = 1; // -151uA when disabled
		//NRF_RTC2->TASKS_STOP = 1; //no influence on current
		//NRF_SAADC->TASKS_STOP = 1; //no influence on current
		//NRF_SPI0->ENABLE &= ~SPI_ENABLE_ENABLE_Msk; //no influence on current
		//NRF_SPI1->ENABLE &= ~SPI_ENABLE_ENABLE_Msk; //no influence on current
		//NRF_SPI2->ENABLE &= ~SPI_ENABLE_ENABLE_Msk; //no influence on current
		//NRF_SPIM0->TASKS_STOP = 1; //no influence on current
		//NRF_SPIM1->TASKS_STOP = 1; //no influence on current
		//NRF_SPIM2->TASKS_STOP = 1; //no influence on current
		//NRF_SPIM3->TASKS_STOP = 1; //no influence on current
		//NRF_SPIS0->ENABLE &= ~SPIS_ENABLE_ENABLE_Msk; //no influence on current
		//NRF_SPIS1->ENABLE &= ~SPIS_ENABLE_ENABLE_Msk; //no influence on current
		//NRF_SPIS2->ENABLE &= ~SPIS_ENABLE_ENABLE_Msk; //no influence on current
		//NRF_TEMP->TASKS_STOP = 1; //no influence on current
		//NRF_TWI0->TASKS_STOP = 1; //no influence on current
		//NRF_TWI1->TASKS_STOP = 1; //no influence on current

		//TASKS_SHUTDOWN is deprecated but necessary. see: https://devzone.nordicsemi.com/f/nordic-q-a/14018/timer-shutdown-deprecated
		//NRF_TIMER0->TASKS_SHUTDOWN = 1; //no influence on current
		NRF_TIMER1->TASKS_SHUTDOWN = 1; //-287uA wenn ausgeschalten
		//NRF_TIMER2->TASKS_SHUTDOWN = 1; //no influence on current
		//NRF_TIMER3->TASKS_SHUTDOWN = 1; //no influence on current
		//NRF_TIMER4->TASKS_SHUTDOWN = 1; //no influence on current

		//NRF_TWIM0->TASKS_STOP = 1; //no influence on current
		//NRF_TWIM1->TASKS_STOP = 1; //no influence on current
		//NRF_TWIS0->TASKS_STOP = 1; //no influence on current
		//NRF_TWIS1->TASKS_STOP = 1; //no influence on current
		//NRF_UART0->TASKS_STOPRX = 1; NRF_UART0->TASKS_STOPTX = 1; //no influence on current
		//NRF_UARTE0->TASKS_STOPRX = 1; NRF_UARTE0->TASKS_STOPTX = 1; //no influence on current
		//NRF_UARTE1->TASKS_STOPRX = 1; NRF_UARTE1->TASKS_STOPTX = 1; //no influence on current
		//NRF_USBD //cannot be disabled
		//NRF_WDT //cannot be disabled be design

		//configure the wake-up pin (low triggers wake-up)
		//D8 is connected to P0.21
		pinMode(D8, INPUT_PULLUP);
		NRF_P0->PIN_CNF[21] |= GPIO_PIN_CNF_SENSE_Low << GPIO_PIN_CNF_SENSE_Pos;

		//light led a bit longer after a reset
		digitalWrite(LED_PWR, HIGH);
		volatile uint32_t dummy = 0;
		while(dummy<5000000){
			dummy++;
		}
	}

	void loop(){
		volatile uint32_t dummy;
		for(int n=0; n<5; n++){
			digitalWrite(LED_PWR, HIGH);
			dummy = 0;
			while(dummy<2000000){
				dummy++;
			}
			digitalWrite(LED_PWR, LOW);
			dummy = 0;
			while(dummy<2000000){
				dummy++;
			}
		}
		
		// Supply measurements: 
		// - with USB-Cable connected: 11.1uA @ 3.3V
		// - without USB-Cable:        3uA @ 3.3V (According to Product Specification 5.2.1.1 table line two,
		//                                         this is probably the lowest possible with system on and RAM retention.)
		__WFI();
	}
}
