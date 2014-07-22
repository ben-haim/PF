#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@interface PFBaseQuote : NSObject

@property ( nonatomic, strong ) NSDate* date;
@property ( nonatomic, assign ) PFByte sessionType;
@property ( nonatomic, assign ) PFLong openInterest;
@property ( nonatomic, assign, readonly ) PFBool isValid;

+(PFBaseQuote*)agregatedQuoteWithQuotes:( NSArray* )quotes_;

@end

@interface PFBaseMinuteQuote : PFBaseQuote

@property ( nonatomic, assign ) PFLong ticks;
@property ( nonatomic, assign ) PFLong volume;

@end

@interface PFBaseDayQuote : PFBaseMinuteQuote

@property ( nonatomic, assign ) PFLong ticksPreMarket;
@property ( nonatomic, assign ) PFLong ticksAfterMarket;
@property ( nonatomic, assign ) PFLong volumePreMarket;
@property ( nonatomic, assign ) PFLong volumeAfterMarket;

@end

@interface PFTickQuoteInfo : NSObject

@property ( nonatomic, assign ) PFDouble  price;
@property ( nonatomic, assign ) PFLong volume;
@property ( nonatomic, assign ) NSString* mpId;
@property ( nonatomic, assign ) NSString* exchange;
@property ( nonatomic, assign, readonly ) PFBool isValid;

@end

@interface PFTickTradesQuote : PFBaseQuote

@property ( nonatomic, strong ) PFTickQuoteInfo* info;

@end

@interface PFTickLotsQuote : PFBaseQuote

@property ( nonatomic, strong ) PFTickQuoteInfo* bidInfo;
@property ( nonatomic, strong ) PFTickQuoteInfo* askInfo;

@end

@interface PFQuoteInfo : NSObject

@property ( nonatomic, assign ) PFDouble open;
@property ( nonatomic, assign ) PFDouble close;
@property ( nonatomic, assign ) PFDouble high;
@property ( nonatomic, assign ) PFDouble low;
@property ( nonatomic, assign ) PFLong volume;

@property ( nonatomic, assign, readonly ) PFBool isValid;

@end

@interface PFTradesMinQuote : PFBaseMinuteQuote

@property ( nonatomic, strong ) PFQuoteInfo* info;

@end

@interface PFLotsMinQuote : PFBaseMinuteQuote

@property ( nonatomic, strong ) PFQuoteInfo* bidInfo;
@property ( nonatomic, strong ) PFQuoteInfo* askInfo;

@end

@interface PFTradesDayQuote : PFBaseDayQuote

@property ( nonatomic, strong ) PFQuoteInfo* info;
@property ( nonatomic, strong ) PFQuoteInfo* infoTotal;

@end

@interface PFLotsDayQuote : PFBaseDayQuote

@property ( nonatomic, strong ) PFQuoteInfo* bidInfo;
@property ( nonatomic, strong ) PFQuoteInfo* bidInfoTotal;
@property ( nonatomic, strong ) PFQuoteInfo* askInfo;
@property ( nonatomic, strong ) PFQuoteInfo* askInfoTotal;

@end

@interface PFBaseQuote (PFQuoteInfo)

-(PFQuoteInfo*)info;
-(double)quoteVolume;

@end

@interface PFBaseDayQuote (PFQuoteInfo)

-(PFQuoteInfo*)infoTotal;

@end
