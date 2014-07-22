#import "PFTableViewItem.h"

#import <UIKit/UIKit.h>

@class PFTableViewSwitchItem;

typedef void (^PFTableViewSwitchItemAction)( PFTableViewSwitchItem* item_ );

@interface PFTableViewSwitchItem : PFTableViewItem

@property ( nonatomic, assign, readonly ) BOOL on;

@property ( nonatomic, strong ) NSString* onText;
@property ( nonatomic, strong ) NSString* offText;

+(id)switchItemWithTitle:( NSString* )title_
                    isOn:( BOOL )is_on_
            switchAction:( PFTableViewSwitchItemAction )action_;

-(void)switchToOn:( BOOL )on_;

@end
