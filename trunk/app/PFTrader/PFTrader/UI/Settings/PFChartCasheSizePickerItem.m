#import "PFChartCasheSizePickerItem.h"

@implementation PFChartCasheSizePickerItem

@synthesize chartCasheLimit;

-(id)initWithChartCasheLimit:( double )cashe_limit_
{
   self = [ super initWithAction: nil title: NSLocalizedString( @"CHART_CASHE_SIZE", nil ) ];
   if ( self )
   {
      if ( cashe_limit_ == 10.0 )
      {
         self.currentChoice = 0;
      }
      else if ( cashe_limit_ == 50.0 )
      {
         self.currentChoice = 1;
      }
      else if (cashe_limit_ == 100.0 )
      {
         self.currentChoice = 2;
      }
      else if ( cashe_limit_ == 500.0 )
      {
         self.currentChoice = 3;
      }

      self.choices = @[ NSLocalizedString( @"10 MB", nil )
                        , NSLocalizedString( @"50 MB", nil )
                        , NSLocalizedString( @"100 MB", nil )
                        , NSLocalizedString( @"500 MB", nil )
                        ];
   }
   return self;
}

-(double)chartCasheLimit
{
   switch ( self.currentChoice )
   {
      case 1:
         return 50.0;
         
      case 2:
         return 100.0;
         
      case 3:
         return 500.0;
         
      default:
         return 10.0;
   }
}

@end
