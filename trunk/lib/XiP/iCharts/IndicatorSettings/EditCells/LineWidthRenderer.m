
#import "LineWidthRenderer.h"
#import <QuartzCore/QuartzCore.h>


@implementation LineWidthRenderer
@synthesize isSelected, item_index;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        isSelected = false;
        item_index = -1;
        self.layer.backgroundColor = [[UIColor clearColor] CGColor];
        self.opaque = false;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{    
    if(item_index==-1)
        return;
    if(item_index >= 6)
        return;

    int lineWidth = item_index+1;
    CGFloat XScale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        XScale = [UIScreen mainScreen].scale;
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, XScale);
    }
    else 
        UIGraphicsBeginImageContext(rect.size);
    double pen_1px = 1/XScale; //a dirty hack to have perfect 1px lines on retina
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, pen_1px);
    
    CGContextSetShouldAntialias(context, false);
    //fill background
    //CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    //CGContextFillRect(context, rect); 
    
    double padding = 10;
    CGContextSetLineWidth(context, lineWidth*pen_1px);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);

    CGContextMoveToPoint(   context,  
                            rect.origin.x + padding, 
                            rect.origin.y + (rect.size.height - lineWidth*pen_1px)/2 + lineWidth*pen_1px/2
                         );
    CGContextAddLineToPoint(context, 
                            rect.origin.x + rect.size.width - padding, 
                            rect.origin.y + (rect.size.height - lineWidth*pen_1px)/2 + lineWidth*pen_1px/2
                            );
    CGContextStrokePath(context);

    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();   
	[img drawInRect: rect];
    
}

- (void)setSelectedElement:(BOOL)selected
{
    self.isSelected = selected;
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [super dealloc];
}

@end
