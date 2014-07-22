#import "NSDate+Timestamp.h"

@implementation NSDate (Timestamp)

-(BOOL)isEqualTodayComponents:( NSUInteger )components_
{
   NSCalendar* gregorian_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
   
   NSDateComponents* today_components_ = [ gregorian_ components: components_
                                                        fromDate: [ NSDate date ] ];
   
   NSDateComponents* self_components_ = [ gregorian_ components: components_
                                                       fromDate: self ];
   
   return [ today_components_ isEqual: self_components_ ];
}

-(BOOL)isToday
{
   return [ self isEqualTodayComponents: NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ];
}

-(BOOL)isThisYear
{
   return [ self isEqualTodayComponents: NSYearCalendarUnit ];
}

-(NSString*)shortTimestampString
{
   NSDateFormatter* date_formatter_ = [ NSDateFormatter new ];

   [ date_formatter_ setTimeStyle: NSDateFormatterShortStyle ];

   if ( [ self isToday ] )
   {
      [ date_formatter_ setDateStyle: NSDateFormatterNoStyle ];
   }
   else
   {
      [ date_formatter_ setDateStyle: kCFDateFormatterShortStyle ];
   }

   return [ date_formatter_ stringFromDate: self ];
}

-(NSString*)shortDateString
{
   NSDateFormatter* date_formatter_ = [ NSDateFormatter new ];
   
   [ date_formatter_ setTimeStyle: NSDateFormatterNoStyle ];
   [ date_formatter_ setDateStyle: NSDateFormatterShortStyle ];
   
   return [ date_formatter_ stringFromDate: self ];
}

-(NSString*)shortTimeString
{
   NSDateFormatter* date_formatter_ = [ NSDateFormatter new ];
   
   [ date_formatter_ setTimeStyle: NSDateFormatterShortStyle ];
   [ date_formatter_ setDateStyle: NSDateFormatterNoStyle ];
   
   return [ date_formatter_ stringFromDate: self ];
}

+(NSDate*)GMTNow
{
   return [ NSDate dateWithTimeInterval: - [ [ NSTimeZone localTimeZone ] secondsFromGMT ] sinceDate: [ NSDate date ] ];
}

+(NSDate*)dateFromDateAndTime:( NSDate* )current_
{
   NSCalendar* calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
   
   return [ calendar_ dateFromComponents: [ calendar_ components: NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                        fromDate: current_ ] ];
}

@end
