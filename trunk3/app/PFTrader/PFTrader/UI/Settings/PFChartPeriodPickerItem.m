#import "PFChartPeriodPickerItem.h"

#import "PFChartPeriodTypeConversion.h"

@implementation PFChartPeriodPickerItem

@synthesize chartPeriod;

-(id)initWithChartPeriod:( PFChartPeriodType )chart_period_
{
   self = [ super initWithAction: nil title: NSLocalizedString( @"CHART_DEFAULT_PERIOD", nil ) ];
   if ( self )
   {
      switch (chart_period_)
      {            
         case PFChartPeriodM5:
            self.currentChoice = 1;
            break;
            
         case PFChartPeriodM15:
            self.currentChoice = 2;
            break;
            
         case PFChartPeriodM30:
            self.currentChoice = 3;
            break;
            
         case PFChartPeriodH1:
            self.currentChoice = 4;
            break;
            
         case PFChartPeriodH4:
            self.currentChoice = 5;
            break;
            
         case PFChartPeriodD1:
            self.currentChoice = 6;
            break;
            
         case PFChartPeriodW1:
            self.currentChoice = 7;
            break;
            
         case PFChartPeriodMN1:
            self.currentChoice = 8;
            break;
            
         default:
            self.currentChoice = 0;
            break;
      }
      
      self.choices = @[ NSStringFromPFChartPeriodType(PFChartPeriodM1)
                        , NSStringFromPFChartPeriodType(PFChartPeriodM5)
                        , NSStringFromPFChartPeriodType(PFChartPeriodM15)
                        , NSStringFromPFChartPeriodType(PFChartPeriodM30)
                        , NSStringFromPFChartPeriodType(PFChartPeriodH1)
                        , NSStringFromPFChartPeriodType(PFChartPeriodH4)
                        , NSStringFromPFChartPeriodType(PFChartPeriodD1)
                        , NSStringFromPFChartPeriodType(PFChartPeriodW1)
                        , NSStringFromPFChartPeriodType(PFChartPeriodMN1)
                        ];
   }
   return self;
}

-(PFChartPeriodType)chartPeriod
{
   switch ( self.currentChoice )
   {
      case 1:
         return PFChartPeriodM5;
         
      case 2:
         return PFChartPeriodM15;
         
      case 3:
         return PFChartPeriodM30;
         
      case 4:
         return PFChartPeriodH1;
         
      case 5:
         return PFChartPeriodH4;
         
      case 6:
         return PFChartPeriodD1;
         
      case 7:
         return PFChartPeriodW1;
         
      case 8:
         return PFChartPeriodMN1;
         
      default:
         return PFChartPeriodM1;
   }
}

@end
