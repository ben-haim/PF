#import "PFTableViewSwitchItemCell.h"

#import "PFTableViewSwitchItem.h"

#import "PFSwitch.h"

@implementation PFTableViewSwitchItemCell

@synthesize switchView;

-(Class)expectedItemClass
{
   return [ PFTableViewSwitchItem class ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewSwitchItem* switch_item_ = ( PFTableViewSwitchItem* )item_;
   self.switchView.on = switch_item_.on;
}

-(IBAction)switchAction:( id )sender_
{
   PFTableViewSwitchItem* switch_item_ = ( PFTableViewSwitchItem* )self.item;
   [ switch_item_ switchToOn: self.switchView.on ];
}

@end
