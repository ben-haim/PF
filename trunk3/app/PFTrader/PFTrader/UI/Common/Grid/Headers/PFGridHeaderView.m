#import "PFGridHeaderView.h"

#import "UIView+LoadFromNib.h"

@implementation PFGridHeaderView

@synthesize titleLabel;

+(id)headerView
{
   return [ self viewAsFirstObjectFromNibNamed: NSStringFromClass( [ self class ] ) ];
}

@end


@implementation PFDetailGridHeaderView

@synthesize secondTitleLabel;

@end
