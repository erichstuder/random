#include <Servo.h>

Servo myservo;

void setup(void) {
	myservo.attach(9);  // attaches the servo on pin 9 to the servo object
}

void loop(void) {
	myservo.write(160);
	delay(1000);
	myservo.write(85);
	delay(3000);
}

