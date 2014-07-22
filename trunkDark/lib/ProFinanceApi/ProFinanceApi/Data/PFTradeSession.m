#import "PFTradeSession.h"

#import "PFTradeSessionDay.h"
#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"
#import "PFOrderType.h"

@interface PFTradeSession ()

@property ( nonatomic, assign ) PFLong tradeSessionId;
@property ( nonatomic, assign ) PFBool isIntraday;
@property ( nonatomic, assign ) PFTradeSessionDayPeriodType dayPeriodType;
@property ( nonatomic, assign ) PFTradeSessionPeriodType periodType;
@property ( nonatomic, assign ) PFTradeSessionSubPeriodType subPeriodType;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong ) NSArray* allowedOrderTypes;
@property ( nonatomic, strong ) NSArray* allowedOperations;

@property ( nonatomic, strong ) NSMutableDictionary* mutableSessionDaysDictionary;

@end

@implementation PFTradeSession

@synthesize tradeSessionId;
@synthesize isIntraday;
@synthesize periodType;
@synthesize subPeriodType;
@synthesize dayPeriodType;
@synthesize name;
@synthesize allowedOrderTypes;
@synthesize allowedOperations;
@synthesize currentTimeZone = _currentTimeZone;
@synthesize mutableSessionDaysDictionary = _mutableSessionDaysDictionary;

-(NSArray*)sessionDays
{
   return self.mutableSessionDaysDictionary.allValues;
}

-(void)setCurrentTimeZone:( NSTimeZone* )current_time_zone_
{
   _currentTimeZone = current_time_zone_;
   
   for ( PFTradeSessionDay* session_day_ in self.mutableSessionDaysDictionary.allValues )
   {
      session_day_.currentTimeZone = current_time_zone_;
   }
}

-(id< PFTradeSessionDay >)currentTradeDayWithTypeDay: (BOOL) shorted_day_
{
   NSCalendar* calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
   calendar_.timeZone = self.currentTimeZone;
   
   return (self.mutableSessionDaysDictionary)[@( shorted_day_ ?
           (7) : [ [ calendar_ components: NSWeekdayCalendarUnit fromDate: [ NSDate date ] ] weekday ] - 1  )];
}

-(NSMutableDictionary*)mutableSessionDaysDictionary
{
   if ( !_mutableSessionDaysDictionary )
      _mutableSessionDaysDictionary = [ NSMutableDictionary new ];
   
   return _mutableSessionDaysDictionary;
}

+(PFMetaObject*)metaObject
{
   PFMetaObjectFieldTransformer order_types_transformer_ = ^id ( id object_, PFFieldOwner* field_owner_, id value_ )
   {
      NSArray* allowed_order_types_strings_ = value_;
      NSMutableArray* allowed_order_types_ = [ NSMutableArray new ];
      
      for ( int i = 0; i < allowed_order_types_strings_.count; i++ )
      {
         if ( [ allowed_order_types_strings_[i] isEqualToString: @"1" ] )
         {
            switch ( i )
            {
               case PFOrderManual :
                  [ allowed_order_types_ addObject: @( PFOrderManual ) ];
                  break;
                  
               case PFOrderMarket :
                  [ allowed_order_types_ addObject: @( PFOrderMarket ) ];
                  break;
                  
               case PFOrderStop :
                  [ allowed_order_types_ addObject: @( PFOrderStop ) ];
                  break;
                  
               case PFOrderLimit :
                  [ allowed_order_types_ addObject: @( PFOrderLimit ) ];
                  break;
                  
               case PFOrderStopLimit :
                  [ allowed_order_types_ addObject: @( PFOrderStopLimit ) ];
                  break;
                  
               case PFOrderTrailingStop :
                  [ allowed_order_types_ addObject: @( PFOrderTrailingStop ) ];
                  break;
                  
               case PFOrderOCO :
                  [ allowed_order_types_ addObject: @( PFOrderOCO ) ];
                  break;
            }
         }
      }
      
      return allowed_order_types_;
   };
   
   PFMetaObjectFieldTransformer operation_types_transformer_ = ^id ( id object_, PFFieldOwner* field_owner_, id value_ )
   {
      NSArray* allowed_operations_strings_ = value_;
      NSMutableArray* allowed_operations_ = [ NSMutableArray new ];
      
      for ( int i = 0; i < allowed_operations_strings_.count; i++ )
      {
         if ( [ allowed_operations_strings_[i] isEqualToString: @"1" ] )
         {
            switch ( i )
            {
               case PFTradeSessionAllowedOperationTypeOrderEntry :
                  [ allowed_operations_ addObject: @( PFTradeSessionAllowedOperationTypeOrderEntry ) ];
                  break;
                  
               case PFTradeSessionAllowedOperationTypeModify :
                  [ allowed_operations_ addObject: @( PFTradeSessionAllowedOperationTypeModify ) ];
                  break;
                  
               case PFTradeSessionAllowedOperationTypeCancel :
                  [ allowed_operations_ addObject: @( PFTradeSessionAllowedOperationTypeCancel ) ];
                  break;
            }
         }
      }
      
      return allowed_operations_;
   };
   
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldId name: @"tradeSessionId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionIsIntaday name: @"isIntraday" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionPeriodType name: @"periodType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionSubPeriodType name: @"subPeriodType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionDayPeriod name: @"dayPeriodType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionAllowedOrderTypes name: @"allowedOrderTypes" transformer: order_types_transformer_ ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionAllowedOperations name: @"allowedOperations" transformer: operation_types_transformer_ ]] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   NSArray* trade_session_days_ = [ field_owner_ groupFieldsWithId: PFGroupTradeSessionPeriod ];
   
   for ( PFGroupField* trade_session_day_ in trade_session_days_ )
   {
      PFTradeSessionDay* trade_day_ = [ PFTradeSessionDay objectWithFieldOwner: trade_session_day_.fieldOwner ];
      trade_day_.currentTimeZone = self.currentTimeZone;
      (self.mutableSessionDaysDictionary)[@( trade_day_.dayIndex )] = trade_day_;
   }
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFTradeSession id=%lld name=%@ isIntraday=%@ dayPeriodType=%d periodType=%d subPeriodType=%d tradeSessionDays=%@"
           , self.tradeSessionId
           , self.name
           , self.isIntraday ? @"YES" : @"NO"
           , self.dayPeriodType
           , self.periodType
           , self.subPeriodType
           , self.sessionDays ];
}

@end
