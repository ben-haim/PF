#import "PFTableViewEditableDetailItemCell.h"

#import "PFTableViewDetailItem.h"

@implementation PFTableViewEditableDetailItemCell

@synthesize valueField;

-(void)setSelected:( BOOL )selected_ animated:( BOOL )animated_
{
   if ( !selected_ )
   {
      [ self.valueField resignFirstResponder ];
   }

   [ super setSelected: selected_ animated: animated_ ];
}

-(void)performAction
{
   [ self.valueField becomeFirstResponder ];
}

-(Class)expectedItemClass
{
   return [ PFTableViewEditableDetailItem class ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewEditableDetailItem* detail_item_ = ( PFTableViewEditableDetailItem* )item_;

   self.valueField.placeholder = detail_item_.placeholder;
   self.valueField.keyboardType = detail_item_.keyboardType;
   self.valueField.secureTextEntry = detail_item_.secureTextEntry;
   self.valueField.text = detail_item_.value;
}

-(IBAction)valueChangedAction:( id )sender_
{
   PFTableViewEditableDetailItem* detail_item_ = ( PFTableViewEditableDetailItem* )self.item;
   detail_item_.value = self.valueField.text;
}

-(IBAction)exitAction:( id )sender_
{
   [ self.valueField resignFirstResponder ];
}

@end
