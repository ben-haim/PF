#import "PFSearchCriteria.h"

#import "NSDateFormatter+PFMessage.h"

static NSString* const PFSearchCriteriaFromDate = @"fromDate";
static NSString* const PFSearchCriteriaToDate = @"toDate";
static NSString* const PFSearchCriteriaBegin = @"begin";
static NSString* const PFSearchCriteriaEnd = @"end";
static NSString* const PFSearchCriteriaLogin = @"login";
static NSString* const PFSearchCriteriaUserId = @"userid";
static NSString* const PFSearchCriteriaInstruments = @"instruments";
static NSString* const PFSearchCriteriaOrderId = @"OrderId";
static NSString* const PFSearchCriteriaPositionId = @"PositionId";
static NSString* const PFSearchCriteriaShowLots = @"IsShowLots";
static NSString* const PFSearchCriteriaReportType = @"reporttype";

static NSString* PFSearchCriteriaDefaultValue = @"";
static NSString* PFSearchCriteriaTrueValue = @"true";
static NSString* PFSearchCriteriaFalseValue = @"false";

@interface PFSearchCriteria ()

@property ( nonatomic, strong ) NSMutableDictionary* criteria;
@property ( nonatomic, strong ) NSDateFormatter* dateFormatter;
@property ( nonatomic, assign ) PFInteger serverOffset;

-(NSDate*)serverDateFromDate:( NSDate* )date_;

@end

@implementation PFSearchCriteria

@synthesize tableType;
@synthesize criteria;
@synthesize dateFormatter;
@synthesize serverOffset;
@synthesize fromDateLocal;
@synthesize toDateLocal;

@dynamic fromDate;
@dynamic toDate;
@dynamic login;
@dynamic userId;
@dynamic reportType;
@dynamic showLots;
@dynamic keysAndValues;

-(id)init
{
   return [ self initWithServerOffset: 0 ];
}

-(id)initWithServerOffset:( PFInteger )server_offset_
{
   self = [ super init ];

   if ( self )
   {
      self.criteria = [ NSMutableDictionary dictionaryWithObjectsAndKeys: PFSearchCriteriaDefaultValue, PFSearchCriteriaInstruments
                       , PFSearchCriteriaDefaultValue, PFSearchCriteriaOrderId
                       , @"99", PFSearchCriteriaReportType
                       , PFSearchCriteriaShowLots, PFSearchCriteriaFalseValue
                       , nil
                       ];

      self.serverOffset = server_offset_;
      self.tableType = PFReportTableTypeUndefined;
      self.toDate = [ NSDate date ];

      self.dateFormatter = [ NSDateFormatter searchCriteriaDateFormatter ];
   }

   return self;
}

-(NSDate*)serverDateFromDate:( NSDate* )date_
{
   if ( self.serverOffset == 0 )
      return date_;

   NSCalendar* gregorian_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];

   NSDateComponents* date_components_ = [ gregorian_ components: NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
                                                       fromDate: date_ ];

   [ date_components_ setHour: date_components_.hour + self.serverOffset ];

   return [ gregorian_ dateFromComponents: date_components_ ];
}

-(NSDictionary*)keysAndValues
{
   return self.criteria;
}

-(void)setString:( NSString* )string_ forKey:( NSString* )key_
{
   NSString* not_nil_string_ = string_ ? string_ : PFSearchCriteriaDefaultValue;

   return [ self.criteria setObject: not_nil_string_ forKey: key_ ];
}

-(NSString*)stringForKey:( NSString* )key_
{
   return (self.criteria)[key_];
}

-(NSDate*)dateForKey:( NSString* )key_
{
   NSString* string_ = [ self stringForKey: key_ ];
   if ( [ string_ length ] == 0 )
      return nil;
   
   return [ self.dateFormatter dateFromString: string_ ];
}

-(void)setDate:( NSDate* )date_ forKey:( NSString* )key_
{
   NSString* string_ = date_
      ? [ self.dateFormatter stringFromDate: [ self serverDateFromDate: date_ ] ]
      : nil;

   [ self setString: string_ forKey: key_ ];
}

-(NSDate*)fromDate
{
   return [ self dateForKey: PFSearchCriteriaFromDate ];
}

-(void)setFromDate:( NSDate* )date_
{
   self.fromDateLocal = date_;
   
   [ self setDate: date_ forKey: PFSearchCriteriaFromDate ];
   [ self setDate: date_ forKey: PFSearchCriteriaBegin ];
}

///////////////////////////////////////////////////////////////////////

-(NSDate*)toDate
{
   return [ self dateForKey: PFSearchCriteriaToDate ];
}

-(void)setToDate:( NSDate* )date_
{
   self.toDateLocal = date_;
   
   [ self setDate: date_ forKey: PFSearchCriteriaToDate ];
   [ self setDate: date_ forKey: PFSearchCriteriaEnd ];
}

///////////////////////////////////////////////////////////////////////

-(NSString*)login
{
   return [ self stringForKey: PFSearchCriteriaLogin ];
}

-(void)setLogin:( NSString* )login_
{
   [ self setString: login_ forKey: PFSearchCriteriaLogin ];
}

///////////////////////////////////////////////////////////////////////

-(PFInteger)userId
{
   return (PFInteger)[ [ self stringForKey: PFSearchCriteriaUserId ] integerValue ];
}

-(void)setUserId:( PFInteger )user_id_
{
   [ self setString: [ NSString stringWithFormat: @"%d", user_id_ ]
             forKey: PFSearchCriteriaUserId ];
}

///////////////////////////////////////////////////////////////////////

-(PFInteger)reportType
{
   return (PFInteger)[ [ self stringForKey: PFSearchCriteriaReportType ] integerValue ];
}

-(void)setReportType:( PFInteger )report_type_
{
   [ self setString: [ NSString stringWithFormat: @"%d", report_type_ ]
             forKey: PFSearchCriteriaReportType ];
}

///////////////////////////////////////////////////////////////////////

-(PFBool)showLots
{
   return [ [ self stringForKey: PFSearchCriteriaShowLots ] boolValue ];
}

-(void)setShowLots:( PFBool )show_lots_
{
   [ self setString: show_lots_ ? PFSearchCriteriaTrueValue : PFSearchCriteriaFalseValue
             forKey: PFSearchCriteriaShowLots ];
}

-(NSString*)reportName
{
   NSAssert( self.tableType != PFReportTableTypeUndefined, @"undefined table type" );
   return PFReportNameWithPFReportTableType( self.tableType );
}

@end
