
#import "BaseBoxLayer.h"
#import "CursorLayer.h"
#import "../../DataStores/BaseDataStore.h"
#import "../FinanceChart.h"
#import "../XYChart.h"
#import "../LegendBox.h"
#import "../Axis.h"
#import "../../ArrayMath.h"

@implementation BaseBoxLayer
@synthesize DataStore, parentChart;
@synthesize srcField, layerName, legendKey;
@synthesize color1, color2, color3, color4, legendColor, layer_rect;

- (id)initWithDataStore:(BaseDataStore*)_DataStore ParentChart:(XYChart*)_parentChart
               SrcField:(NSString*)_srcField LayerName:(NSString*)_layerName
{
    self = [super init];
    if(self == nil)
        return self;
    [self setDataStore:_DataStore];
    parentChart = _parentChart;
    legendKey   = nil;         
    srcField    = _srcField;
    layerName   = _layerName;
    layer_rect  = CGRectMake(0, 0, 0, 0);
    return self;
}


-(ArrayMath*) GetMainData
{
    return [DataStore GetVector:srcField];
}

-(void)build
{
    return;
}

-(double)getLowerDataValue
{
    ArrayMath *v = [self GetMainData];
    double lowerDataValue = [v min2:parentChart.startIndex AndLength:parentChart.range];
    return lowerDataValue;
}

-(double)getUpperDataValue
{			
    ArrayMath *v = [self GetMainData];
    double upperDataValue = [v max2:parentChart.startIndex AndLength:parentChart.range];
    return upperDataValue;
}

-(void)setLegendKey:(NSString*)_legendKey
             color1:(uint)_legendColor
             color2:(uint)_legendColor2 
             legend:(LegendBox*)_legendBox 
         forceFirst:(bool)insertFirst
{
    [self setLegendKey:_legendKey];
    self.color1 = _legendColor;
    self.color2 = _legendColor2;
    
    if (_legendBox == nil)
    {
        if (parentChart.legendBox != nil)
        {
            [parentChart.legendBox setKey:_legendKey color1:_legendColor color2:_legendColor2 forceFirst:insertFirst];
        }
    }
    else 
    {
        [_legendBox setKey:_legendKey color1:_legendColor color2:_legendColor2 forceFirst:insertFirst];
    }
}
- (void)drawInContext:(CGContextRef)ctx InRect:(CGRect)rect AndDPI:(double)pen_1px
{
    layer_rect = rect;
    return;
}
-(void)setChartCursorValue:(uint)valueIndex
{
    ArrayMath* lineData = [self GetMainData];
    double xValue = NAN;
    double yValue = NAN;
    double segment_width_full = NAN;
    if (lineData == nil)
        return;
	
	segment_width_full = (parentChart.parentFChart.xAxis.axis_rect.size.width - [Utils getChartGridRightCellSize: parentChart.parentFChart.frame]) / 
    (parentChart.range );
	xValue = layer_rect.origin.x + (valueIndex+1) * segment_width_full ;        
	int realIndex = parentChart.startIndex + valueIndex;
    
	double line_value = [lineData getData][realIndex];
	yValue = [parentChart.yAxis getCoorValue:line_value];
	[parentChart.cursorLayer setChartCursorValue:layerName pX:xValue pY:yValue Index:valueIndex];
}

-(void)setLegendText:(int)globalIndex
{
    if (parentChart.legendBox == nil || globalIndex==-1) 
		return;
    
    double currentValue = NAN;
    
	ArrayMath* data_set = [self GetMainData];
	if(data_set == nil)
		return;
    
	if(globalIndex< [data_set getLength])
		currentValue = [data_set getData][globalIndex];
	else
        if([data_set getLength]>0)
        {
            double zero_elem = [data_set getData][globalIndex];
            currentValue = isnan(zero_elem)?0:zero_elem;
        }
        else
            currentValue = 0;
    
    NSString *valueText = [parentChart formatPrice:currentValue];
	if(isnan(currentValue))
		valueText = @"";
	
	NSString *LegendMsg = [[NSString alloc] initWithFormat:@"%@: %@", legendKey, valueText];
	
	[parentChart.legendBox setText:LegendMsg ForKey:legendKey];
//	[LegendMsg autorelease];
}
@end
