#import "PFTableViewItem.h"

#import "PFBasePickerField.h"

#import <Foundation/Foundation.h>

@class PFTableViewBasePickerItem;

typedef void (^PFTableViewPickerItemAction)( PFTableViewBasePickerItem* picker_item_ );

@interface PFTableViewBasePickerItem : PFTableViewItem< PFBasePickerFieldDelegate >

@property ( nonatomic, copy ) PFTableViewPickerItemAction pickerAction;
@property ( nonatomic, assign ) BOOL hiddenDoneButton;

-(void)updatePickerField:( PFBasePickerField* )picker_field_;

@end
