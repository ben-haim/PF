

#import <QuartzCore/QuartzCore.h>
#import "FinanceChart.h"
#import "PropertiesStore.h"
#import "Indicators.h"

#import "SplitterLayer.h"
#import "XYChart.h"
#import "PlotArea.h"
#import "TALayer.h"
#import "Axis.h"
#import "Layers/CursorLayer.h"
#import "Layers/LineLayer.h"
#import "Layers/AreaLayer.h"
#import "Stopwatch.h"
#import "ChartSensorView.h"
#import "TAOrderLevel.h"

@interface FinanceChart ()

@property ( nonatomic, assign ) CGSize chartSize;

@end

@implementation FinanceChart

@synthesize contentView, parent, chartSensor, lastOrientation, imgCachedChart;
@synthesize chart_data, startIndex, duration, chartType, dataChanged, symbol;
@synthesize currentZoom;
@synthesize default_properties, properties;
@synthesize xAxis, splitter_layer, showAddIndicators;
@synthesize mainChart, indFactory, addIndCharts, orderLevels;
@synthesize drawSubtype;
@synthesize chartSize;

@synthesize tapBlock;

- (id)initWithCoder:(NSCoder*)coder 
{
    self  = [super initWithCoder:coder];
    if(self == nil)
        return self;
    self.delegate = self;
    self.startIndex = 0;
    self.duration = 1;
    self.chartType = CHART_TYPE_CANDLES;
    self.parent = nil;
    self.chartSensor = nil;
    self.scrollEnabled = YES;
    self.minimumZoomScale = 1;
    self.maximumZoomScale = 1;
    self.bounces = NO;
    self.drawSubtype = CHART_DRAW_LINE;
    self.showAddIndicators = true;
    self.lastOrientation = UIInterfaceOrientationPortrait;
    self.chartSize = CGSizeZero;
    
    self.currentZoom = 20; 
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
    [self addSubview:contentView];
    
    Axis* xx = [[Axis alloc] initWithType:CHART_AXIS_HORIZONTAL 
                            parentXYChart:nil 
                       parentFinanceChart:self];
    [self setXAxis:xx];
    splitter_layer = [[SplitterLayer alloc] initWithParentChart:self];
    
    //setup handling for pinch zooming as we don't use standard zoom
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:pinchGesture]; 
    
    chart_data          = nil;
    imgCachedChart      = nil;

    addIndCharts   = [[NSMutableArray alloc] init];
    orderLevels    = [[NSMutableArray alloc] init];
    
//    Class c = [self IndicatorFactoryClass];    
    indFactory = [[IndicatorFactory alloc] init];
    
    
    //fill the default properties
    default_properties = [[PropertiesStore alloc] init];
    return self;    
}



- (void)updateChartSensor:(ChartSensorView*)val;
{
    self.chartSensor = val;
    [chartSensor setHidden:true];
    [chartSensor setChart:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{    
    if ([touches count] == 1 && [[touches anyObject] tapCount] == 2)
    {	
        [parent needMaximizeMinimize];
        return;
    }
    //+++denis Splitter, Resize & Landscape support
    else if( ![ mainChart.taLayer resizeModeFromTouches: touches ] && showAddIndicators )
    {
       if ( ![ splitter_layer splitterModeFromTouches: touches ] && self.tapBlock )
       {
          self.tapBlock();
       }
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)sensor_touchesBegan:(NSSet *)touches
{
    if ([touches count] == 1 && [[touches anyObject] tapCount] == 2)
	{	
        [parent needMaximizeMinimize];
		return;
	}
    int cnt = (int)MIN([touches count], 2);
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:cnt];
    
    for(int i=0; i<cnt; i++)
    {
        UITouch *touch = [touches allObjects][i];
        CGPoint p = [touch locationInView:self];
        [points addObject:[NSValue valueWithCGPoint:p]];
    }    
   
    if(	cursorMode==CHART_MODE_DRAW ||
       cursorMode==CHART_MODE_RESIZE ||
       cursorMode==CHART_MODE_DELETE)//handle drawing things
    {
        //taLayer.mouseMoveHandler(event);
        //blit();
        [mainChart.taLayer touchesBegan:touches];
    } 
    else
    if( cursorMode == CHART_MODE_SPLITTER && showAddIndicators)
    {
        [splitter_layer touchesBegan:touches];
    }
   
   BOOL need_cursors_ = cursorMode == CHART_MODE_CROSSHAIR || cursorMode == CHART_MODE_DRAW || cursorMode == CHART_MODE_RESIZE;
   if (need_cursors_ )
   {
      CGPoint cursorPoint = [(NSValue*)points[0] CGPointValue];
      
      [self hideCursors];
      int dataIndex = [self.xAxis getXDataIndex:cursorPoint.x] - self.startIndex;
      dataIndex = MAX(dataIndex, 0);
      dataIndex = MIN(dataIndex, self.duration-1);
      
      [self resetCursorPointers];
      [self showCursors:dataIndex AndXY:cursorPoint];
   }
   
    [self setNeedsDisplay];
}
- (void)sensor_touchesMoved:(NSSet *)touches
{
    int cnt = (int)MIN([touches count], 2);
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:cnt];
    
    for(int i=0; i<cnt; i++)
    {
        UITouch *touch = [touches allObjects][i];
        CGPoint p = [touch locationInView:self];
        //p.x-=self.contentOffset.x;
        [points addObject:[NSValue valueWithCGPoint:p]];
    }    
   
    if(	cursorMode==CHART_MODE_DRAW ||
       cursorMode==CHART_MODE_RESIZE ||
       cursorMode==CHART_MODE_DELETE)//handle drawing things
    {
        [mainChart.taLayer touchesMoved:touches];
        //blit();
    } 
    else
    if( cursorMode == CHART_MODE_SPLITTER && showAddIndicators)
    {
        [splitter_layer touchesMoved:touches];
    }
   
   BOOL need_cursors_ = cursorMode == CHART_MODE_CROSSHAIR || cursorMode == CHART_MODE_DRAW || cursorMode == CHART_MODE_RESIZE;
   if (need_cursors_ )
   {
      CGPoint cursorPoint = [(NSValue*)points[0] CGPointValue];
      
      [self hideCursors];
      int dataIndex = [self.xAxis getXDataIndex:cursorPoint.x] - self.startIndex;
      
      dataIndex = MAX(dataIndex, 0);
      dataIndex = MIN(dataIndex, self.duration-1);
      
      
      [self resetCursorPointers];
      [self showCursors:dataIndex AndXY:cursorPoint];
   }
   
    [self setNeedsDisplay];
}
- (void)sensor_touchesEnded:(NSSet *)touches
{
    int cnt = (int)MIN([touches count], 2);
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:cnt];
    
    for(int i=0; i<cnt; i++)
    {
        UITouch *touch = [touches allObjects][i];
        CGPoint p = [touch locationInView:self];
        [points addObject:[NSValue valueWithCGPoint:p]];
    }    
   
    if(	cursorMode==CHART_MODE_DRAW ||
       cursorMode==CHART_MODE_RESIZE ||
       cursorMode==CHART_MODE_DELETE)//handle drawing things
    {
        [mainChart.taLayer touchesEnded:touches];
        //blit();
    } 
    else
    if( cursorMode == CHART_MODE_SPLITTER && showAddIndicators)
    {
        [splitter_layer touchesEnded:touches];
    }

   if (self.mainChart.cursorLayer.chartCursorVisible)
   {
      [self hideCursors];
   }
   
    [self setNeedsDisplay];    
}
- (void)sensor_touchesCancelled:(NSSet *)touches
{
    
}
-(void)resetCursorPointers
{
    [self.mainChart.cursorLayer setChartCursorVisible:false];
    [self.mainChart.cursorLayer setCursorY:NAN];
    
    for(XYChart* addIndChart in self.addIndCharts)
    {
        [addIndChart.cursorLayer setChartCursorVisible:false];
        [addIndChart.cursorLayer setCursorY:NAN];
    }      
}
- (void)hideCursors
{
    [self.mainChart.cursorLayer setChartCursorVisible:false];
    [mainChart.cursorLayer hideLoupe];	
    [mainChart setLegendText:self.startIndex + self.duration - 1];//[chart_data GetLength]-1];
    
    
    for(XYChart* addIndChart in self.addIndCharts)
    {
        [addIndChart.cursorLayer setChartCursorVisible:false];
        [addIndChart.cursorLayer hideLoupe];
        [addIndChart setLegendText:self.startIndex + self.duration - 1];//[chart_data GetLength]-1];
    }      
}
- (void)showCursors:(uint)dataIndex AndXY:(CGPoint)p
{
    static int dataIndexLast;
    static CGPoint pLast;
    if(dataIndex==32000)
    {
        dataIndex = dataIndexLast;
        p = pLast;
    }
    dataIndexLast = dataIndex;
    pLast = p;
    
    [mainChart.cursorLayer setChartCursorVisible:true];  
    [mainChart setChartCursorValue:dataIndex];
    [mainChart setLegendText:self.startIndex + dataIndex];
    [mainChart.cursorLayer hideLoupe];
   bool _showLoupe = [properties getBoolParam:@"style.chart_general.show_loupe"];
    if(CGRectContainsPoint(mainChart.chart_rect, p))
    {
        mainChart.cursorLayer.cursorY = p.y;
        mainChart.cursorLayer.cursorX = p.x;
        if(_showLoupe)
            [mainChart.cursorLayer showLoupe];
    }
    else        
        [mainChart.cursorLayer hideLoupe];
    
    if(showAddIndicators)
    {
        for(XYChart* addIndChart in self.addIndCharts)
        {
            [addIndChart.cursorLayer setChartCursorVisible:true]; 
            [addIndChart setChartCursorValue:dataIndex];
            [addIndChart setLegendText:self.startIndex + dataIndex];
            if(CGRectContainsPoint(addIndChart.chart_rect, p))
            {
                addIndChart.cursorLayer.cursorY = p.y;
                addIndChart.cursorLayer.cursorX = p.x;
                if(_showLoupe)
                    [addIndChart.cursorLayer showLoupe];
            }
            else
                [addIndChart.cursorLayer hideLoupe];
        }  
    }
    //dataChanged = false;
    [self draw];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	contentView.transform = CGAffineTransformMakeScale(1, 1);
	return contentView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    
}
// This method is called by NSNotificationCenter when the device is rotated.
-(void) receivedRotate:(UIInterfaceOrientation)interfaceOrientation 
{
    [self RecalcScroll];
    [self.mainChart.cursorLayer hideLoupe];
	[self setNeedsLayout];
	[self redraw]; 
}

-(void)layoutSubviews
{
   [ super layoutSubviews ];
   
   if ( !CGSizeEqualToSize( self.chartSize, self.bounds.size ) )
   {
      [ self redraw ];
      [ self RecalcScroll ];
   }
}

- (IBAction)handlePinchGesture:(UIGestureRecognizer *)sender 
{
    static double bckpZoom = 20;
    double newScale = currentZoom;
    UIPinchGestureRecognizer *gestureRecognizer = (UIPinchGestureRecognizer *)sender;
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) 
    {
        bckpZoom = currentZoom;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) 
    {        
        newScale = bckpZoom/[gestureRecognizer scale];  
        
        //Limit scale
        newScale = MAX([Utils getMinZoom], newScale);
        newScale = MIN([Utils getMaxZoom], newScale);    
    }
    currentZoom = roundf(newScale);
	[self RecalcScroll];    
    [properties setParamValue:@"zoom" inPath:@"view" WithValue:[NSString stringWithFormat:@"%f", currentZoom]];
    [parent needSaveSettings];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   double x_offset = MAX(self.contentOffset.x, 0.0);
   double data_len = [chart_data GetLength];
   double x_width = MAX(self.contentSize.width, 1);
   double i_bar = roundf(data_len*MAX(x_offset/x_width, 0.0));

   [self setStart:i_bar AndDuration:currentZoom];
//      [self setNeedsDisplay];  // Избыточная перерисовка чарта
}
-(void) scrollToBar:(int)bar
{
    bar = MAX(bar, 0);
    if(bar>=startIndex+duration)
        bar = startIndex + duration - 1;
   
    double data_len = [chart_data GetLength];
   double bar_offset = data_len == 0.0 ? 0.0 : roundf((double)bar/data_len*self.contentSize.width);
    //NSLog(@"bar_offset: %f", bar_offset);
    [self setContentOffset:CGPointMake(bar_offset, 0) animated:NO];
}

-(void)RecalcScroll
{
    double oldLastBar = startIndex + duration;
    dataChanged = true;
    double bars_count = MAX(1, [chart_data GetLength]);    
    double new_width = roundf(bars_count/ currentZoom * self.frame.size.width);
    [self setContentSize:CGSizeMake(new_width, 1)];
    
    [self scrollToBar:roundf(oldLastBar - currentZoom)];
}

-(void) SetData:(HLOCDataSource *)data ForSymbol:(NSString*)_symbol
{ 
    dataChanged = true;
    [self setSymbol:_symbol]; 
    [self clean];
//    if(chart_data!=nil)
//        [chart_data release];
    //[data retain];
    self.chart_data = data;
    [self build:false];    
    [self RecalcScroll];
}

-(void) fillDefaultChartSettings:(NSString*)strSettings
{
    
    default_properties = [[PropertiesStore alloc] initWithString:strSettings];
}
-(void)setChartSettingsWithString:(NSString*)strSettings
{
   [ self setChartSettingsWithPropertiesStore: [[PropertiesStore alloc] initWithString:strSettings] ];
}

-(void) setChartSettingsWithPropertiesStore:(PropertiesStore*)properties_
{

   properties = properties_;
   currentZoom = [[properties getParam:@"view.zoom"] doubleValue];
   chartType = [[properties getParam:@"view.chartType"] intValue];
   duration = currentZoom;
}

-(void)clearXAxis
{
    [self.xAxis clear];   
}

-(void)setStart:(int)_startIndex AndDuration:(int)_displayLength
{
   static uint oldStartIndex=0, oldDisplayLength=0;

   //TimeLabelPositions = new Array;
   int dataLength = [chart_data GetLength];

//   ArrayMath* openData = [mainChart.DataStore GetVector:@"openData"];
//   for(int i=_startIndex; i<dataLength; i++)
//   {
//      if ( isnan([openData getData][i]) )
//         _startIndex++;
//   }

   if(_startIndex+_displayLength>=dataLength)
      startIndex = (((int)dataLength - (int)_displayLength)>=0)?dataLength - _displayLength:0;
   else
      startIndex = _startIndex;

   self.duration = MIN(dataLength, _displayLength);

   if (mainChart != nil)
   {
      [mainChart setDispDataRange:startIndex AndRange:_displayLength];
   }

   if (addIndCharts != nil)
   {
      for (XYChart* indChart in addIndCharts)
      {
         [indChart setDispDataRange:startIndex AndRange:_displayLength];
      }

   }
   
   if ((startIndex != oldStartIndex) || (oldDisplayLength != self.duration))
   {
      [self hideCursors];
      [self redraw];
//      NSLog(@"startIndex = %d self.duration = %d", startIndex, self.duration);
   }

   oldStartIndex = startIndex;
   oldDisplayLength = self.duration;
}
-(void) setMainChartType:(int)_chartType
{
    if(self.chartType==_chartType)
        return;
    
    chartType = _chartType;
    [properties setParamValue:@"chartType" inPath:@"view" WithValue:[NSString stringWithFormat:@"%d", chartType]];
    
    [self rebuild];
    [self draw];
}

-(void)clean
{
    mainChart = nil;
    [addIndCharts removeAllObjects];
    [properties ClearCache];
}
-(void)rebuild
{
    [self build:true];
}

-(void)build:(bool)forceRange
{
    [self clean];
    mainChart = [[XYChart alloc] initWithDataStore:chart_data ParentChart:self Digits:chart_data.symbol_digits];
    
    //first add indicators
    [self buildMainIdicators];
    
    //and only afterwards add main chart layer
    switch (chartType) 
    {
        case CHART_TYPE_BARS:
        {
           //[mainChart addHLOCLayer:chart_data AndColor:[properties getColorParam:@"style.bars.chart_bars_color"]];
           //!!!denis (Vitaliy request)
           [mainChart addHLOCLayer:chart_data
                          AndColor:[properties getColorParam:@"style.bars.chart_bars_color"]
                        AndUpColor:[properties getColorParam:@"style.bars.chart_bars_color_up"]
                      AndDownColor:[properties getColorParam:@"style.bars.chart_bars_color_down"]];
            break;
        }
        case CHART_TYPE_CANDLES:
        {
            [mainChart addCandleStickLayer:chart_data];
            break;
        }
        case CHART_TYPE_LINE:
        {
            NSString* applyToField = [properties getApplyToParam:@"style.main_line.chart_main_line_apply"];
            NSString* applyToFieldTitle = [NSString stringWithFormat:@"%@(%@)", 
                                           symbol,
                                           [chart_data getIntervalName]];
            LineLayer* ll =  [mainChart addLineLayer:chart_data
                                      ForSourceField:applyToField
                                            WithName:applyToFieldTitle
                                              Color1:[properties getColorParam:@"style.main_line.color"]
                                           LineWidth:[properties getUIntParam:@"style.main_line.width"] 
                                            LineDash:[properties getUIntParam:@"style.main_line.dash"] 
                                           LegendKey:applyToFieldTitle
                                        ShowInLegend:true
                                          forceFirst:true];
            ll.subtype = 1;
            break;
        }
        case CHART_TYPE_AREA:
        {
            NSString* applyToField = [properties getApplyToParam:@"style.area.area_apply"];
            NSString* applyToFieldTitle = [NSString stringWithFormat:@"%@(%@)", 
                                           symbol,
                                           [chart_data getIntervalName]];
            [mainChart addAreaLayer:chart_data
                     ForSourceField:applyToField
                           WithName:applyToFieldTitle
                             Color1:[properties getColorParam:@"style.area.area_stroke_color"]
                          LegendKey:@"Close"
                       ShowInLegend:true
                         forceFirst:true];
            break;
        }
        default:
        {
           //[mainChart addHLOCLayer:chart_data AndColor:[properties getColorParam:@"style.bars.chart_bars_color"]];
           
           //!!!denis (Vitaliy request)
           [mainChart addHLOCLayer:chart_data
                          AndColor:[properties getColorParam:@"style.bars.chart_bars_color"]
                        AndUpColor:[properties getColorParam:@"style.bars.chart_bars_color_up"]
                      AndDownColor:[properties getColorParam:@"style.bars.chart_bars_color_down"]];
            break;
        }
    }
    //fix  main chart range
    if (forceRange)
    {
        //[mainChart setDispDataRange:startIndex AndRange:duration];
        //[self setStart:startIndex AndDuration:duration];
    }
    else 
    {
        //[mainChart setDispDataRange:[chart_data GetLength]-duration AndRange:duration];
        startIndex = [chart_data GetLength]-duration;        
        //[self setStart:startIndex AndDuration:duration];

    }    
    [mainChart.yAxis autoScale];
    
    [self buildAddIdicators];
    
    //fix add charts ranges
    /*if (addIndCharts != nil)
     {
     for (XYChart* indChart in addIndCharts) 
     {            
     [indChart setDispDataRange:mainChart.startIndex AndRange:duration];
     }        
     }*/
    [self LoadDrawings:mainChart];
    [self setStart:startIndex AndDuration:duration];
    dataChanged = true;
    [self draw];
}
-(void) tickAdded
{			
    if (addIndCharts != nil)
    {        
        for (XYChart* addChart in addIndCharts) 
        {            
            [addChart SourceDataChanged]; 
            [addChart autoScale];
            
            if(addChart.cursorLayer.chartCursorVisible)
                [self showCursors:32000 AndXY:CGPointZero];
            else        
                [addChart setLegendText:self.startIndex + self.duration - 1]; 
        }
    }
    if (mainChart != nil)  
    {
        [mainChart SourceDataChanged]; 
        [mainChart autoScale];    
    }    
    if(mainChart.cursorLayer.chartCursorVisible)
        [self showCursors:32000 AndXY:CGPointZero];
    else        
        [mainChart setLegendText:self.startIndex + self.duration - 1];
    [self redraw];
}

-(void) newBarAdded
{	
    if (addIndCharts != nil)
    {        
        for (XYChart* addChart in addIndCharts) 
        {            
            [addChart SourceDataChanged]; 
            //[addChart autoScale]; 
        }
    }
    if (mainChart != nil)  
    {
        [mainChart SourceDataChanged]; 
        //[mainChart autoScale];    
    }
    
	BOOL isLastVisible = NO;
	if(self.contentOffset.x + self.bounds.size.width >= (1-1.0/(double)[chart_data GetLength])*self.contentSize.width)
		isLastVisible = YES;
	[self RecalcScroll];    
    
	if(isLastVisible)
	{
		CGPoint newOffset = CGPointMake(self.contentSize.width - self.bounds.size.width+50, 0);
		[self setContentOffset: newOffset animated: NO];
	}
    if(mainChart.cursorLayer.chartCursorVisible)
        [self showCursors:32000 AndXY:CGPointZero];
//    [self redraw];
    [self tickAdded];
}    

-(void) redraw
{    
    dataChanged = true;
    [self setNeedsDisplay];
}

-(void) draw
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect 
{
   static long t_all=0;
   t_all=clock();

   self.chartSize = self.bounds.size;

   CGFloat XScale = 1.0;
   if ([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
   {
      CGFloat tmp = [[UIScreen mainScreen]scale];
      if (tmp > 1.5)
         XScale = 2.0;
   }

   if (XScale > 1.5)
      UIGraphicsBeginImageContextWithOptions(rect.size, NO, XScale);
   else
      UIGraphicsBeginImageContext(rect.size);
   
   double pen_1px = 1/XScale; //a dirty hack to have perfect 1px lines on retina

   CGContextRef context = UIGraphicsGetCurrentContext();

   CGContextSetShouldAntialias(context, false);
   CGContextSetInterpolationQuality(context, kCGInterpolationNone);

	rect.origin.y = 0;
	double deltaX = (rect.origin.x);
   
   
   CGRect r = CGRectMake((rect.origin.x),
                         (rect.origin.y),
                         (rect.size.width),
                         ((rect.size.height - CHART_XAXIS_HEIGHT) * (showAddIndicators?mainChart.percentHeight:1.0)));
   
	CGContextTranslateCTM( context, -deltaX, 0);
   //CGContextSetFillColorWithColor(context, [HEXCOLOR([properties getColorParam:@"style.chart_general.chart_margin_color"]) CGColor]);
   
   
   if(dataChanged)
      ;//CGContextFillRect(context, rect);
   else
   {
      CGContextSaveGState(context);
      CGContextTranslateCTM(context,
                            0.0,
                            rect.size.height);
      CGContextScaleCTM(context, 1.0, -1.0);
      CGContextDrawImage(context, rect, self.imgCachedChart.CGImage);
      CGContextRestoreGState(context);
   }
   
   [xAxis drawInContext:context
                 InRect:CGRectMake((r.origin.x + CHART_PADDING_TOP_BOTTOM),
                                   (rect.origin.y) + rect.size.height - CHART_XAXIS_HEIGHT,
                                   rect.size.width - CHART_PADDING_TOP_BOTTOM - [Utils getYAxisWidth],
                                   CHART_XAXIS_HEIGHT)
                 AndDPI:pen_1px];
   
   //draw data from the layers in each chart
   [mainChart drawInContext:context InRect:r AndDPI:pen_1px AndDataChanged:dataChanged AndDrawCursors:false AndCursorMode:cursorMode];
   r.origin.y = r.origin.y + r.size.height+pen_1px;
   
   if(showAddIndicators)
   {
      int c = 0;
      for (XYChart* addChart in addIndCharts)
      {
         r.size.height = truncf((rect.size.height - CHART_XAXIS_HEIGHT) * addChart.percentHeight);
         if(c==[addIndCharts count]-1)//the last chart
         {
            //round up the height
            r.size.height = xAxis.axis_rect.origin.y - r.origin.y;
         }
         
         [addChart drawInContext:context InRect:r AndDPI:pen_1px AndDataChanged:dataChanged AndDrawCursors:false AndCursorMode:cursorMode];
         r.origin.y = r.origin.y + r.size.height+pen_1px;;
         c++;
      }
   }

   bool origDataChanged = dataChanged;
   if( cursorMode == CHART_MODE_SPLITTER  && !dataChanged && showAddIndicators)
      [self.splitter_layer drawInContext:context InRect:rect AndDPI:pen_1px];
   
   UIImage *img;
   if(dataChanged)
   {
      img = UIGraphicsGetImageFromCurrentImageContext();
      if(imgCachedChart)
      {
         imgCachedChart = nil;
      }
      imgCachedChart = img;
      dataChanged = false;
   }
   
   if(cursorMode != CHART_MODE_CROSSHAIR)
   {
      //draw tech analysis
      [mainChart.taLayer drawInContext:context InRect:mainChart.plotArea.plot_rect AndDPI:pen_1px AndCursorMode:cursorMode];
   }
//   else
      [self drawCursors:context inRect:rect withDPI:pen_1px];
   
   img = UIGraphicsGetImageFromCurrentImageContext();
   
   if( cursorMode == CHART_MODE_SPLITTER  && origDataChanged && showAddIndicators)
   {
      [self.splitter_layer drawInContext:context InRect:rect AndDPI:pen_1px];
      img = UIGraphicsGetImageFromCurrentImageContext();
   }
   
	UIGraphicsEndImageContext();
   //draw_chart_layer.contents = (id) img.CGImage;
   
	context = UIGraphicsGetCurrentContext();
	//[img drawAtPoint:rect.origin];
   
   CGContextTranslateCTM(context,
                         0.0,
                         rect.size.height);
   CGContextScaleCTM(context, 1.0, -1.0);

   CGContextDrawImage(context, rect, img.CGImage);

   t_all = clock() - t_all;

//   double ft_all=((double)t_all) / CLOCKS_PER_SEC;
//   NSLog(@"fps = %f", 1.0/ft_all);
}


-(void) buildMainIdicators
{
    NSArray* indMain = [properties getArray:@"indicators.user_main"];
    for (NSString* indName in indMain)
    {
        NSString* indCode = [properties getParam:[NSString stringWithFormat:@"indicators.%@.code", indName]];
        NSString *path = [NSString stringWithFormat:@"indicators.%@", indName];
        //NSLog(@"main indicator indCode=%@, path=%@", indCode, path);
        [self.indFactory addMainIndicator:indCode WithProperties:path ForChart:self];
    }
    [mainChart setPercentHeight:1.0]; //supposely we have only the main chart
}
-(void) buildAddIdicators
{
    NSArray* indAdd = [properties getArray:@"indicators.user_add"];
    NSMutableArray* mutable_indAdd_ = [ [ NSMutableArray alloc ] initWithArray: indAdd ];

    //+++denis (Vitaliy wishes)
    if ([ [ properties getParam: @"view.chartVolumes" ] intValue ] == 1 )
    {
        [ mutable_indAdd_ addObject: @"vol" ];
        indAdd = mutable_indAdd_;
    }

    NSArray* panelHeights = [properties getArray:@"view.panel_heights"]; 
    
    int c = 0;
    double summHeight = 0;
    NSMutableArray *newHeights = [[NSMutableArray alloc] init];
    
    for (NSString* indName in indAdd) 
    {
        NSString* indCode = [properties getParam:[NSString stringWithFormat:@"indicators.%@.code", indName]];
        
        
        XYChart* indChart = [[XYChart alloc] initWithDataStore:chart_data ParentChart:self Digits:2];
        double percentHeight = 1.0/(2.0 + [indAdd count]);
        if([panelHeights count]==[indAdd count])
        {
            percentHeight = [panelHeights[c] doubleValue];
        }
        [newHeights addObject:@(percentHeight)];
        
        summHeight+=percentHeight;
        
        [indChart setPercentHeight:percentHeight];
        [addIndCharts addObject:indChart];
        
        NSString *path = [NSString stringWithFormat:@"indicators.%@", indName];
        [indFactory addAuxIndicator:indCode WithProperties:path ToChart:indChart];
        c++;
    }
    [properties setArray:@"panel_heights" inPath:@"view" WithArray:newHeights];
    if([indAdd count]>0)
    {        
        [mainChart setPercentHeight:1-summHeight];
        //2.0/(2.0 + [indAdd count])  //double as height as any of the add indicators
    }  
    //NSLog(@"data %@", properties.settings);   
}
- (void)setCursorMode:(uint)ChartModeValue
{
    if(cursorMode == ChartModeValue)
        return;
    cursorMode = ChartModeValue;    
    [chartSensor setHidden:(cursorMode==CHART_MODE_NONE)];
    if(cursorMode==CHART_MODE_RESIZE) //hack to let the chart switch out from drawing mode
    {        
        [parent setCursorMode:ChartModeValue];
    }
   
    //+++denis
    [[NSNotificationCenter defaultCenter] postNotificationName: @"handleChartMode" object: nil ];
   
    [self setNeedsDisplay];
}
-(uint)cursorMode
{
    return cursorMode;
}

- (void)drawSplitters
{
    
}
- (void)drawCursors:(CGContextRef)context inRect:(CGRect)rect withDPI:(double)pen_1px
{
    CGRect r = CGRectMake((rect.origin.x), 
                          (rect.origin.y), 
                          (rect.size.width), 
                          ((rect.size.height - CHART_XAXIS_HEIGHT) * (showAddIndicators?mainChart.percentHeight:1.0)));
    //Вообще не понятно зачем выводить это два раза
//    [xAxis drawInContext:context 
//                  InRect:CGRectMake((r.origin.x + CHART_PADDING_TOP_BOTTOM), 
//                                    (rect.origin.y) + rect.size.height - CHART_XAXIS_HEIGHT, 
//                                    rect.size.width - CHART_PADDING_TOP_BOTTOM - [Utils getYAxisWidth], 
//                                    CHART_XAXIS_HEIGHT) 
//                  AndDPI:pen_1px];

    //draw data from the layers in each chart 
    [mainChart drawInContext:context 
                      InRect:r AndDPI:pen_1px 
              AndDataChanged:dataChanged 
              AndDrawCursors:true
               AndCursorMode:cursorMode];
    r.origin.y = r.origin.y + r.size.height+pen_1px;
    
    if(showAddIndicators)
    {
        int c = 0;
        for (XYChart* addChart in addIndCharts) 
        {
            r.size.height = truncf((rect.size.height - CHART_XAXIS_HEIGHT) * addChart.percentHeight);
            if(c==[addIndCharts count]-1)//the last chart
            {
                //round up the height
                r.size.height = xAxis.axis_rect.origin.y - r.origin.y;
            }
            
            [addChart drawInContext:context 
                             InRect:r 
                             AndDPI:pen_1px 
                     AndDataChanged:dataChanged 
                     AndDrawCursors:true 
                      AndCursorMode:cursorMode];
            r.origin.y = r.origin.y + r.size.height;
            c++;
        }
    }    
}

- (void)clearOrderLevels
{
    [orderLevels removeAllObjects];
    [self redraw];
}
- (void)addOrderLevel:(uint)order_no WithCmd:(uint)cmd AtPrice:(double)price isOrder:(BOOL)is_order
{
    TAOrderLevel *ol =[[TAOrderLevel alloc] init];
    ol.order_no = order_no;
    ol.cmd = cmd;
    ol.price = price;
    ol.isOrder = is_order;
    
    [self deleteOrderLevel:order_no isOrder:is_order];
    [orderLevels addObject:ol];
}
- (void)deleteOrderLevel:(uint)order_no isOrder:(BOOL)is_order
{
    for (TAOrderLevel *ol in orderLevels) 
    {
        if(ol.order_no == order_no && ol.isOrder == is_order)
        {
            [orderLevels removeObject:ol];
            break;
        }
    }
    [self redraw];
}
- (NSMutableArray*)getOrderLevelsBetween:(double)p1 And:(double)p2
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    for (TAOrderLevel *ol in orderLevels) 
    {
        if(ol.price>=p1 && ol.price<=p2)
        {
            [res addObject:ol];            
        }
    }
    return res;
}

- (void) SaveDrawings:(XYChart*)_chart With:(NSArray*)dr
{
    if(_chart!=mainChart)
        return;
    [properties setArray:self.symbol inPath:@"drawings" WithArray:dr];
    //NSLog(@"properties %@", self.properties.settings);
    
    id<ChartSettingsDelegate> iparent = parent;
    [iparent needSaveSettings];
    
    //NSLog(@"properties %@", self.properties.settings);
}

- (void) LoadDrawings:(XYChart*)_chart
{
    //NSLog(@"properties %@", self.properties.settings); 
    NSArray *dr = [self.properties getArray:[NSString stringWithFormat:@"%@.%@", @"drawings", self.symbol]];
    
    //NSLog(@"properties %@", self.properties.settings); 
    //NSLog(@"dr %@", dr);
    if(dr==nil || [dr count]==0)
        return;
    [_chart.taLayer SetDrawings:dr];
}

-(BOOL)includeTradeLevelsInZoom
{
   return [ [ properties getParam: @"view.tradeLevelsInZoom" ] intValue ] == 1;
}

-(double)upperOrderPrice
{
   double res_ = -HUGE_VAL;
   
   if ( [ self includeTradeLevelsInZoom ] )
   {
      for ( TAOrderLevel* order_level_ in self.orderLevels )
         res_ = MAX(res_, order_level_.price);
   }
   return res_;
}

-(double)lowerOrderPrice
{
   double res_ = HUGE_VAL;
   
   if ( [ self includeTradeLevelsInZoom ] )
   {
      for ( TAOrderLevel* order_level_ in self.orderLevels )
         res_ = MIN(res_, order_level_.price);
   }
   return res_;
}

@end
