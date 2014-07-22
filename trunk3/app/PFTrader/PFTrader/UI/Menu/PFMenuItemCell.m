#import "PFMenuItemCell.h"

#import "PFMenuItem.h"

#import "PFBadgeView.h"

@implementation PFMenuItemCell

@synthesize titleLabel;
@synthesize iconView;
@synthesize badgeView;

@synthesize menuItem = _menuItem;

+(id)cell
{
   PFMenuItemCell* cell_ = [ super cell ];
   cell_.selectedBackgroundView.backgroundColor = [ UIColor clearColor ];
   cell_.titleLabel.highlightedTextColor = [ UIColor colorWithRed: 50.f / 255 green: 165.f / 255 blue: 226.f / 255 alpha: 1.f ];
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
