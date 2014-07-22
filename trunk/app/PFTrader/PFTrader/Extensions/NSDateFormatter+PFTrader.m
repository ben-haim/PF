#import "NSDateFormatter+PFTrader.h"

@implementation NSDateFormatter (PFTrader)

+(id)portableDateFormatter
{
   NSDateFormatter* formatter_ = [ self new ];
   
   NSLocale* posix_locale_ = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
   formatter_.locale = posix_locale_;
   
   NSCalendar* gregorian_calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
   gregorian_calendar_.locale = posix_locale_;
   formatter_.calendar = gregorian_calendar_;
   return formatter_;
}

+(id)newsDateFormatter
{
   NSDateFormatter* date_formatter_ = [ self portableDateFormatter ];

   [ date_formatter_ setDateFormat: @"HH:mm, dd.MM.yyyy" ];

   return date_formatter_;
}

+(id)chatMessageDateFormatter
{
   NSDateFormatter* date_formatter_ = [ self portableDateFormatter ];

   [ date_formatter_ setDateFormat: @"MMM. d yyyy, HH:mm" ];

   return date_formatter_;
}

+(id)pickerDateFormatter
{
   NSDateFormatter* date_formatter_ = [ self portableDateFormatter ];

   [ date_formatter_ setDateFormat: @"dd.MM.yyyy HH:mm" ];

   return date_formatter_;
}

+(id)pickerDateOnlyFormatter
{
   NSDateFormatter* date_formatter_ = [ self portableDateFormatter ];
   
   [ date_formatter_ setDateFormat: @"dd.MM.yyyy" ];
   
   return date_formatter_;
}

@end
