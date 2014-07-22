#import "PFQuote.h"

#import "PFSymbol.h"
#import "PFInstrument.h"

#import "PFSymbolOptionType.h"

#import "PFMetaObject.h"
#import "PFField.h"
#import "PFMessage.h"
#import "PFQuoteInfo.h"
#import "PFQuoteFile+PFMessage.h"

@interface PFQuote ()

@property ( nonatomic, assign ) PFQuoteGrowthType growthType;
@property ( nonatomic, unsafe_unretained ) PFSymbol* symbol;

@end

@implementation PFQuote

@synthesize bid;
@synthesize ask = _ask;

@synthesize open;
@synthesize close;
@synthesize high;
@synthesize low;

@synthesize bidOpen;
@synthesize bidClose;
@synthesize bidHigh;
@synthesize bidLow;

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

@synthesize prevSettlementPrice;
@synthesize settlementPrice;

@synthesize openInterest;
@synthesize growthType;

@synthesize symbol;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldBid name: @"bid" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAsk name: @"ask" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLastPrice name: @"last" ]
//            , [ PFMetaObjectField fieldWithId: PFFieldPreClose name: @"previousClose" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBidVolume name: @"bidSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAskVolume name: @"askSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldVolumeTotal name: @"volume" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLastSize name: @"lastSize" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDate name: @"date" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCrossPrice name: @"crossPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPrevSettlementPrice name: @"prevSettlementPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSettlementPrice name: @"settlementPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOpenInterest name: @"openInterest" ]
            , [ PFMetaObjectField fieldWithName: @"growthType" ]
            , [ PFMetaObjectField fieldWithName: @"symbol" ]
            , [ PFMetaObjectField fieldWithName: @"askOpen" ]
            , [ PFMetaObjectField fieldWithName: @"bidOpen" ]
            , [ PFMetaObjectField fieldWithName: @"open" ]
            , [ PFMetaObjectField fieldWithName: @"askLow" ]
            , [ PFMetaObjectField fieldWithName: @"bidLow" ]
            , [ PFMetaObjectField fieldWithName: @"low" ]
            , [ PFMetaObjectField fieldWithName: @"askHigh" ]
            , [ PFMetaObjectField fieldWithName: @"bidHigh" ]
            , [ PFMetaObjectField fieldWithName: @"high" ]
            , [ PFMetaObjectField fieldWithName: @"askClose" ]
            , [ PFMetaObjectField fieldWithName: @"bidClose" ]
            , [ PFMetaObjectField fieldWithName: @"close" ]] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   for (PFGroupField* last_bar_group_ in [ field_owner_ groupFieldsWithId: PFGroupQuoteBar ] )
   {
       self.openInterest = [ (PFLongField*)[ last_bar_group_ fieldWithId: PFFieldOpenInterest ] longValue ];
       
      switch ( [ [ last_bar_group_ fieldWithId: PFFieldBarsType ] byteValue ] )
      {
         case PFQuoteBarTypeBid:
         {
            self.bidOpen  = [ [ last_bar_group_ fieldWithId: PFFieldOpen ] doubleValue ];
            self.bidHigh  = [ [ last_bar_group_ fieldWithId: PFFieldHigh ] doubleValue ];
            self.bidLow   = [ [ last_bar_group_ fieldWithId: PFFieldLow ] doubleValue ];
            self.bidClose = [ [ last_bar_group_ fieldWithId: PFFieldClosePrice ] doubleValue ];
            
            if (self.instrument.barType == PFQuoteBarTypeBid)
            {
               self.open = self.bidOpen;
               self.high = self.bidHigh;
               self.low = self.bidLow;
               self.previousClose = self.bidClose;
            }
            break;
         }
            
         case PFQuoteBarTypeTrade:
         {
            self.open  = [ [ last_bar_group_ fieldWithId: PFFieldOpen ] doubleValue ];
            self.high  = [ [ last_bar_group_ fieldWithId: PFFieldHigh ] doubleValue ];
            self.low   = [ [ last_bar_group_ fieldWithId: PFFieldLow ] doubleValue ];
            self.previousClose = [ [ last_bar_group_ fieldWithId: PFFieldClosePrice ] doubleValue ];
            
            break;
         }
            
         case PFQuoteBarTypeAsk:
         {
            self.askOpen  = [ [ last_bar_group_ fieldWithId: PFFieldOpen ] doubleValue ];
            self.askHigh  = [ [ last_bar_group_ fieldWithId: PFFieldHigh ] doubleValue ];
            self.askLow   = [ [ last_bar_group_ fieldWithId: PFFieldLow ] doubleValue ];
            self.askClose = [ [ last_bar_group_ fieldWithId: PFFieldClosePrice ] doubleValue ];
            
            if (self.instrument.barType == PFQuoteBarTypeAsk)
            {
               self.open = self.askOpen;
               self.high = self.askHigh;
               self.low = self.askLow;
               self.previousClose = self.askClose;
            }
            break;
         }
      }
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
   return self.symbol.lotSize == 0.0 ? 0.0 : self.bidSize / self.symbol.lotSize;
}

-(PFDouble)askAmount
{
   return self.symbol.lotSize == 0.0 ? 0.0 : self.askSize / self.symbol.lotSize;
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
