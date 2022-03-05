#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

#include "main.h"
#include "temperatureSensor.h"
#include "lcd.h"

static float getTemperatureKelvin_Mock(void) {
	mock().actualCall("getTemperatureKelvin_Mock");
	return mock().doubleReturnValue();
}

static void lcd_printTemperatureCelsius_Mock(float temperatureKelvin) {
	mock().actualCall("lcd_printTemperatureCelsius_Mock")
		.withParameter("temperatureKelvin", temperatureKelvin);
}


TEST_GROUP(main_test)
{
    void setup(){}
    void teardown(){
		mock().checkExpectations();
		mock().clear();
	}
};

TEST(main_test, setup){
	// At the moment there is nothing to test.
	setup_forCppUTest();
}

TEST(main_test, loop){
	UT_PTR_SET(getTemperatureKelvin, getTemperatureKelvin_Mock);
	UT_PTR_SET(lcd_printTemperatureCelsius, lcd_printTemperatureCelsius_Mock);

	const float Value = 123.456;
	mock().expectOneCall("getTemperatureKelvin_Mock")
		.andReturnValue(Value);
	mock().expectOneCall("lcd_printTemperatureCelsius_Mock")
		.withParameter("temperatureKelvin", Value);

	loop();
}
