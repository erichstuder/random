#include "CppUTestExt/MockSupport.h"

#include "Adafruit_MCP9808.h"

Adafruit_MCP9808::Adafruit_MCP9808(){}

bool Adafruit_MCP9808::begin(){
	mock().actualCall("Adafruit_MCP9808::begin");
	return true;
}

float Adafruit_MCP9808::readTempC(){ 
	mock().actualCall("Adafruit_MCP9808::readTempC");
	return mock().doubleReturnValue();
}

void Adafruit_MCP9808::wake(){
	mock().actualCall("Adafruit_MCP9808::wake");
}

void Adafruit_MCP9808::setResolution(uint8_t value){
	mock().actualCall("Adafruit_MCP9808::setResolution")
		.withParameter("value", value);
}
