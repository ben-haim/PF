#import "PFPopoverTextField.h"

@interface PFPopoverTextField () < UIPopoverControllerDelegate >

@property (nonatomic, strong) UIPopoverController* popoverController;

@end

@implementation PFPopoverTextField

@synthesize doneBlock;
@synthesize popoverController;

- (BOOL)becomeFirstResponder
{
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      UIViewController* picker_controller_ = [ UIViewController new ];
      [ picker_controller_.view  addSubview: self.inputView ];
      picker_controller_.contentSizeForViewInPopover = self.inputView.frame.size;
      
      self.popoverController = [ [ UIPopoverController alloc ] initWithContentViewController: picker_controller_ ];
      self.popoverController.delegate = self;
      if ( [ self.popoverController respondsToSelector: @selector( setBackgroundColor: ) ] )
      {
         self.popoverController.backgroundColor = [ UIColor darkGrayColor ];
      }
      
      [ self.popoverController presentPopoverFromRect: self.bounds
                                               inView: self
                             permittedArrowDirections: UIPopoverArrowDirectionAny
                                             animated: YES ];
      
      return YES;
   }
   else
   {
      return [ super becomeFirstResponder ];
   }
}

#pragma mark - UIPopoverControllerDelegate

-(void)popoverControllerDidDismissPopover:( UIPopoverController* )popover_controller_
{
   if ( self.doneBlock )
   {
      self.doneBlock();
   }
   
   self.popoverController = nil;
}

@end