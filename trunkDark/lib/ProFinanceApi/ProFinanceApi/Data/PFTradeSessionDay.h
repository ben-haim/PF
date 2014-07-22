#import "Detail/PFObject.h"

@protocol PFTradeSessionDay < NSObject >

-(NSDate*)beginTime;
-(NSDate*)endTime;
-(NSDate*)localBeginTime;
-(NSDate*)localEndTime;

@end

@interface PFTradeSessionDay : PFObject < PFTradeSessionDay >

@property ( nonatomic, assign ) PFInteger dayIndex;
@property ( nonatomic, strong ) NSDate* beginTime;
@property ( nonatomic, strong ) NSDate* endTime;
@property ( nonatomic, strong ) NSTimeZone* currentTimeZone;

@end
