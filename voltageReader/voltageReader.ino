//Board: Arduino Leonardo
#include <Arduino.h>
#include "src/IT_Server/IT_Server/it.h"

#define APP_SAMPLETIME_US 1000000

static inline float getVoltage(void);

static ItSignal_t itSignals[] = {
	{
		"voltage",
		ItValueType_Float,
		(void (*)(void)) getVoltage,
		NULL,
	},
};

//For compatibility with Linux the led pin is defined here.
static const unsigned char OnBoardLedPin = 13;

static unsigned char outBuffer[1024];
static unsigned short outBufferIndex = 0;

static const unsigned char ItSignalCount = sizeof(itSignals) / sizeof(itSignals[0]);
static char itInputBuffer[30];

static float voltage = 0.0f;

static bool timerEvent;
static unsigned long tickMicros = 0;

static inline void setBuiltinLedOn(void);
static inline void setBuiltinLedOff(void);
static inline void timerSetup(void);
static inline bool byteFromUartAvailable(void);
static inline ItError_t readByteFromUart(char* const data);
static inline ItError_t writeByteToUart(const unsigned char data);
static inline void sendBufferToUart(void);

static unsigned long getTickMicros(void){
	return tickMicros;
}

void setup(void){
  ItCallbacks_t itCallbacks;
  itCallbacks.byteFromClientAvailable = byteFromUartAvailable;
  itCallbacks.readByteFromClient = readByteFromUart;
  itCallbacks.writeByteToClient = writeByteToUart;
  itCallbacks.getTimestamp = getTickMicros;
  ItParameters_t itParameters;
  itParameters.itInputBuffer = itInputBuffer;
  itParameters.itInputBufferSize = sizeof(itInputBuffer)/sizeof(itInputBuffer[0]);
  itParameters.itSignals = itSignals;
  itParameters.itSignalCount = ItSignalCount;
  itInit(&itParameters, &itCallbacks);
  
	timerSetup();
}

void setup_ForCppUTest(void){
//The testframework CppUTest uses a function named "setup()" to initialize tests.
//That conflicts with the setup function in here.
//To solve the problem this wrapper is used.
	setup();
}

void loop(void){
	if(!timerEvent){
		setBuiltinLedOff();
		return;
	}
	setBuiltinLedOn();
	timerEvent=false;
	voltage = (float)analogRead(A0) / 1024.0f * 5.0f;
	itTick();
	sendBufferToUart();
}

static inline void initBuiltinLed(void){
	pinMode(OnBoardLedPin, OUTPUT);
}

static inline void setBuiltinLedOn(void){
	initBuiltinLed();
	digitalWrite(OnBoardLedPin, HIGH);
}

static inline void setBuiltinLedOff(void){
	initBuiltinLed();
	digitalWrite(OnBoardLedPin, LOW);
}

static inline float getVoltage(void){
	return voltage;
}

static inline void timerSetup(void){
	timerEvent=false;
	TCCR1A = 0; //for any reason, this must be done!!
	#if APP_SAMPLETIME_US == 1000000
		TCCR1B = _BV(WGM12) | _BV(CS12) | _BV(CS10); //match on value of OCR1A and divide clock by 1024
		OCR1A = 15625; //1000ms
	#elif APP_SAMPLETIME_US == 500000
		TCCR1B = _BV(WGM12) | _BV(CS12); //match on value of OCR1A and divide clock by 256
		OCR1A = 5*6250; //500ms
	#elif APP_SAMPLETIME_US == 100000
		TCCR1B = _BV(WGM12) | _BV(CS12); //match on value of OCR1A and divide clock by 256
		OCR1A = 6250; //100ms
	#elif APP_SAMPLETIME_US == 10000
		TCCR1B = _BV(WGM12) | _BV(CS12); //match on value of OCR1A and divide clock by 256
		OCR1A = 625; //10ms
	#elif APP_SAMPLETIME_US == 2000
		TCCR1B = _BV(WGM12) | _BV(CS10); //match on value of OCR1A and divide clock by 1
		OCR1A = 32000; //2ms
	#elif APP_SAMPLETIME_US == 1000
		TCCR1B = _BV(WGM12) | _BV(CS10); //match on value of OCR1A and divide clock by 1
		OCR1A = 16000; //1ms
	#else
		#error APP_SAMPLETIME not supported
	#endif
	TIMSK1 = _BV(OCIE1A); //enable interrupt
}

ISR(TIMER1_COMPA_vect){
	tickMicros += APP_SAMPLETIME_US;
	timerEvent = true;
}

static inline bool byteFromUartAvailable(void){
	return Serial.available() > 0;
}

static inline ItError_t readByteFromUart(char* const data){
	int incomingByte = Serial.read();
	if(incomingByte == -1){
		return ItError_NoDataAvailable;
	}else{
		*data = (char)incomingByte;
	}
	return ItError_NoError;
}

static inline ItError_t writeByteToUart(const unsigned char data){
	if(outBufferIndex >= sizeof(outBuffer)){
		sendBufferToUart();
		if(outBufferIndex >= sizeof(outBuffer)){
			return ItError_ClientWriteError;
		}
	}

	outBuffer[outBufferIndex++] = data;
	return ItError_NoError;
}

static inline void sendBufferToUart(void){
	outBufferIndex -= Serial.write(outBuffer, outBufferIndex);
}
