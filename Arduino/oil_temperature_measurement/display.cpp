#include "display.h"
#include <Servo.h>

namespace display{
	static Servo servo;

	static float temperatureCelsius_to_angleDegree(float resistance);

	void init(){
		servo.attach(9); //TODO: hier kann man noch ein min und max mitgeben (Sicherheit??)
	}

	void setTemperatureDegree(float temperature){
		float angle = temperatureCelsius_to_angleDegree(temperature);
		servo.write(angle);//TODO: kann an diese Funktion float übergeben werden?
	}

	static float temperatureCelsius_to_angleDegree(float temperature){
		//TODO: implement the calculation
		//TODO: minimum und maximum begrenzen
		const float MinAngle = 20; //TOOD: tune
		const float MaxAngle = 100;//TODO: tune
		return 0;
	}
}
