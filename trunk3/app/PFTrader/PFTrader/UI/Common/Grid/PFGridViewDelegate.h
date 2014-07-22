#import <Foundation/Foundation.h>

@class PFGridView;

@protocol PFGridViewDelegate < NSObject >

@optional

-(void)gridView:( PFGridView* )grid_view_
didSelectPageAtIndex:( NSUInteger )page_index_;

-(void)gridView:( PFGridView* )grid_view_
didSelectRowAtIndex:( NSUInteger )row_index_;

-(UIView*)footerViewInGridView:( PFGridView* )grid_view_;

-(CGFloat)heightOfFooterInGridView:( PFGridView* )grid_view_;

-(UIView*)gridView:( PFGridView* )grid_view_
viewForSelectedRowAtIndex:( NSUInteger )row_index_;

-(UIView*)columnsBackgroundViewInGridView:( PFGridView* )grid_view_;
-(UIView*)columnsOverlayViewInGridView:( PFGridView* )grid_view_;

-(UIView*)gridView:( PFGridView* )grid_view_
backgroundViewForRowAtIndex:( NSUInteger )row_index_
     columnAtIndex:( NSUInteger )column_index_;

@end
