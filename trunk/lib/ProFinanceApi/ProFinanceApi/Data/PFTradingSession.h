#import "../PFTypes.h"

#import "Detail/PFObject.h"

@protocol PFTradingSession < NSObject >

-(NSString*)description;
-(PFInteger)type;
-(NSTimeInterval)beginTime;
-(NSTimeInterval)endTime;

@end

@interface PFTradingSession : PFObject < PFTradingSession >

@property ( nonatomic, strong ) NSString* overview;
@property ( nonatomic, assign ) PFInteger type;
@property ( nonatomic, assign ) NSTimeInterval beginTime;
@property ( nonatomic, assign ) NSTimeInterval endTime;

@end
