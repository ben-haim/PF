
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Utils.h"
#import "IndicatorFactory.h"
#import "HLOCDataSource.h"


@protocol ChartSettingsDelegate
@required
- (void)needSaveSettings;
- (void)setCursorMode:(uint)ChartModeValue;
- (void)needMaximizeMinimize;
@end

@class PropertiesStore, ChartSensorView;
@class Axis, SplitterLayer;
@class XYChart, LineLayer, InterLineLayer, BarLayer;
@interface FinanceChart : UIScrollView <UIScrollViewDelegate>
{
    UIViewController<ChartSettingsDelegate>  *parent;
    ChartSensorView         *chartSensor;
    UIView                  *contentView;
    UIInterfaceOrientation  lastOrientation;
    
    NSString*               symbol;
    
    double                  currentZoom;
    
    HLOCDataSource*         chart_data;
    uint                    startIndex;
    uint                    duration;
    bool                    dataChanged;
    UIImage*                imgCachedChart;
    uint                    chartType;
    uint                    cursorMode;
    uint                    drawSubtype;
    
    PropertiesStore*        default_properties;
    PropertiesStore*        properties;
    id<IndicatorFactoryDelegate> indFactory;
    bool                    showAddIndicators;
    
    Axis*                   xAxis;  //x axis is shared for all the XYcharts
    SplitterLayer*          splitter_layer;
    XYChart*                mainChart;
    NSMutableArray*         addIndCharts;
    
    NSMutableArray*         orderLevels;    
}

- (IndicatorFactory*)initIndicatorFactory;
- (void)updateChartSensor:(ChartSensorView*)val;
- (void)setCursorMode:(uint)ChartModeValue;
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
-(void) scrollToBar:(int)bar;
-(void) RecalcScroll;
-(void) receivedRotate:(UIInterfaceOrientation)interfaceOrientation;
-(void) SetData:(HLOCDataSource *)data ForSymbol:(NSString*)_symbol;
-(void) fillDefaultChartSettings:(NSString*)strSettings;
-(void) setChartSettingsWithString:(NSString*)strSettings;
//-(void) setChartSettings:(IndicatorDesc*)desc;
-(void) setStart:(int)_startIndex AndDuration:(int)_displayLength;
-(void) setMainChartType:(int)_chartType;
-(void) clearXAxis;
-(void) tickAdded;
-(void) newBarAdded;
-(void) redraw;
-(void) draw;
-(void) clean;
-(void) rebuild;
-(void) build:(bool)forceRange;
-(void) buildMainIdicators;
-(void) buildAddIdicators;

- (void)sensor_touchesBegan:(NSSet *)touches;
- (void)sensor_touchesMoved:(NSSet *)touches;
- (void)sensor_touchesCancelled:(NSSet *)touches;
- (void)sensor_touchesEnded:(NSSet *)touches;
- (void)hideCursors; 
- (void)resetCursorPointers;
- (void)showCursors:(uint)dataIndex AndXY:(CGPoint)p;
- (void)drawSplitters;
- (void)drawCursors:(CGContextRef)context inRect:(CGRect)rect withDPI:(double)pen_1px;

- (void)clearOrderLevels;
- (void)addOrderLevel:(uint)order_no WithCmd:(uint)cmd AtPrice:(double)price;
- (void)deleteOrderLevel:(uint)order_no;
- (NSMutableArray*)getOrderLevelsBetween:(double)p1 And:(double)p2;
- (void) SaveDrawings:(XYChart*)_chart With:(NSArray*)dr;
- (void) LoadDrawings:(XYChart*)_chart;

@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) ChartSensorView *chartSensor;
@property (assign) UIInterfaceOrientation lastOrientation;
@property (nonatomic, retain) HLOCDataSource *chart_data;
@property (nonatomic, retain) UIImage* imgCachedChart;
@property (nonatomic, retain) PropertiesStore *properties;
@property (nonatomic, retain) PropertiesStore *default_properties;
@property (nonatomic, retain) NSString *symbol;
@property (nonatomic, retain) XYChart *mainChart;
@property (nonatomic, retain) Axis* xAxis;
@property (nonatomic, retain) SplitterLayer* splitter_layer;
@property (nonatomic, retain) NSMutableArray *addIndCharts;
@property (nonatomic, retain) id<IndicatorFactoryDelegate> indFactory;
@property (assign) double currentZoom;

@property (assign) bool showAddIndicators;
@property (assign) uint startIndex;
@property (assign) uint duration;
@property (assign) uint chartType;
@property (assign) bool dataChanged;
@property (assign) uint cursorMode;
@property (assign) uint drawSubtype;
@property (nonatomic, retain) NSMutableArray *orderLevels;
@end
