#import "PFTableViewDatePickerItemCell.h"

#import "PFTableViewDatePickerItem.h"
#import "PFTableViewDatePickerItem.h"

@interface PFTableViewDatePickerItemCell ()

@end

@implementation PFTableViewDatePickerItemCell

-(Class)expectedItemClass
{
   return [ PFTableViewDatePickerItem class ];
}

-(void)setItem:( PFTableViewItem* )item_
{
   PFTableViewDatePickerItem* date_item_ = (PFTableViewDatePickerItem*)item_;
   
   PFDatePickerField* date_picker_field_ = (PFDatePickerField*)self.valueField;
   date_picker_field_.dateMode = date_item_.dateMode;
   date_picker_field_.fromTodayMode = date_item_.fromTodayMode;
   date_picker_field_.date = date_item_.date;

   [ super setItem: item_ ];
}

@end
