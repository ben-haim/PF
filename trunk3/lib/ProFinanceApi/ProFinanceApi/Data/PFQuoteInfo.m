#import "PFQuoteInfo.h"

@implementation PFBaseQuote

@synthesize date = _date;
@synthesize sessionType = _sessionType;
@synthesize openInterest = _openInterest;

-(PFBool)isValid
{
   [ self doesNotRecognizeSelector: _cmd ];
   return NO;
}

+(PFBaseQuote*)agregatedQuoteWithQuotes:( NSArray* )quotes_
{
   PFBaseQuote* agregated_quote_ = [ PFBaseQuote new ];
   
   for ( PFBaseQuote* quote_ in quotes_ )
   {
      agregated_quote_.openInterest += quote_.openInterest;
   }
   
   return agregated_quote_;
}

@end

@implementation PFTickQuoteInfo

@synthesize price;
@synthesize volume;
@synthesize mpId;
@synthesize exchange;

-(NSString*)description
{
   return [ NSString stringWithFormat: @"price: %f, volume: %lld", self.price, self.volume ];
}

-(PFBool)isValid
{
   return self.price > 0.0;
}

@end

@implementation PFBaseMinuteQuote

@synthesize ticks;
@synthesize volume;

+(PFBaseQuote*)agregatedQuoteWithQuotes:( NSArray* )quotes_
{
   PFBaseMinuteQuote* agregated_quote_ = [ PFBaseMinuteQuote new ];
   
   for ( PFBaseMinuteQuote* quote_ in quotes_ )
   {
      agregated_quote_.openInterest += quote_.openInterest;
      agregated_quote_.ticks += quote_.ticks;
      agregated_quote_.volume += quote_.volume;
   }
   
   return agregated_quote_;
}

-(double)quoteVolume
{
   return self.ticks > 0.0 ? self.ticks : self.info.volume;
}

@end

@implementation PFBaseDayQuote

@synthesize ticksPreMarket;
@synthesize ticksAfterMarket;
@synthesize volumePreMarket;
@synthesize volumeAfterMarket;

+(PFBaseQuote*)agregatedQuoteWithQuotes:( NSArray* )quotes_
{
   PFBaseDayQuote* agregated_quote_ = [ PFBaseDayQuote new ];
   
   for ( PFBaseDayQuote* quote_ in quotes_ )
   {
      agregated_quote_.openInterest += quote_.openInterest;
      agregated_quote_.ticks += quote_.ticks;
      agregated_quote_.volume += quote_.volume;
      agregated_quote_.ticksPreMarket += quote_.ticksPreMarket;
      agregated_quote_.ticksAfterMarket += quote_.ticksAfterMarket;
      agregated_quote_.volumePreMarket += quote_.volumePreMarket;
      agregated_quote_.volumeAfterMarket += quote_.volumeAfterMarket;
   }
   
   return agregated_quote_;
}

@end

@implementation PFTickTradesQuote

@synthesize info = _info;

-(NSString*)description
{
   return [ NSString stringWithFormat: @"date: %@; %@", self.date, self.info ];
}

-(PFBool)isValid
{
   return self.info.isValid;
}

@end

@implementation PFTickLotsQuote

@synthesize bidInfo = _bidInfo;
@synthesize askInfo = _askInfo;

-(NSString*)description
{
   return [ NSString stringWithFormat: @"date: %@; bid: {%@}; ask: {%@}", self.date, self.bidInfo, self.askInfo ];
}

-(PFBool)isValid
{
   return self.bidInfo.isValid && self.askInfo.isValid;
}

@end

@implementation PFQuoteInfo

@synthesize open;
@synthesize close;

@synthesize high;
@synthesize low;

@synthesize volume;

-(NSString*)description
{
   return [ NSString stringWithFormat: @"open: %f, close: %f, high: %f, low: %f, volume: %lld", self.open, self.close, self.high, self.low, self.volume ];
}

-(PFBool)isValid
{
   return self.open > 0.0 && self.close > 0.0 && self.high > 0.0 && self.low > 0.0;
}

@end

@implementation PFTradesMinQuote

@synthesize info = _info;

-(NSString*)description
{
   return [ NSString stringWithFormat: @"date: %@; %@", self.date, self.info ];
}

-(PFBool)isValid
{
   return self.info.isValid;
}

-(double)quoteVolume
{
   return self.volume > 0.0 ? self.volume : self.info.volume;
}

+(PFBaseQuote*)agregatedQuoteWithQuotes:( NSArray* )quotes_
{
   PFTradesMinQuote* agregated_quote_ = [ PFTradesMinQuote new ];
   PFBaseQuote* first_quote_ = [ quotes_ objectAtIndex: 0 ];
   PFBaseQuote* last_quote_ = [ quotes_ lastObject ];
   
   agregated_quote_.info = [ PFQuoteInfo new ];
   agregated_quote_.info.open = first_quote_.info.open;
   agregated_quote_.info.high = first_quote_.info.high;
   agregated_quote_.info.low = first_quote_.info.low;
   agregated_quote_.info.close = last_quote_.info.close;
   
   for ( PFTradesMinQuote* quote_ in quotes_ )
   {
      agregated_quote_.openInterest += quote_.openInterest;
      agregated_quote_.ticks += quote_.ticks;
      agregated_quote_.volume += quote_.volume;
      
      if ( quote_.info.high > agregated_quote_.info.high )
         agregated_quote_.info.high = quote_.info.high;
      
      if ( quote_.info.low < agregated_quote_.info.low )
         agregated_quote_.info.low = quote_.info.low;
   }
   
   return agregated_quote_;
}

@end

@implementation PFLotsMinQuote

@synthesize bidInfo = _bidInfo;
@synthesize askInfo = _askInfo;

-(PFQuoteInfo*)info
{
   return self.bidInfo;
}

-(PFBool)isValid
{
   return self.bidInfo.isValid && self.askInfo.isValid;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"date: %@; bid: {%@}; ask: {%@}", self.date, self.bidInfo, self.askInfo ];
}

+(PFBaseQuote*)agregatedQuoteWithQuotes:( NSArray* )quotes_
{
   PFLotsMinQuote* agregated_quote_ = [ PFLotsMinQuote new ];
   PFLotsMinQuote* first_quote_ = [ quotes_ objectAtIndex: 0 ];
   PFLotsMinQuote* last_quote_ = [ quotes_ lastObject ];
   
   agregated_quote_.bidInfo = [ PFQuoteInfo new ];
   agregated_quote_.bidInfo.open = first_quote_.bidInfo.open;
   agregated_quote_.bidInfo.high = first_quote_.bidInfo.high;
   agregated_quote_.bidInfo.low = first_quote_.bidInfo.low;
   agregated_quote_.bidInfo.close = last_quote_.bidInfo.close;
   
   agregated_quote_.askInfo = [ PFQuoteInfo new ];
   agregated_quote_.askInfo.open = first_quote_.askInfo.open;
   agregated_quote_.askInfo.high = first_quote_.askInfo.high;
   agregated_quote_.askInfo.low = first_quote_.askInfo.low;
   agregated_quote_.askInfo.close = last_quote_.askInfo.close;
   
   for ( PFLotsMinQuote* quote_ in quotes_ )
   {
      agregated_quote_.openInterest += quote_.openInterest;
      agregated_quote_.ticks += quote_.ticks;
      agregated_quote_.volume += quote_.volume;
      
      if ( quote_.bidInfo.high > agregated_quote_.bidInfo.high )
         agregated_quote_.bidInfo.high = quote_.bidInfo.high;
      
      if ( quote_.bidInfo.low < agregated_quote_.bidInfo.low )
         agregated_quote_.bidInfo.low = quote_.bidInfo.low;
      
      if ( quote_.askInfo.high > agregated_quote_.askInfo.high )
         agregated_quote_.askInfo.high = quote_.askInfo.high;
      
      if ( quote_.askInfo.low < agregated_quote_.askInfo.low )
         agregated_quote_.askInfo.low = quote_.askInfo.low;
   }
   
   return agregated_quote_;
}

@end

@implementation PFTradesDayQuote

@synthesize info = _info;
@synthesize infoTotal = _infoTotal;

-(NSString*)description
{
   return [ NSString stringWithFormat: @"date: %@; %@", self.date, self.info ];
}

-(PFBool)isValid
{
   return self.info.isValid;
}

-(double)quoteVolume
{
   return self.volume > 0.0 ? self.volume : self.info.volume;
}

+(PFBaseQuote*)agregatedQuoteWithQuotes:( NSArray* )quotes_
{
   PFTradesDayQuote* agregated_quote_ = [ PFTradesDayQuote new ];
   PFTradesDayQuote* first_quote_ = [ quotes_ objectAtIndex: 0 ];
   PFTradesDayQuote* last_quote_ = [ quotes_ lastObject ];
   
   agregated_quote_.info = [ PFQuoteInfo new ];
   agregated_quote_.info.open = first_quote_.info.open;
   agregated_quote_.info.high = first_quote_.info.high;
   agregated_quote_.info.low = first_quote_.info.low;
   agregated_quote_.info.close = last_quote_.info.close;
   
   agregated_quote_.infoTotal = [ PFQuoteInfo new ];
   agregated_quote_.infoTotal.open = first_quote_.infoTotal.open;
   agregated_quote_.infoTotal.high = first_quote_.infoTotal.high;
   agregated_quote_.infoTotal.low = first_quote_.infoTotal.low;
   agregated_quote_.infoTotal.close = last_quote_.infoTotal.close;
   
   for ( PFTradesDayQuote* quote_ in quotes_ )
   {
      agregated_quote_.openInterest += quote_.openInterest;
      agregated_quote_.ticks += quote_.ticks;
      agregated_quote_.volume += quote_.volume;
      agregated_quote_.ticksPreMarket += quote_.ticksPreMarket;
      agregated_quote_.volumePreMarket += quote_.volumePreMarket;
      agregated_quote_.ticksAfterMarket += quote_.ticksAfterMarket;
      agregated_quote_.volumeAfterMarket += quote_.volumeAfterMarket;
      
      if ( quote_.info.high > agregated_quote_.info.high )
         agregated_quote_.info.high = quote_.info.high;
      
      if ( quote_.info.low < agregated_quote_.info.low )
         agregated_quote_.info.low = quote_.info.low;
      
      if ( quote_.infoTotal.high > agregated_quote_.infoTotal.high )
         agregated_quote_.infoTotal.high = quote_.infoTotal.high;
      
      if ( quote_.infoTotal.low < agregated_quote_.infoTotal.low )
         agregated_quote_.infoTotal.low = quote_.infoTotal.low;
   }
   
   return agregated_quote_;
}

@end

@implementation PFLotsDayQuote

@synthesize bidInfo = _bidInfo;
@synthesize bidInfoTotal = _bidInfoTotal;
@synthesize askInfo = _askInfo;
@synthesize askInfoTotal = _askInfoTotal;

-(PFQuoteInfo*)info
{
   return self.bidInfo;
}

-(PFQuoteInfo*)infoTotal
{
   return self.bidInfoTotal;
}

-(PFBool)isValid
{
   return self.bidInfo.isValid && self.askInfo.isValid;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"date: %@; bid: {%@}; ask: {%@}", self.date, self.bidInfo, self.askInfo ];
}

+(PFBaseQuote*)agregatedQuoteWithQuotes:( NSArray* )quotes_
{
   PFLotsDayQuote* agregated_quote_ = [ PFLotsDayQuote new ];
   PFLotsDayQuote* first_quote_ = [ quotes_ objectAtIndex: 0 ];
   PFLotsDayQuote* last_quote_ = [ quotes_ lastObject ];
   
   agregated_quote_.bidInfo = [ PFQuoteInfo new ];
   agregated_quote_.bidInfo.open = first_quote_.bidInfo.open;
   agregated_quote_.bidInfo.high = first_quote_.bidInfo.high;
   agregated_quote_.bidInfo.low = first_quote_.bidInfo.low;
   agregated_quote_.bidInfo.close = last_quote_.bidInfo.close;
   
   agregated_quote_.bidInfoTotal = [ PFQuoteInfo new ];
   agregated_quote_.bidInfoTotal.open = first_quote_.bidInfoTotal.open;
   agregated_quote_.bidInfoTotal.high = first_quote_.bidInfoTotal.high;
   agregated_quote_.bidInfoTotal.low = first_quote_.bidInfoTotal.low;
   agregated_quote_.bidInfoTotal.close = last_quote_.bidInfoTotal.close;
   
   agregated_quote_.askInfo = [ PFQuoteInfo new ];
   agregated_quote_.askInfo.open = first_quote_.askInfo.open;
   agregated_quote_.askInfo.high = first_quote_.askInfo.high;
   agregated_quote_.askInfo.low = first_quote_.askInfo.low;
   agregated_quote_.askInfo.close = last_quote_.askInfo.close;
   
   agregated_quote_.askInfoTotal = [ PFQuoteInfo new ];
   agregated_quote_.askInfoTotal.open = first_quote_.askInfoTotal.open;
   agregated_quote_.askInfoTotal.high = first_quote_.askInfoTotal.high;
   agregated_quote_.askInfoTotal.low = first_quote_.askInfoTotal.low;
   agregated_quote_.askInfoTotal.close = last_quote_.askInfoTotal.close;
   
   for ( PFLotsDayQuote* quote_ in quotes_ )
   {
      agregated_quote_.openInterest += quote_.openInterest;
      agregated_quote_.ticks += quote_.ticks;
      agregated_quote_.volume += quote_.volume;
      agregated_quote_.ticksPreMarket += quote_.ticksPreMarket;
      agregated_quote_.volumePreMarket += quote_.volumePreMarket;
      agregated_quote_.ticksAfterMarket += quote_.ticksAfterMarket;
      agregated_quote_.volumeAfterMarket += quote_.volumeAfterMarket;
      
      if ( quote_.bidInfo.high > agregated_quote_.bidInfo.high )
         agregated_quote_.bidInfo.high = quote_.bidInfo.high;
      
      if ( quote_.bidInfo.low < agregated_quote_.bidInfo.low )
         agregated_quote_.bidInfo.low = quote_.bidInfo.low;
      
      if ( quote_.bidInfoTotal.high > agregated_quote_.bidInfoTotal.high )
         agregated_quote_.bidInfoTotal.high = quote_.bidInfoTotal.high;
      
      if ( quote_.bidInfoTotal.low < agregated_quote_.bidInfoTotal.low )
         agregated_quote_.bidInfoTotal.low = quote_.bidInfoTotal.low;
      
      if ( quote_.askInfo.high > agregated_quote_.askInfo.high )
         agregated_quote_.askInfo.high = quote_.askInfo.high;
      
      if ( quote_.askInfo.low < agregated_quote_.askInfo.low )
         agregated_quote_.askInfo.low = quote_.askInfo.low;
      
      if ( quote_.askInfoTotal.high > agregated_quote_.askInfoTotal.high )
         agregated_quote_.askInfoTotal.high = quote_.askInfoTotal.high;
      
      if ( quote_.askInfoTotal.low < agregated_quote_.askInfoTotal.low )
         agregated_quote_.askInfoTotal.low = quote_.askInfoTotal.low;
   }
   
   return agregated_quote_;
}

@end

@implementation PFBaseQuote (PFQuoteInfo)

-(PFQuoteInfo*)info
{
   return nil;
}

-(double)quoteVolume
{
   return 0.0;
}

@end

@implementation PFBaseDayQuote (PFQuoteInfo)

-(PFQuoteInfo*)infoTotal
{
   return nil;
}

@end
