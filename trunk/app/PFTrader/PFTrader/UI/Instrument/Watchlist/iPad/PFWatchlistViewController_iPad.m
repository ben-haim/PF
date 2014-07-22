#import "PFWatchlistViewController_iPad.h"

#import "PFChartViewController_iPad.h"
#import "PFOptionChainViewController_iPad.h"

#import "PFSymbolColumn.h"
#import "PFSymbolColumn_iPad.h"
#import "PFSymbolCell.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFWatchlistViewController_iPad ()< PFSymbolPriceCellDelegate >

@end

@implementation PFWatchlistViewController_iPad

-(NSArray*)watchlistColumns
{
   return [ NSArray arrayWithObjects: [ PFSymbolColumn nameColumn ]
           , [ PFSymbolColumn_iPad changePercentColumn ]
           , [ PFSymbolColumn_iPad lastColumn ]
           , [ PFSymbolColumn bidColumnWithDelegate: self ]
           , [ PFSymbolColumn_iPad bSizeColumn ]
           , [ PFSymbolColumn askColumnWithDelegate: self ]
           , [ PFSymbolColumn_iPad aSizeColumn ]
           , [ PFSymbolColumn_iPad spreadColumn ]
           , [ PFSymbolColumn_iPad volumeColumn ]
           , [ PFSymbolColumn_iPad changeColumn ]
           , [ PFSymbolColumn_iPad openColumn ]
           , [ PFSymbolColumn_iPad highColumn ]
           , [ PFSymbolColumn_iPad lowColumn ]
           , [ PFSymbolColumn_iPad closeColumn ]
           , [ PFSymbolColumn_iPad lastUpdateColumn ]
           , nil ];
}

-(void)chartForSymbol:( id< PFSymbol > )symbol_
{
   PFChartViewController* chart_view_controller_ = [ [ PFChartViewController_iPad alloc ] initWithSymbol: symbol_ andSymbols: self.watchlist.symbols ];

   [ self.navigationController pushViewController: chart_view_controller_ animated: YES ];
}

-(void)optionChainForSymbol:( id< PFSymbol > )symbol_ andBaseSymbol:( id< PFSymbol > )base_symbol_
{
   PFOptionChainViewController* option_chain_controller_ = [ [ PFOptionChainViewController_iPad alloc ] initWithSymbol: symbol_
                                                                                                         andBaseSymbol: base_symbol_ ];
   
   [ self.navigationController pushViewController: option_chain_controller_ animated: YES ];
}

@end
