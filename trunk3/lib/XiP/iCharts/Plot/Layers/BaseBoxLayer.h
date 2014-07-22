
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ArrayMath.h"
//#import "../../DataStores/BaseDataStore.h"
//#import "../XYChart.h"
//#import "../LegendBox.h"

@class XYChart;
@class LegendBox;
@class BaseDataStore;

@interface BaseBoxLayer : NSObject 
{
    BaseDataStore*  DataStore;  
    XYChart*        parentChart;
    NSString*       srcField;
    NSString*       layerName;
    NSString*       legendKey;
    uint            color1;  
    uint            color2;  
    uint            color3;  
    uint            color4;     
    uint            legendColor;
    CGRect          layer_rect;
}
- (id)initWithDataStore:(BaseDataStore*)_DataStore ParentChart:(XYChart*)_parentChart
               SrcField:(NSString*)_srcField LayerName:(NSString*)_layerName;
-(ArrayMath*) GetMainData;
-(void)build;
-(double)getLowerDataValue;
-(double)getUpperDataValue;
-(void)setLegendText:(int)globalIndex;
-(void)setLegendKey:(NSString*)_legendKey 
             color1:(uint)_legendColor 
             color2:(uint)_legendColor2 
             legend:(LegendBox*)_legendBox 
         forceFirst:(bool)insertFirst;
- (void)drawInContext:(CGContextRef)ctx InRect:(CGRect)rect AndDPI:(double)pen_1px;
-(void)setChartCursorValue:(uint)valueIndex;

@property (nonatomic, retain) BaseDataStore* DataStore;
@property (assign) XYChart* parentChart;
@property (nonatomic, retain) NSString* srcField;
@property (nonatomic, retain) NSString* layerName;
@property (nonatomic, retain) NSString* legendKey;
@property (assign) uint color1;  
@property (assign) uint color2;  
@property (assign) uint color3;  
@property (assign) uint color4;     
@property (assign) uint legendColor;
@property (assign) CGRect layer_rect;

@end
