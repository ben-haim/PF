#import "PFTableViewPickerItem.h"

#import "PFTableViewPickerItemCell.h"

@interface PFTableViewPickerItem ()

@end


@implementation PFTableViewPickerItem

-(NSString*)value
{
   return nil;
}

-(Class)cellClass
{
   return [ PFTableViewPickerItemCell class ];
}

-(void)updatePickerField:( PFBasePickerField* )base_picker_field_
{
   PFPickerField* picker_field_ = ( PFPickerField* )base_picker_field_;
   picker_field_.text = self.value;
}

#pragma mark PFPickerFieldDelegate

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return 0;
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return nil;
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   if ( self.pickerAction )
   {
      self.pickerAction( self );
   }
}

@end


@implementation PFTableViewChoicesPickerItem

@synthesize choices;
@synthesize currentChoice;

-(NSString*)value
{
   return [ self.choices objectAtIndex: self.currentChoice ];
}

#pragma mark PFPickerFieldDelegate

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return self.currentChoice;
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return [ self.choices count ];
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return [ self.choices objectAtIndex: row_ ];
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.currentChoice = row_;
   picker_field_.text = self.value;

   if ( self.pickerAction )
   {
      self.pickerAction( self );
   }
}

@end

