#import "PFChartColorSchemeTableItem.h"

@implementation PFChartColorSchemeTableItem

-(id)initWithSchemeType:( PFChartColorSchemeType )scheme_type_
{
   self = [ super initWithAction: nil title: NSLocalizedString( @"CHART_COLOR_SCHEME", nil ) ];
   if ( self )
   {
      self.currentChoice = scheme_type_;
      self.choices = @[ NSLocalizedString( @"CHART_SCHEME_DARK", nil )
         , NSLocalizedString( @"CHART_SCHEME_LITE", nil )
         , NSLocalizedString( @"CHART_SCHEME_GREEN", nil )
      ];
   }
   return self;
}

-(PFChartColorSchemeType)schemeType
{
   return (PFChartColorSchemeType)self.currentChoice;
}

@end
