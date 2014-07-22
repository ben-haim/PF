#import "PFIndicatorSettingsViewController.h"

#import "PFIndicator.h"

#import "PFTableView.h"

#import "PFTableViewCategory+PFIndicatorLine.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFIndicatorSettingsViewController ()

@property ( nonatomic, strong ) PFIndicator* indicator;

@end

@implementation PFIndicatorSettingsViewController

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

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   self.tableView.categories = [ self.indicator.lines map: ^id( id line_ )
                                {
                                   return [ PFTableViewCategory categoryWithLine: ( PFIndicatorLine* )line_ ];
                                }];

   [ self.tableView reloadData ];
}

@end
