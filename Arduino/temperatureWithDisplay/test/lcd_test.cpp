#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

#include "lcd.h"

TEST_GROUP(lcd_test)
{
    void setup(){}
    void teardown(){
		mock().checkExpectations();
		mock().clear();
	}
};

TEST(lcd_test, print_begin){
	mock().expectOneCall("LiquidCrystal::begin")
		.withParameter("cols", 16)
		.withParameter("rows", 2);
	mock().ignoreOtherCalls();

    lcd_printTemperatureCelsius(0);
}

TEST(lcd_test, print_0_Kelvin){
	mock().expectOneCall("LiquidCrystal::print")
		.withParameter("str", "-273.1 \xDF""C");
	mock().ignoreOtherCalls();

    lcd_printTemperatureCelsius(0);
}

TEST(lcd_test, print_rounding){
	mock().expectOneCall("LiquidCrystal::print")
		.withParameter("str", "   9.2 \xDF""C");
	mock().ignoreOtherCalls();

    lcd_printTemperatureCelsius(273.15+9.16);
}
