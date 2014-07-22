
#import "CandleSeries.h"


@implementation CandleSeries

@synthesize GridColor, AxisColor, StrokeColor;
@synthesize storage, sym, candles;;

-(id) init
{
	self = [super init];

	UpColor = HEXCOLOR(0x02CB03FF);
	
	[UpColor retain];
	BorderUpColor = HEXCOLOR(0x288728FF);
	[BorderUpColor retain];
	DownColor = HEXCOLOR(0xC80607FF);
	[DownColor retain];
	BorderDownColor = HEXCOLOR(0x881000FF);
	[BorderDownColor retain];
	GridCellSize = 50;
	
	return self;
}
-(void)dealloc
{
	[UpColor release];
	[BorderUpColor release];
	[DownColor release];
	[BorderDownColor release];
	[candles release];
	
	[super dealloc];
}

-(void)SetData:(NSString*)data
{
	/*NSArray *commands = [data componentsSeparatedByString:@"$"];
	//[data release];
	if(commands.count!=2)
	{
		return;
	}
	NSString *command = [[commands objectAtIndex:0] copy];
	
	NSArray *args = [command componentsSeparatedByString:@"|"];
	[command release]; 
	
	[candles removeAllObjects];
	double powered = 100000.0;	
	int gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];
	int count = [args count];
	
	for(int i=0; i<count; i+=5)
	{
		if([[args objectAtIndex:i] compare:@""]==0)
			break;
		
		BarItem *item = [BarItem alloc];
		int time_temp = [[args objectAtIndex:(i)] integerValue];
		item.dat = [[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time_temp] addTimeInterval:(NSTimeInterval)-gmt_delta];
		item.open = [[args objectAtIndex:i+1] doubleValue]/powered;
		item.high = item.open + [[args objectAtIndex:i+2] doubleValue]/powered;
		item.low = item.open + [[args objectAtIndex:i+3] doubleValue]/powered;
		item.close = item.open + [[args objectAtIndex:i+4] doubleValue]/powered;
		[candles addObject:item];
	}*/
}

-(int)GetCount
{
	return [candles count];
}

-(void)Draw:(CGContextRef)context OnRect:(CGRect)rect DrawGrid:(BOOL)drawGrid AndOffset:(double)deltaX AndCount:(double)items
{
	if(deltaX<0)
		deltaX = 0;
	if(items<1)
		items=1;
	items --;
	@try
	{
	double max_val = 0;
	double min_val = 2000000000;
	
	int count = [candles count];
		//NSLog(@"%d", deltaX);
	while( deltaX  + items >= count)
		deltaX --;
	double first_bar = deltaX ;
	if(first_bar + items>=count-1)
		first_bar = first_bar;
	
		

	for(int i=first_bar + items; i>=first_bar-0.5 && i>=0; i--)
	{
		BarItem *bi = (BarItem *)[candles objectAtIndex:i];
		if(bi.high>max_val)
			max_val = bi.high;
		if(bi.low<min_val)
			min_val = bi.low;	
	}	
	
	if(max_val - min_val==0)
		return;
	
	int draw_bars_height = GridCellSize*((int)(rect.size.height) / GridCellSize);
	double scale = draw_bars_height/*rect.size.height*//(max_val - min_val);	
	double bar_width_full = rect.size.width/ (items+1);
	double bar_width = bar_width_full*0.6;
		
	if(drawGrid)
	{
		[self DrawGridAndPrices:context OnRect:rect AndMin:(double)min_val AndMax:(double)max_val];
		if([candles count]>0)
		{
			NSDate *min_time = ((BarItem *)[candles objectAtIndex:(first_bar<0?0:first_bar)]).dat;
			NSDate *max_time = ((BarItem *)[candles objectAtIndex:first_bar + items]).dat;
			CGRect r = rect;
			r.size.width -= (2*bar_width_full - (int)bar_width/2 -0.5); 
			[self DrawGridAndTime:context OnRect:r AndMin:min_time AndMax:max_time];	
		}
	}
		
	CGContextSetAllowsAntialiasing (context, YES);

	int c = 0;
	double last_x = rect.origin.x + rect.size.width - bar_width_full;
		
	CGContextSetStrokeColorWithColor(context, [StrokeColor CGColor]);
	for(int i=first_bar + items; i>=first_bar-0.5 && i>=0; i--)
	{
		BarItem *bi = (BarItem *)[candles objectAtIndex:i];
		CGRect bar_rect;
		double abs_height = fabs(bi.close - bi.open);
		bar_rect.size.height = (double)(abs_height*scale);
		bar_rect.size.width = (double)(bar_width);
		if(bi.close<bi.open)
		{
			bar_rect.origin.y = rect.origin.y + (double)((max_val - bi.open)*scale);
			CGContextSetFillColorWithColor(context, [DownColor CGColor]);				
			CGContextSetStrokeColorWithColor(context, [BorderDownColor CGColor]);
		}
		else
		{
			bar_rect.origin.y = rect.origin.y + (double)((max_val - bi.close)*scale);
			CGContextSetFillColorWithColor(context, [UpColor CGColor]);	
			CGContextSetStrokeColorWithColor(context, [BorderUpColor CGColor]);
		}
		//bar_rect.origin.x = rect.origin.x + rect.size.width - (c+2)*bar_width_full;
		bar_rect.origin.x = last_x - bar_width_full;
		
		last_x = last_x - bar_width_full;
		CGContextFillRect(context, bar_rect);
		CGContextStrokeRect(context, bar_rect);

		//draw current price
		if(i == count-1)
		{
			CGContextSetStrokeColorWithColor(context, [StrokeColor CGColor]);
			
			int lineY = (bi.close<bi.open)?(bar_rect.origin.y + bar_rect.size.height):bar_rect.origin.y;
			
			CGContextMoveToPoint(context, rect.origin.x - 5, lineY);
			CGContextAddLineToPoint(context,  rect.origin.x + rect.size.width + 6, lineY);		
			CGContextStrokePath(context);		

			CGRect price_fill_rect = CGRectMake(rect.origin.x + rect.size.width + 3, lineY - 6 , 46, 12);
			
			CGContextSetFillColorWithColor(context, [StrokeColor CGColor]);
			CGContextFillRect(context, price_fill_rect);
			
		
			CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
			CGContextSetTextMatrix(context, myTextTransform); 
			CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);     
			CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]); 
			CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman); 
			
			CGContextSetTextDrawingMode(context, kCGTextFill); 
			//CGContextSetTextPosition(context, rect.origin.x + rect.size.width +6, lineY + 3 );
			NSString *PriceStr = [storage formatPrice:bi.close forSymbol:sym.Symbol];
			//CGContextShowText(context, [PriceStr UTF8String], strlen([PriceStr UTF8String])); 
			[PriceStr drawAtPoint:CGPointMake(rect.origin.x + rect.size.width + 6, lineY - 7) withFont:[UIFont fontWithName:@"Helvetica" size:10]];
		}
		
		
		CGContextSetStrokeColorWithColor(context, [StrokeColor CGColor]);
		
		CGContextMoveToPoint(context, bar_rect.origin.x + bar_rect.size.width/2, bar_rect.origin.y);
		CGContextAddLineToPoint(context,  bar_rect.origin.x + bar_rect.size.width/2, rect.origin.y + (int)((max_val - bi.high)*scale));		
		CGContextStrokePath(context);
		
		CGContextMoveToPoint(context, bar_rect.origin.x + bar_rect.size.width/2, bar_rect.origin.y + bar_rect.size.height);
		CGContextAddLineToPoint(context,  bar_rect.origin.x + bar_rect.size.width/2, rect.origin.y + (int)((max_val - bi.low)*scale));		
		CGContextStrokePath(context);
		
		c++;
	}
	}
	@catch(...)
	{
		return;
	}
}
-(void)DrawGridAndPrices:(CGContextRef)context OnRect:(CGRect)rect AndMin:(double)min_price AndMax:(double)max_price
{
	//horizontal lines
	float lineY = rect.origin.y;
	double last_price = max_price;
	int steps = (rect.size.height) / GridCellSize;
	double price_increase = (max_price - min_price )/steps;
	while(lineY< rect.origin.y+ rect.size.height)
	{
		float dashLengths[] = {5, 2};
		CGContextSetStrokeColorWithColor(context, [GridColor CGColor]);
		CGContextSetLineDash(	context,
								0, dashLengths,
								sizeof( dashLengths ) / sizeof( float ) );
		CGContextMoveToPoint(context, rect.origin.x-5, lineY);
		CGContextAddLineToPoint(context,  rect.origin.x + rect.size.width, lineY);		
		CGContextStrokePath(context);
		//Draw price		
		CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
		CGContextSetTextMatrix(context, myTextTransform); 
		CGContextSetStrokeColorWithColor(context, [StrokeColor CGColor]);     
		CGContextSetFillColorWithColor(context, [StrokeColor CGColor]); 
		CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman); 
		
		CGContextSetTextDrawingMode(context, kCGTextFill); 
		CGContextSetTextPosition(context, rect.origin.x + rect.size.width+6, lineY + 2);

		//double powered = pow(10, sym.Digits);
		//double price_to_draw = (double)((int)(last_price*powered))/powered;
		
		NSString *PriceStr = [storage formatPrice:last_price forSymbol:sym.Symbol];
	//	[PriceStr autorelease];
		//if([PriceStr doubleValue]==last_price)
		//CGContextShowText(context, [PriceStr UTF8String], strlen([PriceStr UTF8String]));
		
		[PriceStr drawAtPoint:CGPointMake(rect.origin.x + rect.size.width + 6, lineY - 8) withFont:[UIFont fontWithName:@"Helvetica" size:10]];
		
		
		last_price-=price_increase;
		//End draw price	
		//draw nail
		CGContextSetLineDash(	context, 0, nil, 0);
		CGContextMoveToPoint(context,  rect.origin.x + rect.size.width, lineY);
		CGContextAddLineToPoint(context,  rect.origin.x + rect.size.width + 4 , lineY);		
		CGContextStrokePath(context);
		//end draw nail
		lineY+=GridCellSize;
	}
	CGContextSetLineDash(context, 0, nil, 0);
}
-(void)DrawGridAndTime:(CGContextRef)context OnRect:(CGRect)rect AndMin:(NSDate*)min_time AndMax:(NSDate*)max_time
{	//horizontal lines
	float lineX = rect.origin.x + rect.size.width;
	float lastPriceEndPoint = lineX + 50;
	NSDate *last_date = max_time;
	
	int steps = rect.size.width / GridCellSize;
	
	NSTimeInterval  period_length = [max_time timeIntervalSinceDate: min_time];
	int date_increase = (period_length)/steps;
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *end_comps = [calendar components:unitFlags fromDate:max_time];
	NSDateComponents *start_comps = [calendar components:unitFlags fromDate:min_time];
	
	if(period_length > 364*3600*24) 		
		[format setDateFormat:@"d MMM yyyy"];
	else
	if(period_length > 10*3600*24) 		
		[format setDateFormat:@"d MMM yyyy"];
	else
	if([end_comps day]!=[start_comps day]) 		
		[format setDateFormat:@"d MMM yyyy H:mm"];
	else
		[format setDateFormat:@"H:mm"];
		
	while(lineX>rect.origin.x)
	{
		float dashLengths[] = {5, 2};
		CGContextSetStrokeColorWithColor(context, [GridColor CGColor]);
		CGContextSetLineDash(	context,
							 0, dashLengths,
							 sizeof( dashLengths ) / sizeof( float ) );
		CGContextMoveToPoint(context, lineX, rect.origin.y-8);
		CGContextAddLineToPoint(context,  lineX, rect.origin.y + rect.size.height+8);		
		CGContextStrokePath(context);
		//draw time
		CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
		CGContextSetTextMatrix(context, myTextTransform); 
		CGContextSetStrokeColorWithColor(context, [StrokeColor CGColor]);     
		CGContextSetFillColorWithColor(context, [StrokeColor CGColor]); 
		CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman); 
		//1. measure string
		BOOL isDrawTime = NO;
		CGContextSetTextDrawingMode(context, kCGTextInvisible); 
		CGContextSetTextPosition(context, lineX, rect.origin.y + rect.size.height+8);
		

		//[format stringFromDate:tr.open_time];
		NSString *TimeStr = [format stringFromDate:last_date];
		//[TimeStr autorelease];
		CGContextShowText(context, [TimeStr UTF8String], strlen([TimeStr UTF8String]));
		CGPoint pt = CGContextGetTextPosition(context);
		
		int textPixelLength = pt.x - lineX;
		int textPos = lineX - textPixelLength/2;
		isDrawTime = (textPos + textPixelLength < lastPriceEndPoint && textPos>=rect.origin.x - 8);
		//2. may be draw string
		if(isDrawTime)
		{
			
			CGContextSetStrokeColorWithColor(context, [StrokeColor CGColor]);
			
			lastPriceEndPoint = textPos;
			int text_y_pos = rect.origin.y + rect.size.height+20;
			CGContextSetTextDrawingMode(context, kCGTextFill); 
			/*CGContextSetTextPosition(context, textPos, text_y_pos);
			CGContextShowText(context, [TimeStr UTF8String], strlen([TimeStr UTF8String]));	*/
			
			[TimeStr drawInRect: CGRectMake(textPos, text_y_pos-10, textPixelLength+6, 10)
					withFont: [UIFont fontWithName:@"Helvetica" size:10.0f]
					lineBreakMode:UILineBreakModeClip 
					  alignment:UITextAlignmentCenter];
			
			
			
			//draw nail
			CGContextSetLineDash(	context, 0, nil, 0);
			CGContextMoveToPoint(context,  lineX, rect.origin.y + rect.size.height+12 );
			CGContextAddLineToPoint(context,  lineX , rect.origin.y + rect.size.height+8);		
			CGContextStrokePath(context);
			//end draw nail
		}
		//end draw time
		lineX-=GridCellSize;
		last_date= [last_date addTimeInterval:-date_increase];
	}
	CGContextSetLineDash(context, 0, nil, 0);		
	[format release];
	[calendar release];
}







@end
