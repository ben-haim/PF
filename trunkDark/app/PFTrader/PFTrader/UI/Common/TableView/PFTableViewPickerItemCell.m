#import "PFTableViewPickerItemCell.h"

#import "PFTableViewPickerItem.h"

#import "PFPickerField.h"

@interface PFTableViewPickerItemCell () < UIPopoverControllerDelegate >

@property (nonatomic, strong) UIPopoverController* popoverController;

@end

@implementation PFTableViewPickerItemCell

@synthesize valueField;
@synthesize popoverController;

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
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      UIViewController* picker_controller_ = [ UIViewController new ];
      [ picker_controller_.view  addSubview: self.valueField.inputView ];
      picker_controller_.contentSizeForViewInPopover = self.valueField.inputView.frame.size;
      
      [ self.valueField selectCurrentComponent ];
      
      self.popoverController = [ [ UIPopoverController alloc ] initWithContentViewController: picker_controller_ ];
      self.popoverController.delegate = self;
      if ( [ self.popoverController respondsToSelector: @selector( setBackgroundColor: ) ] )
      {
         self.popoverController.backgroundColor = [ UIColor darkGrayColor ];
      }
      
      [ self.popoverController presentPopoverFromRect: self.valueField.frame
                                               inView: self
                             permittedArrowDirections: UIPopoverArrowDirectionAny
                                             animated: YES ];
   }
   else
   {
      [ self.valueField becomeFirstResponder ];
   }
}

-(Class)expectedItemClass
{
   return [ PFTableViewPickerItem class ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewBasePickerItem* picker_item_ = ( PFTableViewBasePickerItem* )item_;

   self.valueField.hiddenDoneButton = picker_item_.hiddenDoneButton;
   self.valueField.delegate = picker_item_;
   [ self.valueField reloadData ];
   [ picker_item_ updatePickerField: self.valueField ];
}

#pragma mark - UIPopoverControllerDelegate

-(void)popoverControllerDidDismissPopover:( UIPopoverController* )popover_controller_
{
   self.popoverController = nil;
}

@end
