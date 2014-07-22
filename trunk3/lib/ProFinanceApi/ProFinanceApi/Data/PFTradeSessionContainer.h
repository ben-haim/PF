#import "Detail/PFObject.h"
#import "PFHolidays.h"

@protocol PFTradeSession;

@protocol PFTradeSessionContainer < NSObject >

-(NSString*)name;
-(NSArray*)tradeSessions;
-(PFBool)isIntraday;
-(id< PFTradeSession >)currentTradeSession;
-(PFHolidays*)currentHolliday;
-(PFHolidays*)currentHollidayFromDate: (NSDate*)date_;
-(NSDate*)nextDateHolliday;

@end

@interface PFTradeSessionContainer : PFObject < PFTradeSessionContainer >

@property ( nonatomic, assign, readonly ) PFLong tradeSessionContainerId;
@property ( nonatomic, assign, readonly ) PFBool isIntraday;
@property ( nonatomic, strong, readonly ) NSString* name;
@property ( nonatomic, strong, readonly ) NSArray* tradeSessions;

-(void)updateWithContainer:( PFTradeSessionContainer* )container_;

@end
