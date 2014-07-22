#import "PFTableViewAccountItem.h"
#import "PFTableViewAccountItemCell.h"

@interface PFTableViewAccountItem ()

@property ( nonatomic, assign ) BOOL isDefaultAccount;

@end

@implementation PFTableViewAccountItem

@synthesize isDefaultAccount;

+(id)itemWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
   isDefaultAccount:( BOOL )is_default_account_
{
   PFTableViewAccountItem* account_item_ = [ [ PFTableViewAccountItem alloc ] initWithAction: action_
                                                                                       title: title_ ];
   account_item_.isDefaultAccount = is_default_account_;
   
   return account_item_;
}

-(Class)cellClass
{
   return [ PFTableViewAccountItemCell class ];
}

@end
