

#import "BalanceGridCell.h"
#import "OpenPosWatch.h"

#define BALANCE ([NSLocalizedString(@"BALANCE", nil) stringByAppendingString:@":"])
#define CURRENT_PL (NSLocalizedString(@"CURRENT_PL", nil))
#define EQUITY (NSLocalizedString(@"EQUITY", nil))
#define FREE (NSLocalizedString(@"FREE", nil))
#define LEVEL (NSLocalizedString(@"LEVEL", nil))
#define MARGIN (NSLocalizedString(@"MARGIN", nil))
#define CREDIT ([NSLocalizedString(@"CREDIT", nil) stringByAppendingString:@":"])
#define ACCOUNT (NSLocalizedString(@"LOGIN_LOGIN", nil))

@implementation BalanceGridCell
@synthesize storage, watch;

-(BalanceGridCell *)init
{
	isGroupRow = NO;
	isSelected = NO;
	isBalanceRow = YES;
	Height = 107;
	return self;
}
-(void)Draw:(CGRect)rect
{
	[super Draw:rect];
	
	//NSString* image_name;
	int delta = 30; 
	int offset = -13;
	int realHeight = Height;
	
	/*image_name = !isSelected?@"MarketWatch_topAndBottomRow.png":@"MarketWatch_topAndBottomRowSelected.png";
	realHeight = 94;
	delta = 6;
		
	
	UIImage *rowBackground = (UIImage*)[dataCacheDelegate getFromCache:image_name];
	if(rowBackground==nil)
	{
		rowBackground = [UIImage imageNamed:image_name];
		[dataCacheDelegate putToCache:image_name AndCell:rowBackground];
	}
	
	
	[rowBackground drawInRect: rect];*/
	


	CGContextRef context = UIGraphicsGetCurrentContext();
	
	
	/*CGContextMoveToPoint(context, 10.5, rect.origin.y+30.5);
	CGContextAddLineToPoint(context,  295+15.5, rect.origin.y+30.5);		
	CGContextStrokePath(context);*/
	CGContextSetLineWidth(context, 1);
	CGFloat dash[] = {1};
	//CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineDash(context, 0.0, dash, 1);
	
	CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	
	CGContextMoveToPoint(context, 10, rect.origin.y+31.5 + offset);
	CGContextAddLineToPoint(context, 310, rect.origin.y+31.5 + offset);
	CGContextStrokePath(context);
	
	//CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	CGContextMoveToPoint(context, 10, rect.origin.y+31.5+delta + offset);
	CGContextAddLineToPoint(context,  310, rect.origin.y+31.5+delta + offset);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 10, rect.origin.y+61.5+delta + offset);
	CGContextAddLineToPoint(context,  310, rect.origin.y+61.5+delta + offset);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 203.5, rect.origin.y+10 + offset+5);
	CGContextAddLineToPoint(context,  203.5, rect.origin.y + realHeight-6);		
	CGContextStrokePath(context);
	
	
	CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	
	CGContextMoveToPoint(context, 10, rect.origin.y+30.5 + offset);
	CGContextAddLineToPoint(context, 310, rect.origin.y+30.5 + offset);
	CGContextStrokePath(context);
		
	//CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	CGContextMoveToPoint(context, 10, rect.origin.y+30.5+delta + offset);
	CGContextAddLineToPoint(context,  310, rect.origin.y+30.5+delta + offset);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 10, rect.origin.y+60.5+delta + offset);
	CGContextAddLineToPoint(context,  310, rect.origin.y+60.5+delta + offset);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 202.5, rect.origin.y+10 + offset+5);
	CGContextAddLineToPoint(context,  202.5, rect.origin.y + realHeight-6);		
	CGContextStrokePath(context);
	
	/*CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextMoveToPoint(context, 10.5, rect.origin.y+28.5+delta+1);
	CGContextAddLineToPoint(context,  295+10.5, rect.origin.y+28.5+delta+1);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 10.5, rect.origin.y+60.5+delta+1);
	CGContextAddLineToPoint(context,  295+10.5, rect.origin.y+60.5+delta+1);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 204.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  204.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);*/
	
	
	UIFont *midGrayFont = (UIFont*)[dataCacheDelegate getFromCache:@"HelveticaBold_11"];
	if(midGrayFont==nil)
	{
		midGrayFont = [UIFont fontWithName:@"Helvetica-Bold" size:11.0f];
		[dataCacheDelegate putToCache:@"HelveticaBold_11" AndCell:(UIImage*)midGrayFont];
	}

	UIFont *bigBlackFont = (UIFont*)[dataCacheDelegate getFromCache:@"HelveticaBold_15"];
	if(bigBlackFont==nil)
	{
		bigBlackFont = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
		[dataCacheDelegate putToCache:@"HelveticaBold_15" AndCell:(UIImage*)bigBlackFont];
	}
	
	CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]);	
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]); 
	
	/*[ACCOUNT drawInRect: CGRectMake(9, rect.origin.y + 15.5, 70, 9)
				  withFont: midGrayFont
			 lineBreakMode:UILineBreakModeClip 
				 alignment:UITextAlignmentLeft];
	
	[CURRENT_PL drawInRect: CGRectMake(9, rect.origin.y + delta + 15.5, 70, 9)
				withFont: midGrayFont
		   lineBreakMode:UILineBreakModeClip 
			   alignment:UITextAlignmentLeft];
	[BALANCE drawInRect: CGRectMake(9, rect.origin.y + delta + 45.5, 70, 9)
				  withFont: midGrayFont
			 lineBreakMode:UILineBreakModeClip 
				 alignment:UITextAlignmentLeft];
	[EQUITY drawInRect: CGRectMake(9, rect.origin.y + delta + 72.5, 90, 9)
				  withFont: midGrayFont
			 lineBreakMode:UILineBreakModeClip 
				 alignment:UITextAlignmentLeft]; 
	

	[CREDIT drawInRect: CGRectMake(206, rect.origin.y + 15.5, 60, 9)
			  withFont: midGrayFont
		 lineBreakMode:UILineBreakModeClip 
			 alignment:UITextAlignmentLeft];
	
	[MARGIN drawInRect: CGRectMake(206, rect.origin.y + delta + 15.5, 60, 9)
					   withFont: midGrayFont
				  lineBreakMode:UILineBreakModeClip 
					  alignment:UITextAlignmentLeft];
	[FREE drawInRect: CGRectMake(206, rect.origin.y + delta + 45.5, 40, 9)
				   withFont: midGrayFont
			  lineBreakMode:UILineBreakModeClip 
				  alignment:UITextAlignmentLeft];
	[LEVEL drawInRect: CGRectMake(206, rect.origin.y + delta + 72.5, 40, 9)
				  withFont: midGrayFont
			 lineBreakMode:UILineBreakModeClip 
				 alignment:UITextAlignmentLeft];*/
	
	[ACCOUNT drawInRect: CGRectMake(9, rect.origin.y + 15.5 + offset, 70, 9)
			   withFont: midGrayFont];
	
	[CURRENT_PL drawInRect: CGRectMake(9, rect.origin.y + delta + 15.5 + offset, 70, 9)
				  withFont: midGrayFont];
	[BALANCE drawInRect: CGRectMake(9, rect.origin.y + delta + 45.5 + offset, 70, 9)
			   withFont: midGrayFont];
	[EQUITY drawInRect: CGRectMake(9, rect.origin.y + delta + 72.5 + offset, 90, 9)
			  withFont: midGrayFont]; 
	
	
	[CREDIT drawInRect: CGRectMake(206, rect.origin.y + 15.5 + offset, 60, 9)
			  withFont: midGrayFont];
	
	[MARGIN drawInRect: CGRectMake(206, rect.origin.y + delta + 15.5 + offset, 60, 9)
			  withFont: midGrayFont];
	[FREE drawInRect: CGRectMake(206, rect.origin.y + delta + 45.5 + offset, 40, 9)
			withFont: midGrayFont];
	[LEVEL drawInRect: CGRectMake(206, rect.origin.y + delta + 72.5 + offset, 40, 9)
			 withFont: midGrayFont];
	
	NSString *temp;
	if(storage.SumProfit>0)	
#ifdef FXTMiiii
		CGContextSetFillColorWithColor(context, [HEXCOLOR(0x83AD21FF) CGColor]);
#else
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x00CC00FF) CGColor]);
#endif	
		//CGContextSetFillColorWithColor(context, [HEXCOLOR(0x00CC00FF) CGColor]);
	else	
		CGContextSetFillColorWithColor(context, [HEXCOLOR(0xCC0000FF) CGColor]);
	
	temp = [storage formatProfit:storage.SumProfit];
	[temp drawInRect: CGRectMake(78, rect.origin.y + delta + 10.5 + offset, 120, 22)
					   withFont: bigBlackFont
				  lineBreakMode:UILineBreakModeClip 
					  alignment:UITextAlignmentRight];
	//[temp autorelease];
	CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]);	
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]); 
	
	temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
	[temp drawInRect: CGRectMake(78, rect.origin.y + 10.5 + offset, 120, 22)
			withFont: bigBlackFont
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight];
	
	temp = [storage formatProfit:storage.Balance]; 
	[temp drawInRect: CGRectMake(78, rect.origin.y + delta + 40.5 + offset, 120, 22)
				   withFont: bigBlackFont
			  lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight];
	//[temp autorelease];
	temp = [storage formatProfit:(storage.Balance + storage.SumProfit + storage.Credit)];
	[temp drawInRect: CGRectMake(78, rect.origin.y + delta + 67.5 + offset, 120, 22)
				  withFont: bigBlackFont
			 lineBreakMode:UILineBreakModeClip 
				 alignment:UITextAlignmentRight];
	//[temp autorelease];
	
	UIFont *middleBlackFont = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_11"];
	if(middleBlackFont==nil)
	{
		middleBlackFont = [UIFont fontWithName:@"Helvetica" size:11.0f];
		[dataCacheDelegate putToCache:@"Helvetica_11" AndCell:(UIImage*)middleBlackFont];
	}
	//NSLog(@"%d", storage.Credit);
	temp = [storage formatProfit:storage.Credit];
	[temp drawInRect: CGRectMake(236, rect.origin.y + 15.5 + offset, 75, 12)
			withFont: middleBlackFont
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight];
	
	temp = [storage formatProfit:storage.Margin];
	[temp drawInRect: CGRectMake(236, rect.origin.y + delta + 15.5 + offset, 75, 12)
												withFont: middleBlackFont
										   lineBreakMode:UILineBreakModeClip 
											   alignment:UITextAlignmentRight];
	//[temp autorelease];
	//NSLog(@"Inside balance: Margin Mode: %d", storage.Margin_Mode);
	if (storage.Margin_Mode == MARGIN_USE_ALL) 
		temp = [storage formatProfit:(storage.Balance + storage.SumProfit + storage.Credit -storage.Margin)];
	else if (storage.Margin_Mode == MARGIN_DONT_USE)
		temp = [storage formatProfit:(storage.Balance + storage.Credit - storage.Margin)];
	else if (storage.Margin_Mode == MARGIN_USE_PROFIT)
		temp = [storage formatProfit:(storage.Balance + storage.Credit + MAX(0, storage.SumProfit) - storage.Margin)];
	else if (storage.Margin_Mode == MARGIN_USE_LOSS)
		temp = [storage formatProfit:(storage.Balance + storage.Credit + MIN(0, storage.SumProfit) - storage.Margin)];
	
	[temp drawInRect: CGRectMake(236, rect.origin.y + delta + 45.5 + offset, 75, 12)
											  withFont: middleBlackFont
										 lineBreakMode:UILineBreakModeClip 
											 alignment:UITextAlignmentRight];
	//[temp autorelease];
	double FreePct = 0;
	if(storage.Margin!=0)
		FreePct = 100 * (storage.Balance + storage.SumProfit + storage.Credit) / storage.Margin;
	else
		FreePct = 0;
	temp = [NSString stringWithFormat:@"%@%%", [storage formatProfit:(round(FreePct*10)/10)]]; //[[NSString alloc] initWithFormat:@"%@%%", [storage formatProfit:(round(FreePct*10)/10)]]; 
	[temp drawInRect: CGRectMake(236, rect.origin.y + delta + 72.5 + offset, 75, 12)
																	withFont: middleBlackFont
															   lineBreakMode:UILineBreakModeClip 
																   alignment:UITextAlignmentRight];	
	//[temp release];
}
@end

