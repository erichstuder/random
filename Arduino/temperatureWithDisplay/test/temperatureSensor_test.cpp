#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

#include "temperatureSensor.h"

TEST_GROUP(temperatureSensor_test)
{
    void setup(){}
    void teardown(){
		mock().checkExpectations();
		mock().clear();
	}
};

TEST(temperatureSensor_test, getTemperature){
	mock().expectOneCall("Adafruit_MCP9808::begin");
	mock().expectOneCall("Adafruit_MCP9808::setResolution")
		.withParameter("value", 3);
	mock().expectOneCall("Adafruit_MCP9808::wake");
	const float TemperatureCelsius = 42.8;
	mock().expectOneCall("Adafruit_MCP9808::readTempC")
		.andReturnValue(TemperatureCelsius);

	float temperatureKelvin = getTemperatureKelvin();

	DOUBLES_EQUAL(TemperatureCelsius+273.15, temperatureKelvin, 0.01);
}
