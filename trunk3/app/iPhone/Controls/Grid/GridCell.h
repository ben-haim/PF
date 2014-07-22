
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@protocol GridCache<NSObject>

@optional

- (UIImage *)getFromCache:(NSString*)cell_id;
- (void)putToCache:(NSString*)cell_id AndCell:(UIImage*)cell;

@end


@interface GridCell : NSObject 
{
	
	id<GridCache> dataCacheDelegate;
	BOOL isGroupRow;
	BOOL isSelected;
	float Height;
	BOOL firstInGroup;
	BOOL lastInGroup;
	int group_index;
	int symbol_index;
	NSString *text;
	BOOL isBalanceRow;
}
@property (assign) BOOL isGroupRow;
@property (assign) BOOL isSelected;
@property (assign) BOOL firstInGroup;
@property (assign) BOOL lastInGroup;
@property (assign) int group_index;
@property (assign) int symbol_index;
@property (assign) float Height;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) UIColor *SelectedColor;
@property (nonatomic, assign) id<GridCache> dataCacheDelegate;
-(void)Draw:(CGRect)rect;
-(void)DrawInRect:(NSString *)str context:(CGContextRef)context drawInRect:(CGRect)rect
	lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment
			 name:(const char *)name size:(CGFloat)size;
@end
