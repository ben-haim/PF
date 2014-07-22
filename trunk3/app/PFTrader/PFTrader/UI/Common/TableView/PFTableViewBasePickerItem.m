#import "PFTableViewBasePickerItem.h"

@interface PFTableViewBasePickerItem ()

@end


@implementation PFTableViewBasePickerItem

@synthesize pickerAction;
@synthesize hiddenDoneButton;

-(id)initWithAction:( PFTableViewItemAction )action_
              title:( NSString* )title_
{
   self = [ super initWithAction: action_
                           title: title_ ];
   if ( self )
   {
      self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   }
   return self;
}

-(Class)cellClass
{
   [ self doesNotRecognizeSelector: _cmd ];
   return Nil;
}

-(void)updatePickerField:( PFBasePickerField* )picker_field_
{
   [ self doesNotRecognizeSelector: _cmd ];
}

@end
