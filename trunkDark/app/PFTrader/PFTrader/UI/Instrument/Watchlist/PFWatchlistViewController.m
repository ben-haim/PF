#import "PFWatchlistViewController.h"
#import "PFNavigationController.h"
#import "PFWatchlistInstrumentEditorViewController.h"
#import "PFTableViewCategory+Watchlist.h"
#import "PFTableView.h"
#import "PFTableViewItemCell.h"
#import "PFModalWindow.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFWatchlistViewController () < PFSessionDelegate >

@property ( nonatomic, weak ) NSTimer* updateTimer;

@end

@implementation PFWatchlistViewController

@synthesize watchlist;
@synthesize selectedSymbol = _selectedSymbol;
@synthesize delegate;
@synthesize updateTimer;

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

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ [ PFSession sharedSession ] addDelegate: self ];
   self.tableView.skipCellsBackground = YES;
   [ self applySymbols ];
   
   UIBarButtonItem* right_button_ = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFEditButton" ]
                                                                        style: UIBarButtonItemStylePlain
                                                                       target: self
                                                                       action: @selector( editAction ) ];
   if ( self.pfNavigationWrapperController )
   {
      self.pfNavigationWrapperController.navigationItem.rightBarButtonItem = right_button_;
   }
   else
   {
      self.navigationItem.rightBarButtonItem = right_button_;
   }
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      [ self setSuperLightNavigationBar ];
      self.view.backgroundColor = [ UIColor backgroundLightColor ];
   }
}

-(void)viewDidAppear:( BOOL )animated_
{
   [ super viewDidAppear: animated_ ];

   self.updateTimer = [ NSTimer scheduledTimerWithTimeInterval: 1.0
                                                        target: self
                                                      selector: @selector( updateWatchlist )
                                                      userInfo: nil
                                                       repeats: YES ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self.updateTimer invalidate ];
   self.updateTimer = nil;
}

-(void)applySymbols
{
   self.tableView.categories = [ PFTableViewCategory symbolCategoriesWithWatchlist: self.watchlist
                                                                        controller: self ];
   [ self.tableView reloadData ];
}

-(void)editAction
{
   PFWatchlistInstrumentEditorViewController* editor_controller_ = [ [ PFWatchlistInstrumentEditorViewController alloc ] initWithWatchlist: self.watchlist ];
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      PFNavigationController* navigation_controller_ = [ PFNavigationController navigationControllerWithController: editor_controller_ ];
      navigation_controller_.useCloseButton = YES;
      
      [ PFModalWindow showWithNavigationController: navigation_controller_ ];
   }
   else
   {
      [ self.pfNavigationController pushViewController: editor_controller_
                                              animated: YES ];
   }
}

-(void)updateWatchlist
{
   NSMutableArray* cells_ = [ NSMutableArray new ];
   
   for ( NSInteger j = 0; j < self.tableView.tableView.numberOfSections; j++ )
   {
      for ( NSInteger i = 0; i < [ self.tableView.tableView numberOfRowsInSection: j ]; i++ )
      {
         id cell_ = [ self.tableView.tableView cellForRowAtIndexPath: [ NSIndexPath indexPathForRow: i inSection: j ] ];
         
         if ( cell_ )
         {
            [ cells_ addObject: cell_ ];
         }
      }
   }
   
   for ( PFTableViewItemCell* cell_ in cells_ )
   {
      [ cell_ updateDataWithItem: cell_.item ];
   }
}

-(void)setSelectedSymbol:( id< PFSymbol > )selected_symbol_
{
   if ( _selectedSymbol != selected_symbol_ )
   {
      _selectedSymbol = selected_symbol_;
      [ self.tableView.tableView reloadData ];
      
      if ( [ self.delegate respondsToSelector: @selector(watchlistViewController:didSelectSymbol:) ] )
      {
         [ self.delegate watchlistViewController: self didSelectSymbol: _selectedSymbol ];
      }
   }
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
  didAddSymbol:( id< PFSymbol > )symbol_
{
   if ( self.watchlist == watchlist_ )
   {
      [ self applySymbols ];
   }
}

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
didRemoveSymbols:( NSArray* )symbols_
{
   if ( self.watchlist == watchlist_ )
   {
      [ self applySymbols ];
      
      for ( id< PFSymbol > symbol_ in symbols_ )
      {
         if ( [ symbol_ isEqual: self.selectedSymbol ] )
         {
            self.selectedSymbol = nil;
            break;
         }
      }
   }
}

-(void)session:( PFSession* )session_
didAddWatchlist:( id< PFWatchlist > )watchlist_
{
   if ( watchlist_.watchlistId == self.watchlist.watchlistId )
   {
      self.watchlist = watchlist_;
      [ self applySymbols ];
      self.selectedSymbol = nil;
   }
}

-(void)didReconnectedSessionWithNewSession:( PFSession* )session_
{
   [ self applySymbols ];
   self.selectedSymbol = nil;
}

@end
