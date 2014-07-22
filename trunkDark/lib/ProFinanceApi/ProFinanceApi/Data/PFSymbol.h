#import "../PFTypes.h"

#import "Detail/PFSymbolId.h"
#import "PFOrderType.h"

#import <Foundation/Foundation.h>

@protocol PFInstrument;

@protocol PFQuote;
@protocol PFLevel3Quote;
@protocol PFLevel2QuotePackage;
@protocol PFLevel4QuotePackage;

@protocol PFSymbol <PFSymbolId>

-(PFInteger)groupId;

-(NSString*)name;
-(NSString*)overview;
-(NSString*)groupName;
-(NSString*)routeName;
-(NSString*)instrumentName;

-(PFDouble)highLimit;
-(PFDouble)lowLimit;
-(PFDouble)pointSize;
-(PFLong)lotSize;

-(PFDouble)lotStep;
-(PFDouble)minimalLot;

-(PFByte)precision;

-(PFByte)barType;

-(id<PFInstrument>)instrument;

-(id<PFQuote>)quote;
-(id<PFQuote>)realQuote;
-(id<PFLevel3Quote>)tradeQuote;
-(id<PFLevel2QuotePackage>)level2Quotes;
-(id<PFLevel4QuotePackage>)level4Quotes;

-(PFDouble)last;
-(PFDouble)spread;
-(PFDouble)change;
-(PFDouble)changePercent;
-(PFDouble)pipsSize;
-(PFInteger)marginType;
-(PFInteger)instrumentId;
-(PFInteger)baseInstrumentId;
-(PFBool)isForex;
-(PFBool)isFutures;
-(PFBool)isOption;
-(PFBool)allowsTifModification;
-(PFDouble)tickCoast;
-(PFBool)allowsTrading;
-(PFByte)tradeMode;
-(PFDouble)highLimitPrice;
-(PFDouble)lowLimitPrice;
-(PFByte)limitMeasure;

-(NSDate*)lastTradeDate;
-(NSDate*)contractMonthDate;
-(NSDate*)settlementDate;
-(NSDate*)noticeDate;
-(NSDate*)firstTradeDate;
-(NSDate*)autoCloseDate;
-(PFInteger)deliveryStatus;
-(PFBool)isContiniousContract;

-(PFInteger)quoteRouteId;

-(NSArray*)allowedOrderTypes;
-(NSArray*)allowedValiditiesForOrderType:( PFOrderType )order_type_;

@end

@class PFInstrument;
@class PFRoute;
@class PFQuote;
@class PFLevel3Quote;
@class PFLevel2QuotePackage;
@class PFLevel4QuotePackage;

@interface PFSymbol : PFSymbolId< PFSymbol >

@property ( nonatomic, assign, readonly ) PFInteger groupId;

@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong ) NSString* shortName;
@property ( nonatomic, strong, readonly ) NSString* overview;

@property ( nonatomic, assign, readonly ) PFDouble pointSize;
@property ( nonatomic, assign, readonly ) PFLong lotSize;

@property ( nonatomic, assign, readonly ) PFDouble lotStep;
@property ( nonatomic, assign, readonly ) PFDouble minimalLot;

@property ( nonatomic, assign, readonly ) PFByte precision;

@property ( nonatomic, assign, readonly ) PFByte barType;

@property ( nonatomic, assign, readonly ) PFBool isForex;
@property ( nonatomic, assign, readonly ) PFBool isFutures;
@property ( nonatomic, assign, readonly ) PFBool isOption;

@property ( nonatomic, assign, readonly ) PFDouble highLimit;
@property ( nonatomic, assign, readonly ) PFDouble lowLimit;
@property ( nonatomic, assign, readonly ) PFDouble pipsSize;
@property ( nonatomic, assign, readonly ) PFDouble tickCoast;

@property ( nonatomic, assign, readonly ) PFInteger marginType;

@property ( nonatomic, assign, readonly ) PFBool allowsTifModification;

@property ( nonatomic, unsafe_unretained, readonly ) PFInstrument* instrument;

@property ( nonatomic, assign, readonly ) PFInteger quoteRouteId;

@property ( nonatomic, strong ) PFQuote* quote;
@property ( nonatomic, strong ) PFQuote* realQuote;

@property ( nonatomic, strong ) PFLevel3Quote* tradeQuote;
@property ( nonatomic, strong ) PFLevel2QuotePackage* level2Quotes;
@property ( nonatomic, strong ) PFLevel4QuotePackage* level4Quotes;

@property ( nonatomic, strong ) NSDate* lastTradeDate;
@property ( nonatomic, strong ) NSDate* contractMonthDate;
@property ( nonatomic, strong ) NSDate* settlementDate;
@property ( nonatomic, strong ) NSDate* noticeDate;
@property ( nonatomic, strong ) NSDate* firstTradeDate;
@property ( nonatomic, strong ) NSDate* autoCloseDate;
@property ( nonatomic, assign ) PFInteger deliveryStatus;
@property ( nonatomic, assign ) PFBool isContiniousContract;
@property ( nonatomic, assign ) PFByte tradeMode;
@property ( nonatomic, assign ) PFDouble highLimitPrice;
@property ( nonatomic, assign ) PFDouble lowLimitPrice;
@property ( nonatomic, assign ) PFByte limitMeasure;

-(void)connectToInstrument:( PFInstrument* )instrument_;
-(void)disconnectFromInstrument;

@end

@interface NSArray (SymbolsFromInstrument)

+(id)symbolsArrayWithInstrument:( PFInstrument* )instrument_
                          route:( PFRoute* )route_;

@end
