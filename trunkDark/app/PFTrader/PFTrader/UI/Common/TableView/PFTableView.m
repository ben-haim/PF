#import "PFTableView.h"

#import "PFTableViewItem.h"
#import "PFTableViewCategory.h"

#import "UIImage+PFTableView.h"

@interface NSArray (NSIndexPath_NSRange)

+(id)arrayWithIndexPathesForSection:( NSUInteger )section_
                           rowRange:( NSRange )range_;

@end

@implementation NSArray (NSIndexPath_NSRange)

+(id)arrayWithIndexPathesForSection:( NSUInteger )section_
                           rowRange:( NSRange )range_
{
   NSMutableArray* indexes_ = [ NSMutableArray arrayWithCapacity: range_.length ];
   for ( NSUInteger row_index_ = range_.location
        ; row_index_ < NSMaxRange( range_ )
        ; ++row_index_ )
   {
      [ indexes_ addObject: [ NSIndexPath indexPathForRow: row_index_ inSection: section_ ] ];
   }
   return indexes_;
}

@end

@interface PFTableView ()< UITableViewDataSource, UITableViewDelegate >

@property ( nonatomic, strong ) UITableView* tableView;

@end

@implementation PFTableView

@synthesize categories;
@synthesize tableView = _tableView;
@synthesize skipCellsBackground;

-(void)dealloc
{
   _tableView.delegate = nil;
   _tableView.dataSource = nil;
}

-(UIView*)tableHeaderView
{
   return _tableView.tableHeaderView;
}

-(void)setTableHeaderView:( UIView* )view_
{
   self.tableView.tableHeaderView = view_;
}

-(UIView*)tableFooterView
{
   return _tableView.tableFooterView;
}

-(void)setTableFooterView:( UIView* )view_
{
   self.tableView.tableFooterView = view_;
}

-(UIEdgeInsets)contentInset
{
   return _tableView.contentInset;
}

-(void)setContentInset:( UIEdgeInsets )inset_
{
   self.tableView.contentInset = inset_;
   self.tableView.scrollIndicatorInsets = inset_;
}

-(UIColor*)backgroundColor
{
   return self.tableView.backgroundColor;
}

-(void)setBackgroundColor:( UIColor* )background_color_
{
   self.tableView.backgroundColor = background_color_;
}

-(CGSize)contentSize
{
   return self.tableView.contentSize;
}

-(UITableView*)tableView
{
   if ( !_tableView )
   {
      _tableView = [ [ UITableView alloc ] initWithFrame: self.bounds style: UITableViewStyleGrouped ];
      _tableView.backgroundView = nil;
      _tableView.backgroundColor = [ UIColor clearColor ];
      _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      _tableView.delegate = self;
      _tableView.dataSource = self;
      _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      [ _tableView setContentInset: UIEdgeInsetsMake( 5.f, 0.f, 5.f , 0.f ) ];
      
      [ self addSubview: _tableView ];
   }

   return _tableView;
}

-(void)reloadData
{
   [ self.tableView reloadData ];
}

-(void)reloadCategory:( PFTableViewCategory* )category_
     withRowAnimation:( UITableViewRowAnimation )animation_
{
   NSUInteger category_index_ = [ self.categories indexOfObject: category_ ];
   if ( category_index_ != NSNotFound )
   {
      [ self.tableView reloadSections: [ NSIndexSet indexSetWithIndex: category_index_ ]
                     withRowAnimation: animation_ ];
   }
}

-(void)reloadCategory:( PFTableViewCategory* )category_
          reloadRange:( NSRange )reload_range_
          insertRange:( NSRange )insert_range_
          deleteRange:( NSRange )delete_range_
     withRowAnimation:( UITableViewRowAnimation )animation_
{
   NSUInteger category_index_ = [ self.categories indexOfObject: category_ ];
   if ( category_index_ != NSNotFound )
   {
      [ self.tableView beginUpdates ];

      [ self.tableView reloadRowsAtIndexPaths: [ NSArray arrayWithIndexPathesForSection: category_index_
                                                                               rowRange: reload_range_ ]
                             withRowAnimation: animation_ ];

      [ self.tableView deleteRowsAtIndexPaths: [ NSArray arrayWithIndexPathesForSection: category_index_
                                                                               rowRange: delete_range_ ]
                             withRowAnimation: animation_ ];

      [ self.tableView insertRowsAtIndexPaths: [ NSArray arrayWithIndexPathesForSection: category_index_
                                                                               rowRange: insert_range_ ]
                             withRowAnimation: animation_ ];

      [ self.tableView endUpdates ];
   }
}

-(PFTableViewCategory*)categoryInSection:( NSInteger )section_
{
   return (self.categories)[( NSUInteger )section_];
}

-(PFTableViewItem*)itemAtIndexPath:( NSIndexPath* )index_path_
{
   return ([ self categoryInSection: index_path_.section ].items)[( NSUInteger )index_path_.row];
}

-(UIView*)sectionViewWithView:( UIView* )view_
{
   /*static CGFloat horyzontal_inset_ = 30.f;
   
   UIView* section_view_ = [ [ UIView alloc ] initWithFrame: self.bounds ];
   view_.frame = CGRectInset( section_view_.bounds, horyzontal_inset_, 0.f );
   view_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [ section_view_ addSubview: view_ ];
   return section_view_;*/
   return view_;
}

-(CGFloat)tableView:( UITableView* )table_view_ heightForHeaderInSection:( NSInteger )section_
{
   PFTableViewCategory* category_ = [ self categoryInSection: section_ ];
   return [ category_ headerHeightForTableView: table_view_ ];
}

-(UIView*)tableView:( UITableView* )table_view_ viewForHeaderInSection:( NSInteger )section_
{
   PFTableViewCategory* category_ = [ self categoryInSection: section_ ];
   return [ self sectionViewWithView: [ category_ headerViewForTableView: table_view_ ] ];
}

-(CGFloat)tableView:( UITableView* )table_view_ heightForFooterInSection:( NSInteger )section_
{
   PFTableViewCategory* category_ = [ self categoryInSection: section_ ];
   return [ category_ footerHeightForTableView: table_view_ ];
}

-(UIView*)tableView:( UITableView* )table_view_ viewForFooterInSection:( NSInteger )section_
{
   PFTableViewCategory* category_ = [ self categoryInSection: section_ ];
   return [ self sectionViewWithView: [ category_ footerViewForTableView: table_view_ ] ];
}

-(NSInteger)numberOfSectionsInTableView:( UITableView* )table_view_
{
   return ( NSInteger )[ self.categories count ];
}

-(NSInteger)tableView:( UITableView* )table_view_
numberOfRowsInSection:( NSInteger )section_
{
   return ( NSInteger )[ [ self categoryInSection: section_ ].items count ];
}

-(UITableViewCell*)tableView:( UITableView* )table_view_
       cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   PFTableViewCategory* category_ = [ self categoryInSection: index_path_.section ];
   PFTableViewItem* item_ = (category_.items)[( NSUInteger )index_path_.row];
   
   UITableViewCell* cell_ = [ item_ cellForTableView: self.tableView ];
   
   if ( category_.plain )
   {
      cell_.backgroundView = [ UIView new ];
      return cell_;
   }

   if ( !self.skipCellsBackground )
   {
      UIImage* background_image_ = [ UIImage groupedCellBackgroundImageForRow: ( NSUInteger )index_path_.row
                                                                    rowsCount: [ category_.items count ] ];
      
      cell_.backgroundView = [ [ UIImageView alloc ] initWithImage: background_image_ ];
   }
   
   return cell_;
}

-(void)tableView:( UITableView* )table_view_
didSelectRowAtIndexPath:( NSIndexPath* )index_path_
{
   PFTableViewItem* item_ = [ self itemAtIndexPath: index_path_ ];
   [ item_ performAction ];
}

-(void)scrollToSelectedRowAnimated:( BOOL )animated_
{
   [ self.tableView scrollToRowAtIndexPath: self.tableView.indexPathForSelectedRow
                          atScrollPosition: UITableViewScrollPositionTop
                                  animated: animated_ ];
}

-(CGFloat)tableView:( UITableView* )table_view_ heightForRowAtIndexPath:( NSIndexPath* )index_path_
{
   PFTableViewItem* item_ = [ self itemAtIndexPath: index_path_ ];
   return [ item_ cellHeightForTableView: table_view_ ];
}

@end
