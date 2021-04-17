#include <Arduino.h>

#include "itHandler.h"
#include "cellCurrent.h"

static inline unsigned long getMicros(void);

static ItSignal_t itSignals[] = {
	{
		"current",
		ItValueType_Float,
		(void (*)(void)) getCellCurrent,
		NULL
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
}

void loop(void){
	currentMicros = micros();
	if(currentMicros - lastMicros < SamplingTimeMicros){
		return;
	}
	lastMicros = currentMicros;
	cellCurrentTick();
	analogWrite(PwmPin, 204);
	itHandlerTick();
}

static unsigned long getMicros(void){
	return currentMicros;
}
