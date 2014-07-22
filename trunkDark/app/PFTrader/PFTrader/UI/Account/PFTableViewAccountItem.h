#import "PFTableViewItem.h"

@interface PFTableViewAccountItem : PFTableViewItem

@property ( nonatomic, assign, readonly ) BOOL isDefaultAccount;

+(id)itemWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
   isDefaultAccount:( BOOL )is_default_account_;

@end
