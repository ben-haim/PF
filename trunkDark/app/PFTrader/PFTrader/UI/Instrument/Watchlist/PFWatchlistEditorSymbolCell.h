#import "PFTableViewCell.h"

@class PFSwitch;

@protocol PFSymbol;
@protocol PFWatchlist;

@interface PFWatchlistEditorSymbolCell : PFTableViewCell

@property ( nonatomic, strong ) IBOutlet UILabel* nameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* overviewLabel;
@property ( nonatomic, strong ) IBOutlet PFSwitch* watchlistSwitch;

-(void)setSymbol:( id< PFSymbol > )symbol_
       watchlist:( id< PFWatchlist > )watchlist_;

-(IBAction)watchlistAction:( id )sender_;

@end
