#import "PFSymbol.h"

#import "PFSymbolId.h"
#import "PFSymbolOptionType.h"

#import "PFInstrumentGroup.h"
#import "PFInstrument.h"
#import "PFRoute.h"
#import "PFQuote.h"
#import "PFLevel2QuotePackage.h"
#import "PFLevel4QuotePackage.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFSymbol ()

//!weak reference
@property ( nonatomic, weak ) PFInstrument* instrument;
@property ( nonatomic, strong ) PFRoute* route;

@end

@implementation PFSymbol

@synthesize instrument;
@synthesize route;
@synthesize name;
@synthesize shortName;

@synthesize quote;
@synthesize realQuote;

@synthesize tradeQuote;
@synthesize level2Quotes = _level2Quotes;
@synthesize level4Quotes = _level4Quotes;

@synthesize lastTradeDate;
@synthesize contractMonthDate;
@synthesize settlementDate;
@synthesize noticeDate;
@synthesize firstTradeDate;
@synthesize autoCloseDate;
@synthesize deliveryStatus;
@synthesize isContiniousContract;

@synthesize tradeMode = _tradeMode;
@synthesize highLimitPrice =_highLimitPrice;
@synthesize lowLimitPrice = _lowLimitPrice;
@synthesize limitMeasure = _limitMeasure;

@dynamic groupId;
@dynamic overview;
@dynamic pointSize;
@dynamic lotSize;
@dynamic lotStep;
@dynamic minimalLot;
@dynamic precision;
@dynamic barType;
@dynamic pipsSize;
@dynamic tickCoast;
@dynamic isForex;
@dynamic isFutures;
@dynamic isOption;
@dynamic marginType;

-(PFDouble)highLimit
{
   switch ( self.limitMeasure )
    { // High limit price  = Settl Price * (1 + High Limit coef /100).
      case PFLimitMeasureAbsolute:
         return self.quote.prevSettlementPrice + (self.highLimitPrice * self.quote.instrument.pointSize);
         
      case PFLimitMeasurePercent:
         return self.quote.prevSettlementPrice * (1.0 + self.highLimitPrice / 100.0);
         
      default:
         return 0.0;
   }
}

-(PFDouble)lowLimit
{
   switch ( self.limitMeasure )
   { // Low limit price  = Settl Price * (1 - Low Limit coef/100).
      case PFLimitMeasureAbsolute:
         return self.quote.prevSettlementPrice - (self.lowLimitPrice * self.quote.instrument.pointSize);
         
      case PFLimitMeasurePercent:
         return self.quote.prevSettlementPrice * (1.0 - self.lowLimitPrice / 100.0);
         
      default:
         return 0.0;
   }
}

-(NSArray*)allowedOrderTypes
{
   return self.route.allowedOrderTypes;
}

-(NSArray*)allowedValiditiesForOrderType:( PFOrderType )order_type_
{
   return [ self.route allowedValiditiesForOrderType: order_type_ ];
}

-(PFBool)allowsTrading
{
   BOOL is_valid_ = YES;
   
   if ( self.lastTradeDate )
   {
      is_valid_ = [ self.lastTradeDate compare: [ NSDate date ] ] == NSOrderedDescending;
   }
   
   return ( [ self.instrument.tradeRouteNames containsObject: self.routeName ] && is_valid_ && self.allowedOrderTypes.count > 0 );
}

-(PFInteger)instrumentId
{
   return self.instrument.instrumentId;
}

-(PFInteger)baseInstrumentId
{
   return self.instrument.baseInstrumentId;
}

-(PFInteger)routeId
{
   return self.route.routeId;
}

-(PFInteger)quoteRouteId
{
   return self.route.quoteRouteId;
}

-(NSString*)routeName
{
   return self.route.name;
}

-(PFBool)allowsTifModification
{
   return self.route.allowsTifModification;
}

-(NSString*)groupName
{
   return self.instrument.group.name;
}

-(NSString*)instrumentName
{
   return self.instrument.name;
}

-(PFDouble)last
{
   return self.quote.last > 0.0
      ? self.quote.last
      : self.quote.bid;
}

-(PFDouble)spread
{
   if ( self.quote.ask <= 0.0 && self.quote.bid <= 0.0 )
      return 0.0;
   else
      return ( self.quote.ask - self.quote.bid ) / self.pipsSize;
}

-(PFDouble)change
{
   if ( self.last <= 0.0 && self.quote.previousClose <= 0.0 )
      return 0.0;
   else
      return ( self.last - self.quote.previousClose );
}

-(PFDouble)changePercent
{
   if ( self.quote.previousClose == 0.0 )
   {
      return 0.0;
   }

   return ( self.change / self.quote.previousClose ) * 100.0;
}

-(PFLevel2QuotePackage*)level2Quotes
{
   if ( !_level2Quotes )
   {
      _level2Quotes = [ PFLevel2QuotePackage new ];
      _level2Quotes.symbol = self;
   }
   return _level2Quotes;
}

-(PFLevel4QuotePackage*)level4Quotes
{
   if ( !_level4Quotes )
   {
      _level4Quotes = [ PFLevel4QuotePackage new ];
      _level4Quotes.symbol = self;
   }
   return _level4Quotes;
}

-(PFByte)tradeMode
{
    return self.instrument.isFutures ? _tradeMode : self.instrument.tradeMode;
}

-(PFDouble)highLimitPrice
{
    return self.instrument.isFutures ? _highLimitPrice : self.instrument.highLimitPrice;
}

-(PFDouble)lowLimitPrice
{
    return self.instrument.isFutures ? _lowLimitPrice : self.instrument.lowLimitPrice;
}

-(PFByte)limitMeasure
{
    return self.instrument.isFutures ? _limitMeasure : self.instrument.limitMeasure;
}

+(id)symbolWithInstrument:( PFInstrument* )instrument_
                    route:( PFRoute* )route_
                 baseName:( NSString* )base_name_
{
   PFSymbol* symbol_ = [ self new ];
   [ symbol_ connectToInstrument: instrument_ ];
   symbol_.route = route_;
   
   symbol_.shortName = base_name_;
   symbol_.name = [ instrument_.routes count ] > 1
   ? [ base_name_ stringByAppendingFormat: @":%@", route_.name ]
   : base_name_;
   
   return symbol_;
}

+(id)symbolWithInstrument:( PFInstrument* )instrument_
                    route:( PFRoute* )route_
{
   return [ self symbolWithInstrument: instrument_
                                route: route_
                             baseName: instrument_.name ];
}

-(void)connectToInstrument:( PFInstrument* )instrument_
{
   self.instrument = instrument_;
}

-(void)disconnectFromInstrument
{
   self.instrument = nil;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFSymbol instrument: %@, routeId: %d, qouteRouteId: %d", self.instrument, self.routeId, self.quoteRouteId ];
}

#pragma mark PFInstrument redirect

-(void)forwardInvocation:( NSInvocation* )invocation_
{
   SEL selector_ = [ invocation_ selector ];

   if ( [ self.instrument respondsToSelector: selector_ ] )
      [ invocation_ invokeWithTarget: self.instrument ];
}

-(NSMethodSignature*)methodSignatureForSelector:( SEL )selector_
{
   return [ self.instrument methodSignatureForSelector: selector_ ];
}

@end

@interface PFFuturesSymbol : PFSymbol

@end

@implementation PFFuturesSymbol

+(NSArray*)monthNames
{
   static NSArray* month_names_ = nil;
   if ( !month_names_ )
   {
      month_names_ = @[ @"F", @"G", @"H", @"J", @"K", @"M", @"N", @"Q", @"U", @"V", @"X", @"Z" ];
   }
   return month_names_;
}

+(NSString*)futuresNameWithInstrumentName:( NSString* )instrument_name_
                                  expYear:( PFShort )year_
                                 expMonth:( PFByte )month_
{
   if ( year_ == 0 )
   {
      return instrument_name_;
   }

   return [ NSString stringWithFormat: @"%@ %@%d"
           , instrument_name_
           , [ [ self monthNames ] objectAtIndex: month_ - 1 ]
           , year_ % 10 ];
}

+(id)futuresSymbolWithInstrument:( PFInstrument* )instrument_
                           route:( PFRoute* )route_
                            date:( NSDate* )date_
{
   NSCalendar* gregorian_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];

   NSDateComponents* date_components_ = [ gregorian_ components: NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                       fromDate: date_ ];

   PFShort exp_year_ = date_components_.year < PFExpYearIgnore ? 0 : date_components_.year;
   PFByte exp_month_ = date_components_.month;

   PFFuturesSymbol* futures_ = [ self symbolWithInstrument: instrument_
                                                     route: route_
                                                  baseName: [ self futuresNameWithInstrumentName: instrument_.name
                                                                                         expYear: exp_year_
                                                                                        expMonth: exp_month_ ] ];

   futures_.expYear = exp_year_;
   futures_.expMonth = exp_month_;
   futures_.expDay = date_components_.day;

   futures_.optionType = PFSymbolOptionTypeFutures;

   return futures_;
}

@end

@implementation NSArray (SymbolsFromInstrument)

+(id)symbolsArrayWithInstrument:( PFInstrument* )instrument_
                          route:( PFRoute* )route_
{
   if ( instrument_.isFutures )
   {
      
      NSMutableArray* result_ = [ NSMutableArray arrayWithCapacity: [ instrument_.expirationDates count ] ];
      
      for ( int i = 0; i < instrument_.expirationDates.count; i++ )
      {
         PFFuturesSymbol* futures_ = [ PFFuturesSymbol futuresSymbolWithInstrument: instrument_
                                                                             route: route_
                                                                              date: [ instrument_.expirationDates objectAtIndex: i ] ];
         
         futures_.lastTradeDate = [ instrument_.lastTradeDates objectAtIndex: i ];
         futures_.contractMonthDate = [ instrument_.expirationDates objectAtIndex: i ];
         futures_.settlementDate = [ instrument_.settlementDates objectAtIndex: i ];
         futures_.noticeDate = [ instrument_.noticeDates objectAtIndex: i ];
         futures_.firstTradeDate = [ instrument_.firstTradeDates objectAtIndex: i ];
         futures_.autoCloseDate = [ instrument_.autoCloseDates objectAtIndex: i ];
         futures_.deliveryStatus = (PFInteger)[ [ instrument_.deliveryStatuses objectAtIndex: i ] integerValue ];
         futures_.isContiniousContract = [ [ instrument_.isContiniousContracts objectAtIndex: i ] boolValue ];
         futures_.tradeMode = [ [ instrument_.tradeModes objectAtIndex: i ] shortValue ];
         futures_.lowLimitPrice = [ [ instrument_.priceLowLimits objectAtIndex: i ] doubleValue ];
         futures_.highLimitPrice = [ [ instrument_.priceHighLimits objectAtIndex: i ] doubleValue ];
         futures_.limitMeasure = [ [ instrument_.priceLimitMeasures objectAtIndex: i ] shortValue ];
         
         [ result_ addObject: futures_ ];
      }
      
      return [ NSArray arrayWithArray: result_ ];
   }

   return [ self arrayWithObject: [ PFSymbol symbolWithInstrument: instrument_
                                                            route: route_ ] ];
}

@end

