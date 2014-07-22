#import "PFChartPeriodType.h"

NSTimeInterval NSTimeIntervalFromPFChartPeriodType( PFChartPeriodType period_type_ )
{
   switch ( period_type_ )
   {
      case PFChartPeriodM1:
         return 60.0;
      case PFChartPeriodM5:
         return 5.0 * NSTimeIntervalFromPFChartPeriodType( PFChartPeriodM1 );
      case PFChartPeriodM15:
         return 15.0 * NSTimeIntervalFromPFChartPeriodType( PFChartPeriodM1 );
      case PFChartPeriodM30:
         return 30.0 * NSTimeIntervalFromPFChartPeriodType( PFChartPeriodM1 );
      case PFChartPeriodH1:
         return 60.0 * NSTimeIntervalFromPFChartPeriodType( PFChartPeriodM1 );
      case PFChartPeriodH4:
         return 4.0 * NSTimeIntervalFromPFChartPeriodType( PFChartPeriodH1 );
      case PFChartPeriodD1:
         return 24.0 * NSTimeIntervalFromPFChartPeriodType( PFChartPeriodH1 );
      case PFChartPeriodW1:
         return 7.0 * NSTimeIntervalFromPFChartPeriodType( PFChartPeriodD1 );
      case PFChartPeriodMN1:
         return 30.0 * NSTimeIntervalFromPFChartPeriodType( PFChartPeriodD1 );
      case PFChartPeriodTick:
         return 0.0;
      case PFChartPeriodUndefined:
         ;
   }

   assert( 0 && "undefined period type" );
   return 0.0;
}

PFChartPeriodType PFBaseChartPeriod( PFChartPeriodType period_type_ )
{
   if ( PFChartPeriodCompare( period_type_, PFChartPeriodD1 ) != NSOrderedAscending )
      return PFChartPeriodD1;

   return PFChartPeriodM1;
}

NSComparisonResult PFChartPeriodCompare( PFChartPeriodType first_, PFChartPeriodType second_ )
{
   NSTimeInterval difference_ = NSTimeIntervalFromPFChartPeriodType( first_ ) - NSTimeIntervalFromPFChartPeriodType( second_ );
   if ( difference_ > 0.0 )
      return NSOrderedDescending;
   else if ( difference_ < 0.0 )
      return NSOrderedAscending;

   return NSOrderedSame;
}
 BOOL IsMinutePeriod( PFChartPeriodType period )
{
    return period == PFChartPeriodM1||
    period == PFChartPeriodM5||
    period == PFChartPeriodM15||
    period == PFChartPeriodM30;
}
