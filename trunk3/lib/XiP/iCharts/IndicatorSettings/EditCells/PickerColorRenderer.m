
#import "PickerColorRenderer.h"
#import <QuartzCore/QuartzCore.h>


@implementation PickerColorRenderer
@synthesize colors, isSelected, item_index;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        isSelected = false;
        item_index = -1;
        colors = nil;
        self.layer.backgroundColor = [[UIColor clearColor] CGColor];
        self.opaque = false;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{    
    if(colors==nil || item_index==-1)
        return;
    if(item_index >= [colors count])
        return;
    uint icolor = (uint)[[colors objectAtIndex:item_index] intValue];
    
    
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
    
    
    bool isClearColor = (icolor==0x00000000);
    
    double iconSize = 13;
    CGRect currentBounds = CGRectMake(rect.origin.x + (rect.size.width - iconSize)/2, 
                                      rect.origin.y + (rect.size.height - iconSize)/2, 
                                      iconSize, iconSize);
    if(!isClearColor)
    {
        CGContextSetFillColorWithColor(context, [HEXCOLOR(icolor) CGColor]);
        CGContextFillRect(context, currentBounds);
    }
    CGContextAddRect(context, currentBounds);
    if(isClearColor)
    {
        CGContextMoveToPoint(context, currentBounds.origin.x, currentBounds.origin.y);
        CGContextAddLineToPoint(context, currentBounds.origin.x+iconSize, currentBounds.origin.y+iconSize);
        CGContextMoveToPoint(context, currentBounds.origin.x+iconSize, currentBounds.origin.y);
        CGContextAddLineToPoint(context, currentBounds.origin.x, currentBounds.origin.y+iconSize);
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
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
    if(colors)
        [colors release];
    [super dealloc];
}

@end
