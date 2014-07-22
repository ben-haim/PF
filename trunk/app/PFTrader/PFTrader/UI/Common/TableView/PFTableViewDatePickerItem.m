#import "PFTableViewDatePickerItem.h"

#import "PFTableViewDatePickerItemCell.h"

@interface PFTableViewDatePickerItem ()

@end


@implementation PFTableViewDatePickerItem

@synthesize date;
@synthesize dateMode;
@synthesize fromTodayMode;

-(Class)cellClass
{
   return [ PFTableViewDatePickerItemCell class ];
}

-(id)initWithAction:(PFTableViewItemAction)action_ title:(NSString *)title_
{
   self = [ super initWithAction: action_ title: title_ ];
   
   if ( self )
   {
      self.dateMode = UIDatePickerModeDateAndTime;
      self.fromTodayMode = NO;
   }
   
   return self;
}

-(void)updatePickerField:( PFBasePickerField* )picker_field_
{
   PFDatePickerField* date_picker_field_ = ( PFDatePickerField* )picker_field_;

   date_picker_field_.date = self.date;
}

#pragma mark PFDatePickerFieldDelegate

-(void)pickerField:( PFDatePickerField* )picker_field_
     didSelectDate:( NSDate* )date_
{
   self.date = date_;

   if ( self.pickerAction )
   {
      self.pickerAction( self );
   }
}

@end
