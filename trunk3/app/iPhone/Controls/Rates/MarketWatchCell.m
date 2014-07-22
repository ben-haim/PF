
#import "MarketWatchCell.h"


@implementation MarketWatchCell

@synthesize lblSymbol;
@synthesize lblBid;
@synthesize lblAsk;
@synthesize lblHigh;
@synthesize lblLow;
@synthesize imgArrow;

@synthesize lblTitleAsk;
@synthesize lblTitleBid;
@synthesize lblTitleHigh;
@synthesize lblTitleLow;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
	{
        // Initialization code
		
    }
    return self;
}

-(void)setIsUp:(BOOL)up
{
	isUP = up;
}
- (NSString *) reuseIdentifier 
{
	if(isUP)
		return @"MWPriceUp";
	else
		return @"MWPriceDown";
		
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)drawRect:(CGRect)rect
//{
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
//	CGContextBeginPath(context);
	
	//CGContextMoveToPoint(context, lblSymbol.bounds.origin.x + lblSymbol.bounds.size.width + 5, rect.origin.y);
	///CGContextAddLineToPoint(context, lblSymbol.bounds.origin.x + lblSymbol.bounds.size.width + 5, rect.origin.y + rect.size.height);
	////CGContextStrokePath(context);
	//CGContextFlush(context);
//}
- (IBAction) btnTrade_Clicked:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"tradeInstrument" object:lblSymbol.titleLabel];	
}
- (void)dealloc {
    [super dealloc];
}


@end
