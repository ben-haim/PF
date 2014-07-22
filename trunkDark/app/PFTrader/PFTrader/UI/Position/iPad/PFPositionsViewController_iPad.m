#import "PFPositionsViewController_iPad.h"
#import "PFPositionsViewController.h"
#import "PFPositionsChartViewController_iPad.h"
#import "PFPositionsInfoView.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFPositionsViewController_iPad () < PFPositionsViewControllerDelegate >

@end

@implementation PFPositionsViewController_iPad

-(id)init
{
   PFPositionsViewController* positions_controller_ = [ PFPositionsViewController new ];
   positions_controller_.delegate = self;
   
   self = [ super initWithMasterController: positions_controller_ ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"POSITIONS", nil );
   }
   
   return self;
}

#pragma mark - PFPositionsViewControllerDelegate

-(void)positionsViewController:( PFPositionsViewController* )controller_
             didSelectPosition:( id< PFPosition > )position_
{
   PFPositionsChartViewController_iPad* positions_chart_ = [ [ PFPositionsChartViewController_iPad alloc ] initWithPosition: position_
                                                                                                                andInfoView: [ PFPositionsInfoView positionsInfoViewWithPosition: position_ ] ];
   
   [ self showDetailController: positions_chart_ ];
}

@end
