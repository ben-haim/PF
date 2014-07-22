#ifndef ProFinanceApi_PFMarketOperationType_h
#define ProFinanceApi_PFMarketOperationType_h

typedef enum
{
   PFMarketOperationBuy
   , PFMarketOperationSell
} PFMarketOperationType;

extern PFMarketOperationType PFMarketOperationReverse( PFMarketOperationType operation_ );

#endif
