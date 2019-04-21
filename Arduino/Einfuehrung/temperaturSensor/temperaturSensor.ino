/**************************************************************************/
/*!
This is a demo for the Adafruit MCP9808 breakout
----> http://www.adafruit.com/products/1782
Adafruit invests time and resources providing this open source code,
please support Adafruit and open-source hardware by purchasing
products from Adafruit!
*/
/**************************************************************************/

#include <Wire.h>
#include "Adafruit_MCP9808.h"

// Create the MCP9808 temperature sensor object
Adafruit_MCP9808 tempsensor = Adafruit_MCP9808();

void setup() {
  //use io pins to power the temp sensor (erich @ 22.03.2015)
  pinMode(0, INPUT);
  pinMode(1, INPUT);
  digitalWrite(4, LOW);
  digitalWrite(5, HIGH);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  
  delay(1000);//delay to power up the temp sensor
  if (!tempsensor.begin()) {
    Serial.println("Couldn't find MCP9808!");
    while (1);
  }

  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);


//  Serial.begin(9600);
//  Serial.println("MCP9808 demo");
//  // Make sure the sensor is found, you can also pass in a different i2c
//  // address with tempsensor.begin(0x19) for example

}

void loop() {
  // Read the temperature
  float temperature = tempsensor.readTempC();

  // Enable LED when temperature becomes too high
  if(temperature < 27.0){
    // turn the LED on (HIGH is the voltage level) 
    digitalWrite(LED_BUILTIN, HIGH);
  }else{
    // turn the LED off by making the voltage LOW
    digitalWrite(LED_BUILTIN, LOW);
  }

  //Serial.println(temperature);
  //delay(250);

  delay(500);
  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
}
