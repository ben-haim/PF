#import "PFSymbolHeaderView.h"

#import "UIView+LoadFromNib.h"

@implementation PFSymbolHeaderView

@synthesize topLabel;
@synthesize bottomLabel;

+(id)symbolHeaderView
{
   return [ self viewAsFirstObjectFromNibNamed: NSStringFromClass( [ self class ] ) ];
}

@end
