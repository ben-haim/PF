#ifndef ProFinanceApi_PFTypes_h
#define ProFinanceApi_PFTypes_h

#include <stdint.h>

enum
{
   PFByteSize = 1
   , PFBoolSize = 1
   , PFShortSize = 2
   , PFIntegerSize = 4
   , PFLongSize = 8
   , PFFloatSize = 4
   , PFDoubleSize = 8
};

typedef int_fast8_t PFByte;
typedef uint_fast8_t PFBool;
typedef int_fast16_t PFShort;
typedef int_fast32_t PFInteger;
typedef int_fast64_t PFLong;
typedef float PFFloat;
typedef double PFDouble;

#endif
