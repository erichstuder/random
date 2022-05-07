#include "display.h"
#include <Servo.h>
#include <Arduino.h>

namespace display{
	static float TemperatureCelsius_to_AngleDegree[][2] = {
	{  12, 130 },
	{  50, 110 },
	{  75,  97 },
	{ 100,  78 },
	{ 110,  66 },
	{ 120,  52 },
	{ 130,  41 },
	{ 140,  35 },
	{ 150,  30 },
	};

	Servo servo;

	static float temperatureCelsiusToAngleDegree(float temperature);

	void init(){
		servo.attach(9);
	}

	void setTemperatureDegree(float temperature){
		float angle = temperatureCelsiusToAngleDegree(temperature);

		Serial.print("Winkel: ");
		Serial.println(angle);
		servo.write(angle);
	}

	static float temperatureCelsiusToAngleDegree(float temperature){
		const uint8_t NrOfEntries = sizeof(TemperatureCelsius_to_AngleDegree) / sizeof(TemperatureCelsius_to_AngleDegree[0]);
		
		uint8_t n = 0;
		while(n < NrOfEntries){
			if(temperature < TemperatureCelsius_to_AngleDegree[n][0]){
				break;
			}
			n++;
		}

		if(n <= 0){
			return TemperatureCelsius_to_AngleDegree[0][1];
		}
		else if(n >= NrOfEntries){
			return TemperatureCelsius_to_AngleDegree[NrOfEntries-1][1];
		}
		else{
			float lowerT = TemperatureCelsius_to_AngleDegree[n-1][0];
			float upperT = TemperatureCelsius_to_AngleDegree[n  ][0];
			float lowerA = TemperatureCelsius_to_AngleDegree[n-1][1];
			float upperA = TemperatureCelsius_to_AngleDegree[n  ][1];

			float angleInterpolated = (temperature-lowerT) / (upperT-lowerT) * (upperA-lowerA) + lowerA;
			
			if(angleInterpolated < 0){
				angleInterpolated = 0;
			}
			else if(angleInterpolated > 130){
				angleInterpolated = 130;
			}

			return angleInterpolated;
		}
	}
}
