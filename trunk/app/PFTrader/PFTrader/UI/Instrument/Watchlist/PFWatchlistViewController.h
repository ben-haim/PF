#import "PFGridViewController.h"

#import <UIKit/UIKit.h>

@protocol PFWatchlist;

@interface PFWatchlistViewController : PFGridViewController

@property ( nonatomic, strong ) id< PFWatchlist > watchlist;

-(id)initWithWatchlist:( id< PFWatchlist > )watchlist_;

@end
