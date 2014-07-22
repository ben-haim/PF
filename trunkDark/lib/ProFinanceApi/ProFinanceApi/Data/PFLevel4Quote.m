#import "PFLevel4Quote.h"

#import "PFSymbol.h"
#import "PFLevel4QuotePackage.h"

#import "PFMetaObject.h"
#import "PFField.h"

@interface PFLevel4Quote ()

@property ( nonatomic, strong ) NSDate* expirationDate;

@end

@implementation PFLevel4Quote

@synthesize bidSize;
@synthesize askSize;
@synthesize bid;
@synthesize ask;
@synthesize close;
@synthesize open;
@synthesize high;
@synthesize low;
@synthesize underlier;
@synthesize date;
@synthesize lastSize;
@synthesize crossPrice;
@synthesize volume;
@synthesize lastPrice;
@synthesize symbol;
@synthesize expirationDate = _expirationDate;

@synthesize delta;
@synthesize gamma;
@synthesize vega;
@synthesize theta;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldUnderlier name: @"underlier" ]
            , [ PFMetaObjectField fieldWithId: PFFieldInstrumentId name: @"instrumentId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldRouteId name: @"routeId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBidVolume name: @"bidSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAskVolume name: @"askSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBid name: @"bid" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAsk name: @"ask" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDate name: @"date" ]
            , [ PFMetaObjectField fieldWithId: PFFieldClosePrice name: @"close" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOpen name: @"open" ]
            , [ PFMetaObjectField fieldWithId: PFFieldHigh name: @"high" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLow name: @"low" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOptionType name: @"optionType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldExpMonth name: @"expMonth" ]
            , [ PFMetaObjectField fieldWithId: PFFieldExpYear name: @"expYear" ]
            , [ PFMetaObjectField fieldWithId: PFFieldExpDay name: @"expDay" ]
            , [ PFMetaObjectField fieldWithId: PFFieldStrikePrice name: @"strikePrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLastSize name: @"lastSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCrossPrice name: @"crossPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldVolumeTotal name: @"volume" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLastPrice name: @"lastPrice" ]] ];
}

-(NSDate*)expirationDate
{
   if ( !_expirationDate )
   {
      NSDateComponents* date_components_ = [ NSDateComponents new ];
      date_components_.day = self.expDay;
      date_components_.month = self.expMonth;
      date_components_.year = self.expYear;
      NSCalendar* calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
      _expirationDate = [ calendar_ dateFromComponents: date_components_ ];
   }
   
   return _expirationDate;
}

-(PFDouble)bidAmount
{
   return self.symbol.lotSize == 0.0 ? 0.0 : self.bidSize / self.symbol.lotSize;
}

-(PFDouble)askAmount
{
   return self.symbol.lotSize == 0.0 ? 0.0 : self.askSize / self.symbol.lotSize;
}

-(BOOL)isEqual:( id )other_
{
   if ( [ self class ] != [ other_ class ] )
      return NO;
   
   PFLevel4Quote* other_quote_ = ( PFLevel4Quote* )other_;

   return [ other_quote_.expirationDate isEqualToDate: self.expirationDate ] && other_quote_.strikePrice == self.strikePrice;
}

-(NSUInteger)hash
{
   return self.expirationDate.hash ^ @(self.strikePrice).hash;
}

#pragma mark - PFSymbolConnection

-(void)connectToSymbol:( PFSymbol* )symbol_
{
   self.symbol = symbol_;
   
   [ symbol_.level4Quotes updateQuote: self ];
}


-(NSComparisonResult)compare:( id< PFLevel4Quote > )quote_
{
   if ( self.strikePrice == quote_.strikePrice )
      return NSOrderedSame;
   
   return self.strikePrice > quote_.strikePrice ? NSOrderedDescending : NSOrderedAscending;
}

@end
