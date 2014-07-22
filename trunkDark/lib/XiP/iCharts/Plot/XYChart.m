
#import <QuartzCore/QuartzCore.h>
#import "XYChart.h"
#import "../DataStores/BaseDataStore.h"
#import "../DataStores/IndDataSource.h"
#import "PropertiesStore.h"
#import "FinanceChart.h"
#import "PlotArea.h"
#import "LegendBox.h"
#import "Axis.h"
#import "TALayer.h"
#import "Layers/CursorLayer.h"
#import "Layers/BaseBoxLayer.h"
#import "Layers/LineLayer.h"
#import "Layers/DOTLayer.h"
#import "Layers/AreaLayer.h"
#import "Layers/BarLayer.h"
#import "Layers/InterLineLayer.h"
#import "Layers/HLOCLayer.h"
#import "Layers/CandleStickLayer.h"
#import "ArrowsLayer.h"
#import "InterLineOverlappingColorLayer.h"
#import "BarTrendLayer.h"
#import "../ArrayMath.h"

@implementation XYChart
@synthesize DataStore, chart_rect, priceFormatter, parentFChart, cursorLayer, taLayer, layers, plotArea, legendBox, yAxis;
@synthesize digits, startIndex, endIndex, range, percentHeight;

- (id)initWithDataStore:(BaseDataStore*)_DataStore ParentChart:(FinanceChart*)_parentFChart Digits:(uint)_digits 
{
    self = [super init];
    if(self == nil)
        return self;
    DataStore       = _DataStore;
    digits          = _digits;
    parentFChart    = _parentFChart; 
    layers          = [[NSMutableArray alloc] init];
    
    plotArea        = [[PlotArea alloc] initWithChart:self AndContainer:_parentFChart];
    yAxis           = [[Axis alloc] initWithType:CHART_AXIS_VERTICAL parentXYChart:self parentFinanceChart:parentFChart];
    legendBox       = [[LegendBox alloc] initWithParentChart:self];
    cursorLayer     = [[CursorLayer alloc] initWithParentChart:self];
    taLayer         = [[TALayer alloc] initWithParentChart:self];
    
    self.startIndex     = 0;
    self.endIndex       = 0;
    self.range          = 0;
    self.percentHeight  = 0;
    
    priceFormatter = [[NSNumberFormatter alloc] init];
	[priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[priceFormatter setDecimalSeparator:@"."];
	[priceFormatter setGeneratesDecimalNumbers:TRUE];
	[priceFormatter setMinimumIntegerDigits:1];
    [priceFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [self Build];
    return self;
}

-(void)dealloc
{
    //[DataStore release];
    //[parentFChart release];
    [priceFormatter release];
    [layers release];
    NSLog(@"legendBox %lu", (unsigned long)[legendBox retainCount] );
    [legendBox release];
    
    [plotArea release];
    [cursorLayer release];
    [taLayer release];
    [yAxis release];
	[super dealloc];
}
-(void)Build
{
    /*if (mouseSensor != null)
     {
     removeChild(mouseSensor);
     mouseSensor = null;
     }*/
    
    /*this.yAxis = new Xogee.Charts.Axis(0, 0, 40, chartHeight - 40, 1, this);
     this.yAxis.setLabelStyle("Verdana", 10, 0xFF000000);
     
     this.xAxis = new Xogee.Charts.Axis(yAxis.axisWidth, chartHeight - 20, chartWidth - yAxis.axisWidth, 20, 0, this);
     this.xAxis.setLabelStyle("Verdana", 10, 0xFF000000);
     
     
     this.plotArea = new Xogee.Charts.PlotArea(yAxis.paddingTopBottom, 0, chartWidth - yAxis.axisWidth, chartHeight - xAxis.axisHeight, this);
     this.plotArea.bgColor = this.bgColor;
     
     this.cursorLayer = new Xogee.Charts.CursorLayer(   yAxis.paddingTopBottom, 
                                                        0, 
                                                        chartWidth - yAxis.axisWidth, 
                                                        chartHeight - xAxis.axisHeight, 
                                                        this,
                                                        0xFF000000);
     
     cursorLayer.setChartCursorVisibility(false);  
     
     taLayer = new TALayer(this);	 		
     layoutChart();
     return;*/    
}

-(double)getLowerTimeValue
{
    ArrayMath *times = [DataStore GetVector:@"timeStamps"];
   int index_ = startIndex;
   double get_time_ = [times getData][index_];
   
   while (get_time_ == 0 && index_ <= endIndex) {
      index_++;
      get_time_ = [times getData][index_];
   }
   
    return get_time_;
}
-(double)getUpperTimeValue
{		
    ArrayMath *times = [DataStore GetVector:@"timeStamps"];
    return [times getData][startIndex+range-1];		
}
-(double)getTimeValueAt:(uint)index
{			
    //index+=startIndex;
    if(index>[parentFChart.chart_data GetLength]-1 || index-startIndex>range)      
        return NAN;
    ArrayMath *times = [DataStore GetVector:@"timeStamps"];
    return [times getData][index];	
}
-(int)getTimeValueIndex:(double)dt
{	
    ArrayMath *times    = [DataStore GetVector:@"timeStamps"];
    int length          = [times getLength];
    double *times_data  = [times getData];
    int iRes = -1;    
    
    double prev_value = NAN;
    for (int i=length-1; i>0; i--) 
    {       
        double curr_value = times_data[i];
        if(curr_value<= dt && (dt<=prev_value || isnan(prev_value)))
        {
            iRes = i;
            break;
        }
        prev_value = curr_value;
    }
    
    return iRes;
}
-(double)getUpperDataValue
{
    double res = -HUGE_VAL;
    for (BaseBoxLayer* layer in layers) 
    {        
        double locMax = [layer getUpperDataValue];
        if(!isnan(locMax))
            res = MAX(res, locMax);
    }
   return self == self.parentFChart.mainChart ? MAX( res, [ self.parentFChart upperOrderPrice ] ) : res;
}
-(double)getLowerDataValue
{   
    double res = HUGE_VAL;
    for (BaseBoxLayer* layer in layers) 
    {        
        double locMin = [layer getLowerDataValue];

        if(!isnan(locMin))
            res = MIN(res, locMin);
    }
   return self == self.parentFChart.mainChart ? MIN( res, [ self.parentFChart lowerOrderPrice ] ) : res;
}
-(NSString*) formatPrice:(double)value
{
   if ( digits == 0 && value > 1000000000.0 )
   {
      return [ NSString stringWithFormat: @"%.1f G", value / 1000000000 ];
   }
   else if ( digits == 0 && value > 1000000.0 )
   {
      return [ NSString stringWithFormat: @"%.1f M", value / 1000000 ];
   }
   else if ( digits == 0 && value > 1000.0 )
   {
      return [ NSString stringWithFormat: @"%.1f K", value / 1000 ];
   }

    /*  Медленная операция
	[priceFormatter setMinimumFractionDigits:digits];
	[priceFormatter setMaximumFractionDigits:digits];
	NSDecimalNumber *c = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", value]];
	NSString * st = [priceFormatter stringFromNumber:c];
    return st;
     */

    return [ NSString stringWithFormat: [ NSString stringWithFormat: @"%%0.%df", digits ], value ];
}
- (void)SourceDataChanged
{    
    for (BaseBoxLayer *bl in layers) 
    {
        if([bl.DataStore isKindOfClass:[IndDataSource class]])
            [(IndDataSource*)bl.DataStore SourceDataChanged];
    }
}

- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect 
               AndDPI:(double)pen_1px 
       AndDataChanged:(bool)dataChanged
       AndDrawCursors:(bool)drawCursors
        AndCursorMode:(uint)cursorMode
{
   self.chart_rect = rect;
   PropertiesStore* style = self.parentFChart.properties;

   if (dataChanged)
   {
      CGContextSetFillColorWithColor(ctx, [HEXCOLOR([style getColorParam:@"style.chart_general.chart_margin_color"]) CGColor]);
//      CGContextFillRect(ctx, rect);
      
      if( rect.size.height<=20 || rect.size.width<=20)
         return;
      
      
      CGRect rect1_ = CGRectMake(rect.origin.x + rect.size.width - [Utils getYAxisWidth],
                                 rect.origin.y + 3*CHART_PADDING_TOP_BOTTOM,
                                 [Utils getYAxisWidth],
                                 rect.size.height - 5*CHART_PADDING_TOP_BOTTOM);
      
      //[xAxis.draw();
      [yAxis drawInContext:ctx
                    InRect:rect1_
                    AndDPI:pen_1px];
      
      CGRect rect2_ = CGRectMake(rect.origin.x + CHART_PADDING_TOP_BOTTOM,
                                 rect.origin.y + CHART_PADDING_TOP_BOTTOM,
                                 rect.size.width - CHART_PADDING_TOP_BOTTOM - [Utils getYAxisWidth],
                                 rect.size.height - CHART_PADDING_TOP_BOTTOM);
      
      [plotArea drawInContext:ctx
                       InRect:rect2_
                       AndDPI:pen_1px
        DrawPositionAndOrders:NO];
      
      CGRect layerRect = plotArea.plot_rect;
      layerRect.origin.y+=CHART_PADDING_TOP_BOTTOM;
      layerRect.size.height-=2*CHART_PADDING_TOP_BOTTOM;
      
      CGContextSaveGState(ctx);
      CGContextClipToRect(ctx, layerRect);
      
      for (BaseBoxLayer *layer in layers)
      {
//         if(parentFChart.duration<10)
//             break;
         [layer drawInContext:ctx InRect:layerRect AndDPI:pen_1px];
      }
      CGContextRestoreGState(ctx);
      
      [plotArea drawInContext:ctx
                       InRect:rect2_
                       AndDPI:pen_1px
        DrawPositionAndOrders:YES];
   }
   
   if(drawCursors)
   {
      //draw the cursors
      [cursorLayer drawInContext:ctx InRect:plotArea.plot_rect AndDPI:pen_1px drawLoupe:false];
   }

   if (legendBox != nil && drawCursors)
   {
      [legendBox drawInContext:ctx
                        InRect:plotArea.plot_rect
                  mustFillRect:(cursorMode==CHART_MODE_CROSSHAIR && cursorLayer.chartCursorVisible)
                        AndDPI:pen_1px];
   }

   if(cursorMode == CHART_MODE_CROSSHAIR && self == parentFChart.mainChart)
   {
      //draw tech analysis
      [taLayer drawInContext:ctx InRect:plotArea.plot_rect AndDPI:pen_1px AndCursorMode:cursorMode];
   }

   //draw the loupe
   if(drawCursors)
      [cursorLayer drawInContext:ctx InRect:plotArea.plot_rect AndDPI:pen_1px drawLoupe:true];
}

-(void) addLegend
{
    legendBox = [[LegendBox alloc] initWithParentChart:self];
} 
-(LineLayer*) addLineLayer:(BaseDataStore*)srcDS
            ForSourceField:(NSString*)srcField
                  WithName:(NSString*)_layerName
                    Color1:(uint)_color
                 LineWidth:(uint)_linewidth
                 LineDash:(uint)_linedash 
                 LegendKey:(NSString*)_legend_key
              ShowInLegend:(bool)_showLegend 
                forceFirst:(bool)insertFirst
{

    LineLayer * lineLayer = [[LineLayer alloc] initWithDataStore:srcDS 
                                                    ParentChart:self 
                                                    SrcField:srcField 
                                                    LayerName:_layerName];
    lineLayer.color1 = _color;
    lineLayer.color2 = _color;
    lineLayer.linewidth = _linewidth;
    lineLayer.linedash = _linedash;
    
    [layers addObject:lineLayer];
    
    if (legendBox != nil && _showLegend)
    {
        [lineLayer setLegendKey:_legend_key color1:_color color2:_color legend:legendBox forceFirst:insertFirst];
        [lineLayer setLegendText:[DataStore GetLength]-1];
    }
    if (_showLegend)
    {
        [cursorLayer setChartCursorKey:_layerName AndColor:_color];
    }
    return [lineLayer autorelease];
}

-(DOTLayer*) addDotLayer:(BaseDataStore*)srcDS
            ForSourceField:(NSString*)srcField
                  WithName:(NSString*)_layerName
                  Color1:(uint)_color1
                  Color2:(uint)_color2
                 LegendKey:(NSString*)_legend_key
              ShowInLegend:(bool)_showLegend 
                forceFirst:(bool)insertFirst
{

    DOTLayer * dotLayer = [[DOTLayer alloc] initWithDataStore:srcDS 
                                                     ParentChart:self 
                                                        SrcField:srcField 
                                                       LayerName:_layerName];
    dotLayer.color1 = _color1;
    dotLayer.color2 = _color2;
    
    [layers addObject:dotLayer];
    
    if (legendBox != nil)
    {
        [dotLayer setLegendKey:_legend_key color1:_color1 color2:_color2 legend:legendBox forceFirst:insertFirst];
        [dotLayer setLegendText:[DataStore GetLength]-1];
    }
    if (_showLegend)
    {
        [cursorLayer setChartCursorKey:_layerName AndColor:_color1];
    }
    return [dotLayer autorelease];
}

-(AreaLayer*) addAreaLayer:(BaseDataStore*)srcDS
            ForSourceField:(NSString*)srcField
                  WithName:(NSString*)_layerName
                    Color1:(uint)_color
                 LegendKey:(NSString*)_legend_key
              ShowInLegend:(bool)_showLegend 
                forceFirst:(bool)insertFirst
{
    AreaLayer * areaLayer = [[AreaLayer alloc] initWithDataStore:srcDS 
                                                     ParentChart:self 
                                                        SrcField:srcField 
                                                       LayerName:_layerName];
    
    [layers addObject:areaLayer];
    
    if (legendBox != nil)
    {
        [areaLayer setLegendKey:_layerName color1:_color color2:areaLayer.fillcolor & 0xFFFFFF55 legend:legendBox forceFirst:insertFirst];
        [areaLayer setLegendText:[DataStore GetLength]-1];
    }
    if (_showLegend)
    {
        [cursorLayer setChartCursorKey:_layerName AndColor:_color];
    }
    return [areaLayer autorelease];
    
}

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
                           ToLegend:(bool)_add2legend   //default true
{
    InterLineLayer* interLineGraph = nil;
    interLineGraph = [[InterLineLayer alloc] initWithDataStore:srcDS 
                                                   ParentChart:self 
                                                     SrcField1:srcField1 
                                                     SrcField2:srcField2 
                                                     LayerName:_layerName 
                                                     LineColor:_color 
                                                       Color12:_color12 
                                                       Color21:_color21 
                                                     FillAlpha:_alpha
                                                     LineWidth:_linewidth
                                                      LineDash:_linedash];
    
    [layers addObject:interLineGraph];
    if (legendBox != nil && _add2legend)
    {
        [interLineGraph setLegendKey:_legendKey color1:_color12 color2:_color21 legend:legendBox forceFirst:false];
        [interLineGraph setLegendText:[DataStore GetLength]-1];
    }

    if (_add2legend)
    {
        [cursorLayer setChartCursorKey:_layerName AndColor:_color];
    }
    return [interLineGraph autorelease];
}

-(HLOCLayer*)addHLOCLayer:(BaseDataStore*)srcDS
                 AndColor:(uint)_color
{
    HLOCLayer* hlayer = [[HLOCLayer alloc] initWithDataStore:srcDS ParentChart:self];  
    [layers addObject:hlayer];
    if (legendBox != nil)
    {
        [hlayer setLegendKey:@"HLOC" color1:_color color2:_color legend:legendBox forceFirst:true];
        [hlayer setLegendText:[DataStore GetLength]-1];
    }
    [cursorLayer setChartCursorKey:@"HLOC" AndColor:_color];
    
    return [hlayer autorelease];
}

-(HLOCLayer*)addHLOCLayer:(BaseDataStore*)srcDS
                 AndColor:(uint)_color
               AndUpColor:(uint)_colorUp
             AndDownColor:(uint)_colorDown
{
   HLOCLayer* hlayer = [[HLOCLayer alloc] initWithDataStore:srcDS ParentChart:self];
   [layers addObject:hlayer];
   if (legendBox != nil)
   {
      [hlayer setLegendKey:@"HLOC" color1:_colorUp color2:_colorDown legend:legendBox forceFirst:true];
      [hlayer setLegendText:[DataStore GetLength]-1];
   }
   [cursorLayer setChartCursorKey:@"HLOC" AndColor:_color];
   
   return [hlayer autorelease];
}

-(CandleStickLayer*)addCandleStickLayer:(BaseDataStore*)srcDS
{
    CandleStickLayer* candles = [[CandleStickLayer alloc] initWithDataStore:srcDS ParentChart:self];  
    [layers addObject:candles];
    
    if (legendBox != nil)
    {
        
        PropertiesStore* style = self.parentFChart.properties;

        [candles setLegendKey:@"CandleStick" 
                      color1:[style getColorParam:@"style.candles.candle_up"] 
                      color2:[style getColorParam:@"style.candles.candle_down"] 
                      legend:legendBox 
                   forceFirst:true];
        [candles setLegendText:[DataStore GetLength]-1];
    }
    [cursorLayer setChartCursorKey:@"CandleStick" AndColor:0x3463B0FF];

    return [candles autorelease];
}
-(BarLayer*)addBarLayer:(BaseDataStore*)srcDS
         ForSourceField:(NSString*)srcField
               WithName:(NSString*)_layerName
                 Color1:(uint)_color
                 Color2:(uint)_color2 
              LegendKey:(NSString*)_legend_key
           ShowInLegend:(bool)_showLegend
{
    
    
    BarLayer * barLayer = [[BarLayer alloc] initWithDataStore:srcDS 
                                                     ParentChart:self 
                                                        SrcField:srcField 
                                                       LayerName:_layerName];
    barLayer.color1 = _color;
    barLayer.color2 = _color2;    
    [layers addObject:barLayer];
    
    if (legendBox != nil)
    {
        [barLayer setLegendKey:_layerName color1:_color color2:_color2 legend:legendBox forceFirst:false];
        [barLayer setLegendText:[DataStore GetLength]-1];
    }
    if (_showLegend)
    {
        [cursorLayer setChartCursorKey:_layerName AndColor:_color];
    }
    return [barLayer autorelease];
}

-(ArrowsLayer*)addArrowsLayer:(BaseDataStore*)srcDS
         ForUpArrowsField:(NSString*)upData
         ForDownArrowsField:(NSString*)downData
               WithName:(NSString*)_layerName
                 UpArrowsColor:(uint)upArrowColor
                 DownArrowsColor:(uint)downArrowColor 
              LegendKey:(NSString*)_legend_key
           ShowInLegend:(bool)_showLegend
{
    
    
    ArrowsLayer * arrowsLayer = [[ArrowsLayer alloc] initWithDataStore:srcDS 
                                                           ParentChart:self 
                                                                UpData:upData 
                                                              DownData:downData 
                                                             LayerName:_layerName 
                                                         UpArrowsColor:upArrowColor 
                                                       DownArrowsColor:downArrowColor];
    [layers addObject:arrowsLayer];
    
    if (legendBox != nil && _showLegend)
    {
        [arrowsLayer setLegendKey:_layerName color1:upArrowColor color2:downArrowColor legend:legendBox forceFirst:false];
        [arrowsLayer setLegendText:[DataStore GetLength]-1];
    }
    if (_showLegend)
    {
        [cursorLayer setChartCursorKey:_layerName AndColor:upArrowColor];
    }
    return [arrowsLayer autorelease];
}

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
                                           ToLegend:(bool)_add2legend   //default true
{
    InterLineOverlappingColorLayer* interLineGraph = [[InterLineOverlappingColorLayer alloc] initWithDataStore:srcDS 
                                                                                                   ParentChart:self 
                                                                                                     SpanAData:spanAData 
                                                                                                     SpanBData:spanBData 
                                                                                                     LayerName:_layerName
                                                                                                    SpanAColor:spanAColor 
                                                                                                    SpanBColor:spanBColor
                                                                                                     FillAlpha:_alpha 
                                                                                                     LineWidth:_linewidth
                                                                                                      LineDash:_linedash];
    
    [layers addObject:interLineGraph];
    if (legendBox != nil && _add2legend)
    {
        [interLineGraph setLegendKey:_legendKey color1:spanAColor color2:spanBColor legend:legendBox forceFirst:false];
        [interLineGraph setLegendText:[DataStore GetLength]-1];
    }
    
    if (_add2legend)
    {
        [cursorLayer setChartCursorKey:_layerName AndColor:spanAColor];
    }
    return [interLineGraph autorelease];
}

-(BarTrendLayer*)addBarTrendLayer:(BaseDataStore*)srcDS
         ForSourceField:(NSString*)srcField
               WithName:(NSString*)_layerName
                 UpColor:(uint)_color
                 DownColor:(uint)_color2 
              LegendKey:(NSString*)_legend_key
           ShowInLegend:(bool)_showLegend
{
    BarTrendLayer * barLayer = [[BarTrendLayer alloc] initWithDataStore:srcDS 
                                                  ParentChart:self 
                                                     SrcField:srcField 
                                                    LayerName:_layerName];
    barLayer.color1 = _color;
    barLayer.color2 = _color2;    
    [layers addObject:barLayer];
    
    if (legendBox != nil && _showLegend)
    {
        [barLayer setLegendKey:_layerName color1:_color color2:_color2 legend:legendBox forceFirst:false];
        [barLayer setLegendText:[DataStore GetLength]-1];
    }
    if (_showLegend)
    {
        [cursorLayer setChartCursorKey:_layerName AndColor:_color];
    }
    return [barLayer autorelease];
}

-(void)setChartCursorValue:(int)dataIndex
{
    for (BaseBoxLayer* layer in layers) 
    {        
        [layer setChartCursorValue:dataIndex];
    }
    [cursorLayer setChartCursorVisible:(dataIndex!=-1)];
}

-(void)setLegendText:(int)globalIndex
{
    for (BaseBoxLayer* layer in layers) 
    {
        [layer setLegendText:globalIndex];
    }
}

-(void)autoScale
{
    [self.yAxis autoScale];
}

-(void)setDispDataRange:(uint)_startIndex AndRange:(uint)_range
{
    self.startIndex = _startIndex;
    self.range = _range;
    self.endIndex = (_startIndex + _range - 1);
    
    if (layers != nil && [layers count] > 0)
    {
        int dataLength = [DataStore GetLength];
        self.endIndex = (endIndex >= dataLength) ? (dataLength - 1) : endIndex;
        self.range = self.endIndex - self.startIndex + 1;
    }
    
    if (layers != nil)
    {
        
        for (BaseBoxLayer* layer in layers) 
        {
            [layer build];
        }
    }
    //xAxis.clear();
    [yAxis clear];
    if ([yAxis isAutoScale])
    {
        [yAxis setAutoScale];
    }
}
     
-(void)setStartIndex_:(uint)_index
{
    [self setDispDataRange:_index AndRange:range];
}




@end
