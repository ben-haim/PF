#import "NSDateFormatter+PFMessage.h"

@interface NSLocale (PFMessage)

+(id)serverLocale;

@end

@implementation NSLocale (PFMessage)

+(id)serverLocale
{
   return [ [ self alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
}

@end

@interface NSCalendar (PFMessage)

+(id)serverCalendar;

@end

@implementation NSCalendar (PFMessage)

+(id)serverCalendar
{
   NSCalendar* calendar_ = [ [ self alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
   calendar_.locale = [ NSLocale serverLocale ];
   return calendar_;
}

@end

@implementation NSDateFormatter (PFMessage)

+(id)serverDateFormatterWithTimeZone:( NSTimeZone* )time_zone_
{
   NSDateFormatter* date_formatter_ = [ self new ];

   date_formatter_.timeZone = time_zone_;
   date_formatter_.locale = [ NSLocale serverLocale ];
   date_formatter_.calendar = [ NSCalendar serverCalendar ];

   return date_formatter_;
}

+(id)serverDateFormatter
{
   return [ self serverDateFormatterWithTimeZone:[ NSTimeZone timeZoneWithAbbreviation: @"UTC" ] ];
}

+(id)compileDateFormatter
{
   NSDateFormatter* date_formatter_ = [ self serverDateFormatter ];
   [ date_formatter_ setDateFormat: @"dd.MM.yyyy" ];
   return date_formatter_;
}

+(id)searchCriteriaDateFormatter
{
   NSDateFormatter* date_formatter_ = [ self serverDateFormatter ];
   [ date_formatter_ setDateFormat: @"dd.MM.yyyy HH:mm:ss" ];
   return date_formatter_;
   
}

+(id)expirationDateFormatter
{
   NSDateFormatter* date_formatter_ = [ self serverDateFormatter ];
   [ date_formatter_ setDateFormat: @"dd-MM-yyyy" ];
   return date_formatter_;
}

+(id)dowJonesDateFormatter
{
   NSDateFormatter* date_formatter_ = [ self serverDateFormatter ];
   [ date_formatter_ setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss'Z'" ];
   return date_formatter_;
}

+(id)dowJonesDetailedDateFormatter
{
   NSDateFormatter* date_formatter_ = [ self serverDateFormatter ];
   [ date_formatter_ setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" ];
   return date_formatter_;
}

@end
