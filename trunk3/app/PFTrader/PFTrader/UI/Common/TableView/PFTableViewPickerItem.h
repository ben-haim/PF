#import "PFTableViewBasePickerItem.h"

#import "PFPickerField.h"

#import <Foundation/Foundation.h>

@interface PFTableViewPickerItem : PFTableViewBasePickerItem< PFPickerFieldDelegate >

@property ( nonatomic, strong, readonly ) NSString* value;

@end


@interface PFTableViewChoicesPickerItem : PFTableViewPickerItem

@property ( nonatomic, strong ) NSArray* choices;
@property ( nonatomic, assign ) NSUInteger currentChoice;

@end
