#import "PFTableViewCell.h"

#import "UIView+LoadFromNib.h"
#import "PFSystemHelper.h"

@implementation PFTableViewCell

+(id)cell
{
   UITableViewCell* cell_ = [ self viewAsFirstObjectFromNibNamed: NSStringFromClass( [ self class ] ) ];
   cell_.backgroundColor = [ UIColor clearColor ];
   return cell_;
}

-(void)setFrame:(CGRect)frame
{
   static CGFloat ofset_ = 10.f;
   
   if ( useFlatUI() )
   {
      frame.origin.x += ofset_;
      frame.size.width -= 2 * ofset_;
   }
   
   [ super setFrame: frame ];
}


@end
