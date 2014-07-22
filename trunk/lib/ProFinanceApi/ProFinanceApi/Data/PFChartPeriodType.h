#ifndef ProFinanceApi_PFChartPeriodType_h
#define ProFinanceApi_PFChartPeriodType_h

#import "../Detail/PFExport.h"

typedef enum
{
   PFChartPeriodUndefined = -1
   , PFChartPeriodM1 = 0
   , PFChartPeriodM5 = 1
   , PFChartPeriodM15 = 2
   , PFChartPeriodM30 = 9
   , PFChartPeriodH1 = 3
   , PFChartPeriodH4 = 10
   , PFChartPeriodD1 = 4
   , PFChartPeriodW1 = 5
   , PFChartPeriodMN1 = 6
   , PFChartPeriodTick = 8
} PFChartPeriodType;

PF_EXPORT PFChartPeriodType PFBaseChartPeriod( PFChartPeriodType period_type_ );
PF_EXPORT NSTimeInterval NSTimeIntervalFromPFChartPeriodType( PFChartPeriodType period_type_ );
PF_EXPORT NSComparisonResult PFChartPeriodCompare( PFChartPeriodType first_, PFChartPeriodType second_ );
PF_EXPORT BOOL IsMinutePeriod( PFChartPeriodType period );


#endif
