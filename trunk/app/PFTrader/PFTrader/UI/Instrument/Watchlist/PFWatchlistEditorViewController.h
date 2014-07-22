#import "PFSegmentedControl.h"

#import <ExpandableTree/ExpandableTree.h>

#import "PFViewController.h"

@class ETOneLevelTreeView;
@class PFSegmentedControl;

@protocol PFWatchlist;

@interface PFWatchlistEditorViewController : PFViewController< ETOneLevelTreeViewDelegate
, ETOneLevelTreeViewDataSource
, PFSegmentedControlDelegate >

@property ( nonatomic, strong ) IBOutlet ETOneLevelTreeView* treeView;
@property ( nonatomic, strong ) IBOutlet UITextField* searchField;
@property ( nonatomic, strong ) IBOutlet PFSegmentedControl* filterControl;

-(id)initWithWatchlist:( id< PFWatchlist > )watchlist_;

-(IBAction)filterAction:( id )sender_;

@end
