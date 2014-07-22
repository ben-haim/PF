
#import <Foundation/Foundation.h>
#import "GridCell.h"


@interface Grid : UIScrollView<GridCache> 
{	
	UIViewController *parent;	
	id<UITableViewDelegate> tableDelegate;
	UIView			*contentView;
	UIImage*		backImage;	
    CGPoint			theHitPoint;
	UIColor			*GridColor;
	NSMutableArray  *cells;
	NSMutableDictionary *cells_cache;
}

-(void)RecalcScroll:(BOOL)moveScroll;
-(void)DrawBackground:(CGRect)rect AndOffset:(int)deltaY;
-(void)DrawCells:(CGRect)rect AndOffset:(int)deltaY;
-(void)ClearCells;
-(void)AddCell:(GridCell *)cell;

- (UIImage *)getFromCache:(NSString*)cell_id;
- (void)putToCache:(NSString*)cell_id AndCell:(UIImage*)cell;

- (NSString *)getStringFromCache:(NSString*)cell_id;
- (void)putStringToCache:(NSString*)cell_id AndCell:(NSString*)cell;

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) UIImage*		backImage;
@property (nonatomic, retain) id<UITableViewDelegate> tableDelegate;
@end
