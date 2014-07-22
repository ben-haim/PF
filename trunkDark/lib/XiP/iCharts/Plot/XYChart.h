

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class BaseDataStore;
@class FinanceChart;
@class LegendBox;
@class PlotArea;
@class CursorLayer;
@class TALayer;
@class LineLayer, DOTLayer, InterLineLayer, AreaLayer, HLOCLayer, CandleStickLayer, BarLayer, ArrowsLayer, InterLineOverlappingColorLayer, BarTrendLayer;
@class Axis;

@interface XYChart : NSObject 
{
    BaseDataStore*      __unsafe_unretained DataStore;
	CGRect              chart_rect;
    NSNumberFormatter*  priceFormatter;
    uint                digits;  
    FinanceChart*       __unsafe_unretained parentFChart;
    NSMutableArray*     layers;
    PlotArea*           plotArea;
    Axis*               yAxis;
    LegendBox*          legendBox;
    CursorLayer*        cursorLayer;
    TALayer*            taLayer;
    int                 startIndex;
    int                 endIndex;
    int                 range;
    double              percentHeight;
}
- (id)initWithDataStore:(BaseDataStore*)_DataStore ParentChart:(FinanceChart*)_parentFChart Digits:(uint)_digits;
-(void)Build;
- (void)SourceDataChanged;
-(void)drawInContext:(CGContextRef)ctx 
              InRect:(CGRect)rect 
              AndDPI:(double)pen_1px 
      AndDataChanged:(bool)dataChanged
      AndDrawCursors:(bool)drawCursors
      AndCursorMode:(uint)cursorMode;
-(double)getLowerTimeValue;
-(double)getUpperTimeValue;
-(double)getTimeValueAt:(uint)index;
-(int)getTimeValueIndex:(double)dt;
-(double)getUpperDataValue;
-(double)getLowerDataValue;
-(NSString*)formatPrice:(double)value;
-(void)addLegend;
-(void)setChartCursorValue:(int)dataIndex;
-(void)setLegendText:(int)globalIndex;
-(void)autoScale;
-(void)setDispDataRange:(uint)_startIndex AndRange:(uint)_range;
-(void)setStartIndex_:(uint)_index;

-(LineLayer*) addLineLayer:(BaseDataStore*)srcDS
            ForSourceField:(NSString*)srcField
                  WithName:(NSString*)_layerName
                    Color1:(uint)_color
                 LineWidth:(uint)_linewidth
                  LineDash:(uint)_linedash 
                 LegendKey:(NSString*)_legend_key
              ShowInLegend:(bool)_showLegend 
                forceFirst:(bool)insertFirst;
-(DOTLayer*) addDotLayer:(BaseDataStore*)srcDS
          ForSourceField:(NSString*)srcField
                WithName:(NSString*)_layerName
                  Color1:(uint)_color1
                  Color2:(uint)_color2
               LegendKey:(NSString*)_legend_key
            ShowInLegend:(bool)_showLegend 
              forceFirst:(bool)insertFirst;
-(AreaLayer*) addAreaLayer:(BaseDataStore*)srcDS
            ForSourceField:(NSString*)srcField
                  WithName:(NSString*)_layerName
                    Color1:(uint)_color
                 LegendKey:(NSString*)_legend_key
              ShowInLegend:(bool)_showLegend 
                forceFirst:(bool)insertFirst;
-(InterLineLayer*)addInterLineLayer:(BaseDataStore*)srcDS
                    ForSourceField1:(NSString*)srcField1
                    ForSourceField2:(NSString*)srcField2
                           WithName:(NSString*)_layerName
                                  c:(uint)_color
                          FillAlpha:(uint)_alpha
                                c12:(uint)_color12
                                c21:(uint)_color21
                          lineWidth:(uint)_linewidth
                           lineDash:(uint)_linedash
                         legend_key:(NSString*)_legendKey
                           ToLegend:(bool)_add2legend;
-(HLOCLayer*)addHLOCLayer:(BaseDataStore*)srcDS
                 AndColor:(uint)_color;
-(HLOCLayer*)addHLOCLayer:(BaseDataStore*)srcDS
                 AndColor:(uint)_color
               AndUpColor:(uint)_colorUp
             AndDownColor:(uint)_colorDown;
-(CandleStickLayer*)addCandleStickLayer:(BaseDataStore*)srcDS;
-(BarLayer*)addBarLayer:(BaseDataStore*)srcDS
         ForSourceField:(NSString*)srcField
               WithName:(NSString*)_layerName
                 Color1:(uint)_color
                 Color2:(uint)_color2 
              LegendKey:(NSString*)_legend_key
           ShowInLegend:(bool)_showLegend;

-(ArrowsLayer*)addArrowsLayer:(BaseDataStore*)srcDS
             ForUpArrowsField:(NSString*)upData
           ForDownArrowsField:(NSString*)downData
                     WithName:(NSString*)_layerName
                UpArrowsColor:(uint)upArrowColor
              DownArrowsColor:(uint)downArrowColor 
                    LegendKey:(NSString*)_legend_key
                 ShowInLegend:(bool)_showLegend;

-(InterLineOverlappingColorLayer*)addInterLineLayer:(BaseDataStore*)srcDS
                                      ForSpanAField:(NSString*)spanAData
                                      ForSpanBField:(NSString*)spanBData
                                           WithName:(NSString*)_layerName                                            
                                          FillAlpha:(uint)_alpha
                                         SpanAColor:(uint)spanAColor
                                         SpanBColor:(uint)spanBColor
                                          lineWidth:(uint)_linewidth
                                           lineDash:(uint)_linedash
                                         legend_key:(NSString*)_legendKey
                                           ToLegend:(bool)_add2legend;

-(BarTrendLayer*)addBarTrendLayer:(BaseDataStore*)srcDS
                   ForSourceField:(NSString*)srcField
                         WithName:(NSString*)_layerName
                          UpColor:(uint)_color
                        DownColor:(uint)_color2 
                        LegendKey:(NSString*)_legend_key
                     ShowInLegend:(bool)_showLegend;

@property (unsafe_unretained) BaseDataStore* DataStore;
@property (unsafe_unretained) FinanceChart* parentFChart;
@property (assign) CGRect chart_rect;
@property (nonatomic, strong) NSNumberFormatter* priceFormatter;
@property (nonatomic, strong) NSMutableArray* layers;
@property (nonatomic, strong) LegendBox* legendBox;
@property (nonatomic, strong) PlotArea* plotArea;
@property (nonatomic, strong) CursorLayer* cursorLayer;
@property (nonatomic, strong) TALayer* taLayer;
@property (nonatomic, strong) Axis* yAxis;
@property (assign) uint digits;
@property (assign) int startIndex;
@property (assign) int endIndex;
@property (assign) int range;
@property (assign) double percentHeight;

@end
