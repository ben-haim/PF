#import "PFWatchlistViewController_iPad.h"

#import "PFSymbolManagerViewController.h"
#import "PFSymbolManagerView.h"
#import "PFSymbolColumn.h"
#import "PFSymbolColumn_iPad.h"
#import "PFSymbolCell.h"
#import "PFGridView.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <QuartzCore/QuartzCore.h>

@interface PFWatchlistViewController_iPad ()< PFSymbolPriceCellDelegate >

@property ( nonatomic, strong ) PFSymbolManagerViewController* managerController;
@property ( nonatomic, strong ) PFSymbolManagerView* managerView;
@property ( nonatomic, strong ) id< PFSymbol > currentSymbol;

@end

@implementation PFWatchlistViewController_iPad

@synthesize managerController = _managerController;
@synthesize managerView;
@synthesize currentSymbol;

-(void)showSymbolManagerForRow:( NSUInteger )row_index_
{
   if ( self.elements.count && (row_index_ < self.elements.count) )
   {
      id< PFSymbol > new_symbol_ = self.elements[ row_index_ ];
      
      if ( new_symbol_ != self.currentSymbol )
      {
         self.currentSymbol = new_symbol_;

         PFSymbolManagerViewController* manager_controller_ = [ [ PFSymbolManagerViewController alloc ] initWithSymbol: self.currentSymbol
                                                                                                               symbols: self.watchlist.symbols
                                                                                                              rowIndex: row_index_  ];

         manager_controller_.wrapController = self;
         self.managerController = manager_controller_;
         [ manager_controller_.backgroundView removeFromSuperview ];
      }
   }
   else
   {
      self.currentSymbol = nil;
      self.managerController = nil;
   }
}

-(void)showFirstSymbol
{
   [ self showSymbolManagerForRow: 0 ];
}

-(void)setManagerController:( PFSymbolManagerViewController* )controller_
{
   [ _managerController.view removeFromSuperview ];

   controller_.view.frame = self.managerView.bounds;
   controller_.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   controller_.view.backgroundColor = [ UIColor clearColor ];
   

      _managerController = controller_;
   [ self.managerView addSubview: _managerController.view ];
}

-(NSArray*)watchlistColumns
{
   return [ NSArray arrayWithObjects: [ PFSymbolColumn nameColumn ]
           , [ PFSymbolColumn bidColumnWithDelegate: self ]
           , [ PFSymbolColumn askColumnWithDelegate: self ]
           , [ PFSymbolColumn_iPad bSizeColumn ]
           , [ PFSymbolColumn_iPad aSizeColumn ]
           , [ PFSymbolColumn_iPad volumeColumn ]
           , [ PFSymbolColumn_iPad changeColumn ]
           , [ PFSymbolColumn_iPad changePercentColumn ]
           , [ PFSymbolColumn_iPad lastColumn ]
           , [ PFSymbolColumn_iPad settlementPriceColumn]
           , [ PFSymbolColumn_iPad prevSettlementPriceColumn]
           , [ PFSymbolColumn_iPad spreadColumn ]
           , [ PFSymbolColumn openInterestColumn ]
//           , [ PFSymbolColumn_iPad openColumn ]
//           , [ PFSymbolColumn_iPad highColumn ]
//           , [ PFSymbolColumn_iPad lowColumn ]
//           , [ PFSymbolColumn_iPad closeColumn ]
           , [ PFSymbolColumn_iPad lastUpdateColumn ]
           , nil ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   CGRect table_rect_ = CGRectZero;
   CGRect dashboard_rect_ = CGRectZero;
   CGRectDivide( self.view.bounds, &table_rect_, &dashboard_rect_, 320.f, CGRectMinXEdge );
   
   self.gridView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
   self.gridView.frame = table_rect_;
   
   UIView* line_view_ = [ [ UIView alloc ] initWithFrame: CGRectMake( self.gridView.frame.size.width - 1.f , 0.f, 1.f, self.gridView.frame.size.height ) ];
   line_view_.backgroundColor = [ UIColor whiteColor ];
   [ self.gridView addSubview: line_view_ ];
   line_view_.layer.zPosition = 1.f;
   
   self.managerView = [ [ PFSymbolManagerView alloc ] initWithFrame: dashboard_rect_ ];
   [ self.view addSubview: self.managerView ];
   [ self showFirstSymbol ];
   [ self.managerController viewDidAppear: NO ];
}

-(BOOL)isPaginal
{
   return YES;
}

#pragma mark - PFSessionDelegate ( override )

-(void)viewDidAppear:(BOOL)animated_
{
   [ super viewDidAppear: animated_ ];

   if ( ![self.elements containsObject: self.currentSymbol] )
      [ self showFirstSymbol ];
}

-(void)session:( PFSession* )session_
didAddWatchlist:( id< PFWatchlist > )watchlist_
{
   [ super session: session_ didAddWatchlist: watchlist_ ];
   [ self showFirstSymbol ];
}

@end
