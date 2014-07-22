#import "PFChartPeriodTypeConversion.h"

NSString* NSStringFromPFChartPeriodType( PFChartPeriodType period_type_ )
{
   switch ( period_type_ )
   {
      case PFChartPeriodM1:
         return NSLocalizedString( @"M1", nil );
      case PFChartPeriodM5:
         return NSLocalizedString( @"M5", nil );
      case PFChartPeriodM15:
         return NSLocalizedString( @"M15", nil );
      case PFChartPeriodM30:
         return NSLocalizedString( @"M30", nil );
      case PFChartPeriodH1:
         return NSLocalizedString( @"H1", nil );
      case PFChartPeriodH4:
         return NSLocalizedString( @"H4", nil );
      case PFChartPeriodD1:
         return NSLocalizedString( @"D1", nil );
      case PFChartPeriodW1:
         return NSLocalizedString( @"W1", nil );
      case PFChartPeriodMN1:
         return NSLocalizedString( @"MN1", nil );
      case PFChartPeriodTick:
         return NSLocalizedString( @"TICK", nil );
      case PFChartPeriodUndefined:
         ;
   }

   assert( 0 && "undefined period type" );
   return nil;
}

NSDate* PFFromDateForPeriod( PFChartPeriodType period_type_ )
{
   NSInteger days_count_ = 1;

   switch ( period_type_ )
   {
      case PFChartPeriodM1:
      case PFChartPeriodTick:
      case PFChartPeriodUndefined:
         days_count_ = 3;
         break;

      case PFChartPeriodM5:
         days_count_ = 5;
         break;

      case PFChartPeriodM15:
         days_count_ = 10;
         break;

      case PFChartPeriodM30:
      case PFChartPeriodH1:
         days_count_ = 30;
         break;

      case PFChartPeriodH4:
         days_count_ = 90;
         break;

      case PFChartPeriodD1:
         days_count_ = 180;
         break;

      case PFChartPeriodW1:
         days_count_ = 1095;
         break;

      case PFChartPeriodMN1:
         days_count_ = 3650;
         break;
   }

   return [ [ NSDate date ] dateByAddingTimeInterval: -days_count_ * 24 * 60 * 60 ];
}

