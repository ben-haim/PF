#import "PFOptionChainViewController.h"

#import "PFLevel4QuoteColumn.h"
#import "PFSegmentedControl.h"

#import "PFOrderEntryViewController.h"

#import "UIImage+Skin.h"
#import "UIColor+Skin.h"

#import "PFBlackScholes.h"

#import <JFFMessageBox/JFFMessageBox.h>
#import <ProFinanceApi/ProFinanceApi.h>

static const int defaultStrikesCount = 8;

@class PFGridFooterView;

@interface PFOptionChainViewController () < PFQuoteDependence, UIPickerViewDelegate, UIPickerViewDataSource >

@property ( nonatomic, strong ) id< PFSymbol > symbol;
@property ( nonatomic, strong ) id< PFSymbol > baseSymbol;
@property ( nonatomic, strong ) NSTimer* reloadTimer;
@property ( nonatomic, strong ) NSArray* expirationDates;

@property ( nonatomic, assign ) BOOL callMode;
@property ( nonatomic, assign ) int strikesCount;

@property ( nonatomic, strong ) NSDate* currentExpirationDate;
@property ( nonatomic, strong ) UIPickerView* expirationPicker;
@property ( nonatomic, strong ) UIToolbar* toolbar;

@end

@implementation PFOptionChainViewController

@synthesize optionTypeSelector;
@synthesize expirationSelector;
@synthesize expirationPicker = _expirationPicker;
@synthesize toolbar = _toolbar;

@synthesize symbol;
@synthesize baseSymbol;

@synthesize callMode = _callMode;
@synthesize expirationDates = _expirationDates;
@synthesize strikesCount = _strikesCount;
@synthesize currentExpirationDate = _currentExpirationDate;

@synthesize reloadTimer;

#pragma mark - Controller Life cicle

-(id)initWithSymbol:( id< PFSymbol > )option_symbol_ andBaseSymbol:( id< PFSymbol > )base_symbol_
{
   self = [ super initWithNibName: @"PFOptionChainViewController" bundle: nil ];
   
   if ( self )
   {
      self.title = [ NSString stringWithFormat: @"%@ %@", base_symbol_.instrumentName, NSLocalizedString( @"OPTION_CHAIN", nil ) ];
      self.symbol = option_symbol_;
      self.baseSymbol = base_symbol_;
      self.ignoreElementsCount = YES;
   }
   
   return self;
}

-(NSArray*)optionChainColumns
{
   return @[[ PFLevel4QuoteColumn strikeColumn ]
           , [ PFLevel4QuoteColumn askColumnWithDelegate: self ]
           , [ PFLevel4QuoteColumn bidColumnWithDelegate: self ]
           , [ PFLevel4QuoteColumn askSizeAndBidSizeColumn ]
           , [ PFLevel4QuoteColumn lastAndVolumeColumn ]
           , [ PFLevel4QuoteColumn deltaAndGammaColumn ]
           , [ PFLevel4QuoteColumn vegaAndThetaColumn ]];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
 
   self.columns = [ self optionChainColumns ];
   
   self.expirationSelector.textColor = [ UIColor mainTextColor ];
   self.expirationSelector.borderStyle = UITextBorderStyleNone;
   self.expirationSelector.background = [ UIImage textFieldBackground ];
   self.expirationSelector.inputView = self.expirationPicker;
   self.expirationSelector.inputAccessoryView = self.toolbar;
   self.expirationSelector.userInteractionEnabled = NO;
   self.expirationSelector.text = NSLocalizedString(@"NO_EXPIRATION_DATES", nil );
   
   self.optionTypeSelector.items = @[NSLocalizedString(@"CALL", nil ), NSLocalizedString(@"PUT", nil )];
   self.optionTypeSelector.selectedSegmentIndex = 0;
   
   self.strikesCount = defaultStrikesCount;
   
   [ self reloadDataWithTimer ];
}

- (void)viewDidUnload
{
   self.optionTypeSelector = nil;
   
   self.expirationPicker.delegate = nil;
   self.expirationPicker.dataSource = nil;
   self.expirationPicker = nil;
   
   [ super viewDidUnload ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   self.reloadTimer = [ NSTimer scheduledTimerWithTimeInterval: 1.5
                                                        target: self
                                                      selector: @selector( reloadDataWithTimer )
                                                      userInfo: nil
                                                       repeats: YES ];
   
   [ [ PFSession sharedSession ].level4QuoteSubscriber addDependence: self
                                                    forGeneralOption: self.symbol ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self.reloadTimer invalidate ];
   self.reloadTimer = nil;
   
   [ [ PFSession sharedSession ].level4QuoteSubscriber removeDependence: self
                                                       forGeneralOption: self.symbol ];
}

#pragma mark - Timer

-(NSArray*)calculateParamsWithLevel4Quotes: (NSArray*)quotes_array_
{
   double current_base_active_ = self.baseSymbol.quote.bid;
   
   for (id<PFLevel4Quote> quote_ in  quotes_array_ )
   {
      if ( current_base_active_ > 0.0 )
      {
         double year_to_date_ = [ quote_.expirationDate timeIntervalSinceNow ] / ( 60 * 60 * 24 * 365 );
         
         double delta_ = quote_.optionType == PFSymbolOptionTypeCallVanilla
         ? [ PFBlackScholes BS_CDELTAWithBaseActive: current_base_active_
                                             Strike: quote_.strikePrice
                                   TimeToExpiration: year_to_date_ ]
         : [ PFBlackScholes BS_PDELTAWithBaseActive: current_base_active_
                                             Strike: quote_.strikePrice
                                   TimeToExpiration: year_to_date_ ];
         
         double gamma_ = quote_.optionType == PFSymbolOptionTypeCallVanilla
         ? [ PFBlackScholes BS_CGAMMAWithBaseActive: current_base_active_
                                             Strike: quote_.strikePrice
                                   TimeToExpiration: year_to_date_ ]
         : [ PFBlackScholes BS_PGAMMAWithBaseActive: current_base_active_
                                             Strike: quote_.strikePrice
                                   TimeToExpiration: year_to_date_ ];
         
         double theta_ = quote_.optionType == PFSymbolOptionTypeCallVanilla
         ? [ PFBlackScholes BS_CTHETAWithBaseActive: current_base_active_
                                             Strike: quote_.strikePrice
                                   TimeToExpiration:year_to_date_ ]
         : [ PFBlackScholes BS_PTHETAWithBaseActive: current_base_active_
                                             Strike: quote_.strikePrice
                                   TimeToExpiration:year_to_date_ ];
         
         double vega_ = quote_.optionType == PFSymbolOptionTypeCallVanilla
         ? [ PFBlackScholes BS_CVEGAWithBaseActive: current_base_active_
                                            Strike: quote_.strikePrice
                                  TimeToExpiration:year_to_date_ ]
         : [ PFBlackScholes BS_PVEGAWithBaseActive: current_base_active_
                                            Strike: quote_.strikePrice
                                  TimeToExpiration:year_to_date_ ];
         
         quote_.delta = isnan(delta_) ? 0.0 : delta_;
         quote_.gamma = isnan(gamma_) ? 0.0 : gamma_;
         quote_.theta = isnan(theta_) ? 0.0 : theta_;
         quote_.vega = isnan(vega_) ? 0.0 : vega_;
      }
      else
      {
         quote_.delta = 0.0;
         quote_.gamma = 0.0;
         quote_.theta = 0.0;
         quote_.vega = 0.0;
      }
   }
   
   return quotes_array_;
}

-(NSArray*)filteredLevel4QuotesFromQuotes: (NSArray*) all_quotes_
{
   if ( self.strikesCount != -1 && self.strikesCount < all_quotes_.count )
   {
      double etalon_price_ = self.baseSymbol.quote.bid;
      NSUInteger location_ = 0;
      NSUInteger length_ = self.strikesCount;
      NSUInteger reverse_count_ = length_ / 2;
      
      for ( int i = 0; i < all_quotes_.count; i++)
      {
         if ( ((id<PFLevel4Quote>)all_quotes_[i]).strikePrice >= etalon_price_ )
         {
            location_ = i >= reverse_count_ ? i - reverse_count_ : 0;
            if ( location_ + length_ > all_quotes_.count )
            {
               location_ -= ( location_ + length_ ) - all_quotes_.count;
            }
            
            return [ self calculateParamsWithLevel4Quotes: [ all_quotes_ subarrayWithRange:  NSMakeRange(location_, length_) ] ];
         }
      }
   }
   
   return [ self calculateParamsWithLevel4Quotes: all_quotes_ ];
}

-(void)reloadDataWithTimer
{
   NSDictionary* current_quotes_ = self.callMode ? self.symbol.level4Quotes.callQuotes : self.symbol.level4Quotes.putQuotes;
   self.expirationDates = current_quotes_.allKeys;
   
   if ( self.expirationDates.count > 0 )
   {
      self.elements = [ self filteredLevel4QuotesFromQuotes: [ [ current_quotes_[self.currentExpirationDate] allObjects ]
                                                              sortedArrayUsingSelector: @selector(compare:) ] ];
   }
   
   [ self reloadData ];
}

#pragma mark - Option params setters

-(void)setExpirationDates: (NSArray*)expiration_dates_
{
   BOOL need_set_first_date_ = _expirationDates.count == 0;
   BOOL need_reload_components_ = _expirationDates.count != expiration_dates_.count;
   _expirationDates = [ expiration_dates_ sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) { return [ obj1 compare: obj2 ]; } ];
   self.expirationSelector.userInteractionEnabled = _expirationDates.count > 0;
   
   if ( need_reload_components_ )
   {
      if ( need_set_first_date_ )
      {
         self.currentExpirationDate = (self.expirationDates)[0];
      }
      
      [ self.expirationPicker reloadAllComponents ];
   }
}

-(void)setStrikesCount: (int)strikes_count_
{
   if ( _strikesCount != strikes_count_ )
   {
      _strikesCount = strikes_count_;
      [ self setSummaryString: _strikesCount == -1 ? NSLocalizedString(@"ALL_COUNT", nil) : [ NSString stringWithFormat: @"%d", _strikesCount ] ];
      
      [ self reloadDataWithTimer ];
   }
}

-(void)setCurrentExpirationDate: (NSDate*)current_expiration_date_
{
   if ( [ current_expiration_date_ compare: _currentExpirationDate ] != NSOrderedSame || _currentExpirationDate == nil )
   {
      _currentExpirationDate = current_expiration_date_;
      self.expirationSelector.text = [ self stringFromDate: _currentExpirationDate ];
      
      [ self reloadDataWithTimer ];
   }
}

-(void)setCallMode: (BOOL)call_mode_
{
   if ( _callMode != call_mode_ )
   {
      _callMode = call_mode_;
      
      [ self reloadDataWithTimer ];
   }
}

#pragma mark - PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_ didSelectItemAtIndex:( NSInteger )index_
{
   self.callMode = ( index_ == 0 );
}

#pragma mark - Expiration Picker

-(BOOL)resignFirstResponder
{
   return [ self.expirationSelector resignFirstResponder ];
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
      
      [ _toolbar setItems: @[done_item_] animated: NO ];
   }
   
   return _toolbar;
}

-(UIPickerView*)expirationPicker
{
   if ( !_expirationPicker )
   {
      _expirationPicker = [ UIPickerView new ];
      [ _expirationPicker sizeToFit ];
      _expirationPicker.showsSelectionIndicator = YES;
      _expirationPicker.delegate = self;
      _expirationPicker.dataSource = self;
   }
   return _expirationPicker;
}

#pragma mark - UIPickerViewDelegate

-(NSString*)stringFromDate: (NSDate*)date_
{
   NSDateFormatter* date_formatter_ = [ [ NSDateFormatter alloc ] init ];
   date_formatter_.dateFormat = @"dd MMMM yyyy";
   
   return [ date_formatter_ stringFromDate: date_ ];
}

-(NSString*)pickerView: (UIPickerView*)picker_view_ titleForRow: (NSInteger)row_ forComponent: (NSInteger)component_
{
   return [ self stringFromDate: (self.expirationDates)[row_] ];
}

-(void)pickerView: (UIPickerView*)picker_view_ didSelectRow: (NSInteger)row_ inComponent: (NSInteger)component_
{
   self.currentExpirationDate = (self.expirationDates)[row_];
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   return 1;
}

-(NSInteger)pickerView: (UIPickerView*)picker_view_ numberOfRowsInComponent: (NSInteger)component_
{
   return self.expirationDates.count;
}

#pragma mark - PFGridFooterViewDelegate

-(void)didTapSummaryInFootterView:( PFGridFooterView* )footer_view_
{
   NSMutableArray* buttons_array_ = [ NSMutableArray arrayWithCapacity: 5 ];
   
   for ( int i = 4; i <= 16; i += 4 )
   {
      NSString* button_localized_key_ = [ NSString stringWithFormat: @"%d_STRIKES", i ];
      
      [ buttons_array_ addObject: [ JFFAlertButton alertButton: NSLocalizedString( button_localized_key_, nil )
                                                        action: ^( JFFAlertView* sender_ )
                                   {
                                      self.strikesCount = i;
                                   } ] ];
   }
   
   [ buttons_array_ addObject: [ JFFAlertButton alertButton: NSLocalizedString( @"ALL_STRIKES", nil )
                                                     action: ^( JFFAlertView* sender_ )
                                {
                                   self.strikesCount = -1;
                                } ] ];
   
   
   JFFActionSheet* action_sheet_ = [ JFFActionSheet actionSheetWithTitle: NSLocalizedString( @"STRIKES_COUNT_PROMPT", nil )
                                                       cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                                  destructiveButtonTitle: nil
                                                       otherButtonsArray: buttons_array_ ];
   
   action_sheet_.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   [ action_sheet_ showInView: self.view ];
}

#pragma mark - PFSymbolPriceCellDelegate

-(void)showOEForLeve4Quote:( id< PFLevel4Quote > )quote_
{
   [ PFOrderEntryViewController showWithLevel4Quote: quote_ ];
}

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_ didAskSelectForLeve4Quote:( id< PFLevel4Quote > )quote_
{
   [ self showOEForLeve4Quote: quote_ ];
}

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_ didBidSelectForLeve4Quote:( id< PFLevel4Quote > )quote_
{
   [ self showOEForLeve4Quote: quote_ ];
}

@end
