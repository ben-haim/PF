#import "PFChartViewController_iPad.h"

#import "PFActiveIndicatorsViewController.h"
#import "PFChartSettingsViewController.h"

#import "PFOrderEntryViewController.h"

#import "NSString+DoubleFormatter.h"
#import "UIViewController+Wrapper.h"

#import "PFPopoverTextField.h"

#import "PFDecimalPadView.h"
#import "PFSettings.h"
#import "UIImage+Skin.h"
#import "UIColor+Skin.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFChartViewController_iPad ()< PFDecimalPadViewDelegate >

@property ( nonatomic, strong ) UIToolbar* toolbar;

-(void)placeOrderWithBuySide: (BOOL)buy_side_;

@end

@implementation PFChartViewController_iPad

@synthesize volumeNameLabel;
@synthesize spreadLabel;
@synthesize volumeLabel;
@synthesize buyButton;
@synthesize sellButton;
@synthesize qtyField;
@synthesize qtyLabel;
@synthesize toolbar = _toolbar;

-(void)didUpdatePriceForSymbol:( id< PFSymbol > )symbol_
{
   self.spreadLabel.text = symbol_.quote ? [ NSString stringWithDouble: symbol_.spread precision: 1 ] : nil;
   self.volumeLabel.text = symbol_.quote ? [ NSString stringWithVolume: symbol_.quote.volume ] : nil;
}

-(BOOL)resignFirstResponder
{
   return [ self.qtyField resignFirstResponder ];
}

-(UIToolbar*)toolbar
{
   if ( !_toolbar )
   {
      _toolbar = [ UIToolbar new ];
      [ _toolbar sizeToFit ];
      _toolbar.barStyle = UIBarStyleDefault;
      
      UIBarButtonItem* done_item_ = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                     target: self
                                                                                     action: @selector( resignFirstResponder ) ];
      
      
      [ _toolbar setItems: [ NSArray arrayWithObject: done_item_ ] animated: NO ];
   }
   
   return _toolbar;
}

-(BOOL)tryAllowTrading
{
   BOOL is_allowed_ = [ super tryAllowTrading ];
   
   self.qtyField.hidden = self.qtyLabel.hidden = self.buyButton.hidden = self.sellButton.hidden = !(is_allowed_ && [ [PFSession sharedSession] allowsPlaceOperationsForSymbol: self.symbol ]);
   
   return is_allowed_;
}

-(void)showOrderEntry
{
   [ self qtyExitAction: nil ];
   [ super showOrderEntry ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.qtyLabel.text = NSLocalizedString(@"QTY", nil);
   self.volumeNameLabel.text = [ NSLocalizedString( @"VOLUME", nil ) stringByAppendingString: @":" ];
   [ self.buyButton setTitle: NSLocalizedString( @"BUY", nil ) forState: UIControlStateNormal ];
   [ self.sellButton setTitle: NSLocalizedString( @"SELL", nil ) forState: UIControlStateNormal ];
   
   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? [ PFSettings sharedSettings ].lots : [ PFSettings sharedSettings ].lots * self.symbol.instrument.lotSize;
   self.qtyField.textColor = [ UIColor mainTextColor ];
   self.qtyField.borderStyle = UITextBorderStyleNone;
   self.qtyField.background = [ UIImage textFieldBackground ];
   self.qtyField.text = [ NSString stringWithAmount: displayed_amount_ ];
   self.qtyField.inputView = [ PFDecimalPadView createDecimalPadWithDelegate: self ];
   self.qtyField.inputAccessoryView = self.toolbar;
   
   __weak PFChartViewController* unsafe_controller_ = self;
   [ ( PFPopoverTextField* )self.nameField setDoneBlock: ^{ [ unsafe_controller_ symbolChangeAction: unsafe_controller_.nameField ]; } ];
}

-(void)dealloc
{
   self.qtyLabel = nil;
   self.qtyField = nil;
   self.buyButton = nil;
   self.sellButton = nil;
   self.spreadLabel = nil;
   self.volumeLabel = nil;
   self.volumeNameLabel = nil;
}

-(BOOL)shouldHideNavigationBarForOrientation:( UIInterfaceOrientation )interface_orientation_
{
   return NO;
}

-(void)showSettingsController:( PFChartSettingsViewController* )settings_controller_
{
   [ self.navigationController pushViewController: settings_controller_ animated: YES ];
}

-(void)hideSettingsController:( PFChartSettingsViewController* )settings_controller_
{
   [ self.navigationController popToViewController: self animated: YES ];
}

-(void)showIndicatorsController:( PFActiveIndicatorsViewController* )indicators_controller_
{
   [ self.navigationController pushViewController: indicators_controller_ animated: YES ];
}

-(void)hideIndicatorsController:( PFActiveIndicatorsViewController* )indicators_controller_
{
   [ self.navigationController popToViewController: self animated: YES ];
}

-(IBAction)buyAction:(id)sender
{
   [ self placeOrderWithBuySide: YES ];
}

-(IBAction)sellAction:(id)sender
{
   [ self placeOrderWithBuySide: NO ];
}

- (IBAction)qtyExitAction:(id)sender
{
   [ self.qtyField resignFirstResponder ];
}

-(void)placeOrderWithBuySide: (BOOL)buy_side_
{
   double amount_ = [ self.qtyField.text doubleValue ];
   
   if ( amount_ > 0.0 )
   {
      double real_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? amount_ : amount_ / self.symbol.instrument.lotSize;
      [ PFOrderEntryViewController placeMarketOrderForSymbol: self.symbol withAmount: real_amount_ buyMode: buy_side_ ];
   }
   else
   {
      [ JFFAlertView showAlertWithTitle: nil description: @"INVALID_AMOUNT" ];
   }
}

#pragma mark - PFDecimalPadViewDelegate

-(void)pressedButtonWithCode: (PFDecimalPadCodeType)code_
{
   // iOS5 and later
   if ( [ self.qtyField conformsToProtocol: @protocol(UITextInput) ] )
   {
      if ( code_ == PFDecimalPadCodeBack )
      {
         [ self.qtyField deleteBackward ];
      }
      else
      {
         [ self.qtyField insertText: code_ == PFDecimalPadCodePoint ? @"." : [ NSString stringWithFormat: @"%d", code_ ] ];
      }
   }
   else
   {
      UIPasteboard* general_pasteboard_ = [ UIPasteboard generalPasteboard ];
      NSArray* items_ = [ general_pasteboard_.items copy ];
      
      general_pasteboard_.string = code_ == PFDecimalPadCodeBack ? @"_" : (code_ == PFDecimalPadCodePoint ? @"." : [ NSString stringWithFormat: @"%d", code_ ]);
      [ self.qtyField paste: self ];
      
      NSRange range_ = [ self.qtyField.text rangeOfString: @"_" ];
      if ( range_.location != NSNotFound )
      {
         if ( range_.location > 0 )
         {
            range_.location--;
            range_.length++;
         }
         
         self.qtyField.text = [ self.qtyField.text stringByReplacingCharactersInRange: range_ withString:@"" ];
      }
      
      general_pasteboard_.items = items_;
   }
}

@end
