#import "PFIndicatorSettingsViewController.h"
#import "PFIndicator.h"
#import "PFTableView.h"
#import "PFTableViewCategory+PFIndicatorLine.h"
#import "PFNavigationController.h"
#import "UIColor+Skin.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFIndicatorSettingsViewController ()

@property ( nonatomic, strong ) PFIndicator* indicator;

@end

@implementation PFIndicatorSettingsViewController

@synthesize closeBlock;
@synthesize indicator;

-(id)initWithIndicator:( PFIndicator* )indicator_
{
   self = [ super init ];
   if ( self )
   {
      self.title = indicator_.title;
      self.indicator = indicator_;
   }
   return self;
}

-(void)done
{
   self.closeBlock();
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   if ( self.closeBlock )
   {
      self.pfNavigationWrapperController.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFCloseButtonModal" ]
                                                                                                                 style: UIBarButtonItemStylePlain
                                                                                                                target: self
                                                                                                                action: @selector( done ) ];
   }

   self.tableView.categories = [ self.indicator.lines map: ^id( id line_ ) { return [ PFTableViewCategory categoryWithLine: ( PFIndicatorLine* )line_ ]; } ];
   self.tableView.backgroundColor = [ UIColor backgroundLightColor ];
   [ self.tableView reloadData ];
}

@end
