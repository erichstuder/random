//board: Arduino Leonardo
#include <Arduino.h>

#define LED_BUILTIN 13

static bool ledIsOn;
static uint8_t filter;
static bool filterFulfilled;

static inline void handleInput(void);
static inline void setLedOn(void);
static inline void setLedOff(void);
static inline void initLed(void);


void setup(void) {
	 ledIsOn = false;
	 filter = 0;
	 filterFulfilled = false;
}

void loop(void) {
	if(analogRead(A0) > 500){
		if(filter < 20){
			filter++;
		}
		else{
			filterFulfilled = true;
		}
	}
	else{
		filter = 0;
		filterFulfilled = false;
	}

	if(filterFulfilled){
		if(ledIsOn){
			setLedOff();
			ledIsOn = false;
		}
		else{
			setLedOn();
			ledIsOn = true;
		}
	}
	else{
		setLedOff();
		ledIsOn = false;
	}
	delay(250);
}

static inline void setLedOn(void) {
	initLed();
	digitalWrite(0, LOW);
	digitalWrite(1, HIGH);
	digitalWrite(2, LOW);
	digitalWrite(3, HIGH);
	digitalWrite(5, LOW);
	digitalWrite(7, HIGH);
	digitalWrite(9, LOW);
	digitalWrite(11, HIGH);
}

static inline void setLedOff(void) {
	initLed();
	digitalWrite(0, LOW);
	digitalWrite(1, LOW);
	digitalWrite(2, LOW);
	digitalWrite(3, LOW);
	digitalWrite(5, LOW);
	digitalWrite(7, LOW);
	digitalWrite(9, LOW);
	digitalWrite(11, LOW);
}

static inline void initLed(void) {
	pinMode(0, OUTPUT);
	pinMode(1, OUTPUT);
	pinMode(2, OUTPUT);
	pinMode(3, OUTPUT);
	pinMode(5, OUTPUT);
	pinMode(7, OUTPUT);
	pinMode(9, OUTPUT);
	pinMode(11, OUTPUT);
}
