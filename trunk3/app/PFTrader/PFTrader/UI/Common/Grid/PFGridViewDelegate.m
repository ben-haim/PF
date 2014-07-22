#import "PFGridViewDelegate.h"

@implementation NSObject (PFGridViewDelegate)

-(void)gridView:( PFGridView* )grid_view_
didSelectPageAtIndex:( NSUInteger )page_index_
{
}

-(void)gridView:( PFGridView* )grid_view_
didSelectRowAtIndex:( NSUInteger )row_index_
{
}

-(UIView*)footerViewInGridView:( PFGridView* )grid_view_
{
   return nil;
}

-(CGFloat)heightOfFooterInGridView:( PFGridView* )grid_view_
{
   return 0.f;
}

-(UIView*)gridView:( PFGridView* )grid_view_
viewForSelectedRowAtIndex:( NSUInteger )row_index_
{
   return nil;
}

-(UIView*)columnsBackgroundViewInGridView:( PFGridView* )grid_view_
{
   return nil;
}

-(UIView*)columnsOverlayViewInGridView:( PFGridView* )grid_view_
{
   return nil;
}

-(UIView*)gridView:( PFGridView* )grid_view_
backgroundViewForRowAtIndex:( NSUInteger )row_index_
     columnAtIndex:( NSUInteger )column_index_
{
   return nil;
}

@end
