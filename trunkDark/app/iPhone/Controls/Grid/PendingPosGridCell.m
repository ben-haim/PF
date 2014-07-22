
#import "PendingPosGridCell.h"
#import "OpenPosWatch.h"

#define TYPE (NSLocalizedString(@"ORDER_TYPE", nil))
#define ORDER (NSLocalizedString(@"ORDER_ORDER", nil))
#define VOLUME (NSLocalizedString(@"ORDER_VOLUME", nil))
#define OPEN_PRICE ([NSLocalizedString(@"OPEN_PRICE", nil) stringByAppendingString:@":"])
#define STOP_LOSS (NSLocalizedString(@"ORDER_STOP_LOSS", nil))
#define TAKE_PROFIT ([NSLocalizedString(@"TAKE_PROFIT", nil) stringByAppendingString:@":"])
#define MARKET_PRICE (NSLocalizedString(@"ORDER_MARKET_PRICE", nil))
#define SWAP (NSLocalizedString(@"ORDER_SWAP", nil))
#define COMMISSION (NSLocalizedString(@"ORDER_COMM", nil))

@implementation PendingPosGridCell
@synthesize storage, watch;

-(PendingPosGridCell *)init
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
	
	//NSString* image_name;
	int delta = 0;
	int realHeight = Height;
	/*if (firstInGroup)
	{
		image_name = !isSelected?@"MarketWatch_topRow.png":@"MarketWatch_topRowSelected.png";
		realHeight = 73;
		delta = 6;
		
	}
	else if (lastInGroup)
	{
		image_name = !isSelected?@"MarketWatch_bottomRow.png":@"MarketWatch_bottomRowSelected.png";
		delta = 0;
		realHeight = 68;
	}
	else
	{
		image_name = !isSelected?@"MarketWatch_middleRow.png":@"MarketWatch_middleRowSelected.png";
		realHeight = 74;
		//delta = -5;
	}
	
	
	
	UIImage *rowBackground = (UIImage*)[dataCacheDelegate getFromCache:image_name];
	if(rowBackground==nil)
	{
		rowBackground = [UIImage imageNamed:image_name];
		[dataCacheDelegate putToCache:image_name AndCell:rowBackground];
	}
	
	
	[rowBackground drawInRect: rect];*/


	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 1);
	CGFloat dash[] = {1};
	//CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineDash(context, 0.0, dash, 1);
	
	CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextMoveToPoint(context, 10, rect.origin.y+22.5+delta);
	CGContextAddLineToPoint(context, 310, rect.origin.y+22.5+delta);
	CGContextStrokePath(context);
	
	CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);	
	CGContextMoveToPoint(context, 10, rect.origin.y+21.5+delta);
	CGContextAddLineToPoint(context, 310, rect.origin.y+21.5+delta);
	CGContextStrokePath(context);
	
	
	/*CGContextMoveToPoint(context, 94.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  94.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, 203.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  203.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);*/
	
	/*CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextMoveToPoint(context, 10.5, rect.origin.y+22.5+delta);
	CGContextAddLineToPoint(context,  295+10.5, rect.origin.y+22.5+ delta);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 95.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  95.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, 204.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  204.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);*/
	
	/*CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextMoveToPoint(context, 0, rect.origin.y+realHeight-0.5);
	CGContextAddLineToPoint(context,  320, rect.origin.y + realHeight-0.5);		
	CGContextStrokePath(context);*/
	
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
	
	CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]);	
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]); 
	
	UIFont *smallFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_9"];
	if(smallFont==nil)
	{
		smallFont = [UIFont fontWithName:@"Helvetica" size:9.0f];
		[dataCacheDelegate putToCache:@"Helvetica_9" AndCell:(UIImage*)smallFont];
	}
	
	/*[TYPE drawInRect: CGRectMake(11, rect.origin.y + 30, 50, 11)
				withFont: smallFont
		   lineBreakMode:UILineBreakModeClip 
			   alignment:UITextAlignmentLeft];
	[ORDER drawInRect: CGRectMake(11, rect.origin.y + 43, 50, 11)
				  withFont: smallFont
			 lineBreakMode:UILineBreakModeClip 
				 alignment:UITextAlignmentLeft];
	[VOLUME drawInRect: CGRectMake(11, rect.origin.y + 56, 50, 11)
				  withFont: smallFont
			 lineBreakMode:UILineBreakModeClip 
				 alignment:UITextAlignmentLeft];
	
	
	[OPEN_PRICE drawInRect: CGRectMake(101, rect.origin.y + 30, 65, 16)
					  withFont: smallFont
				 lineBreakMode:UILineBreakModeClip 
					 alignment:UITextAlignmentLeft];
	[STOP_LOSS drawInRect: CGRectMake(101, rect.origin.y + 43, 50, 11)
					 withFont: smallFont
				lineBreakMode:UILineBreakModeClip 
					alignment:UITextAlignmentLeft];
	[TAKE_PROFIT drawInRect: CGRectMake(101, rect.origin.y + 56, 55, 11)
					   withFont: smallFont
				  lineBreakMode:UILineBreakModeClip 
					  alignment:UITextAlignmentLeft];
	
	
	[MARKET_PRICE drawInRect: CGRectMake(209, rect.origin.y + 30, 60, 16)
					   withFont: smallFont
				  lineBreakMode:UILineBreakModeClip 
					  alignment:UITextAlignmentLeft];
	[SWAP drawInRect: CGRectMake(209, rect.origin.y + 43, 60, 16)
				withFont: smallFont
		   lineBreakMode:UILineBreakModeClip 
			   alignment:UITextAlignmentLeft];
	[COMMISSION drawInRect: CGRectMake(209, rect.origin.y +56, 60, 16)
					  withFont: smallFont
				 lineBreakMode:UILineBreakModeClip 
					 alignment:UITextAlignmentLeft];*/
	
	[TYPE drawInRect: CGRectMake(11, rect.origin.y + 30, 50, 11)
			withFont: smallFont];
	[ORDER drawInRect: CGRectMake(11, rect.origin.y + 43, 50, 11)
			 withFont: smallFont];
	[VOLUME drawInRect: CGRectMake(11, rect.origin.y + 56, 50, 11)
			  withFont: smallFont];
	
	
	[OPEN_PRICE drawInRect: CGRectMake(101, rect.origin.y + 30, 65, 16)
				  withFont: smallFont];
	[STOP_LOSS drawInRect: CGRectMake(101, rect.origin.y + 43, 50, 11)
				 withFont: smallFont];
	[TAKE_PROFIT drawInRect: CGRectMake(101, rect.origin.y + 56, 55, 11)
				   withFont: smallFont];
	
	
	[MARKET_PRICE drawInRect: CGRectMake(209, rect.origin.y + 30, 60, 16)
					withFont: smallFont];
	[SWAP drawInRect: CGRectMake(209, rect.origin.y + 43, 60, 16)
			withFont: smallFont];
	[COMMISSION drawInRect: CGRectMake(209, rect.origin.y +56, 60, 16)
				  withFont: smallFont];
	
	OpenPosWatch * list = (OpenPosWatch*)watch;
	TradeRecord *tr = [list.pending_items objectAtIndex: symbol_index];
	
	TickData *td = [[storage Prices] objectForKey:tr.symbol];
	NSString* close_price = ((tr.cmd%2)!= 0)?td.Bid:td.Ask;
	
	UIFont *smallBlackFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_10"];
	if(smallBlackFont==nil)
	{
		smallBlackFont = [UIFont fontWithName:@"Helvetica" size:10.0f];
		[dataCacheDelegate putToCache:@"Helvetica_10" AndCell:(UIImage*)smallBlackFont];
	}
	NSString *temp;
	CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]);	
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]); 
	
	[tr.cmd_str drawInRect: CGRectMake(45, rect.origin.y + 29, 45, 12)
	 withFont: smallBlackFont
	 lineBreakMode:UILineBreakModeClip 
	 alignment:UITextAlignmentRight];
	
	temp = [NSString stringWithFormat:@"%d", tr.order];
	[temp drawInRect: CGRectMake(41, rect.origin.y + 42, 49, 12)
												   withFont: smallBlackFont
											  lineBreakMode:UILineBreakModeClip 
												  alignment:UITextAlignmentRight];
	//[temp release];
	
	temp = [storage formatVolume:tr.volume];
	[temp drawInRect: CGRectMake(59, rect.origin.y + 55, 30, 12)
										withFont: smallBlackFont
								   lineBreakMode:UILineBreakModeClip 
									   alignment:UITextAlignmentRight];	
	//[temp autorelease];	
	
	UIFont *middleBlackFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_12"];
	if(middleBlackFont==nil)
	{
		middleBlackFont = [UIFont fontWithName:@"Helvetica" size:12.0f];
		[dataCacheDelegate putToCache:@"Helvetica_12" AndCell:(UIImage*)middleBlackFont];
	}
	
	
	UIFont *middleBlackBoldFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_Bold_12"];
	if(middleBlackBoldFont==nil)
	{
		middleBlackBoldFont = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
		[dataCacheDelegate putToCache:@"Helvetica_Bold_12" AndCell:(UIImage*)middleBlackBoldFont];
	}
	
	temp = [storage formatPrice:tr.open_price forSymbol:tr.symbol];
	[temp drawInRect: CGRectMake(150, rect.origin.y + 27, 48, 12)
															   withFont: middleBlackFont
														  lineBreakMode:UILineBreakModeClip 
															  alignment:UITextAlignmentRight];
	//[temp autorelease];	
	
	temp = [storage formatPrice:tr.sl forSymbol:tr.symbol];
	[temp drawInRect: CGRectMake(150, rect.origin.y + 41, 48, 12)
													   withFont: middleBlackFont
												  lineBreakMode:UILineBreakModeClip 
													  alignment:UITextAlignmentRight];
	//[temp autorelease];	
	
	temp = [storage formatPrice:tr.tp forSymbol:tr.symbol];
	[temp drawInRect: CGRectMake(150, rect.origin.y + 54, 48, 12)
													   withFont: middleBlackFont
												  lineBreakMode:UILineBreakModeClip 
													  alignment:UITextAlignmentRight];
	//[temp autorelease];	
	
	
	
	[close_price drawInRect: CGRectMake(262, rect.origin.y + 27, 48, 12)
				   withFont: middleBlackBoldFont
			  lineBreakMode:UILineBreakModeClip 
				  alignment:UITextAlignmentRight];
	temp = [storage formatProfit:tr.storage];
	[temp drawInRect: CGRectMake(262, rect.origin.y + 41, 48, 12)
										 withFont: middleBlackFont
									lineBreakMode:UILineBreakModeClip 
										alignment:UITextAlignmentRight];
	//[temp autorelease];	
	
	temp = [storage formatProfit:tr.commission];
	[temp drawInRect: CGRectMake(262, rect.origin.y + 54, 48, 12)
											withFont: middleBlackFont
									   lineBreakMode:UILineBreakModeClip 
										   alignment:UITextAlignmentRight];
	//[temp autorelease];	
	NSString* icon_name;
	
	if(tr != nil && tr.symbol!=nil && (tr.cmd%2)==0)
	{
		icon_name = @"order_buy.png";
	}
	else
	{
		icon_name = @"order_sell.png";
	}
	
	
	UIImage *rowIcon = (UIImage*)[dataCacheDelegate getFromCache:icon_name];
	if(rowIcon==nil)
	{
		rowIcon = [UIImage imageNamed:icon_name];
		[dataCacheDelegate putToCache:icon_name AndCell:rowIcon];
	}
	
	
	[rowIcon drawInRect: CGRectMake(8, rect.origin.y + 4 + delta, 16, 16)];
	
	
	
	int strSize = 15;
	if ([tr.symbol length] > 6)
		strSize =  17-1.6*([tr.symbol length] - 6); 
	
	UIFont *symbolFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_15"];
	if(symbolFont==nil)
	{
		symbolFont = [UIFont fontWithName:@"Helvetica" size:strSize];
		[dataCacheDelegate putToCache:@"Helvetica_15" AndCell:(UIImage*)symbolFont];
	}	
	
	[tr.symbol drawInRect: CGRectMake(28, rect.origin.y + 3 + delta, 65, 20)
	 withFont: symbolFont
	 lineBreakMode:UILineBreakModeClip 
	 alignment:UITextAlignmentLeft];
}
@end
