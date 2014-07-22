#import <Foundation/Foundation.h>

@class PFGridView;
@class PFGridCell;

@protocol PFGridViewDataSource < NSObject >

@required

-(NSUInteger)numberOfColumnsInGridView:( PFGridView* )grid_view_;

-(NSUInteger)numberOfRowsInGridView:( PFGridView* )grid_view_;

-(PFGridCell*)gridView:( PFGridView* )grid_view_
     cellForRowAtIndex:( NSUInteger )row_index_
         columnAtIndex:( NSUInteger )column_index_;

@optional

-(BOOL)isPaginalGridView:( PFGridView* )grid_view_;

-(CGFloat)gridView:( PFGridView* )grid_view_
widthOfColumnAtIndex:( NSUInteger )column_index_;

-(NSUInteger)gridView:( PFGridView* )grid_view_
numberOfColumnsInPageAtIndex:( NSUInteger )page_index_;

-(CGFloat)widthOfFixedColumnInGridView:( PFGridView* )grid_view_;

-(CGFloat)rightInsetInGridView:( PFGridView* )grid_view_;

-(CGFloat)heightOfRowInGridView:( PFGridView* )grid_view_;

-(UIColor*)backgroundColorForHeaderInGridView:( PFGridView* )grid_view_;

-(CGFloat)heightOfHeaderInGridView:( PFGridView* )grid_view_;

-(UIView*)gridView:( PFGridView* )grid_view_
headerViewForColumnAtIndex:( NSUInteger )column_index_;

@end