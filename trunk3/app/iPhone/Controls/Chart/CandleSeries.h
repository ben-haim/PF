
#import <Foundation/Foundation.h>
#import "Series.h"
#import "BarItem.h"
#import "../../Code/ParamsStorage.h"


@interface CandleSeries : Series 
{
	NSMutableArray *candles;
	UIColor			*UpColor;
	UIColor			*DownColor;
	UIColor			*BorderUpColor;
	UIColor			*BorderDownColor;
	UIColor			*AxisColor;
	UIColor			*GridColor;
	UIColor			*StrokeColor;
	int				GridCellSize;
	ParamsStorage *storage;
	SymbolInfo *sym;

}
@property (nonatomic, retain) UIColor *GridColor;
@property (nonatomic, retain) UIColor *AxisColor;
@property (nonatomic, retain) UIColor *StrokeColor;
//@property (nonatomic, retain) IBOutlet UISegmentedControl *buttons;
@property (nonatomic, retain) NSMutableArray *candles;
@property (nonatomic, assign) ParamsStorage *storage;
@property (nonatomic, retain) SymbolInfo *sym;

-(void)SetData:(NSString*)data;
-(int)GetCount;
-(void)DrawGridAndPrices:(CGContextRef)context OnRect:(CGRect)rect AndMin:(double)min_price AndMax:(double)max_price;
-(void)DrawGridAndTime:(CGContextRef)context OnRect:(CGRect)rect AndMin:(NSDate*)min_time AndMax:(NSDate*)max_time;
-(void)Draw:(CGContextRef)context OnRect:(CGRect)rect DrawGrid:(BOOL)drawGrid AndOffset:(double)deltaX AndCount:(double)items;
@end
