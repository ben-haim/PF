#import "HLOCDataSource+PFLotsQuote.h"

#import "PFChartPeriodTypeConversion.h"

//!XiP
#import "ArrayMath.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation HLOCDataSource (PFLotsQuote)

#define minimalBarsOnChart 20

+(id)dataSourceWithQuotes:( NSArray* )quotes_
                   symbol:( id< PFSymbol > )symbol_
                   period:( PFChartPeriodType )period_
{
   NSUInteger capacity_ = [ quotes_ count ];
   if ( capacity_ == 0 )
      return nil;

   if (capacity_ < minimalBarsOnChart)
      capacity_ = minimalBarsOnChart;
   
   int delta_capacity_ = (int)(capacity_ - [quotes_ count]);

   NSUInteger precision_ = symbol_.precision;

   HLOCDataSource* data_source_ = [[self alloc] initWithRangeType: NSTimeIntervalFromPFChartPeriodType( period_ ) / 60.0
                                                        AndDigits: (uint)precision_];

   ArrayMath *v_open  = [[ArrayMath alloc] initWithLength:(uint)capacity_];
   ArrayMath *v_close = [[ArrayMath alloc] initWithLength:(uint)capacity_];
   ArrayMath *v_high  = [[ArrayMath alloc] initWithLength:(uint)capacity_];
   ArrayMath *v_low   = [[ArrayMath alloc] initWithLength:(uint)capacity_];
   ArrayMath *v_vol   = [[ArrayMath alloc] initWithLength:(uint)capacity_];
   ArrayMath *v_time  = [[ArrayMath alloc] initWithLength:(uint)capacity_];
   //basic derivatives
   ArrayMath *v_hl2   = [[ArrayMath alloc] initWithLength:(uint)capacity_];
   ArrayMath *v_hlc3  = [[ArrayMath alloc] initWithLength:(uint)capacity_];
   ArrayMath *v_hlcc4 = [[ArrayMath alloc] initWithLength:(uint)capacity_];

   PFBaseQuote* quote_ = [quotes_ objectAtIndex: 0];
   
   int time_temp;
   double open;
   double high;
   double low;
   double close;
   double vol;
   
   for ( NSUInteger i_ = 0; i_ < capacity_; i_++ )
   {
      if (i_ >= delta_capacity_)
      {
         quote_ = [quotes_ objectAtIndex: i_ - delta_capacity_];
         
         open  = quote_.info.open;
         high  = quote_.info.high;
         low   = quote_.info.low;
         close = quote_.info.close;
         vol   = quote_.quoteVolume;
         time_temp = [quote_.date timeIntervalSince1970];
      }
      else
      {
         open  = NAN;
         high  = NAN;
         low   = NAN;
         close = NAN;
         vol   = NAN;
         time_temp =  0;
      }
      
      //basic derivatives
      double hl2      = (high + low) / 2.0;
      double hlc3     = (high + low + close) / 3.0;
      double hlcc4    = (high + low + 2*close) / 4.0;
      
      [v_open getData][i_] = open;
      [v_close getData][i_] = close;
      [v_high getData][i_] = high;
      [v_low getData][i_] = low;
      [v_vol getData][i_] = vol;
      [v_time getData][i_] = time_temp;
      
      [v_hl2 getData][i_] = hl2;
      [v_hlc3 getData][i_] = hlc3;
      [v_hlcc4 getData][i_] = hlcc4;
   }
   
   [data_source_ SetVector:v_high forKey:@"highData"];
   [data_source_ SetVector:v_low forKey:@"lowData"];
   [data_source_ SetVector:v_open forKey:@"openData"];
   [data_source_ SetVector:v_close forKey:@"closeData"];
   [data_source_ SetVector:v_vol forKey:@"volData"];
   [data_source_ SetVector:v_time forKey:@"timeStamps"];
   
   [data_source_ SetVector:v_hl2 forKey:@"hl2Data"];
   [data_source_ SetVector:v_hlc3 forKey:@"hlc3Data"];
   [data_source_ SetVector:v_hlcc4 forKey:@"hlcc4Data"];

   data_source_.last_bid = data_source_.last_ask = [v_close getData][[v_close getLength]-1];

   return data_source_;
}

@end