#pragma once

// Somehow the Arduino stdlib.h is different from the standard one.
// Here the missing functions are added.

char *dtostrf(double __val, signed char __width, unsigned char __prec, char *__s);
