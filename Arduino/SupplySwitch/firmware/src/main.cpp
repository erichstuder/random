#include <Arduino.h>

const uint8_t SwitchPin_1 = 11;
const uint8_t SwitchPin_2 = 12;
const uint8_t InterruptPin = 7;

const uint8_t Relay_On = LOW;
const uint8_t Relay_Off = HIGH;

void turnRelaysOff();

void setup(){
  pinMode(SwitchPin_1, OUTPUT);
  pinMode(SwitchPin_2, OUTPUT);

  pinMode(InterruptPin, INPUT);
  delay(1000);
  attachInterrupt(digitalPinToInterrupt(InterruptPin), turnRelaysOff, RISING);

  digitalWrite(SwitchPin_1, Relay_On);
  digitalWrite(SwitchPin_2, Relay_On);
}

void loop(){
	if(digitalRead(InterruptPin) == HIGH){
		turnRelaysOff();
	}
}

void turnRelaysOff(){
  digitalWrite(SwitchPin_1, Relay_Off);
  digitalWrite(SwitchPin_2, Relay_Off);
}
