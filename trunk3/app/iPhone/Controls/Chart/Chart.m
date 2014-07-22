
#import "Chart.h"
#import "iTraderAppDelegate.h"



@implementation Chart
@synthesize contentView, parent;
@synthesize ItemsVisible,GridCellPixels;
@synthesize BackColor, GridColor, AxisColor, StrokeColor, lastScale;
@synthesize storage, sym, lastWidth, isMaximized;
@synthesize all_series;

- (id)initWithCoder:(NSCoder*)coder 
{
    if(self=[super initWithCoder:coder])
	{
		//buffer = [self createOffscreenContext: self.bounds.size];
        ItemsVisible = 10;
		GridCellPixels = 50;
		BackColor = HEXCOLOR(0xE7E3DEFF); //HEXCOLOR(0xFFFFFFFF);
		[BackColor retain];
		GridColor = HEXCOLOR(0xCCCCCCFF);
		[GridColor retain];
		AxisColor = HEXCOLOR(0x000000FF);
		[AxisColor retain];
		StrokeColor = HEXCOLOR(0x090909FF);
		[StrokeColor retain];
		XAxisOffset = 25;
		YAxisOffset = 50;
		
		isMaximized = NO;
		self.scrollEnabled = YES;
		self.minimumZoomScale = 1;
		self.maximumZoomScale = 1;
		self.bounces = NO;
		//self.delegate = self;
		
		//lastScale = 0.05;
		iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
		lastScale = [appDelegate chartScale];
		
		lastWidth = -666;
		//self.minimumZoomScale = 0.001;
		contentView = [[UIView alloc] initWithFrame:self.bounds];
		all_series = [[NSMutableArray alloc] init];
		
		requestSent = NO;
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(chart_newbar:)
													 name:@"chart_newbar" object:nil];	
		UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
		[self addGestureRecognizer:pinchGesture]; 
		[pinchGesture release];

			
	}
	//[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receivedRotate:) name: UIDeviceOrientationDidChangeNotification object: nil];
	

    return self;
}

-(void)GetChart:(SymbolInfo*)symbol AndRange:(NSString*)RangeType
{
	sym = symbol;	
	requestSent = YES;
	[storage.charts GetChart:sym AndRange:RangeType];
}

- (void)chartReceived:(NSMutableArray *)vals
{
	NSLog(@"chart received.: %@", sym.Symbol);
	if(!requestSent)
		return;
	requestSent = NO;
	
	
	CandleSeries* dat = [[CandleSeries alloc] init];
	dat.candles = vals; 
	dat.storage = storage;
	dat.sym = sym;
	[dat setGridColor:GridColor];
	[dat setAxisColor:AxisColor];
	[dat setStrokeColor:StrokeColor];
	[all_series removeAllObjects];
	[self AddSeries:dat];
	//[dat autorelease];
	[dat release];
	[self RecalcScroll];
	[self setShowsVerticalScrollIndicator:NO];
	[self setNeedsDisplay];
	CGPoint newOffset;
	newOffset.y=0;
	newOffset.x = self.contentSize.width;
	[self setContentOffset:newOffset animated: NO];
	[self setNeedsDisplay];
	
}
-(void)AddSeries:(CandleSeries *)series
{
	[all_series addObject:series];
	[self RecalcScroll];
}
- (void)chart_newbar:(NSNotification *)notification
{
	BOOL isLastVisible = NO;
	if(self.contentOffset.x + self.bounds.size.width >= self.contentSize.width)
		isLastVisible = YES;
	[self RecalcScroll];
	if(isLastVisible)
	{
		//[self RecalcScroll];
		CGPoint newOffset = CGPointMake(self.contentSize.width - self.bounds.size.width+50, 0);
		[self setContentOffset: newOffset animated: NO];
	}
}

-(void)RecalcScroll
{
	int max_items = 0;
	for(int i=0; i<all_series.count; i++)
	{
		Series *item = (Series *)[all_series objectAtIndex:i];
		if([item GetCount]>max_items)
			max_items = [item GetCount];
	}
	
	CGRect r = self.frame;

	float deltaWidth = 0;
	if(lastWidth >=0 )
		deltaWidth = (max_items+1) * lastScale * r.size.width -lastWidth;
	//if(deltaWidth<0)
		//deltaWidth = 0;
	lastWidth = (max_items+1) * lastScale * r.size.width;	
	CGPoint oldOffset = self.contentOffset;
	[self setContentSize:CGSizeMake(lastWidth, r.size.height)];
	
	CGPoint newOffset = CGPointMake(oldOffset.x + deltaWidth, 0);
	[self setContentOffset: newOffset animated: NO];
	
	iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate setChartScale:lastScale];
}

- (IBAction)handlePinchGesture:(UIGestureRecognizer *)sender 
{
	static CGRect initialBounds;
	
	UIView *_view = sender.view;
	
	if (sender.state == UIGestureRecognizerStateBegan)
	{
		initialBounds = _view.bounds;
	}
	CGFloat scale = [(UIPinchGestureRecognizer *)sender scale];
	//NSLog(@"factor: %f", scale);
	
	float new_offset_val = 0;
	CGPoint oldOffset = self.contentOffset;
	new_offset_val = ((oldOffset.x + self.bounds.size.width )*scale)/self.lastScale;
	
	
	///
	float deltaX = (oldOffset.x/(self.lastScale * self.bounds.size.width));
	float items = 1/self.lastScale;
	float old_last_bar = deltaX+items-1 ;
	lastScale = lastScale * pow(scale, 0.05); 
	if(lastScale<0.001)
		lastScale = 0.001;
	if(lastScale>0.05)
		lastScale=0.05;
	//NSLog(@"Scale: %f", lastScale);
	
	
	
	
	
	[self RecalcScroll];
	float new_items = 1/self.lastScale;
	CGPoint newOffset = CGPointMake((old_last_bar-new_items+1)*self.lastScale * self.bounds.size.width, 0);
	[self setContentOffset: newOffset animated: NO];
	[self setNeedsDisplay];
	
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if ([touches count] == 1 && [[touches anyObject] tapCount] == 2)
	{	
		isMaximized = !isMaximized;
		if(isMaximized)
			[[NSNotificationCenter defaultCenter] postNotificationName:@"maximizeChart" object:parent]; //[[NSNotificationCenter defaultCenter] postNotificationName:@"maximizeChart" object:[sym Symbol]];
		else
			[[NSNotificationCenter defaultCenter] postNotificationName:@"minimizeChart" object:parent]; //[[NSNotificationCenter defaultCenter] postNotificationName:@"minimizeChart" object:nil];
		return;
	}
	[super touchesBegan:touches withEvent:event];
}

-(int)getSeriesCount
{
	return [all_series count];
}

// This method is called by NSNotificationCenter when the device is rotated.
-(void) receivedRotate: (NSNotification*) notification
{
	[self RecalcScroll];
	[self setNeedsLayout];
	[self setNeedsDisplay];
	
	/*UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation != UIDeviceOrientationPortrait)
	{
		CGRect r = self.frame;
		r.size.height = 50;
		[self drawRect:r];
	}*/
	

}

-(void)dealloc
{
	void *bitmapData = CGBitmapContextGetData(buffer); // 7
    CGContextRelease (buffer);// 8
    if (bitmapData) free(bitmapData); // 9
	[all_series release];
	[super dealloc];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	contentView.transform = CGAffineTransformMakeScale(1, 1);
	return contentView;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self setNeedsDisplay];

}


- (CGContextRef) createOffscreenContext: (CGSize) size  
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width*4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
	
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    return context;
}
- (void)SetData:(NSString *)RawData
{
}

- (void)drawRect:(CGRect)rect 
{
	//UIGraphicsBeginImageContext(self.bounds.size);	
	CGContextRef context = UIGraphicsGetCurrentContext();
	int deltaX = self.contentOffset.x;
	rect.size.height += rect.origin.y;
	rect.origin.y = 0;
	
	[self DrawBackground:rect AndOffset:deltaX];
	
	CGRect clipRect = rect;
	clipRect.size.width-=(YAxisOffset+5);
	clipRect.size.height-=(XAxisOffset+10);
	clipRect.origin.x= 5;
	clipRect.origin.y=  8;	
	
	//NSLog(@"x: %d\n", deltaX);
	CGContextTranslateCTM( context, deltaX, 0);
	[self DrawSeries:clipRect AndOffset:(deltaX/(lastScale * self.bounds.size.width)) AndCount:1/lastScale];
	
	
	
	//UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	
	//UIGraphicsEndImageContext(); 
	//context = UIGraphicsGetCurrentContext();
	//CGContextSetAllowsAntialiasing(context, NO);
	//[img drawInRect: rect];
	
	//bit blitting
	/*
	UIGraphicsBeginImageContext(self.bounds.size);	
	CGContextRef context = UIGraphicsGetCurrentContext();
	int deltaX = self.contentOffset.x;

	
	[self DrawBackground:rect AndOffset:deltaX];
	
	CGRect clipRect = rect;
	clipRect.size.width-=(YAxisOffset+5);
	clipRect.size.height-=(XAxisOffset+10);
	clipRect.origin.x=  -deltaX + 5;
	clipRect.origin.y=  8;	
	
	//NSLog(@"x: %d\n", deltaX);
	 CGContextTranslateCTM( context, deltaX, 0);
	[self DrawSeries:clipRect AndOffset:(deltaX/(lastScale * self.bounds.size.width)) AndCount:1/lastScale];
	
 
   
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext(); 
	context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, NO);
	[img drawInRect: rect];
	 */

}
-(void)DrawBackground:(CGRect)rect AndOffset:(double)deltaX
{
    CGContextRef context = UIGraphicsGetCurrentContext();	
	
	CGRect r = rect;

	//r.origin.x-=deltaX;
	
	CGContextSetFillColorWithColor(context, [BackColor CGColor]);
	CGContextFillRect(context, r);
	//r.origin.x-=deltaX;
	CGContextSetStrokeColorWithColor(context, [StrokeColor CGColor]);
	CGContextStrokeRect(context, r);
	
	r.origin.x-=0.5;
	r.origin.y=0.5;
	
	CGContextTranslateCTM( context, 0.5,0.5 );
	
	
	CGContextSetStrokeColorWithColor(context, [AxisColor CGColor]);
	CGContextMoveToPoint(context,  rect.origin.x + 1, rect.origin.y + rect.size.height - XAxisOffset+5);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - YAxisOffset, rect.origin.y + rect.size.height - XAxisOffset+5);
    CGContextStrokePath(context);
	
	
    CGContextMoveToPoint(context, rect.origin.x + rect.size.width - YAxisOffset, rect.origin.y + rect.size.height - XAxisOffset+5);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - YAxisOffset, rect.origin.y + 1);		
    CGContextStrokePath(context);
	

		
}

-(void)DrawSeries:(CGRect)rect AndOffset:(double)deltaX AndCount:(double)items
{
	
    CGContextRef context = UIGraphicsGetCurrentContext();

	
	for(int i=0; i<all_series.count; i++)
	{
		Series *item = (Series *)[all_series objectAtIndex:i];
		[item Draw:context OnRect:rect DrawGrid:(i==0) AndOffset:deltaX/*(deltaX/(lastScale * self.bounds.size.width))*/ AndCount:items ];
	}
	/*
	 int bars = 1/lastScale;
	 float bar_width = clipRect.size.width/bars;
	 
	 CGContextTranslateCTM( context, deltaX, 0);	//CGContextSetAllowsAntialiasing(context, NO);
	 for(int i=0; i<bars; i++)
	 {		
	 CGRect circle = CGRectMake(i*bar_width, 50, bar_width, bar_width);
	 CGContextAddEllipseInRect(context, circle);	
	 
	 CGContextStrokePath(context);
	 }
	 
	 //CGContextScaleCTM( context, lastScale, lastScale );	
	 */
}



@end
