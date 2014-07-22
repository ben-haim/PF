#import "PFWatchlistViewController.h"

#import "PFWatchlistEditorViewController.h"
#import "PFOrderEntryViewController.h"
#import "PFChartViewController.h"
#import "PFMarketDepthViewController.h"
#import "PFOptionChainViewController.h"
#import "PFSymbolInfoViewController.h"

#import "PFSymbolColumn.h"
#import "PFSymbolCell.h"

#import "PFGridView.h"
#import "PFGridFooterView.h"
#import "PFGridActionView.h"
#import "UIImage+Icons.h"

#import "PFSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFWatchlistViewController ()< PFSessionDelegate, PFSymbolPriceCellDelegate >

@property ( nonatomic, weak ) NSTimer* updateTimer;

@end

@implementation PFWatchlistViewController

@synthesize watchlist;
@synthesize updateTimer;

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)initWithWatchlist:( id< PFWatchlist > )watchlist_
{
   self = [ super init ];
   if ( self )
   {
      self.title = NSLocalizedString( @"WATCHLIST", nil );
      self.watchlist = watchlist_;
   }
   return self;
}

-(void)editAction
{
   PFWatchlistEditorViewController* controller_ = [ [ PFWatchlistEditorViewController alloc ] initWithWatchlist: self.watchlist ];
   [ self.navigationController pushViewController: controller_ animated: YES ];
}

-(void)orderEntryForSymbol:( id< PFSymbol > )symbol_
             operationType:( PFMarketOperationType )operation_type_
{
   [ [ [ PFOrderEntryViewController alloc ] initWithSymbol: symbol_ operationType: operation_type_ ] showControllerWithController: self ];
}

-(void)chartForSymbol:( id< PFSymbol > )symbol_
{
   PFChartViewController* chart_view_controller_ = [ [ PFChartViewController alloc ] initWithSymbol: symbol_
                                                                                         andSymbols: self.watchlist.symbols ];

   [ self.navigationController pushViewController: chart_view_controller_ animated: YES ];
}

-(void)marketDepthForSymbol:( id< PFSymbol > )symbol_
{
   PFMarketDepthViewController* market_depth_controller_ = [ [ PFMarketDepthViewController alloc ] initWithSymbol: symbol_ ];

   [ self.navigationController pushViewController: market_depth_controller_ animated: YES ];
}

-(void)optionChainForSymbol:( id< PFSymbol > )symbol_ andBaseSymbol:( id< PFSymbol > )base_symbol_
{
   PFOptionChainViewController* option_chain_controller_ = [ [ PFOptionChainViewController alloc ] initWithSymbol: symbol_
                                                                                                    andBaseSymbol: base_symbol_ ];
   
   [ self.navigationController pushViewController: option_chain_controller_ animated: YES ];
}

-(void)symbolInfoForSymbol:( id< PFSymbol > )symbol_
{
   PFSymbolInfoViewController* info_view_controller_ = [ [ PFSymbolInfoViewController alloc ] initWithSymbol: symbol_ ];
   [ self.navigationController pushViewController: info_view_controller_ animated: YES ];
}

-(NSArray*)watchlistColumns
{
   return [ NSArray arrayWithObjects: [ PFSymbolColumn nameColumn ]
           , [ PFSymbolColumn bidColumnWithDelegate: self ]
           , [ PFSymbolColumn askColumnWithDelegate: self ]
           , [ PFSymbolColumn bSizeColumn ]
           , [ PFSymbolColumn aSizeColumn ]
           , [ PFSymbolColumn lastColumn ]
           , [ PFSymbolColumn spreadColumn ]
           , [ PFSymbolColumn openColumn ]
           , [ PFSymbolColumn closeColumn ]
           , nil ];
}

-(void)applySymbols
{
   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];
   
   self.elements = self.watchlist.symbols;
   
   self.columns = [ self watchlistColumns ];
   
   __weak PFWatchlistViewController* unsafe_self_ = self;
   PFGridActionBlock oe_action_ = ^( NSUInteger row_index_ )
   {
      id< PFSymbol > symbol_ = [ unsafe_self_.elements objectAtIndex: row_index_ ];
      [ unsafe_self_ orderEntryForSymbol: symbol_ operationType: PFMarketOperationBuy ];
   };
   
   PFGridActionVisibilityBlock oe_visibility_ = ^BOOL(NSUInteger row_index_)
   {
      id< PFSymbol > symbol_ = [ unsafe_self_.elements objectAtIndex: row_index_ ];
      return [ [ PFSession sharedSession ] allowsTradingForSymbol: symbol_ ];
   };
   
   PFGridActionBlock chart_action_ = ^( NSUInteger row_index_ )
   {
      id< PFSymbol > symbol_ = [ unsafe_self_.elements objectAtIndex: row_index_ ];
      [ unsafe_self_ chartForSymbol: symbol_ ];
   };
   
   PFGridActionBlock market_depth_action_ = ^( NSUInteger row_index_ )
   {
      id< PFSymbol > symbol_ = [ unsafe_self_.elements objectAtIndex: row_index_ ];
      [ unsafe_self_ marketDepthForSymbol: symbol_ ];
   };
   
   PFGridActionVisibilityBlock market_depth_visibility_ = ^BOOL(NSUInteger row_index_)
   {
      return [ PFSession sharedSession ].accounts.defaultAccount.allowsLevel2;
   };
   
   PFGridActionBlock option_chain_action_ = ^( NSUInteger row_index_ )
   {
      id< PFSymbol > symbol_ = [ unsafe_self_.elements objectAtIndex: row_index_ ];
      
      for (id< PFSymbol > option_symbol_ in [ PFSession sharedSession ].optionSymbols )
      {
         if ( option_symbol_.baseInstrumentId == symbol_.instrumentId )
         {
            [ unsafe_self_ optionChainForSymbol: option_symbol_
                                  andBaseSymbol: symbol_ ];
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
         id< PFSymbol > symbol_ = [ unsafe_self_.elements objectAtIndex: row_index_ ];
         
         for (id< PFSymbol > option_symbol_ in [ PFSession sharedSession ].optionSymbols )
         {
            if ( option_symbol_.baseInstrumentId == symbol_.instrumentId )
            {
               return YES;
            }
         }
         return NO;
      }
   };
   
   PFGridActionBlock symbol_info_action_ = ^( NSUInteger row_index_ )
   {
      id< PFSymbol > symbol_ = [ unsafe_self_.elements objectAtIndex: row_index_ ];
      [ unsafe_self_ symbolInfoForSymbol: symbol_ ];
   };
   
   PFGridActionVisibilityBlock symbol_info_visibility_ = ^BOOL(NSUInteger row_index_)
   {
      return [ PFSession sharedSession ].accounts.defaultAccount.allowsSymbolInfo;
   };
   
   self.actions = [ NSArray arrayWithObjects: [ PFGridAction actionWithImage: [ UIImage orderEntryIcon ]
                                                            highlightedImage: nil
                                                                      action: oe_action_
                                                             visibilityBlock: oe_visibility_ ]
                   , [ PFGridAction actionWithImage: [ UIImage chartIcon ]
                                   highlightedImage: nil
                                             action: chart_action_ ]
                   , [ PFGridAction actionWithImage: [ UIImage marketDepthIcon ]
                                   highlightedImage: nil
                                             action: market_depth_action_
                                    visibilityBlock: market_depth_visibility_ ]
                   , [ PFGridAction actionWithImage: [ UIImage optionChainIcon ]
                                   highlightedImage: nil
                                             action: option_chain_action_
                                    visibilityBlock: option_chain_visibility_ ]
                   , [ PFGridAction actionWithImage: [ UIImage symbolInfoIcon ]
                                   highlightedImage: nil
                                             action: symbol_info_action_
                                    visibilityBlock: symbol_info_visibility_ ]
                   , nil ];
}

-(void)viewDidLoad
{
   [ self applySymbols ];
   self.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
                                                                                             target: self
                                                                                             action: @selector( editAction ) ];
   [ super viewDidLoad ];
}

-(void)viewDidAppear:( BOOL )animated_
{
   [ super viewDidAppear: animated_ ];

   self.updateTimer = [ NSTimer scheduledTimerWithTimeInterval: 1.0
                                                        target: self
                                                      selector: @selector(updateRows)
                                                      userInfo: nil
                                                       repeats: YES ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self.updateTimer invalidate ];
   self.updateTimer = nil;
}

#pragma mark PFGridFooterViewDelegate

-(void)didTapSummaryInFootterView:( PFGridFooterView* )footer_view_
{
   JFFAlertButton* remove_all_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"REMOVE_ALL", nil )
                                                              action: ^(JFFAlertView* sender_)
                                         {
                                            [ self.watchlist removeAllSymbols ];
                                         } ];

   JFFActionSheet* action_sheet_ = [ JFFActionSheet actionSheetWithTitle: NSLocalizedString( @"REMOVE_ALL_SYMBOLS_PROMPT", nil )
                                                       cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                                  destructiveButtonTitle: remove_all_button_
                                                       otherButtonsArray: nil ];

   action_sheet_.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   [ action_sheet_ showInView: self.view ];
}

#pragma mark PFSessionDelegate

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
  didAddSymbol:( id< PFSymbol > )symbol_
{
   if ( self.watchlist == watchlist_ )
   {
      self.elements = watchlist_.symbols;
      [ self reloadData ];
   }
}

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
didRemoveSymbols:( NSArray* )symbols_
{
   if ( self.watchlist == watchlist_ )
   {
      self.elements = watchlist_.symbols;
      [ self reloadData ];
   }
}

-(void)didReconnectedSessionWithNewSession:( PFSession* )session_
{
   [ self applySymbols ];
   [ self reloadData ];
}

-(void)session:( PFSession* )session_
didAddWatchlist:( id< PFWatchlist > )watchlist_
{
   if ( watchlist_.watchlistId == self.watchlist.watchlistId )
   {
      self.watchlist = watchlist_;
      
      [ self applySymbols ];
      [ self reloadData ];
   }
}

#pragma mark PFSymbolPriceCellDelegate

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
             buySymbol:( id< PFSymbol > )symbol_
{
   if ( [ [ PFSession sharedSession ] allowsTradingForSymbol: symbol_ ] )
   {
      [ self orderEntryForSymbol: symbol_
                   operationType: ([ PFSettings sharedSettings ].orderType == PFOrderLimit) ? PFMarketOperationSell : PFMarketOperationBuy ];
   }
}

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
            sellSymbol:( id< PFSymbol > )symbol_
{
   if ( [ [ PFSession sharedSession ] allowsTradingForSymbol: symbol_ ] )
   {
      [ self orderEntryForSymbol: symbol_
                   operationType: ([ PFSettings sharedSettings ].orderType == PFOrderLimit) ? PFMarketOperationBuy : PFMarketOperationSell ];
   }
}

@end
