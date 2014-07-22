#import "PFPosition.h"

#import "PFAccount.h"
#import "PFOrder.h"
#import "PFSymbol.h"
#import "PFQuote.h"
#import "PFInstrument.h"
#import "PFLevel4QuotePackage.h"

#import "PFMetaObject.h"
#import "PFField.h"

@implementation PFPosition

@synthesize positionId;
@synthesize stopLossOrderId;
@synthesize takeProfitOrderId;
@synthesize openPrice;
@synthesize closePrice;
@synthesize commission;
@synthesize swap;
@synthesize profitUSD;
@synthesize netProfitUSD;
@synthesize openCrossPrice;

@synthesize grossPl;
@synthesize netPl;
@synthesize plTicks;

@synthesize exposure;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldPositionId name: @"positionId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLastOrderId name: @"orderId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSlOrderId name: @"stopLossOrderId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTpOrderId name: @"takeProfitOrderId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOpenPrice name: @"openPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldClosePrice name: @"closePrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCommission name: @"commission" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSwap name: @"swap" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDate name: @"createdAt" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOpenCrossPrice name: @"openCrossPrice" ]
            , [ PFMetaObjectField fieldWithName: @"profitUSD" ]
            , [ PFMetaObjectField fieldWithName: @"netProfitUSD" ]] ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.stopLossOrderId = -1;
      self.takeProfitOrderId = -1;
   }
   return self;
}

-(PFInteger)operationId
{
   return self.positionId;
}

-(PFDouble)price
{
   return self.openPrice;
}

//-(PFDouble)plTicks
//{
//   if ( self.openPrice == 0.0 )
//      return 0.0;
//
//   PFDouble bid_ = self.strikePrice > 0 ? [ self.symbol.level4Quotes bidForSymbolId: self ] : self.symbol.quote.bid;
//   PFDouble ask_ = self.strikePrice > 0 ? [ self.symbol.level4Quotes askForSymbolId: self ] : self.symbol.quote.ask;
//   
//   PFDouble current_price_ = self.operationType == PFMarketOperationBuy ? bid_ : ask_;
//
//   if ( current_price_ == 0.0 )
//      current_price_ = self.symbol.quote.previousClose;
//
//   PFInteger sign_ = self.operationType == PFMarketOperationBuy ? 1 : -1;
//
//   PFDouble ticks_ = sign_ * ( current_price_ - self.openPrice );
//
//   PFDouble pips_size_ = self.symbol.pipsSize;
//   if ( pips_size_ != 0.0 )
//      ticks_ /= pips_size_;
//
//   if ( self.symbol.isForex && self.symbol.instrument.precision % 2 != 0 )
//      ticks_ = round( ticks_ * 10.0 ) / 10.0;
//   else
//      ticks_ = round( ticks_ );
//
//   return ticks_;
//}
//
//-(PFDouble)grossPl
//{
//   BOOL use_account_currency_ = YES;
//   return self.profitUSD * ( use_account_currency_ && self.account ? self.account.crossPrice : 1.0 );
//}
//
//-(PFDouble)netPl
//{
//   BOOL use_account_currency_ = YES;
//   return self.netProfitUSD * ( use_account_currency_ && self.account ? self.account.crossPrice : 1.0 );
//}

-(PFDouble)holdMargin
{
   //!TODO
   return 0.0;
}

-(BOOL)isEqual:( id )other_
{
   if ( ![ other_ isMemberOfClass: [ self class ] ] )
      return NO;

   PFPosition* position_ = ( PFPosition* )other_;
   return [ self isEqualToPosition: position_ ];
}

-(BOOL)isEqualToPosition:( PFPosition* )position_
{
   return self.positionId == position_.positionId;
}

-(PFPosition*)mutablePosition
{
   return [ self copy ];
}

#pragma mark PFQuoteDependence

-(NSString*)dependenceIdentifier
{
   return [ NSString stringWithFormat: @"position_%d", self.positionId ];
}

@end
