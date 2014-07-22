#import <UIKit/UIKit.h>

typedef UIView* (^PFGridViewRowGenerator)( NSUInteger column_index_ );

@class PFGridView;

@protocol PFGridViewLayoutManager <NSObject>

-(void)addRowToGridView:( PFGridView* )grid_view_
      withViewGenerator:( PFGridViewRowGenerator )generator_
              yPosition:( CGFloat )y_position_
                 height:( CGFloat )height_
        fixedColumnView:( UIView* )fixed_column_view_
            columnsView:( UIView* )page_columns_view_;

//-(NSUInteger)pagesCountInGridView:( PFGridView* )grid_view_
//                      columnsView:( UIView* )columns_view_;

-(CGFloat)widthOfColumnsInGridView:( PFGridView* )grid_view_
                       columnsView:( UIView* )columns_view_;

@end

@interface PFGridViewPaginalLayoutManager : NSObject< PFGridViewLayoutManager >

@end

@interface PFGridViewTableLayoutManager : NSObject< PFGridViewLayoutManager >

@end
