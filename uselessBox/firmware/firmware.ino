#include <Servo.h>

Servo myservo;

void setup(void) {
	myservo.attach(9);  // attaches the servo on pin 9 to the servo object
}

void loop(void) {
	myservo.write(180);
	delay(3000);
	myservo.write(95);
	delay(500);
}

