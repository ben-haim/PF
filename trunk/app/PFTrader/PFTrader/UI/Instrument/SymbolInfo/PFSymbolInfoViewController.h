#import <ExpandableTree/ExpandableTree.h>

#import "PFViewController.h"

@class ETOneLevelTreeView;
@protocol PFSymbol;

@interface PFSymbolInfoViewController : PFViewController < ETOneLevelTreeViewDelegate, ETOneLevelTreeViewDataSource >

@property ( nonatomic, strong ) IBOutlet ETOneLevelTreeView* treeView;

-(id)initWithSymbol:( id< PFSymbol > )symbol_;

@end
