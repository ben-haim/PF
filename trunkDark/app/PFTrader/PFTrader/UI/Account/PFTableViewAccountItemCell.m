#import "PFTableViewAccountItemCell.h"
#import "PFTableViewAccountItem.h"
#import "UIImage+PFTableView.h"
#import "UIImage+Skin.h"
#import "UIColor+Skin.h"

@implementation PFTableViewAccountItemCell

@synthesize accountTitleLabel;

-(Class)expectedItemClass
{
   return [ PFTableViewAccountItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   
   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImageLight ] ];
}

-(BOOL)useWhiteAccessoryImage
{
   return ( (PFTableViewAccountItem*)self.item ).isDefaultAccount;
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   BOOL is_default_account_ = ( (PFTableViewAccountItem*)item_ ).isDefaultAccount;
   
   self.backgroundView = [ [ UIImageView alloc ] initWithImage: is_default_account_ ? [ UIImage blueButtonBackground ] : [ UIImage grayButtonBackground ] ];
   self.accountTitleLabel.textColor = is_default_account_ ? [ UIColor mainTextColor ] : [ UIColor blueTextColor ];
   self.accountTitleLabel.text = item_.title;
}

@end
