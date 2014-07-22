#import "PFTradeSessionDay.h"

#import "PFMetaObject.h"
#import "PFField.h"

@interface PFTradeSessionDay ()

@property ( nonatomic, assign ) NSTimeInterval beginInterval;
@property ( nonatomic, assign ) NSTimeInterval endInterval;

@end

@implementation PFTradeSessionDay

@synthesize dayIndex;
@synthesize beginTime;
@synthesize endTime;
@synthesize beginInterval;
@synthesize endInterval;

@synthesize currentTimeZone = _currentTimeZone;

-(NSDate*)localDateFromDate:( NSDate* )date_
{
   return [ NSDate dateWithTimeInterval: [ NSTimeZone localTimeZone ].secondsFromGMT - self.currentTimeZone.secondsFromGMT sinceDate: date_ ];
}

-(NSDate*)localBeginTime
{
   return [ self localDateFromDate: self.beginTime ];
}

-(NSDate*)localEndTime
{
   return [ self localDateFromDate: self.endTime ];
}

-(void)setCurrentTimeZone:( NSTimeZone* )current_time_zone_
{
   _currentTimeZone = current_time_zone_;
   
   NSCalendar* calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
   NSDate* current_date_ = [ calendar_ dateFromComponents: [ calendar_ components: NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                                         fromDate: [ NSDate date ] ] ];
   
   self.beginTime = [ NSDate dateWithTimeInterval: self.beginInterval sinceDate: current_date_ ];
   self.endTime = [ NSDate dateWithTimeInterval: self.endInterval sinceDate: current_date_ ];
   
}

+(PFMetaObject*)metaObject
{
   PFMetaObjectFieldTransformer time_transformer_ = ^id( id object_, PFFieldOwner* field_owner_, id value_ ) { return @( [ (NSDate*)value_ timeIntervalSince1970 ] ); };
   
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldDayIndex name: @"dayIndex" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionBegin name: @"beginInterval" transformer: time_transformer_ ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionEnd name: @"endInterval" transformer: time_transformer_ ]
            , nil ] ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"day=%d begin=%@ end=%@"
           , self.dayIndex
           , self.beginTime
           , self.endTime ];
}

@end
