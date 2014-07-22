

#import "AggrPendingPosGridCell.h"
#import "OpenPosWatch.h"
#import "AggragateTradeRecord.h"

@implementation AggrPendingPosGridCell

@synthesize storage, watch;

-(AggrPendingPosGridCell *)init
{
	[super init];
	isGroupRow = NO;
	isSelected = NO;
	Height = 75;
	return self;
}
-(void)Draw:(CGRect)rect
{
	[super Draw:rect];
	int realHeight = 75;	
	
	int x1 = 5;
	int x2 = 95;
	int x3 = 155;
	int x4 = 190;
	int x5 = 215;
	int y1 = 2;
	int y2 = 32;
	int y3 = 47;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 1);
	CGFloat dash[] = {1};
	//CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineDash(context, 0.0, dash, 1);
	
	CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextMoveToPoint(context, 5, rect.origin.y+22.5);
	CGContextAddLineToPoint(context, 315, rect.origin.y+22.5);
	CGContextStrokePath(context);
	
	CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);	
	CGContextMoveToPoint(context, 5, rect.origin.y+21.5);
	CGContextAddLineToPoint(context, 315, rect.origin.y+21.5);
	CGContextStrokePath(context);
	
	CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	
	if (!lastInGroup)
	{
		CGFloat dash1[] = {0.0};
		//		CGContextSetLineCap(context, kCGLineCapSquare);
		CGContextSetLineDash(context, 0.0, dash1, 0);
		
		CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
		CGContextMoveToPoint(context, 0, rect.origin.y+realHeight-1.5);
		CGContextAddLineToPoint(context,  320, rect.origin.y + realHeight-1.5);		
		CGContextStrokePath(context);
		
		CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
		CGContextMoveToPoint(context, 0, rect.origin.y+realHeight-0.5);
		CGContextAddLineToPoint(context,  320, rect.origin.y + realHeight-0.5);		
		CGContextStrokePath(context);
	}	
	
	AggrOpenPosWatch * list = (AggrOpenPosWatch*)watch;
	AggragateTradeRecord *atr = [list.dicPending objectForKey:[list.pendingOrderKeys objectAtIndex:symbol_index]];
	TickData *td = [[storage Prices] objectForKey:atr.symbol];
	
	
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 10);
	CGContextSetTextMatrix(context, myTextTransform); 
	
	
	CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]);	
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]); 
	
	
	CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]);	
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]);  
	
	
	NSString *temp;
	
	UIFont *bigBlackFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_16"];
	if(bigBlackFont==nil)
	{
		bigBlackFont = [UIFont fontWithName:@"Helvetica" size:16.0f];
		[dataCacheDelegate putToCache:@"Helvetica_16" AndCell:(UIImage*)bigBlackFont];
	}
	
	UIFont *midBlackFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_12"];
	if(midBlackFont==nil)
	{
		midBlackFont = [UIFont fontWithName:@"Helvetica" size:12.0f];
		[dataCacheDelegate putToCache:@"Helvetica_12" AndCell:(UIImage*)midBlackFont];
	}
	
	[atr.symbol drawInRect:CGRectMake(x1, rect.origin.y + y1, 90, 15) withFont:bigBlackFont];
	
	[@"buy" drawInRect:CGRectMake(x1, rect.origin.y + y2, 40, y3-y2)  withFont:midBlackFont];
	[@"sell" drawInRect:CGRectMake(x1, rect.origin.y + y3, 40, y3-y2)  withFont:midBlackFont];
	
	// volume buy
	temp = [[NSString alloc] initWithFormat:@"%.02f", atr.volBuy];
	[temp drawInRect:CGRectMake(x3, rect.origin.y + y2, 40, y3-y2) withFont:midBlackFont];
	[temp release];	
	
	// volume sell
	temp = [[NSString alloc] initWithFormat:@"%.02f", atr.volSell];
	[temp drawInRect:CGRectMake(x3, rect.origin.y + y3, 40, y3-y2) withFont:midBlackFont];
	[temp release];	
	
	//temp = [[NSString alloc] initWithFormat:@"%.02f", atr.storage];
	//temp = [storage formatPrice:t forSymbol:<#(NSString *)symbol#>
	[td.Ask drawInRect: CGRectMake(x5, rect.origin.y + y2, 100, 16)
			withFont: midBlackFont
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight];	
	//[temp release];
	
	//temp = [[NSString alloc] initWithFormat:@"%.02f", atr.commission];
	[td.Bid drawInRect: CGRectMake(x5, rect.origin.y + y3, 100, 16)
			withFont: midBlackFont
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight];	
	
	CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);     
	CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]); 
	
	UIFont *midGrayFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_11"];
	if(midGrayFont==nil)
	{
		midGrayFont = [UIFont fontWithName:@"Helvetica" size:11.0f];
		[dataCacheDelegate putToCache:@"Helvetica_10" AndCell:(UIImage*)midGrayFont];
	}
	UIFont *smallGrayFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_9"];
	if(smallGrayFont==nil)
	{
		smallGrayFont = [UIFont fontWithName:@"Helvetica" size:9.0f];
		[dataCacheDelegate putToCache:@"Helvetica_9" AndCell:(UIImage*)smallGrayFont];
	}
	
	
	[VOLUME drawInRect: CGRectMake(x2, rect.origin.y + y2, 50, 11)
			  withFont: midGrayFont];
	[VOLUME drawInRect: CGRectMake(x2, rect.origin.y + y3, 50, 11)
			  withFont: midGrayFont];
	[ASKSTRING drawInRect: CGRectMake(x4, rect.origin.y + y2, 50, 11) 
			withFont:midGrayFont];
	[BIDSTRING drawInRect: CGRectMake(x4, rect.origin.y + y3, 50, 11) 
				  withFont:midGrayFont];	
	
	
}

@end
