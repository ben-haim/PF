#import "PFTableViewControllerCard.h"

@protocol PFWatchlist;
@protocol PFSymbol;
@protocol PFWatchlistViewControllerDelegate;
@class PFSession;

@interface PFWatchlistViewController : PFTableViewControllerCard

@property ( nonatomic, strong ) id< PFWatchlist > watchlist;
@property ( nonatomic, strong ) id< PFSymbol > selectedSymbol;
@property ( nonatomic, weak ) id< PFWatchlistViewControllerDelegate > delegate;

-(id)initWithWatchlist:( id< PFWatchlist > )watchlist_;

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
  didAddSymbol:( id< PFSymbol > )symbol_;

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
didRemoveSymbols:( NSArray* )symbols_;

-(void)session:( PFSession* )session_
didAddWatchlist:( id< PFWatchlist > )watchlist_;

@end

@protocol PFWatchlistViewControllerDelegate < NSObject >

-(void)watchlistViewController:( PFWatchlistViewController* )controller_
               didSelectSymbol:( id< PFSymbol > )symbol_;

@end
