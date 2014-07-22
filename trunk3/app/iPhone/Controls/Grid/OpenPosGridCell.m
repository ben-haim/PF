
#import "OpenPosGridCell.h"
#import "OpenPosWatch.h"

#define ORDER (NSLocalizedString(@"ORDER_ORDER", nil))
#define TYPE (NSLocalizedString(@"ORDER_TYPE", nil))
#define VOLUME (NSLocalizedString(@"ORDER_VOLUME", nil))
#define PROFIT_LOSS (NSLocalizedString(@"ORDER_PROFIT_LOSS", nil))

@implementation OpenPosGridCell
@synthesize storage, watch;

-(OpenPosGridCell *)init
{
	self = [super init];

   if ( self )
   {
      isGroupRow = NO;
      isSelected = NO;
      Height = 60;
   }

	return self;
}
-(void)Draw:(CGRect)rect
{
	[super Draw:rect];
	
	//NSString* image_name;
	int delta = -5;
	int realHeight = 60;
	/*if (firstInGroup)
	{
		image_name = !isSelected?@"MarketWatch_topRow.png":@"MarketWatch_topRowSelected.png";
		realHeight = 58;
		delta = 5;
		
	}
	else if (lastInGroup)
	{
		image_name = !isSelected?@"MarketWatch_bottomRow.png":@"MarketWatch_bottomRowSelected.png";
		delta = 0;
		realHeight = 53;
	}
	else
	{
		image_name = !isSelected?@"MarketWatch_middleRow.png":@"MarketWatch_middleRowSelected.png";
		realHeight = 59;
		//delta = -5;
	}*/
	
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	/*UIImage *rowBackground = (UIImage*)[dataCacheDelegate getFromCache:image_name];
	if(rowBackground==nil)
	{
		rowBackground = [UIImage imageNamed:image_name];
		[dataCacheDelegate putToCache:image_name AndCell:rowBackground];
	}

	[rowBackground drawInRect: rect];*/

	CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	
	/*CGContextMoveToPoint(context, 94.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  94.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, 203.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  203.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);
	
	
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextMoveToPoint(context, 0, rect.origin.y+realHeight-0.5);
	CGContextAddLineToPoint(context,  320, rect.origin.y + realHeight-0.5);		
	CGContextStrokePath(context);*/
	
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
	/*CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	
	CGContextMoveToPoint(context, 95.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  95.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, 204.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  204.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);*/
	/*else 
		Height = 47;*/
		
	
	OpenPosWatch * list = (OpenPosWatch*)watch;
	TradeRecord *tr = [list.open_items objectAtIndex: symbol_index];
	

	//NSString* close_price = (tr.cmd == 0)?td.Bid:td.Ask;
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
	
	[rowIcon drawInRect: CGRectMake(8, rect.origin.y + 10 + delta, 16, 16)];
	

	
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 10);
	CGContextSetTextMatrix(context, myTextTransform); 

	
	CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]);	
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]); 
	
	
/*	[self DrawInRect:@"Order#:" context:context drawInRect:CGRectMake(8, rect.origin.y  + realHeight - 11 -5, 50, 11)
		lineBreakMode:UILineBreakModeClip 
			alignment:UITextAlignmentLeft
				 name:"Helvetica" size:9];	
	
	[self DrawInRect:@"Type:" context:context drawInRect:CGRectMake(100.5, rect.origin.y + 15 + delta, 32, 11)
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];	
	
	[self DrawInRect:@"Volume:" context:context drawInRect: CGRectMake(100.5, rect.origin.y + realHeight - 11 -5, 50, 11)
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
	
	[self DrawInRect:@"Profit/ Loss:" context:context drawInRect: CGRectMake(209, rect.origin.y + 15 + delta, 50, 16)
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
*/
	
	
	CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]);	
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]);  
		
	
	NSString *temp;
		
	UIFont *bigBlackFont = (UIFont*)[dataCacheDelegate getFromCache:@"HelveticaBold_16"];
	if(bigBlackFont==nil)
	{
		bigBlackFont = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
		[dataCacheDelegate putToCache:@"HelveticaBold_16" AndCell:(UIImage*)bigBlackFont];
	}
	
	int strSize = 15;
	if ([tr.symbol length] > 6)
		strSize =  17-1.6*([tr.symbol length] - 6); 
	
	[self DrawInRect:tr.symbol context:context drawInRect: CGRectMake(28, rect.origin.y + 10 + delta, 65, 15)
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:strSize];
	
	[self DrawInRect:tr.cmd_str context:context drawInRect: CGRectMake(179, rect.origin.y + 12 + delta, 15, 12)
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight
				name:"Helvetica" size:12];
	
	
	temp = [[NSString alloc] initWithFormat:@"%.02f", tr.volume];//temp = [storage formatVolume:tr.volume];
	[self DrawInRect:temp context:context drawInRect: CGRectMake(179, rect.origin.y + realHeight - 18 + delta, 15, 12)
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight
				name:"Helvetica" size:12];
	[temp release];	
	
	temp = [[NSString alloc] initWithFormat:@"%d", tr.order];
	[self DrawInRect:temp context:context drawInRect: CGRectMake(42, rect.origin.y + realHeight - 18 + delta, 49, 12)
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight
				name:"Helvetica" size:12];
	[temp release];
	
	if (storage.openTradesView != OPEN_TRADE_VIEW_POINTS)
    {
        if(tr.profit>0)	
            CGContextSetFillColorWithColor(context, [HEXCOLOR(0x00CC00FF) CGColor]);	
        else	
            CGContextSetFillColorWithColor(context, [HEXCOLOR(0xCC0000FF) CGColor]);
    }
    else
    {
        CGContextSetFillColorWithColor(context, [HEXCOLOR(0x0000CCFF) CGColor]);
    }
	
	temp = [storage formatProfit:tr.profit];
	[temp drawInRect: CGRectMake(210, rect.origin.y + realHeight - 16 -6 + delta, 100, 16)
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
	/*[storage.OrderString drawInRect: CGRectMake(10, rect.origin.y  + realHeight - 17, 50, 11)
			withFont: midGrayFont
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft];
	[storage.TypeString drawInRect: CGRectMake(100.5, rect.origin.y + 15 + delta, 40, 11)
			withFont: midGrayFont
			lineBreakMode:UILineBreakModeClip 
			alignment:UITextAlignmentLeft];
	[storage.VolumeString drawInRect: CGRectMake(100.5, rect.origin.y + realHeight - 11 -5, 50, 11)
			withFont: midGrayFont
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft];
	[storage.ProfitString drawInRect: CGRectMake(209, rect.origin.y + 15 + delta, 80, 16)
			withFont: midGrayFont
	   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft];*/

	[ORDER drawInRect: CGRectMake(10, rect.origin.y + realHeight - 17 + delta, 50, 11)
						   withFont: midGrayFont];
	[TYPE drawInRect: CGRectMake(110, rect.origin.y + 13 + delta, 40, 11)
						  withFont: midGrayFont];
	[VOLUME drawInRect: CGRectMake(110, rect.origin.y + realHeight - 17 + delta, 50, 11)
							withFont: midGrayFont];
	[PROFIT_LOSS drawInRect: CGRectMake(209, rect.origin.y + 13 + delta, 80, 16)
							withFont: midGrayFont];
	
	//[temp release];
	
	/*CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
	CGContextMoveToPoint(context, 10.5, rect.origin.y+21.5+delta);
	CGContextAddLineToPoint(context,  295+10.5, rect.origin.y+21.5+delta);		
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, 94.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  94.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, 203.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  203.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);
	
	CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextMoveToPoint(context, 10.5, rect.origin.y+22.5+delta);
	CGContextAddLineToPoint(context,  295+10.5, rect.origin.y+22.5+ delta);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 95.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  95.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, 204.5, rect.origin.y+delta);
	CGContextAddLineToPoint(context,  204.5, rect.origin.y + realHeight);		
	CGContextStrokePath(context);*/
	

	/*CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]);
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x999999FF) CGColor]); 

	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 10);
	CGContextSetTextMatrix(context, myTextTransform); 
	
	[self DrawInRect:@"Type:" context:context drawInRect:CGRectMake(11, rect.origin.y + 30, 32, 11)
				lineBreakMode:UILineBreakModeClip 
				alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
	[self DrawInRect:@"Order#:" context:context drawInRect: CGRectMake(11, rect.origin.y + 43, 32, 11)
				lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
	[self DrawInRect:@"Volume:" context:context drawInRect: CGRectMake(11, rect.origin.y + 56, 50, 11)
				lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
	
	
	[self DrawInRect:@"Open price:" context:context drawInRect: CGRectMake(101, rect.origin.y + 30, 50, 16)
		   lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
	[self DrawInRect:@"Stop loss:" context:context drawInRect: CGRectMake(101, rect.origin.y + 43, 32, 11)
			 lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
	[self DrawInRect:@"Take profit:" context:context drawInRect: CGRectMake(101, rect.origin.y + 56, 50, 11)
			 lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];

	
	[self DrawInRect:@"Close price:" context:context drawInRect: CGRectMake(209, rect.origin.y + 30, 50, 16)
				 lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
	[self DrawInRect:@"Swap:" context:context drawInRect: CGRectMake(209, rect.origin.y + 43, 50, 16)
				lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
	[self DrawInRect:@"Commission:" context:context drawInRect: CGRectMake(209, rect.origin.y +56, 55, 16)
				  lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentLeft
				name:"Helvetica" size:9];
	

	OpenPosWatch * list = (OpenPosWatch*)watch;
	TradeRecord *tr = [list.open_items objectAtIndex: symbol_index];
	
	TickData *td = [[storage Prices] objectForKey:tr.symbol];
	NSString* close_price = (tr.cmd == 0)?td.Bid:td.Ask;

	NSString *temp;
	CGContextSetStrokeColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]);	
	CGContextSetFillColorWithColor(context, [HEXCOLOR(0x000000FF) CGColor]); 
	
	[self DrawInRect:tr.cmd_str context:context drawInRect: CGRectMake(49, rect.origin.y + 29, 40, 12)
				lineBreakMode:UILineBreakModeClip 
				alignment:UITextAlignmentRight
				name:"Helvetica" size:10];
	temp=@"123456";
	temp = [[NSString alloc] initWithFormat:@"%f", tr.order];//temp = [NSString stringWithFormat:@"%d", tr.order];
	[self DrawInRect:temp context:context drawInRect: CGRectMake(40, rect.origin.y + 42, 49, 12)
				lineBreakMode:UILineBreakModeClip 
				alignment:UITextAlignmentRight
				name:"Helvetica" size:10];


	temp = [[NSString alloc] initWithFormat:@"%f", tr.volume];//temp = [storage formatVolume:tr.volume];
	[self DrawInRect:temp context:context drawInRect: CGRectMake(59, rect.origin.y + 55, 30, 12)
				lineBreakMode:UILineBreakModeClip 
				alignment:UITextAlignmentRight
				name:"Helvetica" size:10];
	//return;
	temp = [[NSString alloc] initWithFormat:@"%f", tr.open_price];//temp = [storage formatPrice:tr.open_price forSymbol:tr.symbol] ;
	[self DrawInRect:temp context:context drawInRect: CGRectMake(150, rect.origin.y + 27, 48, 12)
		lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight
			name:"Helvetica-Bold" size:12];
	
	temp = [[NSString alloc] initWithFormat:@"%f", tr.sl];//temp = [storage formatPrice:tr.sl forSymbol:tr.symbol];
	[self DrawInRect:temp context:context drawInRect: CGRectMake(150, rect.origin.y + 41, 48, 12)
		  lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight
			name:"Helvetica-Bold" size:12];

	
	temp = [[NSString alloc] initWithFormat:@"%f", tr.tp];//temp = [storage formatPrice:tr.tp forSymbol:tr.symbol];
	[self DrawInRect:temp context:context drawInRect: CGRectMake(150, rect.origin.y + 54, 48, 12)
		lineBreakMode:UILineBreakModeClip 
		alignment:UITextAlignmentRight
		name:"Helvetica-Bold" size:12];


	
	
	[self DrawInRect:close_price context:context drawInRect: CGRectMake(258, rect.origin.y + 27, 48, 12)
			lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight
			name:"Helvetica-Bold" size:12];
	
 
	temp = [[NSString alloc] initWithFormat:@"%f", tr.storage];//[storage formatProfit:tr.storage];
	[self DrawInRect:temp context:context drawInRect: CGRectMake(258, rect.origin.y + 41, 48, 12)
			lineBreakMode:UILineBreakModeClip 
		    alignment:UITextAlignmentRight
			name:"Helvetica-Bold" size:12]; 

	temp = [[NSString alloc] initWithFormat:@"%f", tr.commission];//temp = [storage formatProfit:tr.commission];
	[self DrawInRect:temp context:context drawInRect: CGRectMake(258, rect.origin.y + 54, 48, 12)
			lineBreakMode:UILineBreakModeClip 
		    alignment:UITextAlignmentRight
			name:"Helvetica-Bold" size:12];

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
	

	//NSDateFormatter *format = [[NSDateFormatter alloc] init];
	//[format setDateFormat:@"dd.MM.yyyy HH:mm"];
	//[self DrawInRect:[format stringFromDate:tr.open_time] context:context drawInRect: CGRectMake(114, rect.origin.y + 8 + delta, 84, 12)
			//lineBreakMode:UILineBreakModeClip
		   //alignment:UITextAlignmentRight
				//name:"Helvetica" size:10];
	//[format release];

	
	//[self DrawInRect:tr.symbol context:context drawInRect: CGRectMake(28, rect.origin.y + 3 + delta, 65, 20)
	//	lineBreakMode:UILineBreakModeClip
	//	alignment:UITextAlignmentLeft
	//	name:"Helvetica" size:15];
	

	if(tr.profit>0)	
		CGContextSetFillColorWithColor(context, [HEXCOLOR(0x00CC00FF) CGColor]);
	else	
		CGContextSetFillColorWithColor(context, [HEXCOLOR(0xCC0000FF) CGColor]);
	
	temp = [[NSString alloc] initWithFormat:@"%f", tr.profit];//temp = [storage formatProfit:tr.profit];
	[self DrawInRect:temp context:context drawInRect: CGRectMake(232, rect.origin.y + 5 + delta, 74, 14)
			lineBreakMode:UILineBreakModeClip 
		   alignment:UITextAlignmentRight
			name:"Helvetica-Bold" size:14];*/


}
@end
