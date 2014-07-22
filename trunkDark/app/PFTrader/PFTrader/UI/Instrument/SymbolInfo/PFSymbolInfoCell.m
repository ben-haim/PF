#import "PFSymbolInfoCell.h"

@implementation PFSymbolInfoCell

@synthesize nameLabel;
@synthesize valueLabel;

-(void)setName:( NSString* )name_ andValue:( NSString* )value_
{
   self.nameLabel.text = name_;
   self.valueLabel.text = value_;
}

@end
