#import "PFMarketOperationType.h"

PFMarketOperationType PFMarketOperationReverse( PFMarketOperationType operation_ )
{
   return operation_ == PFMarketOperationBuy
      ? PFMarketOperationSell
      : PFMarketOperationBuy;
}
