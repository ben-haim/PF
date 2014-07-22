#import "Detail/PFObject.h"

typedef enum
{
   PFHolidaysDayTypeNotWorking,
   PFHolidaysDayTypeShorted,
   PFHolidaysDayTypeWorking
} PFHolidaysDayType;

@protocol PFHolidays < NSObject >

-(NSString*)name;
-(PFInteger)expDay;
-(PFInteger)expMonth;
-(PFInteger)expYear;
-(PFByte)dayType;

@end

@interface PFHolidays : PFObject < PFHolidays >

@property ( nonatomic, strong, readonly ) NSString* name;
@property ( nonatomic, assign, readonly ) PFInteger expDay;
@property ( nonatomic, assign, readonly ) PFInteger expMonth;
@property ( nonatomic, assign, readonly ) PFInteger expYear;
@property ( nonatomic, assign, readonly ) PFHolidaysDayType dayType;

@end
