#import "PFTableViewCategory.h"

@protocol PFWatchlist;

@interface PFTableViewCategory ( Watchlist )

+(NSArray*)symbolCategoriesWithWatchlist:( id< PFWatchlist > )watchlist_
                              controller:( UIViewController* )controller_;

@end
