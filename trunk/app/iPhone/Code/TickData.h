#import <Foundation/Foundation.h>

@interface TickData : NSObject 

@property( nonatomic, retain) NSString *Symbol;
@property( nonatomic, retain) NSString *Bid;
@property( nonatomic, retain) NSString *Ask;
@property( nonatomic, retain) NSDate *lastUpdate;
@property( assign) int direction;
@property( nonatomic, retain) NSString *Max;
@property( nonatomic, retain) NSString *Min;

@end

@protocol PFQuote;

@interface TickData (PFQuote)

+(id)tickDataWithQuote:( id< PFQuote > )quote_;

@end