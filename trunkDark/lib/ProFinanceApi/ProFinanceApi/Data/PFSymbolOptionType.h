#ifndef ProFinanceApi_PFSymbolOptionType_h
#define ProFinanceApi_PFSymbolOptionType_h

typedef enum
{
   PFSymbolOptionTypeUndefined = -1
   , PFSymbolOptionTypeCallVanilla = 0
   , PFSymbolOptionTypePutVanilla = 1
   , PFSymbolOptionTypeCallBinary = 2
   , PFSymbolOptionTypePutBinary = 3
   , PFSymbolOptionTypeFutures = 5
} PFSymbolOptionType;

#endif
