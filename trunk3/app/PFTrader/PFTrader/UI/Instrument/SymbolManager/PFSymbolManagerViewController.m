#import "PFSymbolManagerViewController.h"

#import "PFGridActionView.h"
#import "PFLoadingView.h"

#import "PFOrderEntryViewController.h"
#import "PFChartViewController_iPad.h"
#import "PFChartViewController.h"
#import "PFMarketDepthViewController.h"
#import "PFOptionChainViewController_iPad.h"
#import "PFOptionChainViewController.h"
#import "PFSymbolInfoViewController.h"

#import "PFSettings.h"
#import "PFChartSettings.h"
#import "PFHistoryCache.h"
#import "HLOCDataSource+PFLotsQuote.h"
#import "PFChartPeriodTypeConversion.h"
#import "UIImage+Icons.h"
#import "UILabel+Price.h"
#import "NSString+DoubleFormatter.h"

//!XiP
#import "Utils.h"
#import "FinanceChart.h"
#import "ChartSensorView.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <ProFinanceApi/Detail/Chart/PFQuoteFilesReader.h>

#import <JFFMessageBox/JFFMessageBox.h>

@interface PFSymbolManagerViewController () < PFSessionDelegate, PFQuoteFilesReaderDelegate, PFQuoteDependence >

@property ( nonatomic, strong ) id< PFSymbol > symbol;
@property ( nonatomic, strong ) NSArray* symbols;
@property ( nonatomic, assign ) NSUInteger watchlistRowIndex;

@property ( nonatomic, strong ) HLOCDataSource* dataSource;
@property ( nonatomic, strong ) id< PFQuoteFilesReader > reader;
@property ( nonatomic, assign ) BOOL tradesMode;

@property ( nonatomic, strong ) PFLoadingView* loadingIndicator;
@property ( nonatomic, weak ) NSTimer* updateTimer;
@property ( nonatomic, assign ) BOOL needUpdatePrice;

@end

@implementation PFSymbolManagerViewController

@synthesize wrapController;
@synthesize chartHolderView;
@synthesize chartView;
@synthesize sensorView;
@synthesize actionsView;
@synthesize symbolNameLabel;
@synthesize symbolOverviewLabel;
@synthesize emptyLabel;
@synthesize loadingIndicator = _loadingIndicator;

@synthesize dataSource;
@synthesize reader;
@synthesize tradesMode;
@synthesize symbol;
@synthesize symbols;
@synthesize watchlistRowIndex;

@synthesize bidNameLabel;
@synthesize changeNameLabel;
@synthesize highNameLabel;
@synthesize bidValueLabel;
@synthesize changeValueLabel;
@synthesize highValueLabel;
@synthesize spreadNameLabel;
@synthesize lastNameLabel;
@synthesize lowNameLabel;
@synthesize spreadValueLabel;
@synthesize lastValueLabel;
@synthesize lowValueLabel;
@synthesize askNameLabel;
@synthesize closeNameLabel;
@synthesize openNameLabel;
@synthesize askValueLabel;
@synthesize closeValueLabel;
@synthesize openValueLabel;

@synthesize updateTimer;
@synthesize needUpdatePrice;

-(PFLoadingView*)loadingIndicator
{
   if ( !_loadingIndicator )
   {
      _loadingIndicator = [ PFLoadingView new ];
      _loadingIndicator.indicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
      _loadingIndicator.backgroundColor = [ UIColor clearColor ];
   }
   return _loadingIndicator;
}

-(PFChartSettings*)settings
{
   return [ PFChartSettings sharedDefaultSettings ];
}

-(UINavigationController*)currentNavigationController
{
   return self.wrapController.navigationController ? self.wrapController.navigationController : self.navigationController;
}

-(void)showOrderEntry
{
   [ [ [ PFOrderEntryViewController alloc ] initWithSymbol: self.symbol ] showControllerWithController: self.wrapController ? self.wrapController : self ];
}

-(void)showChart
{
   PFChartViewController* chart_view_controller_ = self.wrapController ?
   [ [ PFChartViewController_iPad alloc ] initWithSymbol: self.symbol andSymbols: self.symbols ] :
   [ [ PFChartViewController alloc ] initWithSymbol: self.symbol andSymbols: self.symbols ];
   
   [ self.currentNavigationController pushViewController: chart_view_controller_ animated: YES ];
}

-(void)showMarketDepth
{
   [ self.currentNavigationController pushViewController: [ [ PFMarketDepthViewController alloc ] initWithSymbol: self.symbol ]
                                                animated: YES ];
}

-(void)showOptionChainForSymbol:( id< PFSymbol > )symbol_
{
   PFOptionChainViewController* option_chain_controller_ = self.wrapController ?
   [ [ PFOptionChainViewController_iPad alloc ] initWithSymbol: symbol_ andBaseSymbol: self.symbol ] :
   [ [ PFOptionChainViewController alloc ] initWithSymbol: symbol_ andBaseSymbol: self.symbol ];
   
   [ self.currentNavigationController pushViewController: option_chain_controller_ animated: YES ];
}

-(void)showSymbolInfo
{
   [ self.currentNavigationController pushViewController: [ [ PFSymbolInfoViewController alloc ] initWithSymbol: self.symbol ]
                                                animated: YES ];
}

-(NSArray*)actions
{
   __weak PFSymbolManagerViewController* unsafe_self_ = self;
   
   PFGridActionBlock oe_action_ = ^( NSUInteger row_index_ ) { [ unsafe_self_ showOrderEntry ]; };
   PFGridActionVisibilityBlock oe_visibility_ = ^BOOL(NSUInteger row_index_) { return [ [ PFSession sharedSession ] allowsTradingForSymbol: unsafe_self_.symbol ]; };
   
   PFGridActionBlock chart_action_ = ^( NSUInteger row_index_ ) { [ unsafe_self_ showChart ]; };
   
   PFGridActionBlock market_depth_action_ = ^( NSUInteger row_index_ ) { [ unsafe_self_ showMarketDepth ]; };
   PFGridActionVisibilityBlock market_depth_visibility_ = ^BOOL(NSUInteger row_index_) { return [ PFSession sharedSession ].accounts.defaultAccount.allowsLevel2; };
   
   PFGridActionBlock symbol_info_action_ = ^( NSUInteger row_index_ ){ [ unsafe_self_ showSymbolInfo ]; };
   PFGridActionVisibilityBlock symbol_info_visibility_ = ^BOOL(NSUInteger row_index_) { return [ PFSession sharedSession ].accounts.defaultAccount.allowsSymbolInfo; };
   
   PFGridActionBlock option_chain_action_ = ^( NSUInteger row_index_ )
   {
      for (id< PFSymbol > option_symbol_ in [ PFSession sharedSession ].optionSymbols )
      {
         if ( option_symbol_.baseInstrumentId == unsafe_self_.symbol.instrumentId )
         {
            [ unsafe_self_ showOptionChainForSymbol: option_symbol_ ];
            return;
         }
      }
      
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString(@"NO_OPTION_FOR_SYMBOL", nil) ];
   };
   
   PFGridActionVisibilityBlock option_chain_visibility_ = ^BOOL(NSUInteger row_index_)
   {
      if ( ![ PFSession sharedSession ].accounts.defaultAccount.allowsOptions )
      {
         return NO;
      }
      else
      {
         for (id< PFSymbol > option_symbol_ in [ PFSession sharedSession ].optionSymbols )
         {
            if ( option_symbol_.baseInstrumentId == unsafe_self_.symbol.instrumentId )
               return YES;
         }
         return NO;
      }
   };
   
   return [ NSArray arrayWithObjects: [ PFGridAction actionWithImage: [ UIImage orderEntryIcon ]
                                                    highlightedImage: [ UIImage orderEntryIconHighlighted ]
                                                              action: oe_action_
                                                     visibilityBlock: oe_visibility_ ]
           , [ PFGridAction actionWithImage: [ UIImage chartIconRound ]
                           highlightedImage: [ UIImage chartIconRoundHighlighted ]
                                     action: chart_action_ ]
           , [ PFGridAction actionWithImage: [ UIImage marketDepthIcon ]
                           highlightedImage: [ UIImage marketDepthIconHighlighted ]
                                     action: market_depth_action_
                            visibilityBlock: market_depth_visibility_ ]
           , [ PFGridAction actionWithImage: [ UIImage optionChainIcon ]
                           highlightedImage: [ UIImage optionChainIconHighlighted ]
                                     action: option_chain_action_
                            visibilityBlock: option_chain_visibility_ ]
           , [ PFGridAction actionWithImage: [ UIImage symbolInfoIcon ]
                           highlightedImage: [ UIImage symbolInfoIconHighlighted ]
                                     action: symbol_info_action_
                            visibilityBlock: symbol_info_visibility_ ]
           , nil ];
}

//!Workaround for assign delegate
-(void)dealloc
{
   [ self.reader stop ];
   self.reader = nil;
   self.dataSource = nil;
   
   [ [ PFSession sharedSession ].level3QuoteSubscriber removeDependence: self
                                                              forSymbol: self.symbol ];
   
   [ [ PFSession sharedSession ] removeDelegate: self ];
   [ [ PFHistoryCache historyCache ] closeCache ];
   
   self.bidNameLabel = nil;
   self.changeNameLabel = nil;
   self.highNameLabel = nil;
   self.bidValueLabel = nil;
   self.changeValueLabel = nil;
   self.highValueLabel = nil;
   self.spreadNameLabel = nil;
   self.lastNameLabel = nil;
   self.lowNameLabel = nil;
   self.spreadValueLabel = nil;
   self.lastValueLabel = nil;
   self.lowValueLabel = nil;
   self.askNameLabel = nil;
   self.closeNameLabel = nil;
   self.openNameLabel = nil;
   self.askValueLabel = nil;
   self.closeValueLabel = nil;
   self.openValueLabel = nil;
   self.chartHolderView = nil;
   self.symbolNameLabel = nil;
   self.symbolOverviewLabel = nil;
   self.actionsView = nil;
   self.emptyLabel = nil;
   self.loadingIndicator = nil;
   self.chartView = nil;
   self.sensorView = nil;
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
            symbols:( NSArray* )symbols_
           rowIndex:( NSUInteger )row_index_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"DASHBOARD", nil );
      self.symbol = symbol_;
      self.symbols = symbols_;
      self.watchlistRowIndex = row_index_;
   }
   
   return self;
}

-(void)loadDefaultQuotes
{
   [ self.reader stop ];
   self.reader = nil;
   
   self.dataSource = nil;
   self.chartView.hidden = YES;
   self.emptyLabel.hidden = YES;
   [ self.loadingIndicator showInView: self.chartHolderView ];
   
   __weak PFSymbolManagerViewController* weak_self_ = self;
   
   PFChartPeriodType period_ = [ PFSettings sharedSettings ].defaultChartPeriod;
   [ [ PFSession sharedSession ] historyReaderForSymbol: weak_self_.symbol
                                                 period: period_
                                               fromDate: PFFromDateForPeriod( period_ )
                                                 toDate: [ NSDate date ]
                                              doneBlock: ^( id< PFQuoteFilesReader > file_reader_ )
    {
       weak_self_.reader = file_reader_;
       [ weak_self_.reader startWithDelegate: weak_self_ ];
    } ];
}

-(void)updatePrice
{
   if ( self.needUpdatePrice )
   {
      [ self.bidValueLabel showBidForSymbol: self.symbol ];
      [ self.askValueLabel showAskForSymbol: self.symbol ];
      [ self.lastValueLabel showLastForSymbol: self.symbol ];
      [ self.changeValueLabel showColouredValue: self.symbol.changePercent precision: 2 ];
      
      if ( self.symbol.quote )
      {
         self.openValueLabel.text = [ NSString stringWithPrice: self.symbol.quote.open symbol: self.symbol ];
         self.highValueLabel.text = [ NSString stringWithPrice: self.symbol.quote.high symbol: self.symbol ];
         self.lowValueLabel.text = [ NSString stringWithPrice: self.symbol.quote.low symbol: self.symbol ];
         self.closeValueLabel.text = [ NSString stringWithPrice: self.symbol.quote.previousClose symbol: self.symbol ];
         self.spreadValueLabel.text = [ NSString stringWithDouble: self.symbol.spread precision: 1 ];
      }
      else
      {
         self.openValueLabel.text = nil;
         self.highValueLabel.text = nil;
         self.lowValueLabel.text = nil;
         self.closeValueLabel.text = nil;
         self.spreadValueLabel.text = nil;
      }
      
      self.needUpdatePrice = NO;
   }
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   if ( self.symbol )
   {
      self.symbolNameLabel.text = self.symbol.name;
      self.symbolOverviewLabel.text = self.symbol.overview;
      
      self.bidNameLabel.text = [ NSLocalizedString( @"DASHBOARD_BID", nil ) stringByAppendingString: @":" ];
      self.changeNameLabel.text = [ NSLocalizedString( @"DASHBOARD_CHANGE_PERCENT", nil ) stringByAppendingString: @":" ];
      self.highNameLabel.text = [ NSLocalizedString( @"DASHBOARD_HIGH", nil ) stringByAppendingString: @":" ];
      self.spreadNameLabel.text = [ NSLocalizedString( @"DASHBOARD_SPREAD", nil ) stringByAppendingString: @":" ];
      self.lastNameLabel.text = [ NSLocalizedString( @"DASHBOARD_LAST", nil ) stringByAppendingString: @":" ];
      self.lowNameLabel.text = [ NSLocalizedString( @"DASHBOARD_LOW", nil ) stringByAppendingString: @":" ];
      self.askNameLabel.text = [ NSLocalizedString( @"DASHBOARD_ASK", nil ) stringByAppendingString: @":" ];
      self.closeNameLabel.text = [ NSLocalizedString( @"DASHBOARD_CLOSE", nil ) stringByAppendingString: @":" ];
      self.openNameLabel.text = [ NSLocalizedString( @"DASHBOARD_OPEN", nil ) stringByAppendingString: @":" ];
      
      self.needUpdatePrice = YES;
      [ self updatePrice ];
      
      [ self.actionsView addSubview: [ [ PFGridActionView alloc ] initWithActions: self.actions
                                                                              row: self.watchlistRowIndex
                                                                        fixedWith: 0.f
                                                                    startFromZero: YES ] ];
      if ( self.symbol.barType == 1 )
      {
         [ [ PFSession sharedSession ].level3QuoteSubscriber addDependence: self
                                                                 forSymbol: self.symbol ];
      }
      
//      __weak PFSymbolManagerViewController* unsafe_controller_ = self;
//      self.chartView.tapBlock = ^() { [ unsafe_controller_ showChart ]; };

      [ self.chartView setChartSettingsWithPropertiesStore: self.settings.properties ];
      [ self.chartView setParent: nil ];
      [ self.chartView updateChartSensor: self.sensorView ];

      [ [ PFSession sharedSession ] addDelegate: self ];
      [ [ PFHistoryCache historyCache ] openCache ];
      [ self loadDefaultQuotes ];
   }
   else
   {
      self.chartView.hidden = YES;
      self.emptyLabel.hidden = NO;
   }
}

-(void)viewDidAppear:( BOOL )animated_
{
   [ super viewDidAppear: animated_ ];
   
   self.updateTimer = [ NSTimer scheduledTimerWithTimeInterval: 1.0
                                                        target: self
                                                      selector: @selector(updatePrice)
                                                      userInfo: nil
                                                       repeats: YES ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self.updateTimer invalidate ];
   self.updateTimer = nil;
}

-(void)addQuotes:( NSArray* )quotes_
          period:( PFChartPeriodType )period_
{
   self.tradesMode = [ [ quotes_ lastObject ] isMemberOfClass: [ PFTradesMinQuote class ] ];
   
   self.dataSource = [ HLOCDataSource dataSourceWithQuotes: quotes_
                                                    symbol: self.symbol
                                                    period: period_ ];
   
   if ( self.dataSource )
   {
      self.chartView.hidden = NO;
      [ self.chartView SetData: self.dataSource ForSymbol: self.symbol.name ];
   }
   else
   {
      self.emptyLabel.hidden = NO;
   }
}

-(void)mergePriceWithBid: (double)bid_
                  AndAsk: (double)ask_
               AndVolume: (int)volume_
                  AtTime: (NSDate*)time_
{
   if ( self.dataSource && bid_ > 0.0 && ask_ > 0.0 )
   {
      BOOL new_candle_created_ = [ self.dataSource MergePriceWithBid: bid_
                                                              AndAsk: ask_
                                                           AndVolume: volume_
                                                              AtTime: time_ ];
      
      [ self.chartView tickAdded ];
      
      if ( new_candle_created_ )
      {
         self.chartView.startIndex++;
         [ self.chartView RecalcScroll ];
         [ self.chartView tickAdded ];
      }
   }
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
  didLoadQuote:( id< PFQuote > )quote_
{
   if ( [ self.symbol isEqual: symbol_ ] )
   {
      self.needUpdatePrice = YES;
      
      if ( !self.tradesMode )
      {
         [ self mergePriceWithBid: quote_.bid
                           AndAsk: quote_.ask
                        AndVolume: 1
                           AtTime: quote_.date ];
      }
   }
}

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
didLoadTradeQuote:( id< PFLevel3Quote > )trade_quote_
{
   if ( [ self.symbol isEqual: symbol_ ] && self.tradesMode )
   {
      [ self mergePriceWithBid: trade_quote_.price
                        AndAsk: trade_quote_.price
                     AndVolume: trade_quote_.size
                        AtTime: trade_quote_.date ];
   }
}

#pragma mark - PFQuoteFilesReaderDelegate

-(NSData*)reader:( id< PFQuoteFilesReader > )reader_
    dataFromFile:( NSString* )file_name_
   WithSignature:( NSString* )signature_
{
   return self.reader == reader_ ?
   [ [ PFHistoryCache historyCache ] datafromFileWithName: file_name_
                                                     hash: signature_
                                               fromServer: reader_.server
                                                forSymbol: self.symbol.name
                                                     type: reader_.basePeriod ] :
   nil;
}

-(void)reader:( id< PFQuoteFilesReader > )reader_
saveFileWithName: (NSString*)name_
         data: (NSData*)data_
         hash: (NSString*)md5_hash_
{
   if ( self.reader == reader_ )
   {
      [ [ PFHistoryCache historyCache ] saveFileWithName: name_
                                                    data: data_
                                                    hash: md5_hash_
                                              fromServer: reader_.server
                                               forSymbol: self.symbol.name
                                                    type: reader_.basePeriod ];
   }
}

-(void)reader:( id< PFQuoteFilesReader > )reader_
didFailWithError:( NSError* )error_
{
   if ( self.reader == reader_ )
   {
      [ self.loadingIndicator hide ];
      [ error_ showAlertWithTitle: nil ];
   }
}

-(void)reader:( id< PFQuoteFilesReader > )reader_ didLoadQuotes:( NSArray* )quotes_
{
   if ( self.reader == reader_ )
   {
      if ( self.symbol.instrument.barType == 0 || self.symbol.instrument.barType == 2 )
      {
         [ [ PFSession sharedSession ] recalcSpreadChartQuotesWithQuotes: quotes_
                                                           AndInstrument: self.symbol.instrument ];
      }
      
      [ self.loadingIndicator hide ];
      [ self addQuotes: quotes_ period: [ PFSettings sharedSettings ].defaultChartPeriod ];
   }
}

@end
