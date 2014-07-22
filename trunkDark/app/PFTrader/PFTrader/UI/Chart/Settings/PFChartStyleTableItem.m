#import "PFChartStyleTableItem.h"

@implementation PFChartStyleTableItem

-(id)initWithStyleType:( PFChartStyleType )style_type_
{
   self = [ super initWithAction: nil title: NSLocalizedString( @"CHART_STYLE_TYPE", nil ) ];
   if ( self )
   {
      self.currentChoice = style_type_;
      self.choices = @[ NSLocalizedString( @"CHART_STYLE_CANDLE", nil )
         , NSLocalizedString( @"CHART_STYLE_BAR", nil )
         , NSLocalizedString( @"CHART_STYLE_LINE", nil )
         , NSLocalizedString( @"CHART_STYLE_AREA", nil )
      ];
   }
   return self;
}

-(PFChartStyleType)styleType
{
   return (PFChartStyleType)self.currentChoice;
}

@end
