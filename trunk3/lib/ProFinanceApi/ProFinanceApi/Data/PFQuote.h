#import "../PFTypes.h"

#import "PFSymbolConnection.h"

#import "Detail/PFSymbolId.h"

#import <Foundation/Foundation.h>

typedef enum
{
   PFQuoteGrowthUndefined
   , PFQuoteGrowthEqual
   , PFQuoteGrowthUp
   , PFQuoteGrowthDown
} PFQuoteGrowthType;

typedef enum
{
   PFQuoteBarTypeBid,
   PFQuoteBarTypeTrade,
   PFQuoteBarTypeAsk
} PFQuoteBarType;

@protocol PFInstrument;

@protocol PFQuote <PFSymbolId>

-(PFDouble)bid;
-(PFDouble)ask;

-(PFDouble)open;
-(PFDouble)close;
-(PFDouble)high;
-(PFDouble)low;

-(PFDouble)bidOpen;
-(PFDouble)bidClose;
-(PFDouble)bidHigh;
-(PFDouble)bidLow;

-(PFDouble)askOpen;
-(PFDouble)askClose;
-(PFDouble)askHigh;
-(PFDouble)askLow;

-(PFDouble)last;

-(PFDouble)previousClose;

-(PFDouble)bidSize;
-(PFDouble)askSize;

-(PFDouble)bidAmount;
-(PFDouble)askAmount;

-(PFDouble)volume;

-(NSDate*)date;
-(NSDate*)localDate;

-(PFDouble)crossPrice;

-(PFDouble)prevSettlementPrice;
-(PFDouble)settlementPrice;

-(PFQuoteGrowthType)growthType;
-(PFLong)openInterest;

-(NSString*)symbolName;

-(id<PFInstrument>)instrument;

@end

@class PFSymbol;

@interface PFQuote : PFSymbolId< PFQuote, PFSymbolConnection >

@property ( nonatomic, assign ) PFDouble bid;
@property ( nonatomic, assign ) PFDouble ask;

@property ( nonatomic, assign ) PFDouble open;
@property ( nonatomic, assign ) PFDouble close;
@property ( nonatomic, assign ) PFDouble high;
@property ( nonatomic, assign ) PFDouble low;

@property ( nonatomic, assign ) PFDouble bidOpen;
@property ( nonatomic, assign ) PFDouble bidClose;
@property ( nonatomic, assign ) PFDouble bidHigh;
@property ( nonatomic, assign ) PFDouble bidLow;

@property ( nonatomic, assign ) PFDouble askOpen;
@property ( nonatomic, assign ) PFDouble askClose;
@property ( nonatomic, assign ) PFDouble askHigh;
@property ( nonatomic, assign ) PFDouble askLow;

@property ( nonatomic, assign ) PFDouble last;
@property ( nonatomic, assign ) PFDouble previousClose;

@property ( nonatomic, assign ) PFDouble bidSize;
@property ( nonatomic, assign ) PFDouble askSize;

@property ( nonatomic, assign ) PFDouble volume;

@property ( nonatomic, assign ) PFDouble lastSize;

@property ( nonatomic, strong ) NSDate* date;
@property ( nonatomic, strong ) NSDate* localDate;

@property ( nonatomic, assign ) PFDouble crossPrice;

@property ( nonatomic, assign ) PFDouble prevSettlementPrice;
@property ( nonatomic, assign ) PFDouble settlementPrice;
@property ( nonatomic, assign ) PFLong openInterest;

@property ( nonatomic, assign, readonly ) PFQuoteGrowthType growthType;
@property ( nonatomic, strong, readonly ) NSString* symbolName;

@end
