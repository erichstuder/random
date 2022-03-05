#pragma once

#include <stdint.h>
#include <stddef.h>

class LiquidCrystal{
public:
  LiquidCrystal(uint8_t rs, uint8_t rw, uint8_t enable,
		uint8_t d0, uint8_t d1, uint8_t d2, uint8_t d3);

  void begin(uint8_t cols, uint8_t rows);

  size_t print(const char str[]);
};