#include <Arduino.h>

#include "itHandler.h"
#include "currentController.h"
#include "cellCurrent.h"

static inline unsigned long getMicros(void);

static ItSignal_t itSignals[] = {
	{
		"current",
		ItValueType_Float,
		(void (*)(void)) getCellCurrent,
		NULL
	},
	{
		"pwm",
		ItValueType_Float,
		(void (*)(void)) getControllerValue,
		NULL
	},
	{
		"i",
		ItValueType_Float,
		NULL,
		(void (*)(void)) setCurrentController_gainI,
	},
};

static const unsigned char ItSignalCount = sizeof(itSignals) / sizeof(itSignals[0]);

static unsigned long currentMicros;
static unsigned long lastMicros;
static const unsigned long SamplingTimeMicros = 0.01e6;

static const uint8_t PwmPin = 10;

void setup(void){
	itHandlerInit(getMicros, itSignals, ItSignalCount);
	lastMicros = micros();

	pinMode(PwmPin, OUTPUT);

	//TODO: remove
	setCurrentController_gainI(0.02);
	setCellCurrent(0.2);
}

void loop(void){
	currentMicros = micros();
	if(currentMicros - lastMicros < SamplingTimeMicros){
		return;
	}
	lastMicros = currentMicros;
	currentControllerTick();
	itHandlerTick();
}

static unsigned long getMicros(void){
	return currentMicros;
}
