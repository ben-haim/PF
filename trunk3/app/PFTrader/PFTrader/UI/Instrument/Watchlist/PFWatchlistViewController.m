#import "PFWatchlistViewController.h"

#import "PFWatchlistEditorViewController.h"
#import "PFOrderEntryViewController.h"

#import "PFSymbolColumn.h"
#import "PFSymbolCell.h"
#import "PFGridView.h"
#import "PFGridFooterView.h"
#import "PFGridActionView.h"
#import "UIImage+Icons.h"
#import "PFSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

#import "PFSymbolManagerViewController.h"

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
{
   [ [ [ PFOrderEntryViewController alloc ] initWithSymbol: symbol_ ] showControllerWithController: self ];
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
           , [ PFSymbolColumn settlementPriceColumn ]
           , [ PFSymbolColumn openInterestColumn ]
           , nil ];
}

-(void)applySymbols
{
   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];
   
   self.elements = self.watchlist.symbols;
   self.columns = [ self watchlistColumns ];
   
   __weak PFWatchlistViewController* unsafe_self_ = self;
   self.gridView.selectedRowViewBlock = ^( NSUInteger row_index_ ) { [ unsafe_self_ showSymbolManagerForRow: row_index_ ]; };
}

-(void)showSymbolManagerForRow:( NSUInteger )row_index_
{
   if ( self.elements.count && (row_index_ < self.elements.count) )
   {
      [ self.navigationController pushViewController: [ [ PFSymbolManagerViewController alloc ] initWithSymbol: [ self.elements objectAtIndex: row_index_ ]
                                                                                                       symbols: self.watchlist.symbols
                                                                                                      rowIndex: row_index_  ]
                                            animated: YES ];
   }
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
                                            [ self showSymbolManagerForRow: 0 ];
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
      [ self orderEntryForSymbol: symbol_ ];
   }
}

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
            sellSymbol:( id< PFSymbol > )symbol_
{
   if ( [ [ PFSession sharedSession ] allowsTradingForSymbol: symbol_ ] )
   {
      [ self orderEntryForSymbol: symbol_ ];
   }
}

@end
