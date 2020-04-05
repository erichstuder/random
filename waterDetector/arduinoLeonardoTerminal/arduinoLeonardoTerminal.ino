//board: Arduino Leonardo
#include <Arduino.h>
#include <stdio.h>
#include <string.h>

static const char Terminator = '\r';
static char inputBuffer[100];
static unsigned char inputBufferIndex = 0;

static inline void handleInput(void);
static inline void appendToInputBuffer(char ch);

void setup(void) {}

void loop(void) {
	//if(Serial){
		while(true){
			int incomingInt = Serial.read();
			char incomingChar = (char)incomingInt;
			if(incomingInt == -1){
				return;
			}
			else if(incomingChar == Terminator){
				appendToInputBuffer('\0');
				handleInput();
			}
			else{
				appendToInputBuffer(incomingChar);
			}
		}
	//}
}

static inline void handleInput(void) {
	if(strcmp(inputBuffer, "setLedOn") == 0){
		pinMode(LED_BUILTIN, OUTPUT);
		digitalWrite(LED_BUILTIN, HIGH);
	}
	else if(strcmp(inputBuffer, "setLedOff") == 0){
		pinMode(LED_BUILTIN, OUTPUT);
		digitalWrite(LED_BUILTIN, LOW);
	}
	else if(strcmp(inputBuffer, "getAdc_A0") == 0){
		char numberString[sizeof(int)+sizeof('\0')];
		sprintf(numberString, "%d", analogRead(A0)); //TODO: sprintf hat einen Rückgabewert!
		Serial.write(numberString);
		Serial.write(Terminator);
	}
	inputBufferIndex = 0;
}

static inline void appendToInputBuffer(char ch) {
	inputBuffer[inputBufferIndex] = ch;
	inputBufferIndex++;
}
