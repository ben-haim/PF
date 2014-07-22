#import "PFMenuCell.h"
#import "PFMenuItem.h"
#import "UIView+LoadFromNib.h"
#import "PFNavigationController.h"
#import "PFBadgeView.h"
#import "UIColor+Skin.h"
#import "PFGeneralMenuViewController.h"

#import "PFPositionsViewController.h"
#import "PFMarketOperationsViewController.h"

@implementation PFMenuCell

@synthesize menuButton;
@synthesize menuTitleLabel;
@synthesize badgeView;
@synthesize menuItem = _menuItem;
@synthesize menuController;

+(id)cell
{
   UITableViewCell* cell_ = [ self viewAsFirstObjectFromNibNamed: NSStringFromClass( [ self class ] ) ];
   cell_.backgroundColor = [ UIColor clearColor ];
   
   return cell_;
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   
   self.transform = CGAffineTransformMakeRotation( M_PI * 0.5 );
}

-(void)setMenuItem:( PFMenuItem* )menu_item_
{
   _menuItem = menu_item_;
   
   self.menuTitleLabel.text = _menuItem.title;
   self.menuTitleLabel.textColor = [ UIColor grayTextColor ];
   self.badgeView.badgeValue = [ NSString stringWithFormat: @"%d", (int)menu_item_.badgeValue ];
   self.badgeView.hidden = menu_item_.badgeValue < 1;
   [ self.menuButton setImage: _menuItem.icon forState: UIControlStateNormal ];
   [ self.menuButton setImage: _menuItem.icon forState: UIControlStateHighlighted ];
   [ self.menuButton setImage: _menuItem.icon forState: UIControlStateSelected ];
}

-(IBAction)menuAction:( id )sender_
{
   UIViewController* controller_ = self.menuItem.controller;
   ( (PFGeneralMenuViewController*)self.menuController ).currentItem = self.menuItem;

   if ( ![controller_ isMemberOfClass: [PFPositionsViewController class]] &&
       ![controller_ isMemberOfClass: [PFMarketOperationsViewController class]] )
   {
      self.menuItem.badgeValue = 0;
   }

   if ( controller_ )
   {
      [ self.menuController presentViewController: [ PFNavigationController navigationControllerWithController: controller_ ]
                                         animated: YES
                                       completion: nil ];
   }
   else
   {
      [ self.menuItem performAction ];
   }
}

@end
