#include <Arduino.h>

static inline float countsToVolt(int adcCounts);
static inline float voltToCurrent(float volt);

static float current;

void cellCurrentTick(void){
	int adcCounts = analogRead(A0);
	float volt = countsToVolt(adcCounts);
	current = voltToCurrent(volt);
}

static inline float countsToVolt(int adcCounts){
	return ((float)adcCounts) * 5.0f / 1024.0f;
}

static inline float voltToCurrent(float volt){
	const float Rsens = 1.0f/3.0f;
	return volt / Rsens;
}

float getCellCurrent(void){
	return current;
}
