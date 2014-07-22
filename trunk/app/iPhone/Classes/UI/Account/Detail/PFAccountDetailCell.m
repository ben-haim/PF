#import "PFAccountDetailCell.h"

#import "UIView+LoadFromNib.h"

@implementation PFAccountDetailCell

@synthesize titleLabel = _titleLabel;
@synthesize valueLabel = _valueLabel;

-(void)dealloc
{
   [ _titleLabel release ];
   [ _valueLabel release ];

   [ super dealloc ];
}

+(id)accountDetailCell
{
   return [ self viewAsFirstObjectFromNibNamed: NSStringFromClass( self ) ];
}

@end
