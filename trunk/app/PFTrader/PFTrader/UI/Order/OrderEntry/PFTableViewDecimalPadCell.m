#import "PFTableViewDecimalPadCell.h"

#import "PFTableViewDecimalPadItem.h"
#import "PFDecimalPadView.h"

@interface PFTableViewDecimalPadCell () < PFDecimalPadViewDelegate >

@property ( nonatomic, strong ) UIToolbar* toolbar;

@end;

@implementation PFTableViewDecimalPadCell

@synthesize valueField;
@synthesize toolbar = _toolbar;

-(BOOL)resignFirstResponder
{
   self.valueField.text = ( ( PFTableViewDecimalPadItem* )self.item ).value;
   
   BOOL result_ = [ self.valueField resignFirstResponder ];
   self.valueField.userInteractionEnabled = NO;
   
   return result_;
}

-(void)add:( double )increment_
{
   PFTableViewDecimalPadItem* decimal_item_ = ( PFTableViewDecimalPadItem* )self.item;

   decimal_item_.value = [ @( decimal_item_.doubleValue + decimal_item_.step * increment_ ) stringValue ];
   self.valueField.text = decimal_item_.value;
}

-(void)plus1
{
   [ self add: 1.0 ];
}

-(void)minus1
{
   [ self add: -1.0 ];
}

-(UIToolbar*)toolbar
{
   if ( !_toolbar )
   {
      _toolbar = [ UIToolbar new ];
      [ _toolbar sizeToFit ];
      _toolbar.barStyle = UIBarStyleBlackTranslucent;
      
      UIBarButtonItem* done_item_ = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                     target: self
                                                                                     action: @selector( resignFirstResponder ) ];
      
      UIBarButtonItem* spacer_ = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                  target: nil
                                                                                  action: nil ];
      
      UIBarButtonItem* minus_1_item_ = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString( @" - ", nil )
                                                                           style: UIBarButtonItemStyleBordered
                                                                          target: self
                                                                          action: @selector( minus1 ) ];
      
      UIBarButtonItem* plus_1_item_ = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString( @" + ", nil )
                                                                          style: UIBarButtonItemStyleBordered
                                                                         target: self
                                                                         action: @selector( plus1 ) ];

      [ _toolbar setItems: [ NSArray arrayWithObjects: done_item_, spacer_, minus_1_item_, plus_1_item_, nil ] animated: NO ];
   }
   
   return _toolbar;
}

-(void)setSelected:( BOOL )selected_ animated:( BOOL )animated_
{
   if ( !selected_ )
   {      
      [ self resignFirstResponder ];
   }
   
   [ super setSelected: selected_ animated: animated_ ];
}

-(void)performAction
{
   self.valueField.userInteractionEnabled = YES;
   [ self.valueField becomeFirstResponder ];
}

-(Class)expectedItemClass
{
   return [ PFTableViewDecimalPadItem class ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   self.valueField.inputView = [ PFDecimalPadView createDecimalPadWithDelegate: self ];
   self.valueField.inputAccessoryView = self.toolbar;
   
   PFTableViewDecimalPadItem* decimal_item_ = ( PFTableViewDecimalPadItem* )item_;
   self.valueField.text = decimal_item_.value;
   self.valueField.userInteractionEnabled = NO;
}

-(IBAction)valueChangedAction:( id )sender_
{
   PFTableViewDecimalPadItem* decimal_item_ = ( PFTableViewDecimalPadItem* )self.item;
   decimal_item_.value = self.valueField.text;
}

#pragma mark - PFDecimalPadViewDelegate

-(void)pressedButtonWithCode: (PFDecimalPadCodeType)code_
{
   if ( [ self.valueField conformsToProtocol: @protocol( UITextInput ) ] )
   {
      if ( code_ == PFDecimalPadCodeBack )
      {
         [ self.valueField deleteBackward ];
      }
      else
      {
         [ self.valueField insertText: code_ == PFDecimalPadCodePoint ? @"." : [ NSString stringWithFormat: @"%d", code_ ] ];
      }
   }
}

@end
