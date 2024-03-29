#import "PFChartViewController.h"
#import "PFChartViewController_iPad.h"

#import "PFOrderEntryViewController.h"
#import "PFNavigationController.h"
#import "PFEnabledIndicatorsViewController.h"
#import "PFChartSettingsViewController.h"
#import "PFActionSheetButton.h"
#import "PFChartSettings.h"
#import "PFChartPeriodTypeConversion.h"
#import "HLOCDataSource+PFLotsQuote.h"
#import "UILabel+Price.h"
#import "NSString+DoubleFormatter.h"
#import "UIViewController+Wrapper.h"
#import "PFHistoryCache.h"
#import "PFSettings.h"
#import "UIImage+Skin.h"
#import "UIColor+Skin.h"
#import "PFLoadingView.h"
#import "PFModalWindow.h"

//!XiP
#import "Utils.h"
#import "FinanceChart.h"
#import "ChartSensorView.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <ProFinanceApi/Detail/Chart/PFQuoteFilesReader.h>
#import <JFFMessageBox/JFFMessageBox.h>

static NSString* NSStringFromDrawShape( int shape_ )
{
   switch ( shape_ )
   {
      case CHART_DRAW_SEGMENT:
         return NSLocalizedString( @"SEGMENT", nil );
      case CHART_DRAW_LINE:
         return NSLocalizedString( @"LINE", nil );
      case CHART_DRAW_RAY:
         return NSLocalizedString( @"RAY", nil );
      case CHART_DRAW_CHANNEL:
         return NSLocalizedString( @"CHANNEL", nil );
      case CHART_DRAW_FIB_RETR:
         return NSLocalizedString( @"FIB_RETR", nil );
      case CHART_DRAW_FIB_CIRC:
         return NSLocalizedString( @"FIB_CIRC", nil );
      case CHART_DRAW_FIB_FAN:
         return NSLocalizedString( @"FIB_FAN", nil );
      case CHART_DRAW_HLINE:
         return NSLocalizedString( @"HLINE", nil );
      case CHART_DRAW_VLINE:
         return NSLocalizedString( @"VLINE", nil );
   }

   assert( 0 && "undefined drawing type" );
   return nil;
}

static NSString* NSStringFromChartMode( int chart_mode_ )
{
   switch ( chart_mode_ )
   {
      case CHART_MODE_NONE:
         return NSLocalizedString( @"CHART_MODE_FREE", nil );
      case CHART_MODE_CROSSHAIR:
         return NSLocalizedString( @"CHART_MODE_CROSSHAIR", nil );
      case CHART_MODE_SPLITTER:
         return NSLocalizedString( @"CHART_MODE_SPLITTER", nil );
      case CHART_MODE_RESIZE:
         return NSLocalizedString( @"CHART_MODE_RESIZE", nil );
      case CHART_MODE_DELETE:
         return NSLocalizedString( @"CHART_MODE_DELETE", nil );
      case CHART_MODE_DRAW:
         return NSLocalizedString( @"CHART_MODE_DRAW", nil );
   }

   assert( 0 && "undefined chart mode" );
   return nil;
}

@interface PFChartViewController ()
< PFSessionDelegate
, PFQuoteFilesReaderDelegate
, PFEnabledIndicatorsViewControllerDelegate
, PFChartSettingsViewControllerDelegate, PFQuoteDependence >

@property ( nonatomic, strong ) HLOCDataSource* dataSource;
@property ( nonatomic, strong ) id< PFQuoteFilesReader > reader;
@property ( nonatomic, strong ) UIBarButtonItem* rightButton;
@property ( nonatomic, strong ) PFLoadingView* loadingIndicator;
@property ( nonatomic, weak ) NSTimer* updateTimer;
@property ( nonatomic, assign ) BOOL priceChanged;
@property ( nonatomic, assign ) BOOL tradesMode;

@end

@implementation PFChartViewController

@synthesize scrollView;
@synthesize chartView;
@synthesize sensorView;
@synthesize propertiesView;
@synthesize buttonsView;
@synthesize spreadNameLabel;
@synthesize priceNameLabel;
@synthesize changeNameLabel;
@synthesize priceLabel;
@synthesize changeLabel;
@synthesize spreadLabel;
@synthesize emptyLabel;
@synthesize rangeButton;
@synthesize symbol;
@synthesize dataSource;
@synthesize reader;
@synthesize drawingsView;
@synthesize drawButtons;
@synthesize tradesMode;
@synthesize rightButton;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize updateTimer;
@synthesize priceChanged;

-(PFLoadingView*)loadingIndicator
{
   if ( !_loadingIndicator )
   {
      _loadingIndicator = [ PFLoadingView new ];
      _loadingIndicator.indicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
   }
   return _loadingIndicator;
}

-(void)dealloc
{
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
   
   [ self.reader stop ];
   self.reader = nil;
   self.dataSource = nil;
   
   [ [ PFSession sharedSession ].level3QuoteSubscriber removeDependence: self
                                                              forSymbol: self.symbol ];
   
   [ [ PFSession sharedSession ] removeDelegate: self ];
   [ [ PFHistoryCache historyCache ] closeCache ];
   
   self.loadingIndicator = nil;
   self.drawButtons = nil;
   self.scrollView = nil;
   self.drawingsView = nil;
   self.chartView = nil;
   self.buttonsView = nil;
   self.drawingsView = nil;
   self.sensorView = nil;
   self.priceLabel = nil;
   self.priceNameLabel = nil;
   self.changeNameLabel = nil;
   self.spreadNameLabel = nil;
   self.changeLabel = nil;
   self.spreadLabel = nil;
   self.rangeButton = nil;
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
{
   NSString* nib_name_ = [ self isKindOfClass: [ PFChartViewController_iPad class ] ] ? @"PFChartViewController_iPad" : @"PFChartViewController";
   
   self = [ super initWithNibName: nib_name_ bundle: nil ];
   
   if (self)
   {
      self.title = NSLocalizedString( @"CHART", nil );
      self.symbol = symbol_;
      
      [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                  selector: @selector( handleChartMode: )
                                                      name: @"handleChartMode"
                                                    object: nil ];
   }
   return self;
}

-(PFChartSettings*)settings
{
   return [ PFChartSettings sharedSettings ];
}

-(void)addTradeLevel:( id< PFMarketOperation > )market_operation_
{
   if ( market_operation_.symbol == self.symbol && market_operation_.accountId == [ PFSession sharedSession ].accounts.defaultAccount.accountId )
   {
      if ( [ market_operation_ conformsToProtocol: @protocol(PFPosition) ] )
      {
         id< PFPosition > position_ = (id< PFPosition >)market_operation_;
         
         [ self.chartView addOrderLevel: position_.positionId
                                WithCmd: position_.operationType == PFMarketOperationBuy ? 0 : 1
                                AtPrice: position_.openPrice
                                isOrder: NO ];
      }
      else if ( [ market_operation_ conformsToProtocol: @protocol(PFOrder) ] )
      {
         id< PFOrder > order_ = (id< PFOrder >)market_operation_;
         
         [ self.chartView addOrderLevel: order_.orderId
                                WithCmd: order_.operationType == PFMarketOperationBuy ? 0 : 1
                                AtPrice: order_.price
                                isOrder: YES ];
      }
   }
}

-(void)removeTradeLevel:( id< PFMarketOperation > )market_operation_
{
   if ( market_operation_.symbol == self.symbol && market_operation_.accountId == [ PFSession sharedSession ].accounts.defaultAccount.accountId )
   {
      if ( [ market_operation_ conformsToProtocol: @protocol(PFPosition) ] )
      {
         id< PFPosition > position_ = (id< PFPosition >)market_operation_;
         
         [ self.chartView deleteOrderLevel: position_.positionId
                                   isOrder: NO ];
      }
      else if ( [ market_operation_ conformsToProtocol: @protocol(PFOrder) ] )
      {
         id< PFOrder > order_ = (id< PFOrder >)market_operation_;
         
         [ self.chartView deleteOrderLevel: order_.orderId
                                   isOrder: YES ];
      }
   }
}

-(void)updateTradeLevels
{
   [ self.chartView clearOrderLevels ];
   
   if ( self.settings.showOrders )
   {
      for ( id < PFOrder > order_ in [ PFSession sharedSession ].accounts.defaultAccount.allOrders )
         [ self addTradeLevel: order_ ];
   }
   
   if ( self.settings.showPositions )
   {
      for ( id < PFPosition > position_ in [ PFSession sharedSession ].accounts.defaultAccount.positions )
         [ self addTradeLevel: position_ ];
   }
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

-(void)updatePrice
{
   [ self.priceLabel showLastForSymbol: self.symbol ];

   NSUInteger change_precision_ = 2;
   
   [ self.changeLabel showColouredValue: self.symbol.changePercent precision: change_precision_ ];
   self.spreadLabel.text = self.symbol.quote ? [ NSString stringWithDouble: self.symbol.spread precision: 1 ] : nil;
}

-(void)timerUpdate
{
   if ( self.priceChanged )
   {
      self.priceChanged = NO;
      [ self updatePrice ];
   }
}

-(void)showOrderEntry
{
   [ PFOrderEntryViewController showWithSymbol: self.symbol ];
}

-(void)showLoadingView
{
   [ self.loadingIndicator showInView: self.view ];
}

-(void)loadQuotesWithPeriod:( PFChartPeriodType )period_
{
   [ self.reader stop ];
   self.reader = nil;

   self.dataSource = nil;
   self.chartView.hidden = YES;
   self.emptyLabel.hidden = YES;
   [ self showLoadingView ];
   
   __weak PFChartViewController* weak_self_ = self;
   
   [ [ PFSession sharedSession ] historyReaderForSymbol: weak_self_.symbol
                                                 period: period_
                                               fromDate: PFFromDateForPeriod( period_ )
                                                 toDate: [ NSDate date ]
                                              doneBlock: ^( id< PFQuoteFilesReader > file_reader_ )
    {
       if ( period_ == [ weak_self_.rangeButton.currentChoice integerValue ] )
       {
          weak_self_.reader = file_reader_;
          [ weak_self_.reader startWithDelegate: weak_self_ ];
       }
    } ];
}

-(BOOL)tryAllowTrading
{
   BOOL is_allowed_ = [ [ PFSession sharedSession ] allowsTradingForSymbol: self.symbol ];
   
   self.pfNavigationWrapperController.navigationItem.rightBarButtonItem = is_allowed_ ? self.rightButton : nil;
   
   return is_allowed_;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.view.backgroundColor = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [ UIColor backgroundDarkColor ] : [ UIColor backgroundLightColor ];

   self.spreadNameLabel.text = [ NSLocalizedString( @"SPREAD", nil ) stringByAppendingString: @":" ];
   self.changeNameLabel.text = [ NSLocalizedString( @"CHANGE_PERCENT", nil ) stringByAppendingString: @":" ];
   self.priceNameLabel.text = [ NSLocalizedString( @"LAST", nil ) stringByAppendingString: @":" ];
   self.scrollView.contentSize = CGSizeMake( 291.f, 32.f );
   
   if ( self.symbol )
   {
      self.rightButton = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFIconOeSmall" ]
                                                             style: UIBarButtonItemStylePlain
                                                            target: self
                                                            action: @selector( showOrderEntry ) ];
      
      if ( self.symbol.barType == 1 )
      {
         [ [ PFSession sharedSession ].level3QuoteSubscriber addDependence: self
                                                                 forSymbol: self.symbol ];
      }
      
      [ self updatePrice ];
      [ self tryAllowTrading ];
      
      [ self.chartView setChartSettingsWithPropertiesStore: self.settings.properties ];
      [ self.chartView setParent: nil ];
      [ self.chartView updateChartSensor: self.sensorView ];
      
      [ [ PFSession sharedSession ] addDelegate: self ];
      [ [ PFHistoryCache historyCache ] openCache ];
      
      self.rangeButton.choices = @[ @(PFChartPeriodM1)
                                    , @(PFChartPeriodM5)
                                    , @(PFChartPeriodM15)
                                    , @(PFChartPeriodM30)
                                    , @(PFChartPeriodH1)
                                    , @(PFChartPeriodH4)
                                    , @(PFChartPeriodD1)
                                    , @(PFChartPeriodW1)
                                    , @(PFChartPeriodMN1)
                                    ];
      
      self.rangeButton.prompt = NSLocalizedString( @"SELECT_RANGE", nil );
      self.rangeButton.toStringBlock = ^( id choice_ )
      {
         return NSStringFromPFChartPeriodType( (PFChartPeriodType)[ choice_ integerValue ] );
      };
      
      self.rangeButton.currentChoice = @([ PFSettings sharedSettings ].defaultChartPeriod);
      
      [ self updateTradeLevels ];
   }
   else
   {
      self.chartView.hidden = YES;
      self.drawingsView.hidden = YES;
      self.propertiesView.hidden = YES;
      self.buttonsView.hidden = YES;
      
      self.emptyLabel.text = NSLocalizedString( @"EMPTY_WATCHLIST", nil );
      self.emptyLabel.hidden = NO;
   }
}

-(void)viewDidUnload
{
   [ self.reader stop ];
   self.reader = nil;
   self.dataSource = nil;
   
   [ [ PFSession sharedSession ].level3QuoteSubscriber removeDependence: self
                                                              forSymbol: self.symbol ];
   
   [ [ PFSession sharedSession ] removeDelegate: self ];
   [ [ PFHistoryCache historyCache ] closeCache ];
   
   self.loadingIndicator = nil;
   self.drawButtons = nil;
   self.scrollView = nil;
   self.drawingsView = nil;
   self.chartView = nil;
   self.buttonsView = nil;
   self.drawingsView = nil;
   self.sensorView = nil;
   self.priceLabel = nil;
   self.priceNameLabel = nil;
   self.changeNameLabel = nil;
   self.spreadNameLabel = nil;
   self.changeLabel = nil;
   self.spreadLabel = nil;
   self.rangeButton = nil;
   
   [ super viewDidUnload ];
}

-(void)viewDidAppear:( BOOL )animated_
{
   [ super viewDidAppear: animated_ ];
   
   self.updateTimer = [ NSTimer scheduledTimerWithTimeInterval: 1.0
                                                        target: self
                                                      selector: @selector(timerUpdate)
                                                      userInfo: nil
                                                       repeats: YES ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self.updateTimer invalidate ];
   self.updateTimer = nil;
}

-(BOOL)shouldAutorotate
{
   return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldHideNavigationBarForOrientation:( UIInterfaceOrientation )interface_orientation_
{
   return UIInterfaceOrientationIsLandscape( interface_orientation_ );
}

-(void)willRotateToInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
                               duration:( NSTimeInterval )duration_
{
   BOOL is_hidden_ = self.navigationController.navigationBarHidden;
   BOOL should_hide_ = [ self shouldHideNavigationBarForOrientation: interface_orientation_ ];

   if ( is_hidden_ != should_hide_ )
   {
      [ self.navigationController setNavigationBarHidden: should_hide_ animated: YES ];
   }
}

-(void)didRotateFromInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
{
}

-(IBAction)indicatorsAction:(id)sender_
{
   PFEnabledIndicatorsViewController* indicators_controller_ = [ [ PFEnabledIndicatorsViewController alloc ] initWithSettings: self.settings ];
   indicators_controller_.delegate = self;
   
   PFNavigationController* navigation_controller_ = [ PFNavigationController navigationControllerWithController: indicators_controller_ ];
   navigation_controller_.useCloseButton = YES;
   
   [ PFModalWindow showWithNavigationController: navigation_controller_ ];
}

-(IBAction)settingsAction:(id)sender_
{
   PFChartSettingsViewController* settings_controller_ = [ [ PFChartSettingsViewController alloc ] initWithSettings: self.settings ];
   settings_controller_.delegate = self;

   [ PFModalWindow showWithController: settings_controller_ ];
}

-(IBAction)rangeChangeAction:( id )sender_
{
   [ self loadQuotesWithPeriod: (PFChartPeriodType)[ [ sender_ currentChoice ] integerValue ] ];
}

-(IBAction)drawChangeAction:( id )sender_
{
   UIButton* drawings_button = (UIButton*)sender_;
   
   drawings_button.selected = !drawings_button.selected;
   self.drawingsView.hidden = !self.drawingsView.hidden;

   if ( self.drawingsView.hidden )
   {
      self.chartView.frame = CGRectMake( self.chartView.frame.origin.x
                                        , self.chartView.frame.origin.y - self.drawingsView.frame.size.height
                                        , self.chartView.frame.size.width
                                        , self.chartView.frame.size.height + self.drawingsView.frame.size.height );
      
      for ( UIButton* draw_button_ in self.drawButtons )
      {
         draw_button_.selected = NO;
      }
      self.chartView.cursorMode = CHART_MODE_NONE;
   }
   else
   {
      self.chartView.frame = CGRectMake( self.chartView.frame.origin.x
                                        , self.chartView.frame.origin.y + self.drawingsView.frame.size.height
                                        , self.chartView.frame.size.width
                                        , self.chartView.frame.size.height - self.drawingsView.frame.size.height );
   }
}

- (IBAction)drawAction:( id )sender_
{
   UIButton* button_ = (UIButton*)sender_;
   
   if ( button_.selected )
   {
      button_.selected = NO;
      self.chartView.cursorMode = CHART_MODE_NONE;
   }
   else
   {
      for ( UIButton* draw_button_ in self.drawButtons )
      {
         draw_button_.selected = draw_button_ == button_;
      }
      
      if ( button_.tag == CHART_MODE_CROSSHAIR || button_.tag == CHART_MODE_DELETE )
      {
         button_.selected = YES;
         self.chartView.cursorMode = (uint)button_.tag;
      }
      else
      {
         self.chartView.cursorMode = CHART_MODE_DRAW;
         self.chartView.drawSubtype = (uint)button_.tag;
      }
      
   }
}

-(void)handleChartMode:(NSNotification *)notification
{
   if ( self.chartView.cursorMode == CHART_MODE_NONE )
   {
      for ( UIButton* draw_button_ in self.drawButtons )
      {
         draw_button_.selected = NO;
      }
   }
}

-(void)mergePriceWithBid: (double)bid_
                  AndAsk: (double)ask_
               AndVolume: (int)volume_
                  AtTime: (NSDate*)time_
{
   if ( self.dataSource && bid_ > 0.0 && ask_ > 0.0 && [ time_ timeIntervalSince1970 ] > 0.0 )
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

-(void)processOrderRemoving:( id< PFOrder > )order_
{
   
}

-(void)processPositionRemoving:( id< PFPosition > )position_
{
   
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
  didLoadQuote:( id< PFQuote > )quote_
{
   if ( [ self.symbol isEqual: symbol_ ] )
   {
      self.priceChanged = YES;
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

-(void)session:(PFSession *)session_
   didAddOrder:(id<PFOrder>)order_
{
   if ( self.settings.showOrders )
   {
      [ self addTradeLevel: order_ ];
   }
}

-(void)session:(PFSession *)session_
didAddPosition:(id<PFPosition>)position_
{
   if ( self.settings.showPositions )
   {
      [ self addTradeLevel: position_ ];
   }
}

-(void)session:(PFSession *)session_
didUpdateOrder:(id<PFOrder>)order_
{
   if ( self.settings.showOrders )
   {
      [ self addTradeLevel: order_ ];
   }
}

-(void)session:(PFSession *)session_
didUpdatePosition:(id<PFPosition>)position_
          type:(PFPositionUpdateType)type_
{
   if ( self.settings.showPositions )
   {
      [ self addTradeLevel: position_ ];
   }
}

-(void)session:(PFSession *)session_
didRemoveOrder:(id<PFOrder>)order_
{
   [ self processOrderRemoving: order_ ];
   
   if ( self.settings.showOrders )
   {
      [ self removeTradeLevel: order_ ];
   }
}

-(void)session:(PFSession *)session_
didRemovePosition:(id<PFPosition>)position_
{
   [ self processPositionRemoving: position_ ];
   
   if ( self.settings.showPositions )
   {
      [ self removeTradeLevel: position_ ];
   }
}

-(void)session:( PFSession* )session_
didSelectDefaultAccount:( id< PFAccount > )account_
{
   [ self updateTradeLevels ];
   [ self tryAllowTrading ];
   [ self loadQuotesWithPeriod: (PFChartPeriodType)[ self.rangeButton.currentChoice integerValue ] ];
}

#pragma mark - PFQuoteFilesReaderDelegate

-(NSData*)reader:( id< PFQuoteFilesReader > )reader_
    dataFromFile:( NSString* )file_name_
   WithSignature:( NSString* )signature_
{
   return  self.reader == reader_ ?
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
      [ self addQuotes: quotes_ period: (PFChartPeriodType)[ self.rangeButton.currentChoice integerValue ] ];
   }
}

#pragma mark - PFActiveIndicatorsViewControllerDelegate

-(void)hideIndicatorsController:( PFEnabledIndicatorsViewController* )indicators_controller_
{
   [ indicators_controller_.pfNavigationWrapperController.navigationController.formSheetController mz_dismissFormSheetControllerAnimated: YES
                                                                                                                       completionHandler: nil ];
}

-(void)didCompleteIndicatorsController:( PFEnabledIndicatorsViewController* )indicators_controller_
{
   [ self hideIndicatorsController: indicators_controller_ ];
   [ self.settings save ];

   if ( self.dataSource )
   {
      [ self.chartView rebuild ];
   }
}

#pragma mark - PFChartSettingsViewControllerDelegate

-(void)hideSettingsController:( PFChartSettingsViewController* )settings_controller_
{
   [ settings_controller_.navigationController.formSheetController mz_dismissFormSheetControllerAnimated: YES
                                                                                       completionHandler: nil ];
}

-(void)didCompleteSettingsController:( PFChartSettingsViewController* )settings_controller_
{
   [ self hideSettingsController: settings_controller_ ];
   self.chartView.chartType = settings_controller_.settings.styleType;

   [ self updateTradeLevels ];
   
   if ( self.dataSource )
   {
      [ self.chartView rebuild ];
      [ self.chartView draw ];
   }
}

@end
