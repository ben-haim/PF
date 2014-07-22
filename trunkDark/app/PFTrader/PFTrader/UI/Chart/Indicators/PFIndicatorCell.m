#import "PFIndicatorCell.h"
#import "PFEnabledIndicatorsInfoController.h"
#import "UIColor+Skin.h"

@implementation PFIndicatorCell

@synthesize nameLabel;
@synthesize removeButton;
@synthesize indicator;
@synthesize controller;

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   
   self.nameLabel.textColor = [ UIColor blueTextColor ];
}

-(IBAction)removeAction:( id )sender_
{
   [ self.controller removeIndicator: self.indicator ];
}

@end




