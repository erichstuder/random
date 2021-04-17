#include <Arduino.h>

#include "cellCurrent.h"

static float iPart = 100.0f;
static float iGain = 0.0f;
static float setCurrent = 0.0f;

void setCellCurrent(float value){
	setCurrent = value;
}

void currentControllerTick(void){
	cellCurrentTick();
	float cellCurrent = getCellCurrent();
	float err = setCurrent - cellCurrent;
	iPart += iGain * err;

	iPart = min(iPart, 255);
	iPart = max(iPart, 0); 

	const uint8_t PwmPin = 11;
	analogWrite(PwmPin, iPart);
}

void setCurrentController_gainI(float value){
	iGain = value;
}

float getControllerValue(void){
	return iPart;
}
