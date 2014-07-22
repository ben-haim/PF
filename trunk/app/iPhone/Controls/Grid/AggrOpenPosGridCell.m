

#import "AggrOpenPosGridCell.h"
#import "AggrOpenPosWatch.h"
#import "AggragateTradeRecord.h"


@implementation AggrOpenPosGridCell

@synthesize storage, watch;

-(AggrOpenPosGridCell *)init
{
	[super init];
	isGroupRow = NO;
	isSelected = NO;
	Height = 60;
	return self;
}
-(void)Draw:(CGRect)rect
{
	[super Draw:rect];
	int realHeight = 60;	
	
	int x1 = 5;
	int x2 = 95;
	int x3 = 155;
	int x4 = 190;
	int x5 = 215;
	int y1 = 2;
	int y2 = 22;
	int y3 = 37;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
		
	if (!lastInGroup)
	{
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
	AggragateTradeRecord *atr = [list.dicOpen objectForKey:[list.openOrderKeys objectAtIndex:symbol_index]];
	
	
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
	
	temp = [[NSString alloc] initWithFormat:@"%.02f", atr.storage];
	[temp drawInRect: CGRectMake(x5, rect.origin.y + y2, 100, 16)
			withFont: midBlackFont
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight];	
	[temp release];
	
	temp = [[NSString alloc] initWithFormat:@"%.02f", atr.commission];
	[temp drawInRect: CGRectMake(x5, rect.origin.y + y3, 100, 16)
			withFont: midBlackFont
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight];	
	[temp release];
		
	if(atr.profit>0)	
        CGContextSetFillColorWithColor(context, [HEXCOLOR(0x00CC00FF) CGColor]);		
	else	
		CGContextSetFillColorWithColor(context, [HEXCOLOR(0xCC0000FF) CGColor]);

	
	temp = [storage formatProfit:atr.profit];
	[temp drawInRect: CGRectMake(x5, rect.origin.y + y1, 100, 16)
			withFont: bigBlackFont
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
	[PROFIT_LOSS drawInRect: CGRectMake(x4, rect.origin.y + y1 + 5, 80, 16)
				   withFont: midGrayFont];
	[SWAP drawInRect: CGRectMake(x4, rect.origin.y + y2, 50, 11) 
			withFont:midGrayFont];
	[COMMISSION drawInRect: CGRectMake(x4, rect.origin.y + y3, 50, 11) 
				  withFont:midGrayFont];	
	
	
}

@end
