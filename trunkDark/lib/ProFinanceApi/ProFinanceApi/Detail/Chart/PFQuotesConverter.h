#import "../../PFTypes.h"

#import "../../Data/PFChartPeriodType.h"

#import <Foundation/Foundation.h>

@interface PFQuotesConverter : NSObject

-(NSArray*)arrayByConvertingQuotes:( NSArray* )quotes_
                          fromDate:( NSDate* )from_date_
                        fromPeriod:( PFChartPeriodType )from_period_
                          toPeriod:( PFChartPeriodType )to_period_
                    timeZoneOffset:( PFInteger )time_zone_offset_;

@end
