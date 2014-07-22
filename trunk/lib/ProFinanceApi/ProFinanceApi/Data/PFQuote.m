#import "PFQuote.h"

#import "PFSymbol.h"
#import "PFInstrument.h"

#import "PFSymbolOptionType.h"

#import "PFMetaObject.h"
#import "PFField.h"
#import "PFMessage.h"

@interface PFQuote ()

@property ( nonatomic, assign ) PFQuoteGrowthType growthType;
@property ( nonatomic, weak ) PFSymbol* symbol;

@end

@implementation PFQuote

@synthesize bid;
@synthesize ask = _ask;

@synthesize open;
@synthesize close;

@synthesize high;
@synthesize low;

@synthesize askClose;
@synthesize askHigh;
@synthesize askLow;
@synthesize askOpen;

@synthesize last;
@synthesize previousClose;

@synthesize bidSize;
@synthesize askSize;

@synthesize volume;

@synthesize lastSize;

@synthesize date;
@synthesize localDate;

@synthesize crossPrice;

@synthesize growthType;

@synthesize symbol;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects:  [ PFMetaObjectField fieldWithId: PFFieldBid name: @"bid" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAsk name: @"ask" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOpen name: @"open" ]
            , [ PFMetaObjectField fieldWithId: PFFieldClosePrice name: @"close" ]
            , [ PFMetaObjectField fieldWithId: PFFieldHigh name: @"high" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLow name: @"low" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLastPrice name: @"last" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPreClose name: @"previousClose" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBidSize name: @"bidSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAskSize name: @"askSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldVolumeTotal name: @"volume" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLastSize name: @"lastSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDate name: @"date" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCrossPrice name: @"crossPrice" ]
            , [ PFMetaObjectField fieldWithName: @"growthType" ]
            , [ PFMetaObjectField fieldWithName: @"symbol" ]
            , [ PFMetaObjectField fieldWithName: @"askOpen" ]
            , [ PFMetaObjectField fieldWithName: @"askHigh" ]
            , [ PFMetaObjectField fieldWithName: @"askLow" ]
            , [ PFMetaObjectField fieldWithName: @"askClose" ]
            
            
            , nil ] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   PFGroupField* quote_ask_group_ = [ [ field_owner_ groupFieldsWithId: PFGroupQuoteBar ] lastObject ];
   
   if ( quote_ask_group_ )
   {
      self.askOpen = [ [ quote_ask_group_ fieldWithId: PFFieldOpen ] doubleValue ];
      self.askHigh = [ [ quote_ask_group_ fieldWithId: PFFieldHigh ] doubleValue ];
      self.askLow = [ [ quote_ask_group_ fieldWithId: PFFieldLow ] doubleValue ];
      self.askClose = [ [ quote_ask_group_ fieldWithId: PFFieldClosePrice ] doubleValue ];
   }
}

-(PFQuoteGrowthType)compareWithNewAsk:( PFDouble )ask_
{
   if ( self.ask == 0.0 )
   {
      return PFQuoteGrowthUndefined;
   }
   else if ( ask_ == self.ask )
   {
      return PFQuoteGrowthEqual;
   }
   else if ( ask_ > self.ask )
   {
      return PFQuoteGrowthUp;
   }

   return PFQuoteGrowthDown;
}

-(void)setAsk:( PFDouble )ask_
{
   self.growthType = [ self compareWithNewAsk: ask_ ];
   _ask = ask_;
}

-(PFDouble)bidAmount
{
   return self.symbol.lotSize == 0.0 ? 0.0 : ( PFDouble )self.bidSize / self.symbol.lotSize;
}

-(PFDouble)askAmount
{
   return self.symbol.lotSize == 0.0 ? 0.0 : ( PFDouble )self.askSize / self.symbol.lotSize;
}

-(NSString*)symbolName
{
   return self.symbol.name;
}

-(id<PFInstrument>)instrument
{
   return  self.symbol.instrument;
}

-(void)readFromFieldOwner:( PFFieldOwner* )field_owner_
{
   PFDouble volume_ = self.volume;
   [ super readFromFieldOwner: field_owner_ ];
   self.volume = volume_ + self.lastSize;
}

-(void)connectToSymbol:( PFSymbol* )symbol_
{
   self.symbol = symbol_;
   symbol_.realQuote = self;
}

@end
