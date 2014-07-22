#ifndef ProFinanceApi_PFOrderType_h
#define ProFinanceApi_PFOrderType_h

typedef enum
{
   PFOrderManual
   , PFOrderMarket
   , PFOrderStop
   , PFOrderLimit
   , PFOrderStopLimit
   , PFOrderTrailingStop
   , PFOrderOCO
} PFOrderType;

#endif
