#import "PFTableViewSelectedSymbolItemCell.h"
#import "PFTableViewSymbolItem.h"
#import "NSString+DoubleFormatter.h"
#import "UIImage+PFTableView.h"
#import "PFLoadingView.h"

#import "PFSettings.h"
#import "PFChartSettings.h"
#import "PFHistoryCache.h"
#import "HLOCDataSource+PFLotsQuote.h"
#import "PFChartPeriodTypeConversion.h"
#import "UIImage+Icons.h"
#import "UILabel+Price.h"
#import "UIColor+Skin.h"
#import "PFInstrumentTypeConversion.h"
#import "NSString+DoubleFormatter.h"

#import "PFNavigationController.h"
#import "PFOrderEntryViewController.h"
#import "PFChartViewController.h"
#import "PFMarketDepthViewController.h"
#import "PFSymbolInfoTabsViewController.h"

//!XiP
#import "Utils.h"
#import "FinanceChart.h"
#import "ChartSensorView.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <ProFinanceApi/Detail/Chart/PFQuoteFilesReader.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFTableViewSelectedSymbolItemCell () < PFSessionDelegate, PFQuoteFilesReaderDelegate, PFQuoteDependence >

@property ( nonatomic, strong ) HLOCDataSource* dataSource;
@property ( nonatomic, strong ) id< PFQuoteFilesReader > reader;
@property ( nonatomic, strong ) PFLoadingView* loadingIndicator;
@property ( nonatomic, assign ) BOOL tradesMode;

@end

@implementation PFTableViewSelectedSymbolItemCell

@synthesize headerView;
@synthesize symbolNameLabel;
@synthesize symbolOverviewLabel;
@synthesize chartHolderView;
@synthesize chartView;
@synthesize sensorView;
@synthesize emptyLabel;
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

@synthesize valueNameLabel;
@synthesize openInterNameLabel;
@synthesize symbolTypeNameLabel;
@synthesize tickSizeNameLabel;
@synthesize prevSettlPriceNameLabel;
@synthesize settlPriceNameLabel;
@synthesize valueValueLabel;
@synthesize openInterValueLabel;
@synthesize symbolValueLabel;
@synthesize tickValueLabel;
@synthesize prevSettlPriceValueLabel;
@synthesize settlPriceValueLabel;

@synthesize changePercentTitleLabel;
@synthesize lastHeadTitleLabel;
@synthesize changePercentValueLabel;
@synthesize lastHeadValueLabel;

@synthesize dataSource;
@synthesize reader;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize tradesMode;

-(void)dealloc
{
   [ self removeDependencies ];
}

-(void)removeDependencies
{
   [ self.reader stop ];
   self.reader = nil;
   self.dataSource = nil;
   
   [ [ PFSession sharedSession ].level3QuoteSubscriber removeDependence: self
                                                              forSymbol: [ (PFTableViewSymbolItem*)self.item symbol ] ];
   
   [ [ PFSession sharedSession ] removeDelegate: self ];
   [ [ PFHistoryCache historyCache ] closeCache ];
}

-(Class)expectedItemClass
{
   return [ PFTableViewSymbolItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   
   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImage ] ];
   self.headerView.image = [ UIImage topGroupedCellBackgroundImageLight ];
   [ self.headerView addGestureRecognizer: [ [ UITapGestureRecognizer alloc ] initWithTarget: self
                                                                                      action: @selector( headerTapAction ) ] ];
}

-(void)headerTapAction
{
   [ (PFTableViewSymbolItem*)self.item deselectCurrentItem ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   [ self removeDependencies ];
   
   PFTableViewSymbolItem* symbol_item_ = ( PFTableViewSymbolItem* )item_;
   id< PFSymbol > symbol_ = symbol_item_.symbol;
   
   if ( symbol_ )
   {
      self.symbolNameLabel.textColor = [UIColor mainTextColor];
      self.symbolOverviewLabel.textColor = [UIColor mainTextColor];

      self.bidNameLabel.textColor = [UIColor mainTextColor];
      self.changeNameLabel.textColor = [UIColor mainTextColor];
      self.highNameLabel.textColor = [UIColor mainTextColor];
      self.spreadNameLabel.textColor = [UIColor mainTextColor];
      self.lastNameLabel.textColor = [UIColor mainTextColor];
      self.lowNameLabel.textColor = [UIColor mainTextColor];
      self.askNameLabel.textColor = [UIColor mainTextColor];
      self.closeNameLabel.textColor = [UIColor mainTextColor];
      self.openNameLabel.textColor = [UIColor mainTextColor];

      self.bidValueLabel.textColor = [UIColor grayTextColor];
      self.spreadValueLabel.textColor = [UIColor grayTextColor];
      self.askValueLabel.textColor = [UIColor grayTextColor];
      self.changeValueLabel.textColor = [UIColor grayTextColor];
      self.lastValueLabel.textColor = [UIColor grayTextColor];
      self.closeValueLabel.textColor = [UIColor grayTextColor];
      self.highValueLabel.textColor = [UIColor grayTextColor];
      self.lowValueLabel.textColor = [UIColor grayTextColor];
      self.openValueLabel.textColor = [UIColor grayTextColor];

      self.valueNameLabel.textColor = [UIColor mainTextColor];
      self.openInterNameLabel.textColor = [UIColor mainTextColor];
      self.symbolTypeNameLabel.textColor = [UIColor mainTextColor];
      self.tickSizeNameLabel.textColor = [UIColor mainTextColor];
      self.prevSettlPriceNameLabel.textColor = [UIColor mainTextColor];
      self.settlPriceNameLabel.textColor = [UIColor mainTextColor];

      self.valueValueLabel.textColor = [UIColor grayTextColor];
      self.openInterValueLabel.textColor = [UIColor grayTextColor];
      self.symbolValueLabel.textColor = [UIColor grayTextColor];
      self.tickValueLabel.textColor = [UIColor grayTextColor];
      self.prevSettlPriceValueLabel.textColor = [UIColor grayTextColor];
      self.settlPriceValueLabel.textColor = [UIColor grayTextColor];

      self.bidNameLabel.text = NSLocalizedString( @"DASHBOARD_BID", nil );
      self.changeNameLabel.text = NSLocalizedString( @"CHANGE", nil );
      self.highNameLabel.text = NSLocalizedString( @"DASHBOARD_HIGH", nil );
      self.spreadNameLabel.text = NSLocalizedString( @"DASHBOARD_SPREAD", nil );
      self.lastNameLabel.text = NSLocalizedString( @"DASHBOARD_LAST", nil );
      self.lowNameLabel.text = NSLocalizedString( @"DASHBOARD_LOW", nil );
      self.askNameLabel.text = NSLocalizedString( @"DASHBOARD_ASK", nil );
      self.closeNameLabel.text = NSLocalizedString( @"DASHBOARD_CLOSE", nil );
      self.openNameLabel.text = NSLocalizedString( @"DASHBOARD_OPEN", nil );
      self.valueNameLabel.text = NSLocalizedString( @"VOLUME", nil );
      self.openInterNameLabel.text = NSLocalizedString( @"OPEN_INTEREST", nil );
      self.symbolTypeNameLabel.text = NSLocalizedString( @"INSTRUMENT_TYPE", nil );
      self.tickSizeNameLabel.text = NSLocalizedString( @"SYMBOL_INFO_TICKS", nil );
      self.prevSettlPriceNameLabel.text = NSLocalizedString( @"PREV_SETTLEMENT_PRICE", nil );
      self.settlPriceNameLabel.text = NSLocalizedString( @"SETTLEMENT_PRICE", nil );

      self.changePercentTitleLabel.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"DASHBOARD_CHANGE_PERCENT", nil ) ];
      self.lastHeadTitleLabel.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"LAST", nil ) ];

      [ self.lastHeadValueLabel showLastForSymbol: symbol_item_.symbol ];
      [ self.changePercentValueLabel showColouredValue: symbol_item_.symbol.changePercent precision: 2 suffix: @"%" ];
      
      if ( symbol_.barType == 1 )
      {
         [ [ PFSession sharedSession ].level3QuoteSubscriber addDependence: self
                                                                 forSymbol: symbol_ ];
      }
      
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
   
   [ self updateDataWithItem: item_ ];
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewSymbolItem* symbol_item_ = ( PFTableViewSymbolItem* )item_;
   id< PFSymbol > symbol_ = symbol_item_.symbol;
   
   self.symbolNameLabel.text = symbol_.name;
   self.symbolOverviewLabel.text = symbol_.instrument.overview;
   
   [ self.bidValueLabel showBidForSymbol: symbol_ ];
   [ self.askValueLabel showAskForSymbol: symbol_ ];
   [ self.lastValueLabel showLastForSymbol: symbol_ ];
   [ self.changeValueLabel showColouredValue: symbol_.changePercent precision: 2 ];
   self.openInterValueLabel.text = symbol_.quote.openInterest > 0 ? [ NSString stringWithAmount: symbol_.quote.openInterest ] : @"-";
   self.symbolValueLabel.text = NSStringForAssetClass( symbol_.instrument.type );
   self.tickValueLabel.text = [ NSString stringWithAmount: symbol_.instrument.pointSize ];
   
   if ( symbol_.quote )
   {
      self.openValueLabel.text = [ NSString stringWithPrice: symbol_.quote.open symbol: symbol_ ];
      self.highValueLabel.text = [ NSString stringWithPrice: symbol_.quote.high symbol: symbol_ ];
      self.lowValueLabel.text = [ NSString stringWithPrice: symbol_.quote.low symbol: symbol_ ];
      self.closeValueLabel.text = [ NSString stringWithPrice: symbol_.quote.previousClose symbol: symbol_ ];
      self.spreadValueLabel.text = [ NSString stringWithDouble: symbol_.spread precision: 1 ];
      self.valueValueLabel.text = [ NSString stringWithVolume: symbol_.quote.volume ];
      self.prevSettlPriceValueLabel.text = [ NSString stringWithPrice: symbol_.quote.prevSettlementPrice symbol: symbol_ ];
      self.settlPriceValueLabel.text = [ NSString stringWithPrice: symbol_.quote.settlementPrice symbol: symbol_ ];
      [ self.changeValueLabel showColouredValue: symbol_.change precision: 0 ];
   }
   else
   {
      self.openValueLabel.text = nil;
      self.highValueLabel.text = nil;
      self.lowValueLabel.text = nil;
      self.closeValueLabel.text = nil;
      self.spreadValueLabel.text = nil;
   }
}

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

-(void)loadDefaultQuotes
{
   [ self.reader stop ];
   self.reader = nil;
   
   self.dataSource = nil;
   self.chartView.hidden = YES;
   self.emptyLabel.hidden = YES;
   [ self.loadingIndicator showInView: self.chartHolderView ];
   
   __weak PFTableViewSelectedSymbolItemCell* weak_self_ = self;
   
   PFChartPeriodType period_ = [ PFSettings sharedSettings ].defaultChartPeriod;
   [ [ PFSession sharedSession ] historyReaderForSymbol: [ (PFTableViewSymbolItem*)weak_self_.item symbol ]
                                                 period: period_
                                               fromDate: PFFromDateForPeriod( period_ )
                                                 toDate: [ NSDate date ]
                                              doneBlock: ^( id< PFQuoteFilesReader > file_reader_ )
    {
       weak_self_.reader = file_reader_;
       [ weak_self_.reader startWithDelegate: weak_self_ ];
    } ];
}

-(void)addQuotes:( NSArray* )quotes_
          period:( PFChartPeriodType )period_
{
   self.tradesMode = [ [ quotes_ lastObject ] isMemberOfClass: [ PFTradesMinQuote class ] ];
   
   self.dataSource = [ HLOCDataSource dataSourceWithQuotes: quotes_
                                                    symbol: [ (PFTableViewSymbolItem*)self.item symbol ]
                                                    period: period_ ];
   
   if ( self.dataSource )
   {
      self.chartView.hidden = NO;
      [ self.chartView SetData: self.dataSource ForSymbol: [ (PFTableViewSymbolItem*)self.item symbol ].name ];
   }
   else
   {
      self.emptyLabel.hidden = NO;
   }
}

-(void)mergePriceWithBid:( double )bid_
                  AndAsk:( double )ask_
               AndVolume:( int )volume_
                  AtTime:( NSDate* )time_
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

-(IBAction)oeAction:( id )sender_
{
   PFTableViewSymbolItem* symbol_item_ = (PFTableViewSymbolItem*)self.item;
   [ PFOrderEntryViewController showWithSymbol: symbol_item_.symbol ];
}

-(IBAction)chartAction:( id )sender_
{
   PFTableViewSymbolItem* symbol_item_ = (PFTableViewSymbolItem*)self.item;
   PFChartViewController* chart_view_controller_ = [ [ PFChartViewController alloc ] initWithSymbol: symbol_item_.symbol ];
   
   [ symbol_item_.currentController.pfNavigationController pushViewController: chart_view_controller_
                                                                previousTitle: symbol_item_.symbol.name
                                                                     animated: YES ];
}

-(IBAction)mdAction:( id )sender_
{
   PFTableViewSymbolItem* symbol_item_ = (PFTableViewSymbolItem*)self.item;
   
   [ symbol_item_.currentController.pfNavigationController pushViewController: [ [ PFMarketDepthViewController alloc ] initWithSymbol: symbol_item_.symbol ]
                                                                previousTitle: symbol_item_.symbol.name
                                                                     animated: YES ];
}

-(IBAction)infoAction:( id )sender_
{
   PFTableViewSymbolItem* symbol_item_ = (PFTableViewSymbolItem*)self.item;
   
   [ symbol_item_.currentController.pfNavigationController pushViewController: [ [ PFSymbolInfoTabsViewController alloc ] initWithSymbol: symbol_item_.symbol ]
                                                                previousTitle: symbol_item_.symbol.name
                                                                     animated: YES ];
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
  didLoadQuote:( id< PFQuote > )quote_
{
   if ( [ [ (PFTableViewSymbolItem*)self.item symbol ] isEqual: symbol_ ] )
   {
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
   if ( [ [ (PFTableViewSymbolItem*)self.item symbol ] isEqual: symbol_ ] && self.tradesMode )
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
                                                forSymbol: [ (PFTableViewSymbolItem*)self.item symbol ].name
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
                                               forSymbol: [ (PFTableViewSymbolItem*)self.item symbol ].name
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
      if ( [ (PFTableViewSymbolItem*)self.item symbol ].instrument.barType == 0 || [ (PFTableViewSymbolItem*)self.item symbol ].instrument.barType == 2 )
      {
         [ [ PFSession sharedSession ] recalcSpreadChartQuotesWithQuotes: quotes_
                                                           AndInstrument: [ (PFTableViewSymbolItem*)self.item symbol ].instrument ];
      }
      
      [ self.loadingIndicator hide ];
      [ self addQuotes: quotes_ period: [ PFSettings sharedSettings ].defaultChartPeriod ];
   }
}

@end
