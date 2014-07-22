
#import "ToolbarSegDashboard.h"
#import "ToolbarButtonSegment.h"
#import <XiPFramework/PropertiesStore.h>
#import "PlotToolbar.h"


@implementation ToolbarSegDashboard
@synthesize parent_segment, tb_delegate;

- (id)initWithScale:(float)scale AndDelegate:(id)_tb_delegate
{
    self= [super init];
    if (self) 
    { 
        float pen_1px           = 1/scale;
        parent_segment          = nil;
        self.backgroundColor    = [HEXCOLOR(0x00000000) CGColor];
        self.opacity            = CHART_DASH_OPACITY;
        self.borderColor        = [HEXCOLOR(CHART_DASH_BORDER_COLOR) CGColor];//FFFFFF9E
        self.borderWidth        = 1*pen_1px;
        self.cornerRadius       = CHART_BTN_RADIUS+1;
        self.contentsScale      = scale;   
        self.contentsGravity    = kCAGravityLeft;
        self.shadowOffset       = CGSizeMake(0, 4*pen_1px);
        self.shadowOpacity      = 0.6;
        self.tb_delegate        = _tb_delegate;
        //self.masksToBounds      = YES;
        self.needsDisplayOnBoundsChange = YES;
        //self.anchorPoint        = CGPointMake(0, 0);
        [self setNeedsDisplay];
        
    }
	return self;
	
}

- (id) initWithLayer:(id)layer 
{
    self = [super initWithLayer:layer];
    if(self)
    {
        if([layer isKindOfClass:[ToolbarSegDashboard class]]) 
        {
            ToolbarSegDashboard *other = (ToolbarSegDashboard*)layer;
            self.parent_segment     = other.parent_segment;
            self.contentsScale      = other.contentsScale;
            self.anchorPoint        = other.anchorPoint;
            self.borderColor        = other.borderColor;
            self.borderWidth        = other.borderWidth;
            self.tb_delegate        = other.tb_delegate;
        }
    }
    return self;
}

- (void)dealloc 
{
	/*if(segments!=nil && shouldCleanData)
     {
     [segments removeAllObjects];
     [segments release];
     segments = nil;
     }*/
    [super dealloc];
}
CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius) 
{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    
    return path;        
}
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor) 
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

void drawLinearGloss(CGContextRef context, CGRect rect, BOOL reverse) 
{
    
	CGColorRef highlightStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35].CGColor;
	CGColorRef highlightEnd = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
    
    if (reverse) {
		
		CGRect half = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height/2, rect.size.width, rect.size.height/2);    
		drawLinearGradient(context, half, highlightEnd, highlightStart);
	}
	else {
		CGRect half = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);    
		drawLinearGradient(context, half, highlightStart, highlightEnd);
	}
    
}
void drawCurvedGloss(CGContextRef context, CGRect rect, CGFloat radius) 
{
    
    CGColorRef glossStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6].CGColor;
    CGColorRef glossEnd = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
    
    CGMutablePathRef glossPath = CGPathCreateMutable();
    
    CGContextSaveGState(context);
    CGPathMoveToPoint(glossPath, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect)-radius+rect.size.height/2);
    CGPathAddArc(glossPath, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect)-radius+rect.size.height/2, radius, 0.75f*M_PI, 0.25f*M_PI, YES); 
    CGPathCloseSubpath(glossPath);
    CGContextAddPath(context, glossPath);
    CGContextClip(context);
    CGMutablePathRef path2 = createRoundedRectForRect(rect, CHART_BTN_RADIUS-1);
    CGContextAddPath(context, path2);
    CGContextClip(context);
    
    CGRect half = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);    
    
    
    drawLinearGradient(context, half, glossStart, glossEnd);
    CGContextRestoreGState(context);
    CGPathRelease(glossPath);
    CGPathRelease(path2);
}

- (void)drawInContext:(CGContextRef)ctx
{
    if(parent_segment==nil)
        return;
    
    CGContextRef context = nil;
    double pen_1px = 1; 
    UIFont* font = [UIFont systemFontOfSize:CHART_BTN_FONT_BASE_SIZE];

    //prepare with screen settings 
    CGFloat XScale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        XScale = [UIScreen mainScreen].scale;
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, XScale);
    }
    else 
        UIGraphicsBeginImageContext(self.bounds.size);    
    pen_1px = 1/XScale; 
    context = UIGraphicsGetCurrentContext();
    
    //define our boundaries
    CGMutablePathRef white_frame = createRoundedRectForRect( CGRectInset(self.bounds, 3*pen_1px, 3*pen_1px) , CHART_BTN_RADIUS);
    CGMutablePathRef white_frame2 = createRoundedRectForRect( CGRectInset(self.bounds, 2*pen_1px, 2*pen_1px) , CHART_BTN_RADIUS);
    
    //fill bg with rounded corners
    CGContextAddPath(context, white_frame);
    CGContextSetFillColorWithColor(context, [HEXCOLOR(CHART_DASH_BG_COLOR) CGColor]);
    CGContextFillPath(context);
    
    //stroke our white border
    CGContextAddPath(context, white_frame2);
    CGContextSetLineWidth(context, 4*pen_1px);
    CGContextSetStrokeColorWithColor(context, [HEXCOLOR(CHART_DASH_WHITE_BORDER) CGColor]);
    CGContextStrokePath(context);  
     
    
    CGContextSaveGState(context);
    UIGraphicsPushContext(context);  
    CGContextAddPath(context, white_frame);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, [HEXCOLOR(CHART_DASH_FONT_COLOR) CGColor]); 
    CGContextSelectFont(context, [font.fontName UTF8String], CHART_BTN_FONT_BASE_SIZE, kCGEncodingMacRoman);
    CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
    CGContextSetTextMatrix(context, myTextTransform);
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationDefault);
    
    
    for(int r=0; r < parent_segment.rows_count; r++)
    for(int c=0; c < parent_segment.cols_count; c++)
    {
        ToolbarButtonSegment *seg = [self.parent_segment.subsegments objectAtIndex:r*parent_segment.cols_count + c];
        CGRect rect = [self getCellRectAtRow:r AndCol:c AndDPI:pen_1px];
                       
        //draw highlight bg
        if(seg.isDown)
        {                
            CGContextSetFillColorWithColor(context, HEXCOLOR(CHART_DASH_TINT_COLOR).CGColor);
            CGContextFillRect(context, rect);       
        }
        if(seg.text!=nil)
        {
            uint fontcolor = seg.isDown?CHART_DASH_SEL_FONT_COLOR:CHART_DASH_FONT_COLOR;
            CGContextSetFillColorWithColor(context, [HEXCOLOR(fontcolor) CGColor]);
            
            //measure the string
            CGContextSetTextDrawingMode(context, kCGTextInvisible); 
            CGContextSetTextPosition(context, rect.origin.x, rect.origin.y);
            CGContextShowText(context, [seg.text UTF8String], strlen([seg.text UTF8String]));
            
            CGPoint pt = CGContextGetTextPosition(context);	
            float textPixelLength = pt.x - rect.origin.x;
            float textPixelHeight = font.capHeight;
            
            float textHPos = rect.origin.x + (rect.size.width - ((c==0 || c==parent_segment.cols_count-1)?4*pen_1px:0) - textPixelLength)/2.0;
            float textVPos = rect.origin.y + (rect.size.height - ((r==0 || r==parent_segment.rows_count-1)?4*pen_1px:0) -textPixelHeight)/2.0;
            
            //draw the string
            CGContextSetTextDrawingMode(context, kCGTextFill); 
            
            CGContextSetTextPosition(context, textHPos, textVPos + textPixelHeight); 
            CGContextShowText(context, [seg.text UTF8String], strlen([seg.text UTF8String]));
        }
        else
        {           
            //UIGraphicsPushContext(context);
            
            //increase transparency
            //CGContextBeginTransparencyLayer(context, nil);
            CGContextSetAlpha( context, (seg.isDown)?CHART_BTN_SEL_OPACITY:CHART_BTN_NORM_OPACITY );
            
            //give it some tint
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            
            CGRect rect2 = CGRectMake(rect.origin.x + (rect.size.width - seg.image.size.width) / 2, 
                                      self.bounds.size.height - rect.origin.y - (rect.size.height + seg.image.size.height) / 2, 
                                      seg.image.size.width, 
                                      seg.image.size.height);
            
            CGContextClipToMask(context, rect2, seg.image.CGImage);
            uint fontcolor = seg.isDown?CHART_BTN_SEL_ICON_COLOR:CHART_BTN_ICON_COLOR;
            CGContextSetFillColorWithColor(context, [HEXCOLOR(fontcolor) CGColor]);
            CGContextFillRect(context, rect2);
            CGContextRestoreGState(context);   
            
            //CGContextEndTransparencyLayer(context); 
            //UIGraphicsPopContext();            
        }
    }
     
    UIGraphicsPopContext();
    CGContextRestoreGState(context); 
    
    //draw top gloss
    CGFloat outerMargin = 4*pen_1px;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);
    outerRect.size.height = self.bounds.size.height / 3.0;
    drawCurvedGloss(context, outerRect, 2*self.bounds.size.width);
    CGContextClipToRect(context, self.bounds);  

    
    //draw a grid of segments
    CGContextSetLineWidth(context, pen_1px);
    CGContextSetShouldAntialias(context, false);
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    for(int r=0; r<parent_segment.rows_count-1; r++)
    {              
            CGRect rect = [self getCellRectAtRow:r AndCol:0 AndDPI:pen_1px];  
            CGContextSetStrokeColorWithColor(context, [HEXCOLOR(CHART_DASH_GRID_WHITE) CGColor]);
            CGContextMoveToPoint(   context,  
                                    self.bounds.origin.x,
                                    rect.origin.y + rect.size.height);
            CGContextAddLineToPoint(context, 
                                    (self.bounds.origin.x) + self.bounds.size.width, 
                                    rect.origin.y + rect.size.height);
            CGContextStrokePath(context);     
            
            
            CGContextSetStrokeColorWithColor(context, [HEXCOLOR(CHART_DASH_GRID_BLACK) CGColor]);
            CGContextMoveToPoint(   context,  
                                 self.bounds.origin.x,
                                 rect.origin.y + rect.size.height - pen_1px);
            CGContextAddLineToPoint(context, 
                                    (self.bounds.origin.x) + self.bounds.size.width, 
                                    rect.origin.y + rect.size.height - pen_1px);
            CGContextStrokePath(context);    
        }
    for(int c=0; c<parent_segment.cols_count-1; c++)
    {        
            CGRect rect = [self getCellRectAtRow:0 AndCol:c AndDPI:pen_1px]; 
            CGContextSetStrokeColorWithColor(context, [HEXCOLOR(CHART_DASH_GRID_WHITE) CGColor]);    
            CGContextMoveToPoint(   context,  
                                    rect.origin.x + rect.size.width,
                                    (self.bounds.origin.y));
            CGContextAddLineToPoint(context, 
                                    rect.origin.x + rect.size.width, 
                                    (self.bounds.origin.y) + self.bounds.size.height);
            CGContextStrokePath(context);    
            
            
            CGContextSetStrokeColorWithColor(context, [HEXCOLOR(CHART_DASH_GRID_BLACK) CGColor]);    
            CGContextMoveToPoint(   context,  
                                 rect.origin.x + rect.size.width - pen_1px,
                                 (self.bounds.origin.y));
            CGContextAddLineToPoint(context, 
                                    rect.origin.x + rect.size.width - pen_1px, 
                                    (self.bounds.origin.y) + self.bounds.size.height);
            CGContextStrokePath(context);    
        }        
    
    //UIGraphicsPopContext();     
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 

    
    
    CGContextTranslateCTM(ctx, 
                          0.0, 
                          self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(ctx, self.bounds, img.CGImage);
    CGPathRelease(white_frame);
    CGPathRelease(white_frame2);
}

- (CGRect)getCellRectAtRow:(int)r AndCol:(int)c AndDPI:(float)pen_1px
{
    CGRect rect = CGRectMake(self.bounds.origin.x + 4*pen_1px + c*CHART_DASH_BTNSEG_WIDTH, 
                             self.bounds.origin.y + r*CHART_DASH_BTNSEG_HEIGHT, 
                             CHART_DASH_BTNSEG_WIDTH, 
                             CHART_DASH_BTNSEG_HEIGHT); 
    return rect;
}

- (struct HitTestInfo)hitTestSegment:(CGPoint)where
{
    struct HitTestInfo res; 
    for (ToolbarButtonSegment *seg in self.parent_segment.subsegments) 
    {
        seg.isDown = false;
    }
    for(int r=0; r < parent_segment.rows_count; r++)
    for(int c=0; c < parent_segment.cols_count; c++)
    {
        ToolbarButtonSegment *seg = [self.parent_segment.subsegments objectAtIndex:r*parent_segment.cols_count + c];
        CGRect rect = [self getCellRectAtRow:r AndCol:c AndDPI:1];
        CGRect r = rect;
        
        if(CGRectContainsPoint(r, where))
        {
            res.btn = self.parent_segment.btn;
            res.seg = self.parent_segment;
            self.parent_segment.selectedSegmentTag = seg.action;
            seg.isDown = true;
            [self setNeedsDisplay];
            return res;
        }
    }
    return res;
}
@end
