#import "PFMarketDepthViewController.h"

#import "PFLevel2QuotesViewController.h"
#import "PFOrderEntryViewController.h"

#import "PFSymbolCell.h"

#import "DDMenuController+PFTrader.h"
#import "UIView+AddSubviewAndScale.h"
#import "UILabel+Price.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFMarketDepthViewController ()< PFSessionDelegate, PFQuoteDependence, PFSymbolPriceCellDelegate >

@property ( nonatomic, strong ) id< PFSymbol > symbol;

@property ( nonatomic, strong ) PFLevel2QuotesViewController* depthController;
@property ( nonatomic, strong ) NSTimer* reloadTimer;

@property ( nonatomic, strong ) id< PFLevel2QuotePackage > quotes;
@property ( nonatomic, assign ) BOOL changed;
@property ( nonatomic, assign ) BOOL emptyTable;

@end

@implementation PFMarketDepthViewController

@synthesize nameLabel;
@synthesize priceLabel;
@synthesize changeLabel;
@synthesize priceNameLabel;
@synthesize changeNameLabel;
@synthesize depthView;
@synthesize depthController = _depthController;
@synthesize symbol;
@synthesize reloadTimer;
@synthesize quotes;
@synthesize changed;
@synthesize emptyTable;

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
   
   self.depthView = nil;
   self.priceLabel = nil;
   self.changeLabel = nil;
   self.priceNameLabel = nil;
   self.changeNameLabel = nil;
   self.depthController = nil;
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];

   if ( self )
   {
      self.title = NSLocalizedString( @"MARKET_DEPTH", nil );
      self.symbol = symbol_;
   }

   return self;
}

-(PFLevel2QuotesViewController*)depthController
{
   if ( !_depthController )
   {
      _depthController = [ PFLevel2QuotesViewController depthControllerWithSymbolCellDelegate: self symbol: self.symbol ];
      _depthController.view.backgroundColor = [ UIColor clearColor ];
      [ self.depthView addSubviewAndScale: _depthController.view ];
   }
   return _depthController;
}

-(void)reloadData
{
   self.quotes = self.symbol.level2Quotes;
   self.emptyTable = [ self.quotes count ] == 0;

   NSArray* sorted_bid_quotes_ = self.quotes.sortedAndAgregatedBidQuotes;
   NSArray* sorted_ask_quotes_ = self.quotes.sortedAndAgregatedAskQuotes;
   
   [ [ PFSession sharedSession ] recalcSpreadLevel2QuotesWithBidQuotes: sorted_bid_quotes_
                                                          AndAskQuotes: sorted_ask_quotes_
                                                         AndInstrument: self.symbol.instrument
                                                          AndLevel1Bid: self.symbol.realQuote.bid
                                                          AndLevel1Ask: self.symbol.realQuote.ask ];
   
    self.depthController.elements = [ sorted_ask_quotes_ arrayByAddingObjectsFromArray: sorted_bid_quotes_ ];
   [ self.depthController reloadData ];

   self.changed = NO;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.priceNameLabel.text = [ NSLocalizedString( @"LAST", nil ) stringByAppendingString: @":" ];
   self.changeNameLabel.text = [ NSLocalizedString( @"DASHBOARD_CHANGE_PERCENT", nil ) stringByAppendingString: @":" ];
   
   NSArray* buttons_ = [ self.parentViewController.menuController.delegate leftBarButtonItemsInMenuController: self.parentViewController.menuController ];
   if ( [ UINavigationItem instancesRespondToSelector: @selector(leftBarButtonItems) ] && [ buttons_ count ] > 0 )
   {
      self.navigationItem.leftItemsSupplementBackButton = YES;
      self.navigationItem.leftBarButtonItems = buttons_;
   }

   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];

   self.nameLabel.text = self.symbol.instrumentName;

   [ self updatePrice ];

   [ self reloadData ];
}

-(void)reloadDataWithTimer:( NSTimer* )timer_
{
   if ( self.changed )
   {
      [ self reloadData ];
   }
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];

   self.reloadTimer = [ NSTimer scheduledTimerWithTimeInterval: 2.0
                                                        target: self
                                                      selector: @selector( reloadDataWithTimer: )
                                                      userInfo: nil
                                                       repeats: YES ];

   [ [ PFSession sharedSession ].level2QuoteSubscriber addDependence: self
                                                           forSymbol: self.symbol ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];

   [ self.reloadTimer invalidate ];
   self.reloadTimer = nil;

   [ [ PFSession sharedSession ].level2QuoteSubscriber removeDependence: self
                                                              forSymbol: self.symbol ];
}

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
   didSelectLeve2Quote:( id< PFLevel2Quote > )quote_
{
   if ( [ [ PFSession sharedSession ] allowsTradingForSymbol: self.symbol ] )
   {
      PFOrderEntryViewController* order_entry_view_controller_ = [ [ PFOrderEntryViewController alloc ] initWithLevel2Quote: quote_
                                                                                                                  andSymbol: self.symbol ];
      [ order_entry_view_controller_ showControllerWithController: self ];
   }
}

#pragma mark PFSessionDelegate

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
didUpdateLevel2Quotes:( id< PFLevel2QuotePackage > )quotes_
{
   if ( self.symbol == symbol_ )
   {
      if ( self.emptyTable )
      {
         [ self reloadData ];
      }
      else
      {
         self.changed = YES;
      }
   }
}

-(void)updatePrice
{
   [ self.priceLabel showLastForSymbol: self.symbol ];

   NSUInteger change_precision_ = 2;
   
   [ self.changeLabel showColouredValue: self.symbol.changePercent precision: change_precision_ ];
}

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
  didLoadQuote:( id< PFQuote > )quote_
{
   if ( self.symbol == symbol_ )
   {
      [ self updatePrice ];
   }
}

-(void)session:( PFSession* )session_
didSelectDefaultAccount:(id<PFAccount>)account_
{
   [ self reloadData ];
}

@end
