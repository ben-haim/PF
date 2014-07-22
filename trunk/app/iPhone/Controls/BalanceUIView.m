

#import "BalanceUIView.h"
#import "ClientParams.h"


@implementation BalanceUIView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	int offset = -1;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	
	CGContextSetLineWidth(context, 1);
	CGFloat dash[1]; // = {1};	
	dash[0] = [[ClientParams cellBalanceLineDash] floatValue]; //1;
	
	//CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineDash(context, 0.0, dash, 1);
	
	CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
	
	CGContextMoveToPoint(context, 10, rect.origin.y+33.5 + offset);
	CGContextAddLineToPoint(context, 310, rect.origin.y+33.5 + offset);
	CGContextStrokePath(context);
	
	//CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	CGContextMoveToPoint(context, 10, rect.origin.y + 63.5 + offset);
	CGContextAddLineToPoint(context,  310, rect.origin.y + 63.5 + offset);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 10, rect.origin.y + 93.5 + offset);
	CGContextAddLineToPoint(context,  310, rect.origin.y + 93.5 + offset);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 203.5, rect.origin.y + 10 + offset);
	CGContextAddLineToPoint(context,  203.5, rect.origin.y + 120 + offset);		
	CGContextStrokePath(context);
	
	
	CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	
	CGContextMoveToPoint(context, 10, rect.origin.y+32.5 + offset);
	CGContextAddLineToPoint(context, 310, rect.origin.y+32.5 + offset);
	CGContextStrokePath(context);
	
	//CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
	CGContextMoveToPoint(context, 10, rect.origin.y + 62.5 + offset);
	CGContextAddLineToPoint(context,  310, rect.origin.y + 62.5 + offset);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 10, rect.origin.y + 92.5 + offset);
	CGContextAddLineToPoint(context,  310, rect.origin.y + 92.5 + offset);		
	CGContextStrokePath(context);
	
	
	CGContextMoveToPoint(context, 202.5, rect.origin.y + 10 + offset);
	CGContextAddLineToPoint(context,  202.5, rect.origin.y + 120 + offset);		
	CGContextStrokePath(context);

}

@end
