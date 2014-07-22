#import "PFTableViewItem.h"

@protocol PFSymbol;
@protocol PFWatchlist;

@interface PFTableViewSymbolItem : PFTableViewItem

@property ( nonatomic, strong, readonly ) id< PFSymbol > symbol;
@property ( nonatomic, strong, readonly ) id< PFWatchlist > watchlist;
@property ( nonatomic, weak, readonly ) UIViewController* currentController;
@property ( nonatomic, assign, readonly ) BOOL isSelected;

+(id)itemWithSymbol:( id< PFSymbol > )symbol_
          watchlist:( id< PFWatchlist > )watchlist_
         controller:( UIViewController* )controller_;

-(void)selectCurrentItem;
-(void)deselectCurrentItem;

@end
