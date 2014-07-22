
#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"
#import "CandleSeries.h"

@interface Chart :  UIScrollView
{
	UIViewController *parent;
	
	ParamsStorage *storage;
	SymbolInfo *sym;
	BOOL isMaximized;
	UIView			*contentView;
	NSMutableArray	*all_series;
	CGContextRef	buffer;
	UIColor			*BackColor;
	int				ItemsVisible;
	int				GridCellPixels;
	UIColor			*GridColor;
	UIColor			*AxisColor;
	UIColor			*StrokeColor;
	int				XAxisOffset;
	int				YAxisOffset;
	float			lastScale;
	float			lastWidth;
	BOOL			requestSent;
	CGFloat			initialDistance;
}
- (void)SetData:(NSString *)RawData;
- (CGContextRef) createOffscreenContext: (CGSize) size;
-(void)DrawBackground:(CGRect)rect AndOffset:(double)deltaX;
-(void)DrawSeries:(CGRect)rect AndOffset:(double)deltaX AndCount:(double)items;
-(void)AddSeries:(CandleSeries *)series;
-(void)RecalcScroll;
-(void)GetChart:(SymbolInfo*)symbol AndRange:(NSString*)RangeType;
- (void)chartReceived:(NSMutableArray *)vals;
//- (void)chartReceived:(NSNotification *)notification;
-(int) getSeriesCount;

@property (nonatomic, retain) UIViewController *parent;
@property (nonatomic, assign) CGFloat initialDistance;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIColor *BackColor;
@property (assign) int ItemsVisible;
@property (assign) int GridCellPixels;
@property (assign) float lastScale;
@property (assign) float lastWidth;
@property (assign) BOOL isMaximized;
@property (nonatomic, retain) UIColor *GridColor;
@property (nonatomic, retain) UIColor *AxisColor;
@property (nonatomic, retain) UIColor *StrokeColor;
@property (nonatomic, assign) ParamsStorage *storage;
@property (assign) SymbolInfo *sym;

@property (retain) NSMutableArray	*all_series;

@end

