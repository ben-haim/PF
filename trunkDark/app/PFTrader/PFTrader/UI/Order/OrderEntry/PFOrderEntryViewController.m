#import "PFOrderEntryViewController.h"

#import "PFTableView.h"
#import "PFTableViewCategory+Order.h"
#import "PFSettings.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFOrderEntryViewController ()

@property ( nonatomic, strong ) NSArray* categories;
@property ( nonatomic, strong ) id< PFLevel4Quote > optionQuote;
@property ( nonatomic, strong ) id< PFLevel2Quote > level2Quote;
@property ( nonatomic, assign ) BOOL level4Mode;
@property ( nonatomic, assign, readonly ) PFSettings* currentSettings;


@end

@implementation PFOrderEntryViewController

@synthesize placeBuyButton;
@synthesize placeSellButton;
@synthesize bidTextLabel;
@synthesize askTextLabel;

@synthesize categories = _categories;
@synthesize optionQuote;
@synthesize level2Quote;
@synthesize level4Mode;

+(void)showWithSymbol:( id< PFSymbol > )symbol_
{
   [ [ [ PFOrderEntryViewController alloc ] initWithSymbol: symbol_ ] showAsDialog ];
}

+(void)showWithLevel4Quote:( id< PFLevel4Quote > )level4_quote_
{
   [ [ [ PFOrderEntryViewController alloc ] initWithLevel4Quote: level4_quote_ ] showAsDialog ];
}

+(void)showWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
                 andSymbol:( id< PFSymbol >)symbol_
{
   [ [ [ PFOrderEntryViewController alloc ] initWithLevel2Quote: level2_quote_ andSymbol: symbol_ ] showAsDialog ];
}

-(id)initWithsymbol:( id< PFSymbol > )symbol_
        level2Quote:( id< PFLevel2Quote > )level2_quote_
       isLevel4Mode:( BOOL )is_level4_mode_
{
   self = [ super initWithTitle: NSLocalizedString( @"ORDER_ENTRY", nil ) symbol: symbol_ ];
   
   if ( self )
   {
      self.level4Mode = is_level4_mode_;
      self.level2Quote = level2_quote_;
      PFOrderType current_order_type_ = level2_quote_ ? PFOrderLimit : ( is_level4_mode_ ? PFOrderMarket : self.currentSettings.orderType );
      id< PFSymbol > current_symbol_ = level2_quote_ ? level2_quote_.symbol : self.symbol;
      
      self.accountCategory = ([ PFSession sharedSession ].accounts.accounts.count > 1) ? [ PFTableViewCategory accountCategoryWithController: self
                                                                                                                                        type: current_order_type_
                                                                                                                                 level2Quote: level2_quote_
                                                                                                                                isLevel4Mode: is_level4_mode_ ] : nil;
      
      self.slCategory = [ PFTableViewCategory stopLossCategoryWithController: self ];
      self.tpCategory = [ PFTableViewCategory takeProfitCategoryWithController: self ];
      
      if (self.level4Mode || ![PFSession sharedSession].accounts.defaultAccount.allowsSLTP)
      {
         self.slCategory.items = self.tpCategory.items = nil;
         self.slCategory.title = nil;
      }
      
      self.quantityCategory = [ PFTableViewCategory quantityCategoryWithController: self lots: self.currentSettings.lots ];
      
      self.validityCategory = [ PFTableViewCategory categoryWithValidity: self.currentSettings.orderValidity
                                                    andAllowedValidities: [ current_symbol_ allowedValiditiesForOrderType: current_order_type_ ]
                                                              controller: self ];
      
      self.orderTypeCategory = self.level2Quote ? [ PFTableViewCategory orderTypeCategoryWithController: self level2Quote: self.level2Quote ] :
      ( self.level4Mode ? nil : [ PFTableViewCategory orderTypeCategoryWithController: self type: current_order_type_ ] );
      
      
      if ( self.level4Mode )
      {
         self.categories = @[self.accountCategory
                            , self.quantityCategory
                            , self.validityCategory];
      }
      else
      {
         self.categories = self.accountCategory ? @[self.accountCategory] : [ NSArray new ];
         self.categories = [ self.categories arrayByAddingObjectsFromArray: @[self.orderTypeCategory
                                                                             , self.quantityCategory
                                                                             , self.validityCategory
                                                                             , self.slCategory
                                                                             , self.tpCategory] ];
      }
   }
   
   return self;
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
{
   return [ self initWithsymbol: symbol_
                    level2Quote: nil
                   isLevel4Mode: NO ];
}

-(id)initWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
               andSymbol:( id< PFSymbol >)symbol_
{
   return [ self initWithsymbol: symbol_
                    level2Quote: level2_quote_
                   isLevel4Mode: NO ];
}

-(id)initWithLevel4Quote:( id< PFLevel4Quote > )level4_quote_
{
   self = [ self initWithsymbol: level4_quote_.symbol
                    level2Quote: nil
                   isLevel4Mode: YES ];
   
   if ( self )
   {
      self.optionQuote = level4_quote_;
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ self.placeBuyButton setTitle: NSLocalizedString( @"BUY", nil ) forState: UIControlStateNormal ];
   [ self.placeSellButton setTitle: NSLocalizedString( @"SELL", nil ) forState: UIControlStateNormal ];
   
   if ( self.optionQuote )
   {
      NSDateFormatter* date_formatter_ = [ [ NSDateFormatter alloc ] init ];
      date_formatter_.dateFormat = @"MMM dd";
      
      self.nameLabel.text = [ NSString stringWithFormat: @"%@ %@ %@ %@"
                             , self.optionQuote.underlier
                             , self.optionQuote.optionType == PFSymbolOptionTypeCallVanilla ? @"C" : @"P"
                             , [ date_formatter_ stringFromDate: self.optionQuote.expirationDate ]
                             , [ NSString stringWithPrice: self.optionQuote.strikePrice symbol: self.symbol ] ];
      
      self.bidTextLabel.hidden = self.bidLabel.hidden = self.askTextLabel.hidden = self.askLabel.hidden = YES;
      
   }
   self.overviewLabel.text = self.symbol.instrument.overview;
   self.tableView.categories = self.categories;
   [ self.tableView reloadData ];
}

-(PFSettings*)currentSettings
{
   return [ PFSettings sharedSettings ];
}

-(void)updateButtonsVisibility
{
   self.placeBuyButton.hidden = self.placeSellButton.hidden = ![ [ PFSession sharedSession ] allowsPlaceOperationsGivenAccountForSymbol: self.symbol ];
}

+(void)directPlaceMarketOrderForSymbol:( id< PFSymbol > )symbol_
                            withAmount:( double )amount_
                               buyMode:( BOOL )buy_
{
   PFOrder* order_ = [ PFOrder new ];
   
   order_.instrumentId = symbol_.instrumentId;
   order_.routeId = symbol_.routeId;
   order_.optionType = symbol_.optionType;
   order_.expDay = symbol_.expDay;
   order_.expMonth = symbol_.expMonth;
   order_.expYear = symbol_.expYear;
   order_.accountId = [ PFSession sharedSession ].accounts.defaultAccount.accountId;
   order_.operationType = buy_ ? PFMarketOperationBuy : PFMarketOperationSell;
   order_.price = buy_ ? symbol_.quote.ask : symbol_.quote.bid;
   order_.orderType = PFOrderMarket;
   order_.amount = amount_;
   
   [ [ PFSession sharedSession ] createOrder: order_ ];
}

+(void)placeMarketOrderForSymbol:( id< PFSymbol > )symbol_
                      withAmount:( double )amount_
                         buyMode:( BOOL )buy_
{
   if ( [ PFSettings sharedSettings ].shouldConfirmPlaceOrder )
   {
      [ PFMarketOperationViewController showConfirmWithText: NSLocalizedString( @"PLACE_CONFIRMATION", nil )
                                                 actionText: NSLocalizedString( @"PLACE_ORDER", nil )
                                         confirmActionBlock: ^{ [ PFOrderEntryViewController directPlaceMarketOrderForSymbol: symbol_ withAmount: amount_ buyMode: buy_ ]; } ];
   }
   else
   {
      [ PFOrderEntryViewController directPlaceMarketOrderForSymbol: symbol_ withAmount: amount_ buyMode: buy_ ];
   }
}

-(void)placeOrderWithOperationType:( PFMarketOperationType )operation_type_
{
   PFOrder* order_ = [ PFOrder new ];
   order_.accountId = [ PFSession sharedSession ].accounts.defaultAccount.accountId;
   order_.operationType = operation_type_;
   
   if ( self.optionQuote )
   {
      order_.instrumentId = self.optionQuote.symbol.instrumentId;
      order_.routeId = self.optionQuote.symbol.routeId;
      order_.optionType = self.optionQuote.optionType;
      order_.expDay = self.optionQuote.expDay;
      order_.expMonth = self.optionQuote.expMonth;
      order_.expYear = self.optionQuote.expYear;
      order_.price = operation_type_ == PFMarketOperationBuy ? self.optionQuote.ask : self.optionQuote.bid;
      order_.strikePrice = self.optionQuote.strikePrice;
      order_.orderType = PFOrderMarket;
   }
   else
   {
      order_.instrumentId = self.symbol.instrumentId;
      order_.routeId = self.symbol.routeId;
      order_.optionType = self.symbol.optionType;
      order_.expDay = self.symbol.expDay;
      order_.expMonth = self.symbol.expMonth;
      order_.expYear = self.symbol.expYear;
      order_.price = operation_type_ == PFMarketOperationBuy ? self.symbol.quote.ask : self.symbol.quote.bid;
   }
   
   [ self.categories makeObjectsPerformSelector: @selector( performApplierForObject: ) withObject: order_ ];
   
   if ( order_.orderType == PFOrderTrailingStop && order_.operationType == PFMarketOperationSell && order_.trailingOffset > self.symbol.quote.bid )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString(@"INVALID_TR_OFFSET", nil) ];
      return;
   }
   
   if ( [ self checkSLTPForMarketOperation: order_ ] )
   {
      [ [ PFSession sharedSession ] createOrder: order_ ];
      [ self close ];
   }
}

-(void)placeOrderActionWithOperationType:( PFMarketOperationType )operation_type_
{
   if ( [ PFSettings sharedSettings ].shouldConfirmPlaceOrder )
   {
      [ PFMarketOperationViewController showConfirmWithText: NSLocalizedString( @"PLACE_CONFIRMATION", nil )
                                                 actionText: NSLocalizedString( @"PLACE_ORDER", nil )
                                         confirmActionBlock: ^{ [ self placeOrderWithOperationType: operation_type_ ]; } ];
   }
   else
   {
      [ self placeOrderWithOperationType: operation_type_ ];
   }
}

-(IBAction)placeBuyOrderAction:( id )sender_
{
   [ self placeOrderActionWithOperationType: PFMarketOperationBuy ];
}
-(IBAction)placeSellOrderAction:( id )sender_
{
   [ self placeOrderActionWithOperationType: PFMarketOperationSell ];
}

@end
