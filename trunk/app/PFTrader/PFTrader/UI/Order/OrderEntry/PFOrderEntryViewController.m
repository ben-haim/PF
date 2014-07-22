#import "PFOrderEntryViewController.h"

#import "PFTableView.h"
#import "PFBuySellSelector.h"
#import "PFTableViewCategory+Order.h"
#import "PFSettings.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFOrderEntryViewController ()

@property ( nonatomic, strong ) NSArray* categories;
@property ( nonatomic, assign ) PFMarketOperationType operationType;

@property ( nonatomic, strong ) id< PFLevel4Quote > optionQuote;
@property ( nonatomic, assign, readonly ) PFSettings* currentSettings;

@end

@implementation PFOrderEntryViewController

@synthesize buySellSelector;
@synthesize placeButton;
@synthesize bidTextLabel;
@synthesize askTextLabel;

@synthesize categories = _categories;
@synthesize operationType;

@synthesize optionQuote;

-(PFSettings*)currentSettings
{
   return [ PFSettings sharedSettings ];
}

-(void)dealloc
{
   self.bidTextLabel = nil;
   self.askTextLabel = nil;
   self.placeButton = nil;
   self.buySellSelector = nil;
}

-(id)initWithsymbol:( id< PFSymbol > )symbol_
      operationType:( PFMarketOperationType )operation_type_
        level2Quote:( id< PFLevel2Quote > )level2_quote_
       isLevel4Mode:( BOOL )is_level4_mode_
{
   self = [ super initWithTitle: NSLocalizedString( @"ORDER_ENTRY", nil ) symbol: symbol_ ];
   
   if ( self )
   {
      self.operationType = operation_type_;
      
      PFOrderType current_order_type_ = level2_quote_ ? PFOrderLimit : ( is_level4_mode_ ? PFOrderMarket : self.currentSettings.orderType );
      id< PFSymbol > current_symbol_ = level2_quote_ ? level2_quote_.symbol : self.symbol;
      
       self.accountCategory = ([ PFSession sharedSession ].accounts.accounts.count > 1) ?
           [ PFTableViewCategory accountCategoryWithController: self
                                                          type: self.currentSettings.orderType
                                                   level2Quote: level2_quote_
                                                  isLevel4Mode: is_level4_mode_ ] : nil;

      self.quantityCategory = [ PFTableViewCategory quantityCategoryWithController: self lots: self.currentSettings.lots ];

      self.orderTypeCategory = level2_quote_ ? [ PFTableViewCategory orderTypeCategoryWithController: self level2Quote: level2_quote_ ] :
      ( is_level4_mode_ ? nil : [ PFTableViewCategory orderTypeCategoryWithController: self type: self.currentSettings.orderType ] );
      
      self.validityCategory = [ PFTableViewCategory categoryWithValidity: self.currentSettings.orderValidity
                                                    andAllowedValidities: [ current_symbol_ allowedValiditiesForOrderType: current_order_type_ ]
                                                              controller: self ];
      
      self.slCategory = is_level4_mode_ ? nil : [ PFTableViewCategory stopLossCategoryWithController: self ];
      self.tpCategory = is_level4_mode_ ? nil : [ PFTableViewCategory takeProfitCategoryWithController: self ];
      
      if ( is_level4_mode_ )
      {
         self.categories = [ NSArray arrayWithObjects: self.accountCategory
                            , self.quantityCategory
                            , self.validityCategory
                            , nil ];
      }
      else
      {
         self.categories = self.accountCategory ? [ NSArray arrayWithObject: self.accountCategory ] : [ NSArray new ];
         self.categories = [ self.categories arrayByAddingObjectsFromArray: [ NSArray arrayWithObjects: self.orderTypeCategory
                                                                             , self.quantityCategory
                                                                             , self.validityCategory
                                                                             , self.slCategory
                                                                             , self.tpCategory
                                                                             , nil ] ];
      }
      
   }
   
   return self;
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
      operationType:( PFMarketOperationType )operation_type_
{
   return [ self initWithsymbol: symbol_
                  operationType: operation_type_
                    level2Quote: nil
                   isLevel4Mode: NO ];
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
{
   return [ self initWithSymbol: symbol_ operationType: PFMarketOperationBuy ];
}

-(id)initWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
               andSymbol:( id< PFSymbol >)symbol_
{
   return [ self initWithsymbol: symbol_
                  operationType: level2_quote_.side == PFLevel2QuoteSideBid ? PFMarketOperationBuy : PFMarketOperationSell
                    level2Quote: level2_quote_
                   isLevel4Mode: NO ];
}

-(id)initWithLevel4Quote:( id< PFLevel4Quote > )level4_quote_ bidMode:( BOOL )bid_mode_
{
   self = [ self initWithsymbol: level4_quote_.symbol
                  operationType: bid_mode_ ? PFMarketOperationSell : PFMarketOperationBuy
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

   [ self.placeButton setTitle: NSLocalizedString( @"PLACE_ORDER_BUTTON", nil ) forState: UIControlStateNormal ];
   
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

   self.buySellSelector.buy = self.operationType == PFMarketOperationBuy;
}

-(void)updateButtonsVisibility
{
   self.placeButton.hidden = ! [ [ PFSession sharedSession ] allowsMarketOperationsForSymbol: self.symbol ];
}

+(void)directPlaceMarketOrderForSymbol:( id< PFSymbol > )symbol_ withAmount:( double )amount_ buyMode:( BOOL )buy_
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

+(void)placeMarketOrderForSymbol:( id< PFSymbol > )symbol_ withAmount:( double )amount_ buyMode:( BOOL )buy_
{
   if ( [ PFSettings sharedSettings ].shouldConfirmPlaceOrder )
   {
      JFFAlertButton* place_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"PLACE_ORDER", nil )
                                                            action: ^( JFFAlertView* sender_ )
                                       {
                                          [ PFOrderEntryViewController directPlaceMarketOrderForSymbol: symbol_ withAmount: amount_ buyMode: buy_ ];
                                       } ];
      
      JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: nil
                                                        message: NSLocalizedString( @"PLACE_CONFIRMATION", nil )
                                              cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                              otherButtonTitles: place_button_, nil ];
      
      [ alert_view_ show ];
   }
   else
   {
      [ PFOrderEntryViewController directPlaceMarketOrderForSymbol: symbol_ withAmount: amount_ buyMode: buy_ ];
   }
}

-(void)placeOrder
{
   PFOrder* order_ = [ PFOrder new ];
   order_.accountId = [ PFSession sharedSession ].accounts.defaultAccount.accountId;
   order_.operationType = self.operationType;
   
   if ( self.optionQuote )
   {
      order_.instrumentId = self.optionQuote.symbol.instrumentId;
      order_.routeId = self.optionQuote.symbol.routeId;
      order_.optionType = self.optionQuote.optionType;
      order_.expDay = self.optionQuote.expDay;
      order_.expMonth = self.optionQuote.expMonth;
      order_.expYear = self.optionQuote.expYear;
      order_.price = self.operationType == PFMarketOperationBuy ? self.optionQuote.ask : self.optionQuote.bid;
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
      order_.price = self.operationType == PFMarketOperationBuy ? self.symbol.quote.ask : self.symbol.quote.bid;
   }

   [ self.categories makeObjectsPerformSelector: @selector( performApplierForObject: )
                                     withObject: order_ ];
   
   if ( order_.orderType == PFOrderTrailingStop
       && order_.operationType == PFMarketOperationSell
       && order_.trailingOffset > self.symbol.quote.bid )
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

-(IBAction)placeOrderAction:( id )sender_
{
   if ( [ PFSettings sharedSettings ].shouldConfirmPlaceOrder )
   {
      JFFAlertButton* place_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"PLACE_ORDER", nil )
                                                            action: ^( JFFAlertView* sender_ )
                                       {
                                          [ self placeOrder ];
                                       } ];

      JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: nil
                                                        message: NSLocalizedString( @"PLACE_CONFIRMATION", nil )
                                              cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                              otherButtonTitles: place_button_, nil ];

      [ alert_view_ show ];
   }
   else
   {
      [ self placeOrder ];
   }
}

-(void)buySellSelector:( PFBuySellSelector* )selector_
          didSelectBuy:( BOOL )buy_
{
   self.operationType = buy_ ? PFMarketOperationBuy : PFMarketOperationSell;
}

@end
