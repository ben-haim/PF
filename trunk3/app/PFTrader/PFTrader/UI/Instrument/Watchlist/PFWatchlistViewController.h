#import "PFGridViewController.h"

#import <UIKit/UIKit.h>

@protocol PFWatchlist;
@protocol PFSymbol;
@class PFSession;

@interface PFWatchlistViewController : PFGridViewController

@property ( nonatomic, strong ) id< PFWatchlist > watchlist;

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
