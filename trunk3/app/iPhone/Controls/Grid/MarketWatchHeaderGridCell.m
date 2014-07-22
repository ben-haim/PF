
#import "MarketWatchHeaderGridCell.h"
#import "ClientParams.h"

#define SYMBOLSTR (NSLocalizedString(@"SYMBOL", nil))
#define ASKSTRING (NSLocalizedString(@"RATES_ASK", nil))
#define BIDSTRING (NSLocalizedString(@"RATES_BID", nil))


@implementation MarketWatchHeaderGridCell

/*-(MarketWatchHeaderGridCell *)init
{
	isGroupRow = NO;
	isSelected = NO;
	Height = 33;

	return self;
}
  
-(void)Draw:(CGRect)rect
{
	[super Draw:rect];

	UIImage *header = (UIImage*)[dataCacheDelegate getFromCache:@"market_header_img"];
	if(header==nil)
	{
		header = [UIImage imageNamed:@"market_header.png"];
		[dataCacheDelegate putToCache:@"market_header_img" AndCell:header];
	}	
	CGRect headerRect = rect;
	headerRect.origin.x = 0;
	headerRect.origin.y = 0; //rect.origin.y + (rect.size.height-header.size.height)/2;
	//headerRect.size.width = header.size.width;
	//headerRect.size.height = header.size.height;
	[header drawInRect: headerRect];
		
}*/

-(id)init
{
	[super init];
	CGRect r = CGRectMake(0, 0, 320, 33);
	[self setFrame:r];
	
	return self;
}

-(void)drawRect:(CGRect)rect
{
	//[super drawRect];
	//UIImage *header = (UIImage*)[dataCacheDelegate getFromCache:@"market_header_img"];
	//if(header==nil)
	//{
	//	header = [UIImage imageNamed:@"market_header.png"];
	//	[dataCacheDelegate putToCache:@"market_header_img" AndCell:header];
	//}	
	
	UIImage *header = [ClientParams marketWatchHeaderImage];
	
	CGRect headerRect = rect;
	headerRect.origin.x = 0;
	headerRect.origin.y = 0; //rect.origin.y + (rect.size.height-header.size.height)/2;
	//headerRect.size.width = header.size.width;
	//headerRect.size.height = header.size.height;
	[header drawInRect: headerRect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);     
	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]); 
	/*CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 10);
	CGContextSetTextMatrix(context, myTextTransform); 
	CGContextSelectFont(context, "Helvetica-Bold", 17, kCGEncodingMacRoman); 
	
	CGContextSetTextDrawingMode(context, kCGTextFill); 
	CGContextSetTextPosition(context, 20, rect.origin.y + 36+delta );*/
	
	UIFont *priceFont2 = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];

	
	[SYMBOLSTR drawInRect: CGRectMake(20, 5, 80, 20) withFont:priceFont2];
	[BIDSTRING drawInRect: CGRectMake(137, 5, 70, 20) withFont:priceFont2 lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
	[ASKSTRING drawInRect: CGRectMake(237, 5, 70, 20) withFont:priceFont2 lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
	
}

@end
