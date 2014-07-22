#import "PFGridView.h"

#import "PFGridViewDataSource.h"
#import "PFGridViewDelegate.h"

#import "PFGridCell.h"
#import "PFGridRows.h"

#import "PFGridViewLayoutManager.h"

@interface PFGridView ()< UIScrollViewDelegate, UIGestureRecognizerDelegate >
{
@private
   NSUInteger _activePage;
}

@property ( nonatomic, strong ) UIScrollView* verticalScrollView;
@property ( nonatomic, strong ) UIScrollView* horyzontalScrollView;
@property ( nonatomic, strong ) UIScrollView* headerScrollView;

@property ( nonatomic, strong ) UIView* columnsBackgroundView;
@property ( nonatomic, strong ) UIView* columnsOverlayView;

@property ( nonatomic, strong ) UIView* headerView;
@property ( nonatomic, strong ) UIView* footerView;
@property ( nonatomic, strong ) UIView* selectedRowView;

@property ( nonatomic, strong ) PFGridRows* rows;

@property ( nonatomic, assign ) NSUInteger selectedRow;
@property ( nonatomic, assign ) NSRange visibleRange;
@property ( nonatomic, assign ) CGFloat width;

@property ( nonatomic, strong ) id< PFGridViewLayoutManager > layoutManager;

@end

@implementation PFGridView

@synthesize selectedRowViewBlock;

@synthesize delegate;
@synthesize dataSource;

@synthesize verticalScrollView = _verticalScrollView;
@synthesize horyzontalScrollView = _horyzontalScrollView;
@synthesize headerScrollView = _headerScrollView;

@synthesize columnsBackgroundView;
@synthesize columnsOverlayView;

@synthesize headerView = _headerView;
@synthesize footerView;
@synthesize selectedRowView;

@synthesize rows = _rows;

@synthesize selectedRow;
@synthesize visibleRange;
@synthesize width;

@synthesize layoutManager;

@dynamic activePage;

-(void)dealloc
{
   _verticalScrollView.delegate = nil;
   _horyzontalScrollView.delegate = nil;
   _headerScrollView.delegate = nil;
}

-(NSUInteger)activePage
{
   return self.horyzontalScrollView.contentOffset.x / self.horyzontalScrollView.bounds.size.width;
}

-(void)setActivePage:( NSUInteger )page_
{
   [ self setActivePage: page_ animated: NO ];
}

-(void)setActivePage:( NSUInteger )page_ animated:( BOOL )animated_
{
   [ self.horyzontalScrollView setContentOffset: CGPointMake( page_ * self.horyzontalScrollView.bounds.size.width, 0.f )
                                       animated: animated_ ];

   _activePage = page_;
}

-(PFGridRows*)rows
{
   if ( !_rows )
   {
      _rows = [ PFGridRows new ];
   }
   return _rows;
}

-(void)updateRectForSelectedView
{
   if ( self.selectedRow != NSNotFound )
   {
      CGFloat row_height_ = [ self.dataSource heightOfRowInGridView: self ];

      self.selectedRowView.frame = CGRectMake( 0.f
                                              , self.selectedRow * row_height_
                                              , self.verticalScrollView.bounds.size.width - [ self.dataSource rightInsetInGridView: self ]
                                              , row_height_ - 1 );
   }
}

-(void)addSelectedViewForRow:( NSUInteger )row_
{
   if ( self.selectedRowViewBlock )
   {
      self.selectedRowViewBlock( row_ );
      return;
   }
   
   //If second click hide overlay
   [ self.selectedRowView removeFromSuperview ];
   self.selectedRowView = nil;

   if ( self.selectedRow == row_ )
   {
      self.selectedRow = NSNotFound;
      return;
   }

   self.selectedRow = row_;

   self.selectedRowView = [ self.delegate gridView: self viewForSelectedRowAtIndex: row_ ];
   if ( self.selectedRowView )
   {
      [ self updateRectForSelectedView ];

      [ self.verticalScrollView insertSubview: self.selectedRowView aboveSubview: self.columnsOverlayView ];
   }
}

-(BOOL)gestureRecognizer:( UIGestureRecognizer* )gesture_recognizer_
      shouldReceiveTouch:( UITouch* )touch_
{
   return ![ touch_.view isKindOfClass: [ UIButton class ] ];
}

-(void)handleTap:(UITapGestureRecognizer*)recognizer_
{
   if ( recognizer_.state != UIGestureRecognizerStateEnded )
      return;

   CGPoint tap_location_ = [ recognizer_ locationInView: self.verticalScrollView ];
   NSUInteger row_ = tap_location_.y / [ self.dataSource heightOfRowInGridView: self ];

   if ( row_ < [ self.dataSource numberOfRowsInGridView: self ] )
   {
      [ self addSelectedViewForRow: row_ ];
      [ self.delegate gridView: self didSelectRowAtIndex: row_ ];
   }
}

-(UIScrollView*)verticalScrollView
{
   if ( !_verticalScrollView )
   {
      _verticalScrollView = [ UIScrollView new ];
      _verticalScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

      _verticalScrollView.delegate = self;

      _verticalScrollView.showsHorizontalScrollIndicator = NO;
      _verticalScrollView.showsVerticalScrollIndicator = YES;

      _verticalScrollView.alwaysBounceVertical = YES;
      _verticalScrollView.alwaysBounceHorizontal = NO;

      UITapGestureRecognizer* gesture_recognizer_ = [ [ UITapGestureRecognizer alloc ] initWithTarget: self
                                                                                               action: @selector(handleTap:) ];
      gesture_recognizer_.delegate = self;

      [ _verticalScrollView addGestureRecognizer: gesture_recognizer_ ];
   }

   return _verticalScrollView;
}

-(UIScrollView*)horyzontalScrollView
{
   if ( !_horyzontalScrollView )
   {
      _horyzontalScrollView = [ UIScrollView new ];
      _horyzontalScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

      _horyzontalScrollView.delegate = self;

      _horyzontalScrollView.bounces = NO;
      _horyzontalScrollView.directionalLockEnabled = YES;

      _horyzontalScrollView.showsHorizontalScrollIndicator = NO;
      _horyzontalScrollView.showsVerticalScrollIndicator = NO;
   }

   return _horyzontalScrollView;
}

-(UIScrollView*)headerScrollView
{
   if ( !_headerScrollView )
   {
      _headerScrollView = [ UIScrollView new ];
      _headerScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

      _headerScrollView.delegate = self;

      _headerScrollView.bounces = NO;
      _headerScrollView.directionalLockEnabled = YES;

      _headerScrollView.showsHorizontalScrollIndicator = NO;
   }

   return _headerScrollView;
}

-(void)divideRect:( CGRect )rect_
         getFixed:( CGRect* )out_fixed_rect_
         getOther:( CGRect* )out_other_rect_
{
   CGFloat fixed_width_ = [ self.dataSource widthOfFixedColumnInGridView: self ];

   CGRect fixed_rect_ = CGRectZero;
   CGRect other_rect_ = CGRectZero;

   CGRectDivide( rect_, &fixed_rect_, &other_rect_, fixed_width_, CGRectMinXEdge );
   other_rect_.size.width -= [ self.dataSource rightInsetInGridView: self ];

   if ( out_fixed_rect_ )
      *out_fixed_rect_ = fixed_rect_;

   if ( out_other_rect_ )
      *out_other_rect_ = other_rect_;
}

-(void)addHeaderView
{
   self.headerScrollView = nil;
   [ self.headerView removeFromSuperview ];

   CGFloat header_height_ = [ self.dataSource heightOfHeaderInGridView: self ];

   CGRect header_rect_ = CGRectZero;
   CGRect grid_rect_ = CGRectZero;

   CGRectDivide( self.bounds, &header_rect_, &grid_rect_, header_height_, CGRectMinYEdge );

   self.headerView = [ [ UIView alloc ] initWithFrame: header_rect_ ];
   self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
   self.headerView.backgroundColor = [ self.dataSource backgroundColorForHeaderInGridView: self ];

   [ self addSubview: self.headerView ];

   CGRect column_header_rect_ = CGRectZero;

   [ self divideRect: self.headerView.bounds
            getFixed: 0
            getOther: &column_header_rect_ ];

   self.headerScrollView.frame = column_header_rect_;
   [ self.headerView addSubview: self.headerScrollView ];

   self.headerScrollView.pagingEnabled = [ self.dataSource isPaginalGridView: self ];

   self.headerScrollView.contentSize = CGSizeMake( [ self.layoutManager widthOfColumnsInGridView: self
                                                                                     columnsView: self.headerScrollView ]
                                                  , header_height_ );

   PFGridViewRowGenerator header_generator_ = ^( NSUInteger column_index_ )
   {
      return [ self.dataSource gridView: self headerViewForColumnAtIndex: column_index_ ];
   };

   [ self.layoutManager addRowToGridView: self
                       withViewGenerator: header_generator_
                               yPosition: 0.f
                                  height: self.headerView.bounds.size.height
                         fixedColumnView: self.headerView
                             columnsView: self.headerScrollView ];
}

-(NSRange)calculateVisibleRange
{
   CGFloat row_height_ = [ self.dataSource heightOfRowInGridView: self ];

   NSUInteger min_row_ = fmax( floor( self.verticalScrollView.contentOffset.y / row_height_ ), 0.f );
   NSUInteger max_row_ = fmin( ceil( ( self.verticalScrollView.contentOffset.y + self.verticalScrollView.bounds.size.height ) / row_height_ ), [ self.dataSource numberOfRowsInGridView: self ] );

   return NSMakeRange( min_row_, max_row_ - min_row_ );
}

-(void)addRowWithIndex:( NSUInteger )row_index_
{
   PFGridViewRowGenerator header_generator_ = ^( NSUInteger column_index_ )
   {
      PFGridCell* cell_ = [ self.dataSource gridView: self
                                   cellForRowAtIndex: row_index_
                                       columnAtIndex: column_index_ ];

      [ self.rows addCell: cell_ toRowWithIndex: row_index_ ];

      UIView* background_view_ = [ self.delegate gridView: self
                              backgroundViewForRowAtIndex: row_index_
                                            columnAtIndex: column_index_ ];

      cell_.backgroundView = background_view_;

      return cell_;
   };

   [ self.layoutManager addRowToGridView: self
                       withViewGenerator: header_generator_
                               yPosition: row_index_ * [ self.dataSource heightOfRowInGridView: self ]
                                  height: [ self.dataSource heightOfRowInGridView: self ]
                         fixedColumnView: self.verticalScrollView
                             columnsView: self.horyzontalScrollView ];
}

-(void)addFooterView
{
   [ self.footerView removeFromSuperview ];

   self.footerView = [ self.delegate footerViewInGridView: self ];
   
   CGRect other_rect_ = CGRectZero;
   CGRect footer_rect_ = CGRectZero;

   CGRectDivide( self.bounds
                , &footer_rect_
                , &other_rect_
                , [ self.delegate heightOfFooterInGridView: self ]
                , CGRectMaxYEdge );

   self.footerView.frame = footer_rect_;
   self.footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
   [ self addSubview: self.footerView ];
}

-(void)relayoutGrid
{
   BOOL width_changed_ = self.width != self.bounds.size.width;

   if ( width_changed_ )
   {
      [ self reloadDataOrReuse: YES ];
      return;
   }

   NSRange current_visible_range_ = [ self calculateVisibleRange ];
   if ( NSEqualRanges( current_visible_range_, self.visibleRange ) )
      return;

   NSRange unchaged_range_ = NSIntersectionRange( current_visible_range_, self.visibleRange );

   //enqueue hidden rows
   for ( NSUInteger old_index_ = self.visibleRange.location, last_old_index_ = NSMaxRange( self.visibleRange )
        ; old_index_ < last_old_index_; ++old_index_ )
   {
      BOOL is_hidden_ = !NSLocationInRange( old_index_, unchaged_range_ );

      if ( is_hidden_ )
      {
         [ self.rows enqueueRowWithIndex: old_index_ ];
      }
   }

   //add new rows
   for ( NSUInteger index_ = current_visible_range_.location, last_index_ = NSMaxRange( current_visible_range_ )
        ; index_ < last_index_; ++index_ )
   {
      BOOL is_new_ = !NSLocationInRange( index_, unchaged_range_ );

      if ( is_new_ )
      {
         [ self addRowWithIndex: index_ ];
      }
   }

   self.width = self.bounds.size.width;
   self.visibleRange = current_visible_range_;
}

-(void)addBackgroundViewOrReuse:( BOOL )reuse_
{
   if ( !self.columnsBackgroundView || !reuse_ )
   {
      [ self.columnsBackgroundView removeFromSuperview ];
      self.columnsBackgroundView = [ self.delegate columnsBackgroundViewInGridView: self ];
   }

   CGRect pages_rect_ = CGRectZero;

   [ self divideRect: self.bounds getFixed: 0 getOther: &pages_rect_ ];

   self.columnsBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   self.columnsBackgroundView.frame = pages_rect_;

   [ self addSubview: self.columnsBackgroundView ];
   [ self sendSubviewToBack: self.columnsBackgroundView ];
}

-(void)updateOverlayViewRect
{
   CGFloat top_inset_ = [ self.dataSource heightOfHeaderInGridView: self ];

   CGRect pages_rect_ = CGRectZero;

   [ self divideRect: self.verticalScrollView.bounds getFixed: 0 getOther: &pages_rect_ ];
   pages_rect_.origin.y = self.verticalScrollView.contentOffset.y - top_inset_;
   pages_rect_.size.height += top_inset_;
   self.columnsOverlayView.frame = pages_rect_;
}

-(void)addOverlayViewOrReuse:( BOOL )reuse_
{
   if ( !self.columnsOverlayView || !reuse_ )
   {
      [ self.columnsOverlayView removeFromSuperview ];
      self.columnsOverlayView = [ self.delegate columnsOverlayViewInGridView: self ];
      self.columnsOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      self.columnsOverlayView.userInteractionEnabled = NO;
   }

   [ self updateOverlayViewRect ];

   [ self.verticalScrollView addSubview: self.columnsOverlayView ];
}

-(void)reloadDataOrReuse:( BOOL )reuse_
{
   NSAssert( self.dataSource, @"dataSource should be initialized" );

   //ignores any delegate call inside this reloadDataOrReuse
   self.verticalScrollView.delegate = nil;

   [ self.selectedRowView removeFromSuperview ];
   self.selectedRow = NSNotFound;

   BOOL is_paginal_ = [ self.dataSource isPaginalGridView: self ];
   
   self.horyzontalScrollView.pagingEnabled = is_paginal_;
   
   self.layoutManager = is_paginal_
   ? [ PFGridViewPaginalLayoutManager new ]
   : [ PFGridViewTableLayoutManager new ];
   
   [ self.rows enqueueAllRows ];
   
   CGFloat header_height_ = [ self.dataSource heightOfHeaderInGridView: self ];
   CGFloat footer_height_ = [ self.delegate heightOfFooterInGridView: self ];
   
   self.verticalScrollView.frame = CGRectMake( self.bounds.origin.x
                                              , header_height_
                                              , self.bounds.size.width
                                              , self.bounds.size.height - header_height_ - footer_height_ + 1 );

   [ self addSubview: self.verticalScrollView ];
   [ self addBackgroundViewOrReuse: reuse_ ];
   [ self addHeaderView ];
   [ self addFooterView ];

   NSUInteger rows_count_ = [ self.dataSource numberOfRowsInGridView: self ];
   CGFloat row_height_ = [ self.dataSource heightOfRowInGridView: self ];
   CGFloat content_height_ = row_height_ * rows_count_;
   
   CGRect pages_rect_ = CGRectZero;
   [ self divideRect: self.bounds getFixed: 0 getOther: &pages_rect_ ];
   pages_rect_.size.height = fmax( content_height_, self.verticalScrollView.bounds.size.height );
   
   self.horyzontalScrollView.frame = pages_rect_;

   [ self.verticalScrollView addSubview: self.horyzontalScrollView ];
   [ self addOverlayViewOrReuse: reuse_ ];

   self.verticalScrollView.contentSize = CGSizeMake( self.verticalScrollView.frame.size.width, content_height_ );
   
   CGFloat columns_width_ = [ self.layoutManager widthOfColumnsInGridView: self
                                                              columnsView: self.horyzontalScrollView ];
   self.horyzontalScrollView.contentSize = CGSizeMake( columns_width_, content_height_ );
   
   [ self scrollViewDidScroll: self.horyzontalScrollView ];
   
   self.visibleRange = [ self calculateVisibleRange ];
   
   for ( NSUInteger row_index_ = self.visibleRange.location; row_index_ < NSMaxRange( self.visibleRange ); ++row_index_ )
   {
      [ self addRowWithIndex: row_index_ ];
   }
   
   self.width = self.bounds.size.width;
   self.verticalScrollView.delegate = self;
   
   [ self updateOverlayViewRect ];
}

-(void)updateRows
{
   if ( !self.horyzontalScrollView.isDecelerating && !self.verticalScrollView.isDecelerating )
   {
      [ self.rows updateRows ];
   }
}

-(void)reloadData
{
   [ self reloadDataOrReuse: NO ];
}

-(PFGridCell*)dequeueCellWithIdentifier:( NSString* )identifier_
{
   return [ self.rows dequeueCellWithIdentifier: identifier_ ];
}

-(void)scrollViewDidScroll:( UIScrollView* )scroll_view_
{
   if ( scroll_view_ == self.horyzontalScrollView )
   {
      self.headerScrollView.contentOffset = CGPointMake( scroll_view_.contentOffset.x
                                                        , self.headerScrollView.contentOffset.y );

      NSUInteger active_page_ = self.activePage;

      if ( _activePage != active_page_ )
      {
         _activePage = active_page_;
         [ self.delegate gridView: self didSelectPageAtIndex: _activePage ];
      }
   }
   else if ( scroll_view_ == self.headerScrollView )
   {
      self.horyzontalScrollView.contentOffset = CGPointMake( scroll_view_.contentOffset.x
                                                            , self.headerScrollView.contentOffset.y );
   }
   else if ( scroll_view_ == self.verticalScrollView )
   {
      [ self updateOverlayViewRect ];
      [ self relayoutGrid ];
   }
}

-(void)layoutSubviews
{
   [ self relayoutGrid ];
}

@end
