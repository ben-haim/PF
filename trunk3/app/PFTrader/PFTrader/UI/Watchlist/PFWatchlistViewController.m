#import "PFSymbolsViewController.h"

#import "PFSymbolColumn.h"

#import "PFGridView.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFSymbolsViewController ()< PFSessionDelegate >

@end

@implementation PFSymbolsViewController

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.title = NSLocalizedString( @"SYMBOLS", nil );
   }
   return self;
}

-(void)viewDidLoad
{
   PFSession* session_ = [ PFSession sharedSession ];
   [ session_ addDelegate: self ];

   self.elements = session_.symbols.symbols;

   self.columns = [ NSArray arrayWithObjects: [ PFSymbolColumn nameColumn ]
                   , [ PFSymbolColumn bidColumn ]
                   , [ PFSymbolColumn askColumn ]
                   , [ PFSymbolColumn bSizeColumn ]
                   , [ PFSymbolColumn aSizeColumn ]
                   , [ PFSymbolColumn lastColumn ]
                   , [ PFSymbolColumn changeColumn ]
                   , [ PFSymbolColumn openColumn ]
                   , [ PFSymbolColumn closeColumn ]
                   , nil ];

   [ super viewDidLoad ];
}

-(void)gridView:( PFGridView* )grid_view_
didSelectRowAtIndex:( NSUInteger )row_index_
{
   id< PFSymbol > symbol_ = [ self.elements objectAtIndex: row_index_ ];
   NSLog( @"didSelect element: %@", symbol_ );
   
   [ [ PFSession sharedSession ].watchlist addSymbol: symbol_ ];
}

#pragma mark PFSessionDelegate

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
  didAddSymbol:( id< PFSymbol > )symbol_
{
   self.elements = session_.watchlist.symbols;
   [ self.gridView reloadData ];
}

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
didRemoveSymbol:( id< PFSymbol > )symbol_
{
   self.elements = session_.watchlist.symbols;
   [ self.gridView reloadData ];
}

@end
