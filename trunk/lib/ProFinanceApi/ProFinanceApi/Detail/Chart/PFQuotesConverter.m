#import "PFQuotesConverter.h"

#import "PFQuoteInfo.h"

@implementation PFQuotesConverter

-(NSDate*)startTimeForPeriod:( PFChartPeriodType )period_
                       quote:( PFBaseQuote* )quote_
              timeZoneOffset:( PFInteger )time_zone_offset_
{
   NSCalendar* gregorian_calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];

   if ( PFChartPeriodCompare( period_, PFChartPeriodD1 ) != NSOrderedDescending )
   {
      gregorian_calendar_.timeZone = [ NSTimeZone timeZoneWithName: @"UTC" ];
      
      NSDateComponents* quote_date_components_ =
      [ gregorian_calendar_ components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
                              fromDate: quote_.date ];

      if ( period_ == PFChartPeriodH4 )
         [ quote_date_components_ setHour: (quote_date_components_.hour + time_zone_offset_) ];

      NSTimeInterval seconds_since_day_start_ = 60.0 * quote_date_components_.minute
         + 3600.0 * quote_date_components_.hour;

      NSTimeInterval seconds_in_period_ = NSTimeIntervalFromPFChartPeriodType( period_ );

      NSUInteger period_index_ = seconds_since_day_start_ / seconds_in_period_;

      NSTimeInterval period_seconds_ = period_index_ * seconds_in_period_;
      
      NSUInteger hours_ = (NSUInteger)period_seconds_ / 3600;
   
      if ( period_ == PFChartPeriodH4 )
         hours_ -= time_zone_offset_;

      [ quote_date_components_ setHour: hours_ ];
      [ quote_date_components_ setMinute: (NSUInteger)( period_seconds_ / 60 ) % 60 ];

      return  [ gregorian_calendar_ dateFromComponents: quote_date_components_ ];
   }
   else if ( period_ == PFChartPeriodMN1 )
   {
      return [ gregorian_calendar_ dateFromComponents: [ gregorian_calendar_ components: NSYearCalendarUnit | NSMonthCalendarUnit
                                                                               fromDate: quote_.date ] ];
   }
   else if ( period_ == PFChartPeriodW1 )
   {
      NSDate* rounded_date_ = [ gregorian_calendar_ dateFromComponents: [ gregorian_calendar_ components:  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                                                                fromDate: quote_.date ] ];
      
      // Get the weekday component of the current date
      NSDateComponents* week_day_components_ = [ gregorian_calendar_ components: NSWeekdayCalendarUnit fromDate: rounded_date_ ];
      
      // Create a date components to represent the number of days to subtract from the current date.
      // The weekday value for Monday in the Gregorian calendar is 2, so subtract 2 from the number of days to subtract from the date in question.
      // (If today is Monday, subtract 0 days.)
      NSDateComponents* components_to_subtract_ = [ [ NSDateComponents alloc ] init ];
      [ components_to_subtract_ setDay: - ( [ week_day_components_ weekday ] - 2 ) ];
      
      return [ gregorian_calendar_ dateByAddingComponents: components_to_subtract_ toDate: rounded_date_ options: 0 ];
   }

   return quote_.date;
}

-(NSDate*)endTimeForStartTime:( NSDate* )from_date_ period:( PFChartPeriodType )period_
{
   if ( period_ == PFChartPeriodMN1 )
   {
      NSCalendar* gregorian_calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];

      NSDateComponents* quote_date_components_ = [ gregorian_calendar_ components: NSYearCalendarUnit | NSMonthCalendarUnit
                                                                         fromDate: from_date_ ];

      [ quote_date_components_ setMonth: quote_date_components_.month + 1 ];

      return [ gregorian_calendar_ dateFromComponents: quote_date_components_ ];
      
   }

   NSTimeInterval destination_interval_ = NSTimeIntervalFromPFChartPeriodType( period_ );
   return [ from_date_ dateByAddingTimeInterval: destination_interval_ ];
}


-(PFBaseQuote*)quoteWithQuotes:( NSArray* )quotes_
{
   PFLotsQuote* united_quote_ = [ PFLotsQuote new ];
   if ( quotes_.count == 0 )
      return united_quote_;
   
   if ( [ [ quotes_ lastObject ] isMemberOfClass: [ PFLotsQuote class ] ] )
   {
      united_quote_.bidInfo = [ PFQuoteInfo new ];
      united_quote_.askInfo = [ PFQuoteInfo new ];
      
      PFLotsQuote* first_quote_ = [ quotes_ objectAtIndex: 0 ];
      
      united_quote_.bidInfo.open = first_quote_.bidInfo.open;
      united_quote_.bidInfo.high = first_quote_.bidInfo.high;
      united_quote_.bidInfo.low = first_quote_.bidInfo.low;
      
      united_quote_.askInfo.open = first_quote_.askInfo.open;
      united_quote_.askInfo.high = first_quote_.askInfo.high;
      united_quote_.askInfo.low = first_quote_.askInfo.low;
      
      PFLotsQuote* last_quote_ = [ quotes_ lastObject ];
      united_quote_.bidInfo.close = last_quote_.bidInfo.close;
      united_quote_.askInfo.close = last_quote_.askInfo.close;
      
      for ( PFLotsQuote* current_quote_ in quotes_ )
      {
         if ( current_quote_.bidInfo.high > united_quote_.bidInfo.high )
            united_quote_.bidInfo.high = current_quote_.bidInfo.high;
         
         if ( current_quote_.bidInfo.low < united_quote_.bidInfo.low )
            united_quote_.bidInfo.low = current_quote_.bidInfo.low;
         
         united_quote_.bidInfo.volume += current_quote_.bidInfo.volume;
         
         if ( current_quote_.askInfo.high > united_quote_.askInfo.high )
            united_quote_.askInfo.high = current_quote_.askInfo.high;
         
         if ( current_quote_.askInfo.low < united_quote_.askInfo.low )
            united_quote_.askInfo.low = current_quote_.askInfo.low;
         
         united_quote_.askInfo.volume += current_quote_.askInfo.volume;
      }
   }
   else
   {
      united_quote_.bidInfo = [ PFQuoteInfo new ];
      
      PFBaseQuote* first_quote_ = [ quotes_ objectAtIndex: 0 ];
      
      united_quote_.bidInfo.open = first_quote_.info.open;
      united_quote_.bidInfo.high = first_quote_.info.high;
      united_quote_.bidInfo.low = first_quote_.info.low;
      
      PFBaseQuote* last_quote_ = [ quotes_ lastObject ];
      united_quote_.bidInfo.close = last_quote_.info.close;
      
      for ( PFBaseQuote* current_quote_ in quotes_ )
      {
         if ( current_quote_.info.high > united_quote_.bidInfo.high )
            united_quote_.bidInfo.high = current_quote_.info.high;
         
         if ( current_quote_.info.low < united_quote_.bidInfo.low )
            united_quote_.bidInfo.low = current_quote_.info.low;
         
         united_quote_.bidInfo.volume += current_quote_.info.volume;
      }
   }

   return united_quote_;
}

-(NSArray*)arrayByConvertingQuotes:( NSArray* )quotes_
                          fromDate:( NSDate* )from_date_
                        fromPeriod:( PFChartPeriodType )from_period_
                          toPeriod:( PFChartPeriodType )to_period_
                    timeZoneOffset:( PFInteger )time_zone_offset_
{
   NSComparisonResult period_comparison_result_ = PFChartPeriodCompare( from_period_, to_period_ );
   if ( period_comparison_result_ == NSOrderedSame )
      return quotes_;

   NSAssert( period_comparison_result_ == NSOrderedAscending, @"can't convert from wide period" );

   NSMutableArray* converted_quotes_ = [ NSMutableArray new ];

   NSUInteger from_date_index_ = [ quotes_ indexOfObjectPassingTest:
                                  ^BOOL( id object_, NSUInteger idx, BOOL* stop_ )
                                  {
                                     PFBaseQuote* quote_ = ( PFBaseQuote* )object_;
                                     BOOL later_than_from_date_ = [ quote_.date compare: from_date_ ] != NSOrderedAscending;
                                     *stop_ = later_than_from_date_;
                                     return later_than_from_date_;
                                  }];

   for ( NSUInteger i_ = from_date_index_; i_ < [ quotes_ count ]; )
   {
      PFBaseQuote* quote_ = [ quotes_ objectAtIndex: i_ ];

      NSDate* start_date_ = [ self startTimeForPeriod: to_period_
                                                quote: [ quotes_ objectAtIndex: i_ ]
                                       timeZoneOffset: time_zone_offset_ ];

      NSMutableArray* qoutes_for_interval_ = [ NSMutableArray new ];

      NSDate* end_date_ = [ self endTimeForStartTime: start_date_ period: to_period_ ];

      if(quote_)
      {

      }

      for ( ; i_ < [ quotes_ count ]; ++i_ )
      {
         PFBaseQuote* current_quote_ = [ quotes_ objectAtIndex: i_ ];
   
         if ( [ current_quote_.date compare: end_date_ ] != NSOrderedAscending )
         {
            break;
         }

         [ qoutes_for_interval_ addObject: current_quote_ ];
      }

      PFBaseQuote* united_quote_ = [ self quoteWithQuotes: qoutes_for_interval_ ];
      united_quote_.date = start_date_;
      
      [ converted_quotes_ addObject: united_quote_ ];
   }

   return converted_quotes_;
}

@end
