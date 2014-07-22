#import "PFQuoteInfo.h"

@implementation PFBaseQuote

@synthesize date = _date;

-(PFBool)isValid
{
   [ self doesNotRecognizeSelector: _cmd ];
   return NO;
}

@end

@implementation PFTickQuoteInfo

@synthesize price;
@synthesize volume;

-(NSString*)description
{
   return [ NSString stringWithFormat: @"price: %f, volume: %lld", self.price, self.volume ];
}

-(PFBool)isValid
{
   return self.price > 0.0;
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

@implementation PFTradesQuote

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

@implementation PFLotsQuote

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

@end

@implementation PFBaseQuote (PFQuoteInfo)

-(PFQuoteInfo*)info
{
   return nil;
}

@end
