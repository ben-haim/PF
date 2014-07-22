#import "PFTableViewItem.h"

#import <Foundation/Foundation.h>

@interface PFTableViewDetailItem : PFTableViewItem

@property ( nonatomic, strong ) NSString* value;

-(id)initWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
              value:( NSString* )value_;

+(id)itemWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
              value:( NSString* )value_;

@end

@interface PFTableViewEditableDetailItem : PFTableViewDetailItem

@property ( nonatomic, strong ) NSString* placeholder;
@property ( nonatomic, assign ) UIKeyboardType keyboardType;
@property ( nonatomic, assign ) BOOL secureTextEntry;

-(id)initWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
              value:( NSString* )value_
        placeholder:( NSString* )placeholder_
       keyboardType:( UIKeyboardType )keyboard_type_;

+(id)itemWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
              value:( NSString* )value_
        placeholder:( NSString* )placeholder_
       keyboardType:( UIKeyboardType )keyboard_type_;

@end
