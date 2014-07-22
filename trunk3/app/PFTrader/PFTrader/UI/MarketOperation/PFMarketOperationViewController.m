#import "PFMarketOperationViewController.h"

#import "PFOrdersViewController.h"
#import "PFPositionsViewController.h"

#import "PFTableView.h"
#import "PFTableViewCategory.h"

#import "DDMenuController+PFTrader.h"
#import "UILabel+Price.h"
#import "UIColor+Skin.h"

#import "PFNavigationController.h"
#import "PFSettings.h"
#import "PFSoundManager.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFMarketOperationViewController ()< PFSessionDelegate >

@property ( nonatomic, strong ) id< PFSymbol > symbol;

@property ( nonatomic, weak ) NSTimer* updateTimer;
@property ( nonatomic, assign ) BOOL priceChanged;

@end

@implementation PFMarketOperationViewController

@synthesize closingBlock;

@synthesize tableView;
@synthesize nameLabel;
@synthesize overviewLabel;
@synthesize bidLabel;
@synthesize askLabel;
@synthesize bidTitleLabel;
@synthesize askTitleLabel;

@synthesize symbol;

@synthesize updateTimer;
@synthesize priceChanged;
@synthesize OCOMode;

@synthesize accountCategory;
@synthesize orderTypeCategory;
@synthesize quantityCategory;
@synthesize validityCategory;
@synthesize slCategory;
@synthesize tpCategory;

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
   
   self.tableView = nil;
   self.nameLabel = nil;
   self.overviewLabel = nil;
   self.bidLabel = nil;
   self.askLabel = nil;
   self.bidTitleLabel = nil;
   self.askTitleLabel = nil;
}

-(BOOL)useOffsetMode
{
   return self.OCOMode || [ [ PFSettings sharedSettings ] useSLTPOffset ];
}

-(PFMarketOperationType)operationType
{
   return PFMarketOperationBuy;
}

-(PFDouble)defaultPrice
{
   return self.operationType == PFMarketOperationBuy ? self.symbol.quote.ask : self.symbol.quote.bid;
}

-(PFDouble)defaultSLTPPrice
{
   return self.useOffsetMode ? self.symbol.instrument.pointSize : ( self.operationType == PFMarketOperationBuy ? self.symbol.quote.bid : self.symbol.quote.ask );
}

-(id)initWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_
{
    self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
    if ( self )
    {
       self.title = title_;
       self.symbol = symbol_;
    }
    return self;
}

-(void)remove
{
   DDMenuController* menu_controller_ = self.menuController;
   [ menu_controller_ showRootController: NO ];
   menu_controller_.rightViewController = nil;
}

-(void)close
{
   if ( self.closingBlock )
   {
      self.closingBlock();
   }
   else
   {
      [ self.menuController showRootController: YES ];
   }
}

-(void)showOrders
{
   [ self.menuController pushRootController: [ PFOrdersViewController new ] animated: YES ];
}

-(void)showPositions
{
   [ self.menuController pushRootController: [ PFPositionsViewController new ] animated: YES ];
}

-(void)updatePrice
{
   [ self.bidLabel showBidForSymbol: self.symbol ];
   [ self.askLabel showAskForSymbol: self.symbol ];
}

-(BOOL)showModal
{
   return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && [ PFSettings sharedSettings ].showModalForms;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ [ PFSession sharedSession ] addDelegate: self ];

   self.nameLabel.text = self.symbol.name;
   self.bidTitleLabel.text = [ NSLocalizedString( @"BID", nil ) stringByAppendingString: @":" ];
   self.askTitleLabel.text = [ NSLocalizedString( @"ASK", nil ) stringByAppendingString: @":" ];

   [ self updatePrice ];
   [ self updateButtonsVisibility ];

   UIBarButtonItem* close_item_ = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString( @"CLOSE_BUTTON", nil )
                                                                      style: UIBarButtonItemStyleBordered
                                                                     target: self
                                                                     action: @selector( close ) ];
   
   
   self.navigationItem.rightBarButtonItem = close_item_;
   
   if ( self.showModal )
   {
      CGRect old_rect_ = self.tableView.frame;
      self.tableView.frame = CGRectMake( 0.0, old_rect_.origin.y, old_rect_.size.width + old_rect_.origin.x, old_rect_.size.height);
   }
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

-(void)timerUpdate
{
   if ( self.priceChanged )
   {
      self.priceChanged = NO;
      [ self updatePrice ];
   }
}

-(void)showControllerWithController:( UIViewController* )controller_
{
   if ( self.showModal )
   {
      PFNavigationController* navigation_sheet_ = [ [ PFNavigationController alloc ] initWithRootViewController: self ];
      [ controller_ presentViewController: navigation_sheet_
                                 animated: YES
                               completion: nil ];
      
      [ self setClosingBlock: ^{ [ controller_ dismissViewControllerAnimated: YES completion: nil ]; } ];
   }
   else
   {
      [ controller_.menuController pushRightController: self animated: YES ];
   }
}

-(double)priceLimitForOperation:( id<PFMarketOperation> )market_operation_ andSLMode:( BOOL )is_sl_
{
   if ( [ market_operation_ conformsToProtocol: @protocol(PFPosition) ] )
   {
      return market_operation_.operationType == PFMarketOperationBuy ? self.symbol.quote.bid : self.symbol.quote.ask;
   }
   else if ( [ market_operation_ conformsToProtocol: @protocol(PFOrder) ] )
   {
      id< PFOrder > order_ = (id< PFOrder >)market_operation_;
      
      switch ( order_.orderType )
      {
         case PFOrderStopLimit :
            return  is_sl_ ? order_.stopPrice : order_.price;
            
         case PFOrderMarket:
         case PFOrderTrailingStop:
            return market_operation_.operationType == PFMarketOperationBuy ? self.symbol.quote.bid : self.symbol.quote.ask;

         default:
            return order_.price;
      }
   }
   
   return 0.0;
}

-(double)slLimitForMarketOperation:( id<PFMarketOperation> )operation_
{
   PFDouble point_size_ = self.symbol.instrument.pointSize;
   return [ self priceLimitForOperation: operation_ andSLMode: YES ] + ( operation_.operationType == PFMarketOperationBuy ? ( - point_size_ ) : point_size_ );
}

-(double)tpLimitForMarketOperation:( id<PFMarketOperation> )operation_
{
   PFDouble point_size_ = self.symbol.instrument.pointSize;
   return [ self priceLimitForOperation: operation_ andSLMode: NO ] + ( operation_.operationType == PFMarketOperationBuy ? point_size_ : ( - point_size_ ) );
}

-(BOOL)checkSLTPForMarketOperation:( id<PFMarketOperation> )market_operation_
{
   BOOL result_ = YES;
   BOOL is_buy_ = market_operation_.operationType == PFMarketOperationBuy;
   
   if ( market_operation_.stopLossPrice > 0.0 )
   {
      double sl_limit_ = [ self slLimitForMarketOperation: market_operation_ ];
      result_ = is_buy_ ? market_operation_.stopLossPrice <= sl_limit_ : market_operation_.stopLossPrice >= sl_limit_;
      
      if ( !result_ )
         [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString(@"INVALID_SL_PRICE", nil) ];
   }
   
   if ( market_operation_.takeProfitPrice > 0.0 )
   {
      double tp_limit_ = [ self tpLimitForMarketOperation: market_operation_ ];
      result_ = is_buy_ ? market_operation_.takeProfitPrice >= tp_limit_ : market_operation_.takeProfitPrice <= tp_limit_;
      
      if ( !result_ )
         [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString(@"INVALID_TP_PRICE", nil) ];
   }
   
   if ( !result_ )
      [ [ PFSoundManager sharedManager ] playNegativeSound ];
   
   return result_;
}

+(void)showConfirmWithText:( NSString* )text_
                actionText:( NSString* )action_text_
        confirmActionBlock:( PFMarketOperationConfirmBlock )block_
{
   JFFAlertButton* button_ = [ JFFAlertButton alertButton: action_text_
                                                   action: ^( JFFAlertView* sender_ )
                              {
                                 if ( block_ )
                                    block_();
                              } ];
   
   JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: nil
                                                     message: text_
                                           cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                           otherButtonTitles: button_, nil ];
   
   [ alert_view_ show ];
   [ [ PFSoundManager sharedManager ] playConfirmationSound ];
}

-(void)updateButtonsVisibility
{
   [ self doesNotRecognizeSelector: _cmd ];
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
  didLoadQuote:( id< PFQuote > )quote_
{
   if ( [ self.symbol isEqual: symbol_ ] )
   {
      self.priceChanged = YES;
   }
}

-(void)session:( PFSession* )session_
didSelectDefaultAccount:( id< PFAccount > )account_
{
   [ self updateButtonsVisibility ];
}

@end
