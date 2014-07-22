#import "PFTableViewDetailItem.h"

#import "PFTableViewDetailItemCell.h"
#import "PFTableViewEditableDetailItemCell.h"

@implementation PFTableViewDetailItem

@synthesize value;

-(id)initWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
              value:( NSString* )value_
{
   self = [ super initWithAction: action_ title: title_ ];
   if ( self )
   {
      self.value = value_;
   }
   return self;
}

+(id)itemWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
              value:( NSString* )value_
{
   return [ [ self alloc ] initWithAction: action_
                                    title: title_
                                    value: value_ ];
}

-(Class)cellClass
{
   return [ PFTableViewDetailItemCell class ];
}

@end

@implementation PFTableViewEditableDetailItem

@synthesize placeholder;
@synthesize keyboardType;
@synthesize secureTextEntry;

-(id)initWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
              value:( NSString* )value_
        placeholder:( NSString* )placeholder_
       keyboardType:( UIKeyboardType )keyboard_type_
{
   self = [ super initWithAction: action_
                           title: title_
                           value: value_ ];

   if ( self )
   {
      self.placeholder = placeholder_;
      self.keyboardType = keyboard_type_;
   }

   return self;
}

+(id)itemWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
              value:( NSString* )value_
        placeholder:( NSString* )placeholder_
       keyboardType:( UIKeyboardType )keyboard_type_
{
   return [ [ self alloc ] initWithAction: action_
                                    title: title_
                                    value: value_
                              placeholder: placeholder_
                             keyboardType: keyboard_type_ ];
}

-(Class)cellClass
{
   return [ PFTableViewEditableDetailItemCell class ];
}

@end
