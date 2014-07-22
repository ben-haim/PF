#import <UIKit/UIKit.h>

@protocol ETOneLevelTreeViewDataSource;
@protocol ETOneLevelTreeViewDelegate;

@interface ETOneLevelTreeView : UIView

@property ( nonatomic, /*weak*/assign ) IBOutlet id<ETOneLevelTreeViewDataSource> dataSource;
@property ( nonatomic, /*weak*/assign ) IBOutlet id<ETOneLevelTreeViewDelegate> delegate;
@property ( nonatomic, assign, readonly ) NSInteger activeRootIndex;
@property ( nonatomic, assign ) UIEdgeInsets contentInset;

-(void)reloadData;

-(id)dequeueReusableCellWithIdentifier:( NSString* )reuse_identifier_;

-(void)selectItemAtIndexPath:( NSIndexPath* )index_path_
                    animated:( BOOL )animated_;

-(void)deselectHighlightedItemAnimated:( BOOL )animated_;

-(BOOL)isExpandedRootItemAtIndex:( NSInteger )root_index_;

@end

@interface NSIndexPath (ETOneLevelTreeView)

@property ( nonatomic, assign, readonly ) NSInteger rootTreeIndex;
@property ( nonatomic, assign, readonly ) NSInteger childTreeIndex;

+(id)indexPathWithRootIndex:( NSInteger )root_index_
                 childIndex:( NSInteger )child_index_;

@end
