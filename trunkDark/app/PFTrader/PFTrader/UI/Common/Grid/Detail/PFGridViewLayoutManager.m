#import "PFGridViewLayoutManager.h"

#import "PFGridView.h"
#import "PFGridViewDataSource.h"

@interface UIView (PFGridViewLayout)

-(void)addSubview:( UIView* )cell_
                x:( CGFloat )x_
                y:( CGFloat )y_
            width:( CGFloat )width_
           height:( CGFloat )height_;

@end

@implementation UIView (PFGridViewLayout)

-(void)addSubview:( UIView* )cell_
                x:( CGFloat )x_
                y:( CGFloat )y_
            width:( CGFloat )width_
           height:( CGFloat )height_
{
   if ( cell_ )
   {
      cell_.frame = CGRectMake( x_, y_, width_, height_ );
      
      cell_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
      
      [ self addSubview: cell_ ];
   }
}

@end

@implementation PFGridViewPaginalLayoutManager

-(void)addRowToGridView:( PFGridView* )grid_view_
      withViewGenerator:( PFGridViewRowGenerator )generator_
              yPosition:( CGFloat )y_position_
                 height:( CGFloat )height_
        fixedColumnView:( UIView* )fixed_column_view_
            columnsView:( UIView* )page_columns_view_
{
   NSUInteger column_index_ = 0;
   CGFloat fixed_column_width_ = [ grid_view_.dataSource widthOfFixedColumnInGridView: grid_view_ ];
   if ( fixed_column_width_ > 0.0 )
   {
      [ fixed_column_view_ addSubview: generator_(column_index_++)
                                    x: 0.f
                                    y: y_position_
                                width: fixed_column_width_
                               height: height_ ];
   }
   
   CGFloat page_width_ = page_columns_view_.bounds.size.width;
   
   NSUInteger columns_count_ = [ grid_view_.dataSource numberOfColumnsInGridView: grid_view_ ];

   NSUInteger pages_count_ = [ self pagesCountInGridView: grid_view_
                                             columnsView: page_columns_view_ ];

   for ( NSUInteger page_index_ = 0; page_index_ < pages_count_; ++page_index_ )
   {
      NSUInteger columns_in_page_ = [ grid_view_.dataSource gridView: grid_view_ numberOfColumnsInPageAtIndex: page_index_ ];
      
      CGFloat column_width_ = page_width_ / columns_in_page_;
      
      for ( NSUInteger page_column_index_ = 0
           ; column_index_ < columns_count_ && page_column_index_ < columns_in_page_
           ; ++page_column_index_, ++column_index_ )
      {
         [ page_columns_view_  addSubview: generator_(column_index_)
                                        x: page_index_ * page_width_ + page_column_index_ * column_width_
                                        y: y_position_
                                    width: column_width_
                                   height: height_ ];
      }
   }
}

-(NSUInteger)pagesCountInGridView:( PFGridView* )grid_view_
                      columnsView:( UIView* )columns_view_
{
   NSUInteger column_index_ = [ grid_view_.dataSource widthOfFixedColumnInGridView: grid_view_ ] > 0.f ? 1 : 0;
   NSUInteger columns_count_ = [ grid_view_.dataSource numberOfColumnsInGridView: grid_view_ ];
   NSUInteger page_index_ = 0;

   for ( ; column_index_ < columns_count_ ; ++page_index_ )
   {
      column_index_ += [ grid_view_.dataSource gridView: grid_view_ numberOfColumnsInPageAtIndex: page_index_ ];
   }

   return page_index_;
}

-(CGFloat)widthOfColumnsInGridView:( PFGridView* )grid_view_
                       columnsView:( UIView* )columns_view_
{
   return [ self pagesCountInGridView: grid_view_ columnsView: columns_view_ ] * columns_view_.bounds.size.width;
}

@end

@implementation PFGridViewTableLayoutManager

-(void)addRowToGridView:( PFGridView* )grid_view_
      withViewGenerator:( PFGridViewRowGenerator )generator_
              yPosition:( CGFloat )y_position_
                 height:( CGFloat )height_
        fixedColumnView:( UIView* )fixed_column_view_
            columnsView:( UIView* )page_columns_view_
{
   NSUInteger column_index_ = 0;
   CGFloat fixed_column_width_ = [ grid_view_.dataSource widthOfFixedColumnInGridView: grid_view_ ];
   if ( fixed_column_width_ > 0.0 )
   {
      [ fixed_column_view_ addSubview: generator_(column_index_++)
                                    x: 0.f
                                    y: y_position_
                                width: fixed_column_width_
                               height: height_ ];
   }

   NSUInteger columns_count_ = [ grid_view_.dataSource numberOfColumnsInGridView: grid_view_ ];

   CGFloat columns_x_ = 0.f;
   
   for ( ; column_index_ < columns_count_; ++column_index_ )
   {
      CGFloat column_width_ = [ grid_view_.dataSource gridView: grid_view_
                                          widthOfColumnAtIndex: column_index_ ];

      [ page_columns_view_ addSubview: generator_(column_index_)
                                    x: columns_x_
                                    y: y_position_
                                width: column_width_
                               height: height_ ];
      

      columns_x_ += column_width_;
   }
}

-(CGFloat)widthOfColumnsInGridView:( PFGridView* )grid_view_
                       columnsView:( UIView* )columns_view_
{
   NSUInteger column_index_ = [ grid_view_.dataSource widthOfFixedColumnInGridView: grid_view_ ] > 0.f ? 1 : 0;
   CGFloat width_ = 0.f;

   NSUInteger columns_count_ = [ grid_view_.dataSource numberOfColumnsInGridView: grid_view_ ];

   for ( ; column_index_ < columns_count_; ++column_index_ )
   {
      width_ += [ grid_view_.dataSource gridView: grid_view_
                            widthOfColumnAtIndex: column_index_ ];
   }

   return width_;
}

@end
