#import "PFGridRows.h"

#import "PFGridCell.h"

#import "PFViewQueue.h"

@interface PFGridRows ()

@property ( nonatomic, strong ) PFViewQueue* viewsQueue;
@property ( nonatomic, strong ) NSMutableDictionary* viewsByRow;

@end

@implementation PFGridRows

@synthesize viewsQueue = _viewsQueue;
@synthesize viewsByRow = _viewsByRow;

-(PFViewQueue*)viewsQueue
{
   if ( !_viewsQueue )
   {
      _viewsQueue = [ PFViewQueue new ];
   }
   return _viewsQueue;
}

-(NSMutableDictionary*)viewsByRow
{
   if ( !_viewsByRow )
   {
      _viewsByRow = [ NSMutableDictionary new ];
   }
   return _viewsByRow;
}

-(void)addCell:( PFGridCell* )cell_
toRowWithIndex:( NSUInteger )row_index_
{
   if ( !cell_ )
      return;

   NSMutableArray* row_ = [ self.viewsByRow objectForKey: @(row_index_) ];
   if ( !row_ )
   {
      row_ = [ NSMutableArray arrayWithObject: cell_ ];
      [ self.viewsByRow setObject: row_ forKey: @(row_index_) ];
   }
   else
   {
      [ row_ addObject: cell_ ];
   }
}

-(void)enqueueRow:( NSArray* )row_
{
   for ( PFGridCell* cell_ in row_ )
   {
      [ cell_ prepareForEnqueue ];
      [ cell_ removeFromSuperview ];
      NSString* identifier_ = [ cell_ reuseIdentifier ];
      if ( identifier_ )
      {
         [ self.viewsQueue enqueueView: cell_ withIdentifier: identifier_ ];
      }
   }
}

-(void)updateRow:( NSArray* )row_
{
   for ( PFGridCell* cell_ in row_ )
   {
      [ cell_ update ];
   }
}

-(void)enqueueRowWithIndex:( NSUInteger )row_index_
{
   NSArray* row_ = [ self.viewsByRow objectForKey: @(row_index_) ];
   [ self enqueueRow: row_ ];
   [ self.viewsByRow removeObjectForKey: @(row_index_) ];
}

-(void)enqueueAllRows
{
   for ( id row_number_ in self.viewsByRow )
   {
      [ self enqueueRow: [ self.viewsByRow objectForKey: row_number_ ] ];
   }
   self.viewsByRow = nil;
}

-(void)updateRows
{
   for ( id row_number_ in self.viewsByRow )
   {
      [ self updateRow: [ self.viewsByRow objectForKey: row_number_ ] ];
   }
}

-(PFGridCell*)dequeueCellWithIdentifier:( NSString* )identifier_
{
   PFGridCell* cell_ = ( PFGridCell* )[ self.viewsQueue dequeueViewWithIdentifier: identifier_ ];
   [ cell_ prepareForDequeue ];
   return cell_;
}

@end
