#import "PFTableViewCategory+Watchlist.h"
#import "PFTableViewSymbolItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory ( Watchlist )

+(NSArray*)symbolCategoriesWithWatchlist:( id< PFWatchlist > )watchlist_
                              controller:( UIViewController* )controller_
{
   NSMutableArray* categories_array_ = [ NSMutableArray arrayWithCapacity: watchlist_.symbols.count ];
   
   for ( id< PFSymbol > symbol_ in watchlist_.symbols )
   {
      PFTableViewSymbolItem* symbol_item_ = [ PFTableViewSymbolItem itemWithSymbol: symbol_
                                                                         watchlist: watchlist_
                                                                        controller: controller_ ];
      symbol_item_.action = ^( PFTableViewItem* item_ ) { [ (PFTableViewSymbolItem*)item_ selectCurrentItem ]; };
      [ categories_array_ addObject: [ PFTableViewCategory categoryWithTitle: nil items: [ NSArray arrayWithObject: symbol_item_ ] ] ];
   }
   
   return categories_array_;
}

@end
