#import <Foundation/Foundation.h>

@class PFGridCell;

@interface PFGridRows : NSObject

-(void)addCell:( PFGridCell* )cell_
toRowWithIndex:( NSUInteger )row_index_;

-(void)enqueueRowWithIndex:( NSUInteger )row_index_;
-(void)enqueueAllRows;

-(void)updateRows;

-(PFGridCell*)dequeueCellWithIdentifier:( NSString* )identifier_;

@end
