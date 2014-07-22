#import "PFGridViewDataSource.h"

@implementation NSObject (PFGridViewDataSource)

-(BOOL)isPaginalGridView:( PFGridView* )grid_view_
{
   return YES;
}

-(CGFloat)gridView:( PFGridView* )grid_view_
widthOfColumnAtIndex:( NSUInteger )column_index_
{
   return 100.f;
}

-(CGFloat)widthOfFixedColumnInGridView:( PFGridView* )grid_view_
{
   return 100.f;
}

-(CGFloat)rightInsetInGridView:( PFGridView* )grid_view_
{
   return 10.f;
}

-(CGFloat)heightOfRowInGridView:( PFGridView* )grid_view_
{
   return 60.f;
}

-(NSUInteger)gridView:( PFGridView* )grid_view_
numberOfColumnsInPageAtIndex:( NSUInteger )page_index_
{
   return 2;
}

-(UIColor*)backgroundColorForHeaderInGridView:( PFGridView* )grid_view_
{
   return [ UIColor colorWithWhite: 0.f alpha: 0.7f ];
}

-(CGFloat)heightOfHeaderInGridView:( PFGridView* )grid_view_
{
   return 0.f;
}

-(UIView*)gridView:( PFGridView* )grid_view_
headerViewForColumnAtIndex:( NSUInteger )column_index_
{
   return nil;
}

@end
