#import "ETOneLevelTreeViewDataSource.h"

@implementation NSObject (ETOneLevelTreeViewDataSource)

-(BOOL)treeView:( ETOneLevelTreeView* )tree_view_
isInitiallyExpandedRootItemAtIndex:( NSInteger )root_index_
{
   return NO;
}

@end
