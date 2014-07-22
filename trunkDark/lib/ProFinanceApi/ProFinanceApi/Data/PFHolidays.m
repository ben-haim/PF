#import "PFHolidays.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

@interface PFHolidays ()

@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, assign ) PFInteger expDay;
@property ( nonatomic, assign ) PFInteger expMonth;
@property ( nonatomic, assign ) PFInteger expYear;
@property ( nonatomic, assign ) PFHolidaysDayType dayType;

@end

@implementation PFHolidays

@synthesize name;
@synthesize expDay;
@synthesize expMonth;
@synthesize expYear;
@synthesize dayType;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects:
              [ PFMetaObjectField fieldWithId: PFFieldExpDay name: @"expDay" ],
              [ PFMetaObjectField fieldWithId: PFFieldExpMonth name: @"expMonth" ],
              [ PFMetaObjectField fieldWithId: PFFieldExpYear name: @"expYear" ],
              [ PFMetaObjectField fieldWithId: PFFieldDayType name: @"dayType" ],
              [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ],
              nil ] ];
}

@end
