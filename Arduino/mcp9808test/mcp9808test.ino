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
  
  Serial.begin(9600);
  Serial.println("MCP9808 demo");
  
  // Make sure the sensor is found, you can also pass in a different i2c
  // address with tempsensor.begin(0x19) for example
  if (!tempsensor.begin()) {
    Serial.println("Couldn't find MCP9808!");
    while (1);
  }

  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // Read and print out the temperature, then convert to *F
  float c = tempsensor.readTempC();
  float f = c * 9.0 / 5.0 + 32;

  if(c < 27.0){
    // turn the LED on (HIGH is the voltage level) 
    digitalWrite(LED_BUILTIN, HIGH);
  }else{
    // turn the LED off by making the voltage LOW
    digitalWrite(LED_BUILTIN, LOW);
  }
  
//  Serial.print("Temp: "); Serial.print(c); Serial.print("*C\t"); 
//  Serial.print(f); Serial.println("*F");
  Serial.println(c);
  delay(250);
  
  //Serial.println("Shutdown MCP9808.... ");
  tempsensor.shutdown_wake(1); // shutdown MSP9808 - power consumption ~0.1 mikro Ampere
  
  delay(2000);
  
  //Serial.println("wake up MCP9808.... "); // wake up MSP9808 - power consumption ~200 mikro Ampere
  tempsensor.shutdown_wake(0);

  
   
}
