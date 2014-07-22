#import "ETOneLevelTreeView.h"

#import "ETOneLevelTreeViewDataSource.h"
#import "ETOneLevelTreeViewDelegate.h"

#import "ETRootIndexStore.h"
#import "UIViewWithRootItemIndex.h"
#import "ETRootItemDelegate.h"

#import "ETIndexPathFactory.h"

#include <map>

//disable logging workaround
#import "DisableLogsMacro.h"

static const NSInteger ETHeaderCell      = 1;

typedef std::map< NSInteger, BOOL > ExpandedStateMapType;

@interface ETOneLevelTreeView() <UITableViewDataSource, UITableViewDelegate>
{
@private
   ExpandedStateMapType expandedStateMap;
}

@property ( nonatomic, strong ) UITableView* tableView;

@property ( nonatomic, strong ) NSIndexPath* lastSelectedIndexPath;

#pragma mark -
#pragma mark Private helper declarations

-(UITableViewCell *)rootCellAtIndex:( NSInteger )root_index_;
-(UITableViewCell *)childCellAtIndexPath:(NSIndexPath *)indexPath_;

-(void)toggleRootItemAtIndex:( NSInteger )root_index_;
-(void)expandChildrenForRootItem:( NSInteger )root_index_;
-(void)collapseChildrenForRootItem:( NSInteger )root_index_;

-(BOOL)assertTableView:(UITableView*)tableView_;
-(BOOL)assertDelegates;

@end


@interface NSIndexPath ( ETOneLevelTreeViewPrivate )

-(NSIndexPath*)indexPathForTableView;

@end


@implementation NSIndexPath( ETOneLevelTreeViewPrivate )


-(NSIndexPath*)indexPathForTableView
{
   return [ [ self class ] indexPathForRow: self.childTreeIndex + ETHeaderCell
                                 inSection: self.rootTreeIndex ];
}


@end

@implementation ETOneLevelTreeView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize tableView = _tableView;
@synthesize lastSelectedIndexPath;


-(void)dealloc
{
   self->_tableView.delegate   = nil;
   self->_tableView.dataSource = nil;
}

-(void)setupTableView
{
   self.tableView = [ [ UITableView alloc ] initWithFrame: self.bounds ];
   self.tableView.dataSource = self;
   self.tableView.delegate = self;

   self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   self.tableView.backgroundColor = [ UIColor clearColor ];
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

   [ self addSubview: self.tableView ];
}

-(id)initWithFrame:( CGRect )frame_
{
   self = [ super initWithFrame: frame_ ];
   if ( !self )
   {
      return nil;
   }

   [ self setupTableView ];

   return self;
}

-(void)awakeFromNib
{
   [ self setupTableView ];
}


-(void)reloadData
{
   [ self.tableView reloadData ];
}

-(BOOL)isRootAtIndexPath:( NSIndexPath* )index_path_
{
   static const NSInteger ETHeaderCellIndex = 0;

   return ETHeaderCellIndex == index_path_.row;
}

-(NSIndexPath*)indexPathForRootItemWithIndex:( NSInteger )root_index_
{
   return [ NSIndexPath indexPathForRow: 0 inSection: root_index_ ];
}

#pragma mark -
#pragma mark DelegateSetters
-(void)setDelegate:(id<ETOneLevelTreeViewDelegate>)delegate_
{
   self->expandedStateMap.clear();
   self->_delegate = delegate_;
}

-(void)setDataSource:(id<ETOneLevelTreeViewDataSource>)dataSource_
{
   self->expandedStateMap.clear();
   self->_dataSource = dataSource_;
}

#pragma mark - 
#pragma mark ExpandState

-(BOOL)isExpandableRootItemAtIndex:( NSInteger )root_index_
{
   return [ self.dataSource treeView: self
         isExpandableRootItemAtIndex: root_index_ ];
}

-(void)setExpandState:( BOOL )new_state_
         forRootIndex:( NSInteger )root_index_
{
   BOOL is_expandable_ = [ self isExpandableRootItemAtIndex: root_index_ ];
   if ( !is_expandable_ )
   {
      return;
   }
   
   self->expandedStateMap[ root_index_ ] = new_state_;
}

-(BOOL)isExpandedRootItemAtIndex:( NSInteger )root_index_
{
   BOOL is_expandable_ = [ self isExpandableRootItemAtIndex: root_index_ ];

   if ( !is_expandable_ )
   {
      return NO;
   }

   ExpandedStateMapType::const_iterator root_iterator_ = self->expandedStateMap.find( root_index_ );
   if ( root_iterator_ == self->expandedStateMap.end() )
   {
      BOOL initial_expanded_value_ = [ self.dataSource treeView: self
                             isInitiallyExpandedRootItemAtIndex: root_index_ ];

      self->expandedStateMap[ root_index_ ] = initial_expanded_value_;

      return initial_expanded_value_;
   }

   return root_iterator_->second;
}

-(NSInteger)numberOfChildrenForRootItemAtIndex:( NSInteger )root_index_
{
   if ( [ self isExpandedRootItemAtIndex: root_index_ ] )
   {
      return [ self.dataSource treeView: self
       numberOfChildItemsForRootAtIndex: root_index_ ];
   }
   
   return 0;
}

-(BOOL)assertDelegates
{
   if ( nil == self.delegate )
   {
      NSAssert( NO, @"ETOneLevelTreeView : delegate not initialized" );
      return NO;
   }

   if ( nil == self.dataSource )
   {
      NSAssert( NO, @"ETOneLevelTreeView : dataSource not initialized" );
      return NO;
   }

   return YES;
}

-(BOOL)assertTableView:(UITableView*)tableView_
{
   if ( self.tableView != tableView_ )
   {
      NSAssert( NO, @"ETOneLevelTreeView : tableView context mismatch" );
      return NO;
   }
   
   return [ self assertDelegates ];
}


#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView_
{  
   [ self assertTableView: tableView_ ];
 
   NSInteger result_ = [ self.dataSource numberOfRootItemsInTreeView: self ];
   NSLog( @"ETOneLevelTreeView->numberOfSectionsInTableView - [%d]", (int)result_ );

   return result_;
}

-(NSInteger)tableView:(UITableView*)tableView_
 numberOfRowsInSection:(NSInteger)section_
{
   [ self assertTableView: tableView_ ];

   NSInteger result_ = ETHeaderCell + [ self numberOfChildrenForRootItemAtIndex: section_ ];
   NSLog( @"ETOneLevelTreeView->numberOfRowsInSection[%d] - %d", (int)section_, (int)result_ );

   return result_;
}

-(UITableViewCell*)tableView:( UITableView* )table_view_
       cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   NSLog( @"ETOneLevelTreeView->cellForRowAtIndexPath - invoked" );
   
   [ self assertTableView: table_view_ ];

   UITableViewCell* result_ = nil;
   
   if ( [ self isRootAtIndexPath: index_path_ ] )
   {
      result_ = [ self rootCellAtIndex: index_path_.section ];
   }
   else
   {
      result_ = [ self childCellAtIndexPath: index_path_ ];
   }
   
   NSLog( @"ETOneLevelTreeView->cellForRowAtIndexPath[%@] - %@", index_path_, result_ );
   
   return result_;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView*)table_view_
didSelectRowAtIndexPath:(NSIndexPath*)index_path_
{
   [ self assertTableView: table_view_ ];
   
   if ( [ self isRootAtIndexPath: index_path_ ] )
   {
      [ self toggleRootItemAtIndex: index_path_.section ];
      return;
   }

   [ self.delegate treeView: self 
  didSelectChildItemAtIndex: index_path_.row - ETHeaderCell
                forRootItem: index_path_.section ];
}

-(NSInteger)activeRootIndex
{
   NSIndexPath* active_index_path_ = [ self.tableView indexPathForSelectedRow ];
   return active_index_path_ ? active_index_path_.section : NSNotFound;
}

-(void)selectRowAtIndexPath:( NSIndexPath* )index_path_
                   animated:( BOOL )animated_
{
   if ( index_path_.row != 0 || ![ self isExpandableRootItemAtIndex: index_path_.section ] )
   {
      [ self.tableView selectRowAtIndexPath: index_path_ 
                                   animated: animated_ 
                             scrollPosition: UITableViewScrollPositionNone ];
      self.lastSelectedIndexPath = index_path_;
   }
}

-(void)selectItemAtIndexPath:( NSIndexPath* )index_path_
                    animated:( BOOL )animated_
{
   NSIndexPath* table_view_index_path_ = [ index_path_ indexPathForTableView ];

   [ self tableView: self.tableView didSelectRowAtIndexPath: table_view_index_path_ ];

   [ self selectRowAtIndexPath: table_view_index_path_ 
                      animated: animated_  ];
}

-(void)setExpanded:( BOOL )is_expanded_
   rootItemAtIndex:( NSInteger )root_index_
{
   BOOL currently_is_expanded_ = [ self isExpandedRootItemAtIndex: root_index_ ];
   if ( currently_is_expanded_ == is_expanded_ )
      return;

   [ self setExpandState: is_expanded_
            forRootIndex: root_index_ ];

   [ self.tableView beginUpdates ];
   {
      if ( currently_is_expanded_ )
      {        
         [ self collapseChildrenForRootItem: root_index_ ];
         
         [ self.delegate treeView: self
         didToggleRootItemAtIndex: root_index_ ];
      }
      else
      {
         [ self.delegate treeView: self
         didToggleRootItemAtIndex: root_index_ ];
         
         [ self expandChildrenForRootItem: root_index_ ];
      }

      [ self.tableView reloadRowsAtIndexPaths: [ ETIndexPathFactory indexPathItemForSection: root_index_ ] 
                             withRowAnimation: UITableViewRowAnimationNone ];
   }

   [ self.tableView endUpdates ];

   NSInteger default_child_index_ = [ self.delegate treeView: self defaultChildIndexForRootItemAtIndex: root_index_ ];
   if ( ![ self isExpandableRootItemAtIndex: root_index_ ] )
   {
      [ self selectRowAtIndexPath: [ self indexPathForRootItemWithIndex: root_index_ ] animated: NO ];
   }
   else if ( default_child_index_ != NSNotFound )
   {
      if ( is_expanded_ )
      {
         NSIndexPath* selected_index_path_ = [ NSIndexPath indexPathForRow: default_child_index_ + ETHeaderCell inSection: root_index_ ];

         [ self selectRowAtIndexPath: selected_index_path_ animated: NO ];
      }
   }
   else
   {
      [ self selectRowAtIndexPath: self.lastSelectedIndexPath animated: NO ];
   }
}

-(void)toggleRootItemAtIndex:( NSInteger )root_index_
{  
   BOOL is_expanded_ = [ self isExpandedRootItemAtIndex: root_index_ ];

   [ self setExpanded: !is_expanded_
      rootItemAtIndex: root_index_ ];
}

-(UITableViewCell *)rootCellAtIndex:( NSInteger )root_index_
{
   return [ self.dataSource treeView: self
              cellForRootItemAtIndex: root_index_ ];
}

#pragma mark -
#pragma mark Helpers
-(void)expandChildrenForRootItem:( NSInteger )root_index_
{
   NSInteger number_of_items_to_expand_ = [ self.dataSource treeView: self
                                    numberOfChildItemsForRootAtIndex: root_index_ ];

   NSRange insertion_range_ = NSMakeRange( ETHeaderCell, static_cast<NSUInteger>( number_of_items_to_expand_ ) );
   NSArray* insertion_ = [ ETIndexPathFactory indexPathItemsForRange: insertion_range_
                                                             section: root_index_ ];
   
   [ self.tableView insertRowsAtIndexPaths: insertion_
                          withRowAnimation: UITableViewRowAnimationFade ];
}

-(void)collapseChildrenForRootItem:( NSInteger )root_index_
{
   NSInteger number_of_items_to_shrink_ = [ self.dataSource treeView: self
                                    numberOfChildItemsForRootAtIndex: root_index_ ];
   
   NSRange deletion_range_ = NSMakeRange( ETHeaderCell, static_cast<NSUInteger>( number_of_items_to_shrink_ ) );
   NSArray* deletion_ = [ ETIndexPathFactory indexPathItemsForRange: deletion_range_
                                                            section: root_index_ ];
   
   [ self.tableView deleteRowsAtIndexPaths: deletion_
                          withRowAnimation: UITableViewRowAnimationFade ];
}

- (void)tableView:( UITableView* )table_view_
  willDisplayCell:( UITableViewCell* )cell_
forRowAtIndexPath:( NSIndexPath* )index_path_
{
   [ self.delegate treeView: self willDisplayCell: cell_ ];
}

-(CGFloat)tableView:( UITableView* )table_view_
heightForRowAtIndexPath:( NSIndexPath* )index_path_
{
   if ( [ self isRootAtIndexPath: index_path_ ] )
   {
      return [ self.delegate treeView: self
             heightForRootItemAtIndex: index_path_.section ];
   }

   return [ self.delegate treeView: self
         heightForChildItemAtIndex: index_path_.row - ETHeaderCell
                       forRootItem: index_path_.section ];
}

-(NSInteger)tableView:( UITableView* )table_view_
indentationLevelForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return [ self isRootAtIndexPath: index_path_ ] ? 0 : 1;
}

-(NSIndexPath*)tableView:( UITableView* )table_view_ willSelectRowAtIndexPath:( NSIndexPath* )index_path_
{
   if ( [ self isRootAtIndexPath: index_path_ ] && [ self isExpandableRootItemAtIndex: index_path_.section ] )
   {
      [ self toggleRootItemAtIndex: index_path_.section ];
      return nil;
   }
   return index_path_;
}

-(id)dequeueReusableCellWithIdentifier:( NSString* )reuse_identifier_
{
   return [ self.tableView dequeueReusableCellWithIdentifier: reuse_identifier_ ];
}

-(UITableViewCell *)childCellAtIndexPath:(NSIndexPath *)index_path_
{
   return [ self.dataSource treeView: self
             cellForChildItemAtIndex: index_path_.row - ETHeaderCell
                         parentIndex: index_path_.section ];
}

-(void)deselectHighlightedItemAnimated:( BOOL )animated_
{
   [ self.tableView deselectRowAtIndexPath: [ self.tableView indexPathForSelectedRow ]
                                  animated: animated_ ];
}

-(UIEdgeInsets)contentInset
{
   return self.tableView.contentInset;
}

-(void)setContentInset:( UIEdgeInsets )insets_
{
   self.tableView.contentInset = insets_;
   self.tableView.scrollIndicatorInsets = insets_;
}

@end

typedef enum
{
   ETOneLevelTreeViewIndexRoot
   , ETOneLevelTreeViewIndexChild
   , ETOneLevelTreeViewIndexCount
}
ETOneLevelTreeViewIndexType;

@implementation NSIndexPath (ETOneLevelTreeView)

+(id)indexPathWithRootIndex:( NSInteger )root_index_
                 childIndex:( NSInteger )child_index_
{
   NSUInteger indexes_[ ETOneLevelTreeViewIndexCount ];
   indexes_[ ETOneLevelTreeViewIndexRoot ] = ( NSUInteger )root_index_;
   indexes_[ ETOneLevelTreeViewIndexChild ] = ( NSUInteger )child_index_;
   return [ self indexPathWithIndexes: indexes_ length: ETOneLevelTreeViewIndexCount ];
}

-(NSInteger)rootTreeIndex
{
   return ( NSInteger )[ self indexAtPosition: ETOneLevelTreeViewIndexRoot ];
}

-(NSInteger)childTreeIndex
{
   return ( NSInteger )[ self indexAtPosition: ETOneLevelTreeViewIndexChild ];
}

@end
