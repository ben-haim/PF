#import "PFMarketOperation+PFMessage.h"

#import "PFFieldOwner.h"
#import "PFField.h"

@implementation PFMarketOperation (PFMessage)

+(id)marketOperationWithFieldOwner:( PFFieldOwner* )field_owner_
{
   PFMarketOperation* market_operation_ = [ self new ];

   market_operation_.accountId = [ (PFIntegerField*)([ field_owner_ fieldWithId: PFFieldAccountId ]) integerValue ];
   market_operation_.instrumentId = [ (PFIntegerField*)([ field_owner_ fieldWithId: PFFieldInstrumentId ]) integerValue ];
   market_operation_.routeId = [ (PFIntegerField*)([ field_owner_ fieldWithId: PFFieldRouteId ]) integerValue ];
   market_operation_.operationType = [ [ field_owner_ fieldWithId: PFFieldOperationType ] byteValue ];
   market_operation_.amount = [ [ field_owner_ fieldWithId: PFFieldAmount ] doubleValue ];
   market_operation_.stopLossPrice = [ [ field_owner_ fieldWithId: PFFieldSlPrice ] doubleValue ];
   market_operation_.takeProfitPrice = [ [ field_owner_ fieldWithId: PFFieldTpPrice ] doubleValue ];

   return market_operation_;
}

@end
