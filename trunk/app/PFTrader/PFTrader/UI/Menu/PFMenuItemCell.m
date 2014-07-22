#import "PFMenuItemCell.h"

#import "PFMenuItem.h"

#import "PFBadgeView.h"

#import "UIColor+Skin.h"

@implementation PFMenuItemCell

@synthesize titleLabel;
@synthesize iconView;
@synthesize badgeView;

@synthesize menuItem = _menuItem;

+(id)cell
{
   PFMenuItemCell* cell_ = [ super cell ];
   cell_.selectedBackgroundView.backgroundColor = [ UIColor mainHighlightedBackgroundColor ];
   return cell_;
}

-(void)setMenuItem:( PFMenuItem* )menu_item_
{
   self.titleLabel.text = menu_item_.title;
   self.iconView.image = menu_item_.icon;

   self.badgeView.badgeValue = [ NSString stringWithFormat: @"%d", (int)menu_item_.badgeValue ];
   self.accessoryView = menu_item_.badgeValue > 0 ? self.badgeView : nil;

   _menuItem = menu_item_;
}

@end
