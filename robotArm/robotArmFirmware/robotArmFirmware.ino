//Board: Arduino Yun
#include <Servo.h>

Servo myservo;

void setup(void){
	pinMode(A0, OUTPUT);
	digitalWrite(A0, LOW);

	pinMode(A2, OUTPUT);
	digitalWrite(A2, HIGH);

	myservo.attach(9);
}

void loop(void){
	float degrees = (float)analogRead(A1) / 1024.0f * 100.0f;
	myservo.write((uint8_t)degrees);
	delay(100);
}
