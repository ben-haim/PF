#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@interface PFBaseQuote : NSObject

@property ( nonatomic, strong ) NSDate* date;
@property ( nonatomic, assign, readonly ) PFBool isValid;

@end

@interface PFTickQuoteInfo : NSObject

@property ( nonatomic, assign ) PFDouble  price;
@property ( nonatomic, assign ) PFLong volume;
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

@interface PFTradesQuote : PFBaseQuote

@property ( nonatomic, strong ) PFQuoteInfo* info;

@end

@interface PFLotsQuote : PFBaseQuote

@property ( nonatomic, strong ) PFQuoteInfo* bidInfo;
@property ( nonatomic, strong ) PFQuoteInfo* askInfo;

@end

@interface PFBaseQuote (PFQuoteInfo)

-(PFQuoteInfo*)info;

@end
