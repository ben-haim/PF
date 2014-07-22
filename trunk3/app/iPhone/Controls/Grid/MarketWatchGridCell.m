
#import "MarketWatchGridCell.h"

#define MAXSTRING (NSLocalizedString(@"RATES_MAX", nil))
#define MINSTRING (NSLocalizedString(@"RATES_MIN", nil))
#define ASKSTRING (NSLocalizedString(@"RATES_ASK", nil))
#define BIDSTRING (NSLocalizedString(@"RATES_BID", nil))
#define SPREADSTRING (NSLocalizedString(@"RATES_SPREAD", nil))

@implementation MarketWatchGridCell
@synthesize storage, Symbol;
-(MarketWatchGridCell *)init
{
	[super init];
	isGroupRow = NO;
	isSelected = NO;
	Height = 60;
	//SelectedColor = [UIColor lightGrayColor];

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
		realHeight = 59;
		delta = 5;

	}
	else if (lastInGroup)
	{
		image_name = !isSelected?@"MarketWatch_bottomRow.png":@"MarketWatch_bottomRowSelected.png";
		delta = -5;
		realHeight = 54;
	}
	else
	{
		image_name = !isSelected?@"MarketWatch_middleRow.png":@"MarketWatch_middleRowSelected.png";
		realHeight = 59;
		//delta = -5;
	}
	

	
	UIImage *rowBackground = (UIImage*)[dataCacheDelegate getFromCache:image_name];
	if(rowBackground==nil)
	{
		rowBackground = [UIImage imageNamed:image_name];
		[dataCacheDelegate putToCache:image_name AndCell:rowBackground];
	}
	
	
	
	//CGContextTranslateCTM( UIGraphicsGetCurrentContext(), 0, rect.origin.y);
	//cell.backgroundColor = [UIColor clearColor];
	//[[cell layer]  renderInContext:UIGraphicsGetCurrentContext()];

	[rowBackground drawInRect: rect];*/
	
	//NSLog(@"%@", Symbol);
	
	if(storage==nil)
		return;
	if (Symbol==nil)
	{
		return;
	}
	TickData *price;
	@try {
		price = [[storage Prices] objectForKey:Symbol];
	}
	@catch (NSException * e) {
		NSLog(@"MarketWatchGridCell exception:%@",[NSThread callStackSymbols]);
	}
	//TickData *price = [[storage Prices] objectForKey:Symbol];
	if(price==nil)
	{
		//return;
	}
	SymbolInfo *sym_info = [[storage Symbols] objectForKey:Symbol]; 
	if(sym_info==nil)
		return;
					
	BOOL isUP;
	NSString *tempMin;
	NSString *tempMax;
	
	NSString *tempBid;
	NSString *tempAsk;
	
	NSString *tempBid1;
	NSString *tempBid2;
	NSString *tempBid3;
	NSString *tempAsk1;
	NSString *tempAsk2;
	NSString *tempAsk3;
	
	if (price != nil) 
	{
		isUP = price.direction==1;
		NSString* arrow_name;
		if(isUP)
		{
			arrow_name = @"up_blue.png";
		}
		else
		{
			arrow_name = @"down_red.png";	
		}
		UIImage *rowArrow = (UIImage*)[dataCacheDelegate getFromCache:arrow_name];
		if(rowArrow==nil)
		{
			rowArrow = [UIImage imageNamed:arrow_name];
			[dataCacheDelegate putToCache:arrow_name AndCell:rowArrow];
		}	
		CGRect arrowRect = rect;
		arrowRect.origin.x = 3;
		arrowRect.origin.y = rect.origin.y + (rect.size.height-rowArrow.size.height)/2;
		arrowRect.size.width = rowArrow.size.width;
		arrowRect.size.height = rowArrow.size.height;
		[rowArrow drawInRect: arrowRect];
		
		tempAsk = price.Ask;
		tempBid = price.Bid;
		tempMax = price.Max;
		tempMin = price.Min;
	}
	else 
	{
		tempAsk = @" ";
		tempBid = @" ";
		tempMax = @" ";
		tempMin = @" ";
	}

	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 10);
	CGContextSetTextMatrix(context, myTextTransform); 
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);     
	CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]); 
	CGContextSelectFont(context, "Helvetica", 17, kCGEncodingMacRoman); 

	CGContextSetTextDrawingMode(context, kCGTextFill); 
	CGContextSetTextPosition(context, 20, rect.origin.y + 36+delta );

	
	if(sym_info.TradeMode ==0) // trading not available
		CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	else
	if(sym_info.TradeMode ==1) // only close
		CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	else
	if(sym_info.TradeMode ==2) // full trading
		CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
	
	
	if ([sym_info.Symbol length] > 6)
		CGContextSelectFont(context, "Helvetica", 17-1.2*([sym_info.Symbol length] - 6), kCGEncodingMacRoman); 
	
	
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
	
	
	if (price==nil)
	{
		CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
		CGContextShowText(context, [sym_info.Symbol UTF8String], strlen([sym_info.Symbol UTF8String])); 
		return;
	}
	
	CGContextShowText(context, [sym_info.Symbol UTF8String], strlen([sym_info.Symbol UTF8String])); 
	
	//CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
//	CGContextMoveToPoint(context, 100.5, rect.origin.y+delta);
//	CGContextAddLineToPoint(context,  100.5, rect.origin.y + realHeight);		
//	CGContextStrokePath(context);
//		
//	CGContextMoveToPoint(context, 205.5, rect.origin.y+delta);
//	CGContextAddLineToPoint(context,  205.5, rect.origin.y + realHeight);		
//	CGContextStrokePath(context);
	
			
	
	
	
	
	/*CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextMoveToPoint(context, 101.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  101.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, 206.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  206.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);*/
			
	/*CGContextSelectFont(context, "Helvetica-Bold", 19, kCGEncodingMacRoman); 
	
	CGContextSetTextDrawingMode(context, kCGTextFill); 
	CGContextSetTextPosition(context, 132, rect.origin.y + 23);
	CGContextShowText(context, [price.Ask UTF8String], strlen([price.Ask UTF8String]));
	CGContextSetTextPosition(context, 132, rect.origin.y + 53 );
	//NSString *priceString = [storage formatPrice:price.open_price forSymbol:tr.symbol]; 
	//CGContextShowText(context, [price.Bid UTF8String], strlen([price.Bid UTF8String]));
	CGRect priceRect = CGRectMake(132, rect.origin.y + 53, 69, 16);
	[price.Bid drawInRect: CGRectMake(132, rect.origin.y + 53, 69, 16);  
				withFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0f] 
				lineBreakMode:UILineBreakModeClip 
				alignment:UITextAlignmentRight];*/

	
	
//	CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);     .......
//	CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);			...
//	CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);				.......
	
	//CGContextSetTextDrawingMode(context, kCGTextFill); 
	//CGContextSetTextPosition(context, 107, rect.origin.y + 53);	
	//CGContextShowText(context, [@"Ask:" UTF8String], strlen([@"Ask:" UTF8String]));	
	//CGContextSetTextPosition(context, 107, rect.origin.y + 23);	
	//CGContextShowText(context, [@"Bid:" UTF8String], strlen([@"Bid:" UTF8String]));
	//CGContextSetTextPosition(context, 212, rect.origin.y + 23);	
	////CGContextShowText(context, [MAXSTRING UTF8String] , [MAXSTRING length] );	
	//CGContextSetTextPosition(context, 212, rect.origin.y + 53);	
	//CGContextShowText(context, [MINSTRING UTF8String] , [MINSTRING length] );

//	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);			....
//	CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);		......
	
	/*CGContextSelectFont(context, "Helvetica", 15, kCGEncodingMacRoman); 
	
	CGContextSetTextDrawingMode(context, kCGTextFill); 
	CGContextSetTextPosition(context, 240, rect.origin.y + 23);	
	CGContextShowText(context, [price.Max UTF8String], strlen([price.Max UTF8String]));	
	CGContextSetTextPosition(context, 240, rect.origin.y + 53);	
	CGContextShowText(context, [price.Min UTF8String], strlen([price.Min UTF8String]));	*/
	
	//[self DrawInRect:tempMin context:context drawInRect: CGRectMake(250, rect.origin.y + 8, 50, 16)
//	   lineBreakMode:UILineBreakModeClip 
//		   alignment:UITextAlignmentRight
//				name:"Helvetica" size:15];
//	[self DrawInRect:tempMax context:context drawInRect: CGRectMake(250, rect.origin.y + 38, 50, 16)
//	   lineBreakMode:UILineBreakModeClip 
//		   alignment:UITextAlignmentRight
//				name:"Helvetica" size:15];
	
	//[self DrawInRect:tempMin context:context drawInRect: CGRectMake(145, rect.origin.y + 38, 50, 16)
//	   lineBreakMode:UILineBreakModeClip 
//		   alignment:UITextAlignmentRight
//				name:"Helvetica" size:15];
//	[self DrawInRect:tempMax context:context drawInRect: CGRectMake(255, rect.origin.y + 38, 50, 16)
//	   lineBreakMode:UILineBreakModeClip 
//		   alignment:UITextAlignmentRight
//				name:"Helvetica" size:15];
	
	
	CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);     
	CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]); 
	
	UIFont *font = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_10"];
	if(font==nil)
	{
		font = [UIFont fontWithName:@"Helvetica" size:10.0f];
		[dataCacheDelegate putToCache:@"Helvetica_10" AndCell:(UIImage*)font];
	}
	
	UIFont *priceFont3 = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_Bold_11"];
	if(priceFont3==nil)
	{
		priceFont3 = [UIFont fontWithName:@"Helvetica-Bold" size:11.0f];
		[dataCacheDelegate putToCache:@"Helvetica_Bold_11" AndCell:(UIImage*)priceFont3];
	}
	UIFont *priceFont2 = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_Bold_17"];
	if(priceFont2==nil)
	{
		priceFont2 = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
		[dataCacheDelegate putToCache:@"Helvetica_Bold_17" AndCell:(UIImage*)priceFont2];
	}
	UIFont *priceFont1 = (UIFont*)[dataCacheDelegate getFromCache:@"Helvetica_Bold_34"];
	if(priceFont1==nil)
	{
		priceFont1 = [UIFont fontWithName:@"Helvetica-Bold" size:34.0f];
		[dataCacheDelegate putToCache:@"Helvetica_Bold_34" AndCell:(UIImage*)priceFont1];
	}
	
	//draw spread
	CGSize spreadSize = [SPREADSTRING sizeWithFont:font];
	[SPREADSTRING drawInRect: CGRectMake(21, rect.origin.y+9, spreadSize.width, spreadSize.height) withFont:font];
	NSString* spread = [self CalculateSpreadOf:sym_info withAsk:tempAsk withBid:tempBid];
	//[spread drawAtPoint:CGPointMake(21 + spreadSize.width + 5, rect.origin.y+5) withFont:font];
	[spread drawInRect:CGRectMake(21 + spreadSize.width + 3, rect.origin.y+9, 30, 15) withFont:font];
	
	//draw last update
	//NSDate* lastUpdate = [price lastUpdate];
	
	NSDateFormatter *dateFormater = (NSDateFormatter*)[dataCacheDelegate getFromCache:@"dateFormater"];
	if(dateFormater==nil)
	{
		dateFormater = [[NSDateFormatter alloc] init];
		[dateFormater setDateFormat:@"HH:mm:ss"];
		[dataCacheDelegate putToCache:@"dateFormater" AndCell:(UIImage*)dateFormater];
	}
	
	
	NSString *dateString = [dateFormater stringFromDate:[price lastUpdate]];
	//[dateString drawAtPoint:CGPointMake(21, rect.origin.y+43) withFont:font];
	[dateString drawInRect:CGRectMake(21, rect.origin.y+43, 50, 10) withFont:font];
	
	//draw min, max values
	[tempMin drawInRect:CGRectMake(147, rect.origin.y + 43, 50, 16) withFont:font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
	
	[tempMax drawInRect:CGRectMake(257, rect.origin.y + 43, 50, 16) withFont:font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
	
	//NSString *MaxString = storage.MaxString;
	
	/*NSString *MaxString = (NSString*)[dataCacheDelegate getFromCache:@"maxstr"];
	if(MaxString==nil)
	{
		MaxString = NSLocalizedString(@"RATES_MAX", nil);
		[dataCacheDelegate putToCache:@"maxstr" AndCell:(UIImage*)MaxString];
		NSLog(@"loaded to cache");
	}
	
	const char *str = [MaxString UTF8String];*/
	/*NSString *MaxString = (NSString *)[dataCacheDelegate getFromCache:@"maxstr"];
	if(MaxString==nil)
	{
		MaxString = NSLocalizedString(@"RATES_MAX", nil);
		[dataCacheDelegate putToCache:@"maxstr" AndCell:(UIImage*)MaxString];
		NSLog(@"loaded to cache");
	}*/
	
	//[MINSTRING drawInRect: CGRectMake(212, rect.origin.y+13, 30, 9) withFont:font];
//	[MAXSTRING drawInRect: CGRectMake(212, rect.origin.y+43, 30, 9) withFont:font];
//	[ASKSTRING drawInRect: CGRectMake(107, rect.origin.y+43, 30, 9) withFont:font];
//	[BIDSTRING drawInRect: CGRectMake(107, rect.origin.y+13, 30, 9) withFont:font];
	
	//draw min, max labels
	
	CGSize maxSize = [tempMax sizeWithFont:font];
	CGSize strSize1 = [MAXSTRING sizeWithFont:font];
	CGSize strSize2 = [MINSTRING sizeWithFont:font];
	[MAXSTRING drawInRect: CGRectMake(305 - (maxSize.width + strSize1.width), rect.origin.y+43, strSize1.width, 9) withFont:font];
	CGSize minSize = [tempMin sizeWithFont:font];
	[MINSTRING drawInRect: CGRectMake(195 - (minSize.width + strSize2.width), rect.origin.y+43, strSize2.width, 9) withFont:font];
		
	UIColor *priceColor = nil; 
	if (price == nil) 
		priceColor = [UIColor grayColor];
	
	else if(isUP)
	{
		priceColor = HEXCOLOR(0x0000CCFF);//HEXCOLOR(0x00CC00FF);
	}
	else
	{
		priceColor= HEXCOLOR(0xCC0000FF);
	}
	
	CGContextSetStrokeColorWithColor(context, [priceColor CGColor]);     
	CGContextSetFillColorWithColor(context, [priceColor CGColor]); 
	
	
	//UIFont *PriceFont = [UIFont fontWithName:@"Helvetica-Bold" size:19.0f];
//	[tempAsk drawInRect: CGRectMake(132, rect.origin.y + 35, 69, 16)
//	 withFont: PriceFont
//	 lineBreakMode:UILineBreakModeClip 
//	 alignment:UITextAlignmentRight];
	
//	[tempBid drawInRect: CGRectMake(132, rect.origin.y + 5, 69, 16)  
//	 withFont:PriceFont 
//	 lineBreakMode:UILineBreakModeClip 
//	 alignment:UITextAlignmentRight];
	
	//draw ask value
	[self SplitPrice:tempAsk P1:&tempAsk1 P2:&tempAsk2 P3:&tempAsk3 Sym:sym_info];
	
	CGFloat askWidth =  300;
	//UIFont *PriceFont = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
	CGSize textSize = [tempAsk3 sizeWithFont:priceFont3];
	if([tempAsk3 length] > 0)
	{
//		[tempAsk3 drawAtPoint:CGPointMake(askWidth, rect.origin.y + 9) forWidth:textSize.width withFont:priceFont12 fontSize:12.0f
//			lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentAlignCenters];
		[tempAsk3 drawInRect:CGRectMake(askWidth, rect.origin.y + 9, textSize.width, textSize.height) withFont:priceFont3];
	}
	else
	{
		askWidth += 8;
	}
	
	//PriceFont = [UIFont fontWithName:@"Helvetica-Bold" size:38.0f];
	textSize = [tempAsk2 sizeWithFont:priceFont1];
	askWidth -= textSize.width;
	//	[tempAsk2 drawAtPoint:CGPointMake(askWidth, rect.origin.y + 3) forWidth:textSize.width withFont:priceFont38 fontSize:38.0f
	//			lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentAlignCenters];
	[tempAsk2 drawInRect:CGRectMake(askWidth, rect.origin.y + 3, textSize.width, textSize.height) withFont:priceFont1];
		
	//PriceFont = [UIFont fontWithName:@"Helvetica-Bold" size:22.0f];
	textSize = [tempAsk1 sizeWithFont:priceFont2];
	askWidth -= textSize.width;	
	[tempAsk1 drawInRect:CGRectMake(askWidth, rect.origin.y + 19, textSize.width, textSize.height) withFont:priceFont2];
	//	[tempAsk1 drawAtPoint:CGPointMake(askWidth, rect.origin.y + 19) forWidth:textSize.width withFont:priceFont2 fontSize:17.0f
	//			lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentAlignCenters];	
	
	//draw bid value
	[self SplitPrice:tempBid P1:&tempBid1 P2:&tempBid2 P3:&tempBid3 Sym:sym_info];
	
	CGFloat bidWidth =  200;
	//PriceFont = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
	textSize = [tempBid3 sizeWithFont:priceFont3];
	if([tempBid3 length] > 0)
	{
//		[tempBid3 drawAtPoint:CGPointMake(bidWidth, rect.origin.y + 9) forWidth:textSize.width withFont:priceFont12 fontSize:12.0f
//			lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentAlignCenters];
		[tempBid3 drawInRect:CGRectMake(bidWidth, rect.origin.y + 9, textSize.width, textSize.height) withFont:priceFont3];
	}
	else
	{
		bidWidth += 8;//textSize.width;
	}

	//PriceFont = [UIFont fontWithName:@"Helvetica-Bold" size:38.0f];
	textSize = [tempBid2 sizeWithFont:priceFont1];
	bidWidth -= textSize.width;
//	[tempBid2 drawAtPoint:CGPointMake(bidWidth, rect.origin.y + 3) forWidth:textSize.width withFont:priceFont38 fontSize:38.0f
//			lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentAlignCenters];
	[tempBid2 drawInRect:CGRectMake(bidWidth, rect.origin.y + 3, textSize.width, textSize.height) withFont:priceFont1];
	
	//PriceFont = [UIFont fontWithName:@"Helvetica-Bold" size:22.0f];
	textSize = [tempBid1 sizeWithFont:priceFont2];
	bidWidth -= textSize.width;	
//	[tempBid1 drawAtPoint:CGPointMake(bidWidth, rect.origin.y + 19) forWidth:textSize.width withFont:priceFont22 fontSize:22.0f
//			lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentAlignCenters];	
	[tempBid1 drawInRect:CGRectMake(bidWidth, rect.origin.y + 19, textSize.width, textSize.height) withFont:priceFont2];
	
}

-(void)SplitPrice:(NSString *)Price P1:(NSString**)p1 P2:(NSString**)p2 P3:(NSString**)p3 Sym:(SymbolInfo *)sym
{
	int pos = 0;
	int len = [Price length];
	if (len<3) 
	{
		*p1 = @"";
		*p2 = Price;
		*p3 = @"";
	}
	else if (len>0) 
	{		
		NSRange r;
		if(sym.Digits == 3 || sym.Digits == 5)
		{
			pos++;
			r.location = len-pos;
			r.length = 1;
			*p3 = [Price substringWithRange:r];
		}
		else
		{
			*p3 = @"";
		}
		pos+=2;
		r.location = len-pos;
		r.length = 2;
		*p2 = [Price substringWithRange:r]; 
		//*p2 = Regex.Replace(s, @"dfsd", "");
		if (len>pos)
		{
			*p1 = [Price substringToIndex:len-pos];
		}
		else 
		{
			*p1 = @"";
		}
	}
	else
	{
		*p1 = @"";
		*p2 = @"";
		*p3 = @"";
	}
}

-(NSString*)CalculateSpreadOf:(SymbolInfo *)sym withAsk:(NSString *)ask withBid:(NSString *)bid
{
	double spread = 0;
	double askValue = [ask doubleValue];
	double bidValue = [bid doubleValue];
	double askBidDif = askValue - bidValue;
	int digits = [sym Digits];
	double powerOf10 = pow(10, digits);
	spread = (int) round(askBidDif * powerOf10);
	if([sym Digits] == 3 || [sym Digits] == 5)
	{
		spread = spread / 10;
	}
    NSString *spreadString = nil;
    if (digits == 3 || digits == 5)
    {
        spreadString = [NSString stringWithFormat:@"%.1f", spread];
    }
    else
    {
        spreadString = [NSString stringWithFormat:@"%d", (int)spread];
    }
    return spreadString;
}

@end
