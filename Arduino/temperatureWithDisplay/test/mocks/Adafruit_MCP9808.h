#pragma once

#include <stdint.h>

class Adafruit_MCP9808{
public:
  Adafruit_MCP9808();
  bool begin();
  float readTempC();
  void setResolution(uint8_t value);
  void wake();
};
