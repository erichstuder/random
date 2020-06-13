#include <Arduino.h>
#include <Wire.h>

void setup(void){
  //Serial.begin();
  while(!Serial);
  Serial.print("started\n");  
  Wire.begin();
}

void loop(void){
  Wire.beginTransmission(2); 
  Wire.write(byte(0x08));
  Wire.endTransmission(false);
  
  Wire.requestFrom(2,5,true);
  while(Wire.available()){
    char c = Wire.read();
    Serial.print(c);
  }
  //Serial.print("try to stop\n");
  //Wire.endTransmission(true);
  Serial.print("reading done\n");
  delay(1000);
}
