#import <Foundation/Foundation.h>

@class PFMessage;

@interface PFCrossRates : NSObject

+(PFCrossRates*)sharedRates;

-(void)updateWithMessage:( PFMessage* )message_;

-(double)priceForCurrency:( NSString* )base_currency_
               toCurrency:( NSString* )to_currency_;

@end
