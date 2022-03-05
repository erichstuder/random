#include "CppUTestExt/MockSupport.h"

#include "LiquidCrystal.h"

LiquidCrystal::LiquidCrystal(uint8_t rs, uint8_t rw, uint8_t enable, uint8_t d0, uint8_t d1, uint8_t d2, uint8_t d3){}

void LiquidCrystal::begin(uint8_t cols, uint8_t rows){
	mock().actualCall("LiquidCrystal::begin")
		.withParameter("cols", cols)
		.withParameter("rows", rows);
}

size_t LiquidCrystal::print(const char str[]){
	mock().actualCall("LiquidCrystal::print")
		.withParameter("str", str);
	
	return 0;
}
