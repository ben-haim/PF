#import "PFTableViewSymbolItem.h"
#import "PFTableViewSymbolItemCell.h"
#import "PFTableViewSelectedSymbolItemCell.h"
#import "PFWatchlistViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTableViewSymbolItem ()

@property ( nonatomic, strong ) id< PFSymbol > symbol;
@property ( nonatomic, strong ) id< PFWatchlist > watchlist;
@property ( nonatomic, weak ) UIViewController* currentController;

@end

@implementation PFTableViewSymbolItem

@synthesize symbol;
@synthesize watchlist;
@synthesize currentController;

+(id)itemWithSymbol:( id< PFSymbol > )symbol_
          watchlist:( id< PFWatchlist > )watchlist_
         controller:( UIViewController* )controller_
{
   PFTableViewSymbolItem* symbol_item_ = [ self itemWithAction: nil
                                                         title: symbol_.name ];
   symbol_item_.symbol = symbol_;
   symbol_item_.watchlist = watchlist_;
   symbol_item_.currentController = controller_;
   
   return symbol_item_;
}

-(PFWatchlistViewController*)watchlistController
{
   return (PFWatchlistViewController*)self.currentController;
}

-(BOOL)isSelected
{
   return self.symbol == self.watchlistController.selectedSymbol;
}

-(void)selectCurrentItem
{
   if ( ![ self isSelected ] )
   {
      self.watchlistController.selectedSymbol = self.symbol;
   }
}

-(void)deselectCurrentItem
{
   if ( [ self isSelected ] )
   {
      self.watchlistController.selectedSymbol = nil;
   }
}

-(Class)cellClass
{
   return ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || ![ self isSelected ] ) ? [ PFTableViewSymbolItemCell class ] : [ PFTableViewSelectedSymbolItemCell class ];
}

-(CGFloat)cellHeightForTableView:( UITableView* )table_view_
{
   return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || ![ self isSelected ]) ? 55.0f : 453.0f;
}

@end
