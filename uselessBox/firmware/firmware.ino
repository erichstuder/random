#include <Servo.h>

Servo myservo;

void setup(void) {
	myservo.attach(9);  // attaches the servo on pin 9 to the servo object
	pinMode(LED_BUILTIN, OUTPUT);
	digitalWrite(LED_BUILTIN, HIGH);

	const uint8_t SwitchPin = 4;
	pinMode(SwitchPin, INPUT_PULLUP);

	const uint8_t RelayPin = 12;
	pinMode(RelayPin, OUTPUT);
	digitalWrite(RelayPin, LOW);
	delay(500);
	digitalWrite(LED_BUILTIN, LOW);

	myservo.write(95);
	delay(500);
	myservo.write(180);
	delay(700);

	while( digitalRead(SwitchPin) == LOW );

	digitalWrite(RelayPin, HIGH);
}

void loop(void) {}
