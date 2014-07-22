
#import "Axis.h"
#import "Utils.h"
#import "XYChart.h"
#import "FinanceChart.h"
#import "PlotArea.h"
#import "PropertiesStore.h"
#import "TAOrderLevel.h"


@implementation Axis
@synthesize parentChart, parentFChart, tickPositions;
@synthesize axisType, axis_rect;
@synthesize isAutoScale, isAutoLower, showZero, upperLimit, lowerLimit, dateFormatter;

-(id)initWithType:(uint)_axisType parentXYChart:(XYChart*)_parentChart parentFinanceChart:(FinanceChart*)_parentFChart
{    
	self = [super init];
    if(self == nil)
        return self;    
	
	[self setDateFormatter:[[[NSDateFormatter alloc] init] autorelease]];
	[self setTickPositions:[[[NSMutableArray alloc] initWithCapacity:10] autorelease]];
    self.parentChart		= _parentChart;
    self.parentFChart		= _parentFChart;
	self.isAutoScale		= true;
	self.isAutoLower		= true;
    self.axisType			= _axisType;
	self.axis_rect			= CGRectMake(0, 0, 0, 0);
    self.upperLimit			= 0;
    self.lowerLimit			= 0;
	self.showZero			= false;
    return self;
}

-(void)dealloc
{	
    [tickPositions release];
	[dateFormatter release];
	[super dealloc];
}

- (void)layoutInRect:(CGRect)rect
{
    axis_rect = rect;	
}
- (void)drawInContext:(CGContextRef)ctx InRect:(CGRect)rect AndDPI:(double)pen_1px
{
    axis_rect = rect;
	[tickPositions removeAllObjects];
    if (axisType == CHART_AXIS_VERTICAL) //vertical  
    {
		[self drawYAxisInContext:ctx InRect:rect AndDPI:pen_1px];
    }
    else 
    {
		[self drawXAxisInContext:ctx InRect:rect AndDPI:pen_1px];
    }
}
 
- (void)drawYAxisInContext:(CGContextRef)ctx InRect:(CGRect)rect AndDPI:(double)pen_1px
{
	PropertiesStore* style = self.parentFChart.properties;
	int _x = CHART_AXIS_TICK_LEN;

	//prepare for text drawing
	CGColorRef text_color = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_font_color"]) CGColor];
	UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	float textPixelHeight = round(font.capHeight/2)*2;
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	CGContextSetTextMatrix(ctx, myTextTransform);
	CGContextSetStrokeColorWithColor(ctx, text_color);
	CGContextSetFillColorWithColor(ctx, text_color);
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);
	//CGContextSetTextDrawingMode(ctx, kCGTextFill);
	CGContextSetLineWidth(ctx, pen_1px);

	//draw ticks
	double lineY 				= axis_rect.origin.y;
	double last_price;
	int steps					= truncf(axis_rect.size.height / CHART_GRID_CELLSIZE);
	double realCellSize			= axis_rect.size.height / steps;
	while(lineY <= axis_rect.origin.y + axis_rect.size.height + 2*CHART_PADDING_TOP_BOTTOM)
	{
		last_price = [self coorToValue:lineY];

		if (isnan(last_price))
			last_price = 0;

		if(showZero)
		{
			if(fabs([self getCoorValue:0] - lineY)<font.capHeight)
			{
				lineY+=realCellSize;
				continue;
			}
		}

		//Draw price
		float textPosX = axis_rect.origin.x + CHART_AXIS_TICK_LEN;
		float textPosY = lineY - textPixelHeight;
		CGContextSetShouldAntialias(ctx, true);
		[ [parentChart formatPrice: last_price] drawAtPoint: CGPointMake(textPosX+1, textPosY)
												   withFont: font ];
		CGContextSetShouldAntialias(ctx, false);

		//draw nail
		CGContextMoveToPoint(   ctx,
							 (rect.origin.x),
							 (lineY));
		CGContextAddLineToPoint(ctx,
								(rect.origin.x)+_x,
								(lineY));

		[tickPositions addObject:[NSNumber numberWithDouble:(lineY)]];
		//end draw nail

		lineY+=realCellSize;
	}
	CGContextStrokePath(ctx);

	if(showZero)
	{
		lineY 				= [self getCoorValue:0];
		if (isnan(lineY)) lineY=0;
		//Draw 0 price
		NSString *PriceStr = [parentChart formatPrice:0.0];
		//if(upperLimit>0 && lowerLimit<0)
		//	txtPrice.text = " " + txtPrice.text;

		float textPosX = axis_rect.origin.x + CHART_AXIS_TICK_LEN;
		float textPosY = lineY - textPixelHeight;
		CGContextSetShouldAntialias(ctx, true);
		[PriceStr drawAtPoint:CGPointMake(textPosX+1, textPosY) withFont:font];
		CGContextSetShouldAntialias(ctx, false);
		//draw nail
		CGContextMoveToPoint(   ctx,
							 (rect.origin.x),
							 (lineY));
		CGContextAddLineToPoint(ctx,
								(rect.origin.x)+_x,
								(lineY));
		CGContextStrokePath(ctx);
		[tickPositions addObject:[NSNumber numberWithDouble:(lineY)]];
	}


    if(parentChart == parentChart.parentFChart.mainChart)
    {
		//if([style getBoolParam:@"style.annotations.show_orders"])//show orders
        {
			CGColorRef textColor = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_cursor_textcolor"]) CGColor];
            NSMutableArray *orders = [parentFChart getOrderLevelsBetween:parentChart.yAxis.lowerLimit
                                                                     And:parentChart.yAxis.upperLimit];
            if([orders count]>0)
            {
                //setup the font
                UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
                CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
                CGContextSetTextMatrix(ctx, myTextTransform);
                CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getSmallFontSize], kCGEncodingMacRoman);
                CGContextSetTextDrawingMode(ctx, kCGTextFill);
                CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);

                for (TAOrderLevel* ol in orders)
                {
					double y_order = [parentChart.yAxis getCoorValue:ol.price];//(topPadding + (topValue-bid)*pixelValue);

					CGColorRef lineColor = [ [ UIColor colorWithRed: 39.f / 255 green: 152.f / 255 blue: 236.f / 255 alpha: 1.f ] CGColor ];
					CGContextSetStrokeColorWithColor(ctx, lineColor);
					CGContextSetLineWidth(ctx, pen_1px);

					float textPosX = axis_rect.origin.x + CHART_AXIS_TICK_LEN;
					float textPosY = y_order - textPixelHeight;


					//fill text rectangle
					CGContextSetFillColorWithColor(ctx, lineColor);
					CGContextFillRect(ctx, CGRectMake(textPosX,
													  y_order - textPixelHeight/2 - CHART_CURSOR_RECT_PADDING,
													  axis_rect.size.width,
													  textPixelHeight + 2*CHART_CURSOR_RECT_PADDING));

					//Draw price
					CGContextSetShouldAntialias(ctx, true);
					CGContextSetFillColorWithColor(ctx, textColor);
					NSString *PriceStr = [parentChart formatPrice:ol.price];
					[PriceStr drawAtPoint:CGPointMake(textPosX+1, textPosY) withFont:font];
					CGContextSetShouldAntialias(ctx, false);
                }
            }
        }
	}
	//draw last price
	if(	parentChart == parentChart.parentFChart.mainChart &&
       parentChart.endIndex == [parentChart.DataStore GetLength]-1)
	{
		CGColorRef textColor = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_cursor_textcolor"]) CGColor];
		HLOCDataSource *ds = parentFChart.chart_data;
		if([style getBoolParam:@"style.annotations.show_ask"])
		{
			double ask = ds.last_ask;
			double y_ask = [parentChart.yAxis getCoorValue:ask];//(topPadding + (topValue-bid)*pixelValue);

			CGColorRef lineColor = [HEXCOLOR([style getColorParam:@"style.annotations.chart_ask_color"]) CGColor];
			CGContextSetStrokeColorWithColor(ctx, lineColor);
			CGContextSetLineWidth(ctx, pen_1px);

			float textPosX = axis_rect.origin.x + CHART_AXIS_TICK_LEN;
			float textPosY = y_ask - textPixelHeight;


			//fill text rectangle
			CGContextSetFillColorWithColor(ctx, lineColor);
			CGContextFillRect(ctx, CGRectMake(textPosX,
											  y_ask - textPixelHeight/2 - CHART_CURSOR_RECT_PADDING,
											  axis_rect.size.width,
											  textPixelHeight + 2*CHART_CURSOR_RECT_PADDING));

			//Draw price
			CGContextSetShouldAntialias(ctx, true);
			CGContextSetFillColorWithColor(ctx, textColor);
			NSString *PriceStr = [parentChart formatPrice:ask];
			[PriceStr drawAtPoint:CGPointMake(textPosX+1, textPosY) withFont:font];
			CGContextSetShouldAntialias(ctx, false);
		}
		if([style getBoolParam:@"style.annotations.show_bid"])
		{
			double bid = ds.last_bid;
			double y_bid = [parentChart.yAxis getCoorValue:bid];//(topPadding + (topValue-bid)*pixelValue);
			CGColorRef lineColor = [HEXCOLOR([style getColorParam:@"style.annotations.chart_bid_color"]) CGColor];
			CGContextSetStrokeColorWithColor(ctx, lineColor);
			CGContextSetLineWidth(ctx, pen_1px);

			float textPosX = axis_rect.origin.x + CHART_AXIS_TICK_LEN;
			float textPosY = y_bid - textPixelHeight;

			//fill text rectangle
			CGContextSetFillColorWithColor(ctx, lineColor);
			CGContextFillRect(ctx, CGRectMake(textPosX,
											  y_bid - textPixelHeight/2 - CHART_CURSOR_RECT_PADDING,
											  axis_rect.size.width,
											  textPixelHeight + 2*CHART_CURSOR_RECT_PADDING));

			//Draw price
			CGContextSetShouldAntialias(ctx, true);
			CGContextSetFillColorWithColor(ctx, textColor);
			NSString *PriceStr = [parentChart formatPrice:bid];
			[PriceStr drawAtPoint:CGPointMake(textPosX+1, textPosY) withFont:font];
			CGContextSetShouldAntialias(ctx, false);
		}
	}
}

- (void)drawXAxisInContext:(CGContextRef)ctx InRect:(CGRect)rect AndDPI:(double)pen_1px
{
    PropertiesStore* style = self.parentFChart.properties;
		CGContextSetFillColorWithColor(ctx, [HEXCOLOR([style getColorParam:@"style.chart_general.chart_margin_color"]) CGColor]);
	    CGContextFillRect(ctx, rect);


	double _y= CHART_AXIS_TICK_LEN;


    NSDate *last_date = nil;
	//    int gmt_delta		= [[NSTimeZone localTimeZone] secondsFromGMT];

	double lMaxTime		= [parentFChart.mainChart getUpperTimeValue];
	double lMinTime		= [parentFChart.mainChart getLowerTimeValue];
	double period_length = lMaxTime - lMinTime;
	double lineX		= [self XIndexToX:(parentFChart.startIndex + parentFChart.duration - 1)];
	double lastPriceEndPoint = axis_rect.origin.x + axis_rect.size.width + [Utils getYAxisWidth];

	if (lMaxTime == lMinTime)
		[dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
	else
		if (period_length > 10*3600*24)
			[dateFormatter setDateFormat:@"dd.MM.yyyy"];
		else
			if ((uint)lMaxTime/(24*3600) != (uint)lMinTime/(24*3600)) //day is different
				[dateFormatter setDateFormat:@"dd/MM HH:mm"];
			else
				[dateFormatter setDateFormat:@"HH:mm"];

	//prepare to draw time

	CGColorRef text_color = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_font_color"]) CGColor];
	UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	CGContextSetTextMatrix(ctx, myTextTransform);
	CGContextSetStrokeColorWithColor(ctx, text_color);
	CGContextSetFillColorWithColor(ctx, text_color);
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);
	//CGContextSetTextDrawingMode(ctx, kCGTextFill);
	CGContextSetLineWidth(ctx, pen_1px);

	int last_bar_index = -1;
	while (lineX > axis_rect.origin.x)
	{
		int bar_index = [self getXDataIndex:(lineX)];
		if(last_bar_index==bar_index)
			break;
		last_bar_index=bar_index;
		double last_timeval = [self.parentFChart.mainChart getTimeValueAt:bar_index];

		if (last_timeval != 0)
		{
			//int dateDaylightSaving	= [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:[[[NSDate alloc] initWithTimeIntervalSince1970:last_timeval] autorelease]];
			//int timeDelta = gmt_delta;
			//if (dateDaylightSaving == 0)
			//{
			//	timeDelta -= [[NSTimeZone localTimeZone] daylightSavingTimeOffset];
			//}
			last_date= [NSDate dateWithTimeIntervalSince1970:last_timeval];// addTimeInterval:(NSTimeInterval)-timeDelta];

			NSString *lastDateString = [dateFormatter stringFromDate:last_date];
			lineX = [self XIndexToX:bar_index];

			//save minor tick position
			[tickPositions addObject:[NSNumber numberWithDouble:lineX]];

			//measure the string
			//		CGContextSetTextDrawingMode(ctx, kCGTextInvisible);
			//		CGContextSetTextPosition(ctx, rect.origin.x, rect.origin.y);
			//		CGContextShowText(ctx, [lastDateString UTF8String], strlen([lastDateString UTF8String]));
			//
			//		CGPoint pt = CGContextGetTextPosition(ctx);
			//		float textPixelLength = pt.x - rect.origin.x + CHART_XAXIS_LABEL_PADDING;

			CGSize timeSize = [lastDateString sizeWithFont:font];
			float textPixelLength = timeSize.width + CHART_XAXIS_LABEL_PADDING;
			/////////
			float textPosX = lineX - (textPixelLength-CHART_XAXIS_LABEL_PADDING)/2.0;
			float textPosY = axis_rect.origin.y + _y;// + CHART_AXIS_TICK_LEN*pen_1px;
			bool shouldDrawTime = (textPosX + textPixelLength < lastPriceEndPoint) && textPosX > axis_rect.origin.x;

			//draw the string (may be)
			if(shouldDrawTime)
			{
				CGContextSetTextDrawingMode(ctx, kCGTextFill);
				//NSLog(@"textPosX - %f, textPosY = %f", textPosX, textPosY);
				CGContextSetShouldAntialias(ctx, true);
				[lastDateString drawAtPoint:CGPointMake(textPosX, textPosY) withFont:font];
				CGContextSetShouldAntialias(ctx, false);
				lastPriceEndPoint = textPosX;

				//draw nail
				CGContextMoveToPoint(   ctx,
									 lineX,
									 (rect.origin.y));
				CGContextAddLineToPoint(ctx,
										lineX,
										(rect.origin.y)+_y);

			}
			lineX -= textPixelLength;
		}

		//move line X
		//lineX -= CHART_GRID_CELLSIZE;
	}
	CGContextStrokePath(ctx);
}

- (void)drawCursorTimeInContext:(CGContextRef)ctx
                      WithIndex:(uint)cursorIndex 
                  WithFillColor:(CGColorRef)fillColor
                  WithTextColor:(CGColorRef)textColor
                         AndDPI:(double)pen_1px
{
	UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	CGContextSetTextMatrix(ctx, myTextTransform);
	CGContextSetStrokeColorWithColor(ctx, textColor);
	CGContextSetFillColorWithColor(ctx, textColor);
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);


	int bar_index = self.parentFChart.startIndex + cursorIndex;
	//	int gmt_delta		= [[NSTimeZone localTimeZone] secondsFromGMT];
	[dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];

	double last_timeval = [self.parentFChart.mainChart getTimeValueAt:bar_index];
	//	int dateDaylightSaving	= [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:[[[NSDate alloc] initWithTimeIntervalSince1970:last_timeval] autorelease]];
	//	int timeDelta = gmt_delta;
	//	if (dateDaylightSaving == 0)
	//	{
	//		timeDelta -= [[NSTimeZone localTimeZone] daylightSavingTimeOffset];
	//	}
	//	NSDate* cursor_date= [[NSDate dateWithTimeIntervalSince1970:last_timeval] addTimeInterval:(NSTimeInterval)-timeDelta];
	NSDate* cursor_date= [NSDate dateWithTimeIntervalSince1970:last_timeval];

	NSString *lastDateString = [dateFormatter stringFromDate:cursor_date];
	double lineX = [self XIndexToX:bar_index];

	//measure string
	//	CGContextSetTextDrawingMode(ctx, kCGTextInvisible);
	//	CGContextSetTextPosition(ctx, axis_rect.origin.x, axis_rect.origin.y);
	//	CGContextShowText(ctx, [lastDateString UTF8String], strlen([lastDateString UTF8String]));
	//
	//	CGPoint pt = CGContextGetTextPosition(ctx);
	//	float textPixelLength = pt.x - axis_rect.origin.x;

	CGSize timeSize = [lastDateString sizeWithFont:font];
	float textPixelLength = timeSize.width;

	float textPosX = MAX(axis_rect.origin.x, lineX - (textPixelLength)/2.0);
	float textPosY = axis_rect.origin.y + CHART_AXIS_TICK_LEN;

	//fill text rectangle
	CGContextSetFillColorWithColor(ctx, fillColor);
	CGContextFillRect(ctx, CGRectMake(textPosX - 2*pen_1px, textPosY , textPixelLength + 4, font.capHeight + 12*pen_1px ));

	//draw triangle on top of the text rect
	CGContextSetShouldAntialias(ctx, true);
	CGContextMoveToPoint(ctx,		lineX - CHART_AXIS_TICK_LEN,	textPosY);
	CGContextAddLineToPoint(ctx,	lineX,							axis_rect.origin.y);
	CGContextAddLineToPoint(ctx,	lineX + CHART_AXIS_TICK_LEN,	textPosY);
	CGContextFillPath(ctx);

	//draw text
	CGContextSetFillColorWithColor(ctx, textColor);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
	[lastDateString drawAtPoint:CGPointMake(textPosX, textPosY) withFont:font];
	CGContextSetShouldAntialias(ctx, false);
}

- (void)drawCursorPriceInContext:(CGContextRef)ctx
						   WithY:(int)pY
				   WithFillColor:(CGColorRef)fillColor
				   WithTextColor:(CGColorRef)textColor
						  AndDPI:(double)pen_1px
{
	UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	CGContextSetTextMatrix(ctx, myTextTransform); 
	CGContextSetStrokeColorWithColor(ctx, textColor);     
	CGContextSetFillColorWithColor(ctx, textColor); 
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);	
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
	float textPixelHeight = font.capHeight;
	
	
	float last_price = [self coorToValue:pY];
	
	//Prepare for Draw price	
	NSString *PriceStr = [parentChart formatPrice:last_price];
	float textPosX = axis_rect.origin.x + CHART_AXIS_TICK_LEN;
	float textPosY = pY - textPixelHeight;
	CGContextSetShouldAntialias(ctx, true);
	
	
	//fill text rectangle
	CGContextSetFillColorWithColor(ctx, fillColor);
	CGContextFillRect(ctx, CGRectMake(textPosX, pY - textPixelHeight/2 - CHART_CURSOR_RECT_PADDING, axis_rect.size.width, textPixelHeight + 2*CHART_CURSOR_RECT_PADDING));
	
	
	
	//draw triangle on top of the text rect
	CGContextMoveToPoint(ctx,		axis_rect.origin.x,		pY);
	CGContextAddLineToPoint(ctx,	textPosX,				pY - CHART_AXIS_TICK_LEN);
	CGContextAddLineToPoint(ctx,	textPosX,				pY + CHART_AXIS_TICK_LEN);
	CGContextFillPath(ctx);
	
	
	//Draw price   
	CGContextSetShouldAntialias(ctx, true);   
	CGContextSetFillColorWithColor(ctx, textColor); 		
	[PriceStr drawAtPoint:CGPointMake(textPosX+1, textPosY) withFont:font];
	CGContextSetShouldAntialias(ctx, false);
}
        
-(double)getPixelValue
{
    if (axisType == CHART_AXIS_VERTICAL) //vertical
    {
        //if(showZero)
        //	return (axisHeight-paddingTopBottom*2) / (upperLimit);
        //else
        return (axis_rect.size.height) / (upperLimit - lowerLimit);
    }
    else //horizontal
    {
        //no need
    }
    return 0;			
}
-(void)autoScale
{
    if (axisType == CHART_AXIS_VERTICAL) //vertical  
    {		
		if(isAutoScale)		
			upperLimit = [parentChart getUpperDataValue];
		if(isAutoLower)
			lowerLimit = [parentChart getLowerDataValue];	
	}
}
-(double)getValueOfPixel
{
	if (axisType == CHART_AXIS_VERTICAL) //vertical
	{
		return (upperLimit - lowerLimit)/(axis_rect.size.height-axis_rect.origin.y*2);
	}
	else //horizontal
	{
		//no need
	}
	return 0;
}
		
-(int)getXDataIndex:(double)pX
{
	if (axisType == CHART_AXIS_VERTICAL) //vertical
		return 0;

	double segmentWidth = (axis_rect.size.width - [Utils getChartGridRightCellSize: parentFChart.frame]) / parentFChart.duration;
	
	return parentFChart.startIndex + (pX - axis_rect.origin.x) / segmentWidth - 1;	
}
        
-(double)XIndexToX:(int)x_index
{	
	return [self XIndexToXRaw:x_index AndCheck:true];	 
}

-(double)XIndexToXRaw:(int)x_index AndCheck:(bool)mustCheck
{	
	if (axisType == CHART_AXIS_VERTICAL) //vertical
		return NAN;
	if ((x_index<(int)parentFChart.startIndex ||
		x_index>=(int)parentFChart.startIndex + (int)parentFChart.duration) && mustCheck)
		return NAN;
	double local_index = x_index-(int)parentFChart.startIndex;
	
	double segment_width_full = (self.axis_rect.size.width - [Utils getChartGridRightCellSize: parentFChart.frame]) / ((int)parentFChart.duration);
	return self.axis_rect.origin.x + (local_index+1) * segment_width_full ;	 
}
		
-(double)getCoorValue:(double)value
{
	double result = NAN;
	if(isnan(value))
		return result;
	if (axisType == CHART_AXIS_VERTICAL) //vertical
	{
		result = axis_rect.origin.y + 
				(axis_rect.size.height) * (upperLimit - value) / (upperLimit - lowerLimit);         
		return result;
	}
	else //horizontal
	{
		double workWidth = axis_rect.size.width-[Utils getChartGridRightCellSize: parentFChart.frame];
		double xPos = value;
		
		double lMaxTime = [parentChart getUpperTimeValue];
		double lMinTime = [parentChart getLowerTimeValue];
		double period_length = lMaxTime - lMinTime;
		
		return lMinTime+ period_length*(xPos/ workWidth);
	}
}
		
-(double)coorToValue:(double)pY
{
	if (axisType == CHART_AXIS_HORIZONTAL) //horizontal
		return NAN;

	return upperLimit - (pY - axis_rect.origin.y)*(upperLimit - lowerLimit)/(axis_rect.size.height);
}
        
- (void)clear
{	
	
}  
        
- (void)setAutoScale
{
	isAutoScale = true;
	[self autoScale];
}

- (void)setLinearScale:(double)_lowerLimit AndUpper:(double)_upperLimit
{
	self.lowerLimit = _lowerLimit;
    self.upperLimit = _upperLimit;
	isAutoScale		= false;
	isAutoLower		= false;
}

- (void)setLowerLimit_:(double)_lowerLimit
{
	self.lowerLimit = _lowerLimit;
	isAutoLower = false;
}


@end
