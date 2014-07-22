#import "PFPickerField.h"
#import "UIColor+Skin.h"

@interface PFPickerTextField : UITextField

@property ( nonatomic, strong ) UIView* pickerView;
@property ( nonatomic, strong ) UIToolbar* toolbar;

@end

@implementation PFPickerTextField

@synthesize pickerView;
@synthesize toolbar = _toolbar;

-(UIToolbar*)toolbar
{
   if ( !_toolbar )
   {
      _toolbar = [ UIToolbar new ];
      [ _toolbar sizeToFit ];
      _toolbar.barStyle = UIBarStyleDefault;
   }
   
   return _toolbar;
}

-(UIView*)inputView
{
   return self.pickerView;
}

-(UIView*)inputAccessoryView
{
   return self.toolbar;
}

-(CGRect)textRectForBounds:( CGRect )bounds_
{
   return CGRectInset( bounds_, 0.f, 3.f );
}

-(CGRect)editingRectForBounds:( CGRect )bounds_
{
   return [ self textRectForBounds: bounds_ ];
}

-(BOOL)canBecomeFirstResponder
{
   return YES;
}

@end

@interface PFBasePickerField ()

@property ( nonatomic, strong, readonly ) PFPickerTextField* textField;

@end

@implementation PFBasePickerField

@synthesize hiddenDoneButton;
@synthesize textField = _textField;
@synthesize delegate;

-(UIView*)inputView
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(void)selectCurrentComponent
{
   [ self doesNotRecognizeSelector: _cmd ];
}

-(NSString*)text
{
   return self.textField.text;
}

-(void)setText:( NSString* )text_
{
   self.textField.text = text_;
}

-(PFPickerTextField*)textField
{
   if ( !_textField )
   {
      _textField = [ [ PFPickerTextField alloc ] initWithFrame: self.bounds ];
      _textField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      _textField.textAlignment = NSTextAlignmentRight;
      _textField.font = [ UIFont systemFontOfSize: 17.f ];
      _textField.textColor = [ UIColor mainTextColor ];
      _textField.pickerView = self.inputView;
      [ self addSubview: _textField ];
      [ self sendSubviewToBack: _textField ];
   }
   return _textField;
}

-(NSArray*)items
{
   NSMutableArray* items_;
   
   if ( self.hiddenDoneButton )
   {
      items_ = [ NSMutableArray new ];
   }
   else
   {
      UIBarButtonItem* done_item_ = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                     target: self
                                                                                     action: @selector( resignFirstResponder ) ];
      items_ = [ NSMutableArray arrayWithObject: done_item_ ];
   }
   
   NSArray* accessory_items_ = [ self.delegate accessoryItemsInPickerField: self ];
   if ( [ accessory_items_ count ] > 0 )
   {
      UIBarButtonItem* spacer_ = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                  target: nil
                                                                                  action: nil ];
      
      [ items_ addObject: spacer_ ];
      [ items_ addObjectsFromArray: accessory_items_ ];
   }
   
   return items_;
}

-(void)reloadData
{
   [ self.textField.toolbar setItems: self.items animated: NO ];
}

#pragma mark UIResponder

-(BOOL)canBecomeFirstResponder
{
   return [ self.textField canBecomeFirstResponder ];
}

-(BOOL)becomeFirstResponder
{
   return [ self.textField becomeFirstResponder ];
}

-(BOOL)isFirstResponder
{
   return [ self.textField isFirstResponder ];
}

-(BOOL)resignFirstResponder
{
   return [ self.textField resignFirstResponder ];
}

@end

@implementation NSObject (PFBasePickerFieldDelegate)

-(NSArray*)accessoryItemsInPickerField:( PFBasePickerField* )picker_field_
{
   return nil;
}

@end
