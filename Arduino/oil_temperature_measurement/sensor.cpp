#include "sensor.h"
#include <Arduino.h>

namespace sensor{
	// Teilenummer: VDO 323-801-001-010N
	// https://vdo-webshop.nl/de/temperaturgeber/414-vdo-kuhlmitteltemperatursensor-120c-1-2-14-nptf-4103590689665.html
	static float TemperatureCelsius_to_Resistance[][2] = {
	{ -40, 17162.35 },
	{ -35, 12439.50 },
	{ -30,  9134.53 },
	{ -25,  6764.48 },
	{ -20,  5067.60 },
	{ -15,  3833.89 },
	{ -10,  2929.90 },
	{  -5,  2249.44 },
	{   0,  1743.15 },
	{   5,  1364.07 },
	{  10,  1075.63 },
	{  15,   850.09 },
	{  20,   676.95 },
	{  25,   543.54 },
	{  30,   439.29 },
	{  35,   356.64 },
	{  40,   291.46 },
	{  45,   239.56 },
	{  50,   197.29 },
	{  55,   161.46 },
	{  60,   134.03 },
	{  65,   113.96 },
	{  70,    97.05 },
	{  75,    82.36 },
	{  80,    70.12 },
	{  85,    59.73 },
	{  90,    51.21 },
	{  95,    44.32 },
	{ 100,    38.47 },
	{ 105,    33.40 },
	{ 110,    29.12 },
	{ 115,    25.53 },
	{ 120,    22.44 },
	{ 125,    19.75 },
	{ 130,    17.44 },
	{ 135,    15.46 },
	{ 140,    13.75 },
	{ 145,    12.26 },
	{ 150,    10.96 },
	};

	static float resistanceToTemperatureCelsius(float resistance);

	float getTemperature_Celsius(){
		const float AdcCounts = 1024;
		const float ReferenceVoltage = 5;
		const float VoltageDividerResistor = 1000;

		float sensorCounts = (float)analogRead(A0);
		float sensorVoltage = sensorCounts / AdcCounts * ReferenceVoltage;
		float sensorResistance = sensorVoltage * VoltageDividerResistor / (ReferenceVoltage-sensorVoltage);
		return resistanceToTemperatureCelsius(sensorResistance);
	}

	static float resistanceToTemperatureCelsius(float resistance){
		const uint8_t NrOfEntries = sizeof(TemperatureCelsius_to_Resistance) / sizeof(TemperatureCelsius_to_Resistance[0]);
		
		uint8_t n = 0;
		while(n < NrOfEntries){
			if(resistance > TemperatureCelsius_to_Resistance[n][1]){
				break;
			}
			n++;
		}

		if(n <= 0){
			return TemperatureCelsius_to_Resistance[0][0];
		}
		else if(n >= NrOfEntries){
			return TemperatureCelsius_to_Resistance[NrOfEntries-1][0];
		}
		else{
			float lowerR = TemperatureCelsius_to_Resistance[n-1][1];
			float upperR = TemperatureCelsius_to_Resistance[n  ][1];
			float lowerT = TemperatureCelsius_to_Resistance[n-1][0];
			float upperT = TemperatureCelsius_to_Resistance[n  ][0];

			float rInterpolated = (resistance-lowerR) / (upperR-lowerR) * (upperT-lowerT) + lowerT;
			return rInterpolated;
		}
	}
}
