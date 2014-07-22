#import <Foundation/Foundation.h>

@protocol PFSymbol;

@interface NSString (DoubleFormatter)

+(id)stringWithDouble:( double )double_
            precision:( NSUInteger )precision_;

+(id)stringWithMoney:( double )money_;

+(id)stringWithMoney:( double )money_
        andPrecision:( NSUInteger )precision_;

+(id)stringWithPrice:( double )price_
              symbol:( id< PFSymbol > )symbol_;

+(id)stringWithAmount:( double )amount_
               symbol:( id< PFSymbol > )symbol_;

+(id)stringWithAmount:( double )amount_;

+(id)stringWithAmount:( double )amount_
              lotStep:( double )lot_step_;

+(id)stringWithAmount:( double )amount_
            minChange:( double )min_change_;

+(id)stringWithVolume:( double )volume_;

+(id)stringWithPercent:( double )volume_;

+(id)stringWithPercent:( double )volume_
       showPercentSign:( BOOL )percent_sign_;

@end
