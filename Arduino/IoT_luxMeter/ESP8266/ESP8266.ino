// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full
// license information.

//see: https://www.adafruit.com/product/1334
//see: http://arduinolearning.com/code/arduino-tcs34725-color-sensor.php

//Board: ESP8266

#include <Wire.h>
#include "Adafruit_TCS34725.h"

#include <ESP8266WiFi.h>
#include "src/iotc/common/string_buffer.h"
#include "src/iotc/iotc.h"

char* wifiSsid = "lqo-07675";
char* wifiPassword = "";

char* scopeId = "";
char* deviceId = "";
char* deviceKey = "";

boolean isConfigured = false;

/* Initialise with specific int time and gain values */
Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_700MS, TCS34725_GAIN_1X);

void on_event(IOTContext ctx, IOTCallbackInfo* callbackInfo);
#include "src/connection.h"

void on_event(IOTContext ctx, IOTCallbackInfo* callbackInfo) {
  // ConnectionStatus
  if (strcmp(callbackInfo->eventName, "ConnectionStatus") == 0) {
    LOG_VERBOSE("Is connected ? %s (%d)",
                callbackInfo->statusCode == IOTC_CONNECTION_OK ? "YES" : "NO",
                callbackInfo->statusCode);
    isConnected = callbackInfo->statusCode == IOTC_CONNECTION_OK;
    return;
  }

  // payload buffer doesn't have a null ending.
  // add null ending in another buffer before print
  AzureIOT::StringBuffer buffer;
  if (callbackInfo->payloadLength > 0) {
    buffer.initialize(callbackInfo->payload, callbackInfo->payloadLength);
  }

  LOG_VERBOSE("- [%s] event was received. Payload => %s\n",
              callbackInfo->eventName, buffer.getLength() ? *buffer : "EMPTY");

  if (strcmp(callbackInfo->eventName, "Command") == 0) {
    LOG_VERBOSE("- Command name was => %s\r\n", callbackInfo->tag);
  }
}

void setup(){
  //String s;
  Serial.begin(9600);
  /*while(!Serial){;}

  delay(3000);//make sure the next text is displayed
  Serial.setTimeout(2147483647); //2147483647ms = about 24 days
  
  Serial.println("Enter WIFI SSID:");
  s = Serial.readStringUntil('\n');*/

  /*for(;;){
    s = Serial.readStringUntil('\n');
    if(s.length() > 0){
      Serial.println(s);
    }
  }*/

  if(tcs.begin()){
    Serial.println("Found sensor");
  }else{
    Serial.println("No TCS34725 found ... check your connections");
    while(1);
  }

  connect_wifi(wifiSsid, wifiPassword);
  connect_client(scopeId, deviceId, deviceKey);

  if (context != NULL) {
    lastTick = 0;  // set timer in the past to enable first telemetry a.s.a.p
  }
}

void loop() {
  uint16_t r, g, b, c, colorTemp, lux;

  tcs.getRawData(&r, &g, &b, &c);
  colorTemp = tcs.calculateColorTemperature(r, g, b);
  lux = tcs.calculateLux(r, g, b);
  
  if (isConnected) {
    unsigned long ms = millis();
    if (ms - lastTick > 10000) {  // send telemetry every 10 seconds
      char msg[64] = {0};
      int pos = 0, errorCode = 0;

      lastTick = ms;
      if (loopId++ % 2 == 0) {  // send telemetry
        pos = snprintf(msg, sizeof(msg) - 1, "{\"lux\": %d}", lux);
        errorCode = iotc_send_telemetry(context, msg, pos);
      } else {  // send property
        /*pos = snprintf(msg, sizeof(msg) - 1, "{\"dieNumber\":%d}", 1 + (rand() % 5));
        errorCode = iotc_send_property(context, msg, pos);*/
      }
      msg[pos] = 0;

      if (errorCode != 0) {
        LOG_ERROR("Sending message has failed with error code %d", errorCode);
      }
    }

    iotc_do_work(context);  // do background work for iotc
  } else {
    iotc_free_context(context);
    context = NULL;
    connect_client(scopeId, deviceId, deviceKey);
  }
}
