#import "PFTableViewDetailItemCell.h"

#import "PFTableViewDetailItem.h"

@implementation PFTableViewDetailItemCell

@synthesize valueLabel;

-(Class)expectedItemClass
{
   return [ PFTableViewDetailItem class ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewDetailItem* detail_item_ = ( PFTableViewDetailItem* )item_;

   self.valueLabel.text = detail_item_.value;
}

@end
