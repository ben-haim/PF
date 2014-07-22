#import "PFMarketDepthViewController.h"
#import "PFLevel2QuotesViewController.h"
#import "PFOrderEntryViewController.h"
#import "PFSymbolCell.h"
#import "UIColor+Skin.h"
#import "UIView+AddSubviewAndScale.h"
#import "UILabel+Price.h"
#import "NSString+DoubleFormatter.h"
#import "UIImage+PFTableView.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFMarketDepthViewController ()< PFSessionDelegate, PFQuoteDependence, PFSymbolPriceCellDelegate >

@property ( nonatomic, strong ) id< PFSymbol > symbol;

@property ( nonatomic, strong ) PFLevel2QuotesViewController* depthController;
@property ( nonatomic, strong ) NSTimer* reloadTimer;

@property ( nonatomic, strong ) id< PFLevel2QuotePackage > quotes;
@property ( nonatomic, assign ) BOOL level1Changed;
@property ( nonatomic, assign ) BOOL level2Changed;
@property ( nonatomic, assign ) BOOL emptyTable;

@end

@implementation PFMarketDepthViewController

@synthesize spreadLabel;
@synthesize priceLabel;
@synthesize changeLabel;
@synthesize spreadNameLabel;
@synthesize priceNameLabel;
@synthesize changeNameLabel;
@synthesize titleView;
@synthesize depthView;
@synthesize depthController = _depthController;
@synthesize symbol;
@synthesize reloadTimer;
@synthesize quotes;
@synthesize level1Changed;
@synthesize level2Changed;
@synthesize emptyTable;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
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

   self.level2Changed = NO;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.priceNameLabel.text = [ NSLocalizedString( @"LAST", nil ) stringByAppendingString: @":" ];
   self.changeNameLabel.text = [ NSLocalizedString( @"DASHBOARD_CHANGE_PERCENT", nil ) stringByAppendingString: @":" ];
   self.spreadNameLabel.text = [ NSLocalizedString( @"SPREAD", nil ) stringByAppendingString: @":" ];
   
   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];

   if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
   {
      self.titleView.backgroundColor = [ UIColor navigationBarColor ];
   }
   
   [ self updatePrice ];
   [ self reloadData ];
}

-(void)reloadDataWithTimer:( NSTimer* )timer_
{
   if ( self.level2Changed )
   {
      [ self reloadData ];
   }
   
   if ( self.level1Changed )
   {
      [ self updatePrice ];
   }
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];

   self.reloadTimer = [ NSTimer scheduledTimerWithTimeInterval: 1.0
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
      [ PFOrderEntryViewController showWithLevel2Quote: quote_
                                             andSymbol: self.symbol ];
   }
}

#pragma mark - PFSessionDelegate

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
         self.level2Changed = YES;
      }
   }
}

-(void)updatePrice
{
   self.spreadLabel.text = self.symbol.quote ? [ NSString stringWithDouble: self.symbol.spread precision: 1 ] : nil;
   [ self.priceLabel showLastForSymbol: self.symbol ];
   [ self.changeLabel showColouredValue: self.symbol.changePercent precision: 2 suffix: @"%" ];
   
   self.level1Changed = NO;
}

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
  didLoadQuote:( id< PFQuote > )quote_
{
   if ( self.symbol == symbol_ )
   {
      self.level1Changed = YES;
   }
}

-(void)session:( PFSession* )session_
didSelectDefaultAccount:( id< PFAccount > )account_
{
   [ self reloadData ];
   [ self updatePrice ];
}

@end
