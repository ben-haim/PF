
#import "LineDashRenderer.h"
#import <QuartzCore/QuartzCore.h>


@implementation LineDashRenderer
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
    if(item_index >= 5)
        return;

    int lineDash = item_index;
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
	CGContextSetLineWidth(context, 2*pen_1px);
    
    CGContextSetShouldAntialias(context, false);
    //fill background
    //CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    //CGContextFillRect(context, rect); 
    
    
    
    switch (lineDash) 
    {
        case 1:
        {
            CGFloat dashLengths[] = CHART_DASH_1;
            CGContextSetLineDash(	context, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
            break;
        case 2:
        {
            CGFloat dashLengths[] = CHART_DASH_2;
            CGContextSetLineDash(	context, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
            break;
        case 3:
        {
            CGFloat dashLengths[] = CHART_DASH_3;
            CGContextSetLineDash(	context, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
            break;
        case 4:
        {
            CGFloat dashLengths[] = CHART_DASH_4;
            CGContextSetLineDash(	context, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
            break;
            
        default:
            break;
    }
    double padding = 10;
    
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);

    CGContextMoveToPoint(   context,  
                            rect.origin.x + padding, 
                            rect.origin.y + rect.size.height/2
                         );
    CGContextAddLineToPoint(context, 
                            rect.origin.x + rect.size.width - padding, 
                            rect.origin.y + rect.size.height/2
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
