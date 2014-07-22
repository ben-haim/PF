#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

static double PFMillion = 1000000.0;
static double PFThousand = 1000.0;

@implementation NSString (DoubleFormatter)

+(id)stringWithDouble:( double )double_
            precision:( NSUInteger )precision_
{
   if ( precision_ == 0 )
   {
      return [ self stringWithFormat: @"%d", ( int )ceil(double_) ];
   }

   NSString* double_format_ = [ NSString stringWithFormat: @"%%0.%df", (uint)precision_ ];
   return [ self stringWithFormat: double_format_, double_ ];
}

+(id)stringWithMoney:( double )money_
{
    return [self stringWithMoney:money_ andPrecision: 0];
}

+(id)stringWithMoney:( double )money_
        andPrecision:( NSUInteger )precision_
{
    static NSNumberFormatter* money_formatter_ = nil;

    if ( !money_formatter_ )
    {
        money_formatter_ = [ [ NSNumberFormatter alloc ] init ];
        money_formatter_.numberStyle = NSNumberFormatterDecimalStyle;
        money_formatter_.groupingSeparator = @" ";
        money_formatter_.usesGroupingSeparator = YES;
        money_formatter_.decimalSeparator = @".";
        money_formatter_.alwaysShowsDecimalSeparator = YES;
    }

    if (precision_ == 0)
        precision_ = 2;

    double step = pow(10.0, precision_);
    double abs_money_round_ = fabs(round(money_ * step) / step);
    double floor_money_ = floor(abs_money_round_);

    NSString* integer_part_ = [ money_formatter_ stringFromNumber: [ NSNumber numberWithDouble: floor_money_ * (money_ >= 0 ? 1 : -1) ] ];
    NSString* double_format_ = [ NSString stringWithFormat: @"%%.%df", (int)precision_ ];
    NSString* real_part_ = [NSString stringWithFormat: double_format_, abs_money_round_ - floor_money_ ];

    return [self stringWithFormat: @"%@%@", integer_part_, [real_part_ substringFromIndex: 2]];
}

+(id)stringWithPrice:( double )price_
              symbol:( id< PFSymbol > )symbol_
{
   if ( price_ == 0.0 )
      return @"-";

   return [ self stringWithDouble: price_ precision: symbol_.precision ];
}

+(id)stringWithAmount:( double )amount_
               symbol:( id< PFSymbol > )symbol_
{
   int precision_ = 1;
   
   if ( symbol_.lotStep != 0.0 )
   {
      int symbol_precision_ = -log10( symbol_.lotStep );
      
      if ( symbol_precision_ > 1)
      {
         precision_ = symbol_precision_;
      }
   }
   
   return [ NSString stringWithDouble: amount_
                            precision: precision_ ];
}

+(id)stringWithAmount:( double )amount_
{
   NSNumberFormatter* nf_ = [ NSNumberFormatter new ];

   [ nf_ setMaximumFractionDigits: 8 ];
   [ nf_ setMinimumIntegerDigits: 1 ];
   [ nf_ setUsesSignificantDigits: NO ];

   return [ nf_ stringFromNumber: [ NSNumber numberWithDouble: amount_ ] ];
}

+(id)stringWithVolume:( double )volume_
{
   if ( volume_ >= PFMillion )
   {
      return [ NSString stringWithFormat: @"%.1f M", volume_ / PFMillion ];
   }
   else if ( volume_ >= PFThousand )
   {
      return [ NSString stringWithFormat: @"%.1f K", volume_ / PFThousand ];
   }
   
   return [ NSString stringWithFormat: @"%lld", (long long)volume_ ];
}

+(id)stringWithPercent:( double )volume_
{
   return [ self stringWithPercent: volume_
                   showPercentSign: NO ];
}

+(id)stringWithPercent:( double )volume_
       showPercentSign:( BOOL )percent_sign_
{
   NSString* formatted_string_ = [ self stringWithDouble: volume_ precision: 2 ];
   if ( percent_sign_ )
   {
      return [ formatted_string_ stringByAppendingFormat: @" %%" ];
   }
   
   return formatted_string_;
}

@end
