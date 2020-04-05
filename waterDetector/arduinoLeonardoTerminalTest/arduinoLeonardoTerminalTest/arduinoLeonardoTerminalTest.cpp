#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"
#include "CppUTestExt/MockSupport_c.h"
#include "Arduino.h"

HardwareSerial Serial;

extern void loop(void);

static void expectInputString(const char* str);
static void expectNoInputLeft(void);

static void expectLedOn(void);
static void expectLedOff(void);
static void expectReadAndSendAdcA0(void);

void pinMode(uint8_t pin, uint8_t value) {
	mock_c()->actualCall("pinMode")
		->withIntParameters("pin", pin)
		->withIntParameters("value", value);
}

void digitalWrite(uint8_t pin, uint8_t value) {
	mock_c()->actualCall("digitalWrite")
		->withIntParameters("pin", pin)
		->withIntParameters("value", value);
}

int analogRead(uint8_t pin) {
	mock_c()->actualCall("analogRead")
		->withIntParameters("pin", pin);
	return mock_c()->returnValue().value.intValue;
}

TEST_GROUP(ArduinoLeonardoTerminalTest) {
	void setup() {
		mock().strictOrder();
	}

	void teardown() {
		mock().checkExpectations();
		mock().clear();
	}
};

TEST(ArduinoLeonardoTerminalTest, turnLedOn) {
	expectInputString("setLedOn");
	expectLedOn();
	expectNoInputLeft();

	loop();
}

TEST(ArduinoLeonardoTerminalTest, turnLedOff) {
	expectInputString("setLedOff");
	expectLedOff();
	expectNoInputLeft();

	loop();
}

TEST(ArduinoLeonardoTerminalTest, getAdcA0) {
	expectInputString("getAdc_A0");
	expectReadAndSendAdcA0();
	expectNoInputLeft();

	loop();
}

static void expectInputString(const char* str) {
	for (int i = 0; i < strlen(str) + 1; i++) {
		mock().expectOneCall("read")
			.andReturnValue(str[i]);
	}
	mock().expectOneCall("read")
		.andReturnValue('\r');
}

static void expectNoInputLeft(void) {
	mock().expectOneCall("read")
		.andReturnValue(-1);
}

static void expectLedOn(void) {
	mock().expectOneCall("pinMode")
		.withIntParameter("pin", LED_BUILTIN)
		.withIntParameter("value", 1);
	mock().expectOneCall("digitalWrite")
		.withIntParameter("pin", LED_BUILTIN)
		.withIntParameter("value", 1);
}

static void expectLedOff(void) {
	mock().expectOneCall("pinMode")
		.withIntParameter("pin", LED_BUILTIN)
		.withIntParameter("value", 1);
	mock().expectOneCall("digitalWrite")
		.withIntParameter("pin", LED_BUILTIN)
		.withIntParameter("value", 0);
} 

static void expectReadAndSendAdcA0(void) {
	mock().expectOneCall("analogRead")
		.withIntParameter("pin", A0)
		.andReturnValue(222);

	const char* str = "222";
	mock().expectOneCall("write")
		.withStringParameter("str", str)
	    .andReturnValue((int)strlen(str));

	mock().expectOneCall("write")
		.withIntParameter("val", '\r')
		.andReturnValue(1);
}
