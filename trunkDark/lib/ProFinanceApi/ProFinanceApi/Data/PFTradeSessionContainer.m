#import "PFTradeSessionContainer.h"

#import "PFTradeSession.h"
#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"
#import "PFHolidays.h"

@interface PFTradeSessionContainer ()

@property ( nonatomic, assign ) PFInteger currentTradeSessionId;
@property ( nonatomic, assign ) PFLong tradeSessionContainerId;
@property ( nonatomic, assign ) PFBool isIntraday;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong ) NSTimeZone* currentTimeZone;
@property ( nonatomic, strong ) NSMutableDictionary* mutableTradeSessionsDictionary;
@property ( nonatomic, strong ) NSMutableArray* mutableHolidaysArray;

@end

@implementation PFTradeSessionContainer

@synthesize tradeSessionContainerId;
@synthesize currentTradeSessionId;
@synthesize isIntraday;
@synthesize name;
@synthesize currentTimeZone;
@synthesize mutableTradeSessionsDictionary = _mutableTradeSessionsDictionary;
@synthesize mutableHolidaysArray = _mutableHolidaysArray;

-(NSArray*)tradeSessions
{
   return self.mutableTradeSessionsDictionary.allValues;
}

-(id< PFTradeSession >)currentTradeSession
{
   return (self.mutableTradeSessionsDictionary)[@( self.currentTradeSessionId )];
}

-(NSMutableDictionary*)mutableTradeSessionsDictionary
{
   if ( !_mutableTradeSessionsDictionary )
      _mutableTradeSessionsDictionary = [ NSMutableDictionary new ];
   
   return _mutableTradeSessionsDictionary;
}

-(NSMutableArray*)mutableHolidaysArray
{
   if ( !_mutableHolidaysArray )
      _mutableHolidaysArray = [ NSMutableArray new ];
   
   return _mutableHolidaysArray;
}

+(PFMetaObject*)metaObject
{
   PFMetaObjectFieldTransformer time_zone_transformer_ = ^id ( id object_, PFFieldOwner* field_owner_, id value_ ) { return [ NSTimeZone timeZoneWithName: (NSString*)value_ ]; };
   
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldId name: @"tradeSessionContainerId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTradeSessionCurrentPeriodId name: @"currentTradeSessionId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionIsIntaday name: @"isIntraday" ]
            , [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTimeZoneId name: @"currentTimeZone" transformer: time_zone_transformer_ ]] ];
}

-(PFHolidays*)currentHolliday
{
   return [self currentHollidayFromDate:[NSDate date]];
}

-(PFHolidays*)currentHollidayFromDate: (NSDate*)date_
{
   NSCalendar* calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
   NSDateComponents* today_ = [ calendar_ components: (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate: date_ ];
   
   [self nextDateHolliday];
   
   for ( PFHolidays* holiday_ in self.mutableHolidaysArray )
   {
      if (holiday_.expDay == [today_ day] && holiday_.expMonth == [today_ month] && holiday_.expYear == [today_ year])
         return holiday_;
   }
   return nil;
}

-(NSDate*)nextDateHolliday
{
   NSDateFormatter* formatter_ = [NSDateFormatter new];
   formatter_.dateFormat = @"dd MM yyyy";
   
   NSDate* next_holiday_ = nil;
   NSDate* today_ = [NSDate date];
   
   for ( PFHolidays* holiday_ in self.mutableHolidaysArray )
   {
      NSString* str = [NSString stringWithFormat:@"%.2d %.2d %.4d", holiday_.expDay, holiday_.expMonth, holiday_.expYear ] ;
      NSDate* date_holiday_ = [formatter_ dateFromString: str];
      
      if ( [ [date_holiday_ laterDate:today_] isEqualToDate: today_] )
         continue;
      
      if (!next_holiday_)
      {
         next_holiday_ = date_holiday_;
         continue;
      }
      
      next_holiday_ = [date_holiday_ earlierDate: next_holiday_];
   }
   return next_holiday_;
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{  
   for ( PFGroupField* holiday_group_ in [ field_owner_ groupFieldsWithId: PFGroupHoliday ] )
   {
      PFHolidays* holiday_ = [ PFHolidays objectWithFieldOwner: holiday_group_.fieldOwner ];
      [ self.mutableHolidaysArray addObject: holiday_ ];
   }
   
   for ( PFGroupField* trade_session_group_ in [ field_owner_ groupFieldsWithId: PFGroupSession ] )
   {
      PFTradeSession* trade_session_ = [ PFTradeSession objectWithFieldOwner: trade_session_group_.fieldOwner ];
      
      if ( trade_session_.tradeSessionId > 0 )
      {
         trade_session_.currentTimeZone = self.currentTimeZone;
         (self.mutableTradeSessionsDictionary)[@( trade_session_.tradeSessionId )] = trade_session_;
      }
   }
}

-(void)updateWithContainer:( PFTradeSessionContainer* )container_
{
   if ( container_.currentTradeSessionId != 0 )
   {
      self.currentTradeSessionId = container_.currentTradeSessionId;
   }
   if ( container_.name )
   {
      self.name = container_.name;
   }
   if ( container_.currentTimeZone )
   {
      self.currentTimeZone = container_.currentTimeZone;
   }
   
   if ( container_.mutableTradeSessionsDictionary.count > 0 )
   {
      self.mutableTradeSessionsDictionary = container_.mutableTradeSessionsDictionary;
   }
   if ( container_.mutableHolidaysArray.count > 0 )
   {
      self.mutableHolidaysArray = container_.mutableHolidaysArray;
   }
   
   self.isIntraday = container_.isIntraday;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFTradeSessionContainer id=%lld name=%@ currentTradeSessionId=%d isIntraday=%@ timeZone=%@ tradeSessions=%@"
           , self.tradeSessionContainerId
           , self.name
           , self.currentTradeSessionId
           , self.isIntraday ? @"YES" : @"NO"
           , self.currentTimeZone
           , self.tradeSessions ];
}

@end
