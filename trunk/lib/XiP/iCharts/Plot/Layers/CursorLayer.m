
#import "CursorLayer.h" 
#import "../XYChart.h"
#import "../FinanceChart.h"
#import "PropertiesStore.h"
#import "Axis.h"
#import "PlotArea.h"


@implementation ChartCursor
@synthesize key, color, x, y, index;

- (id)initWithKey:(NSString*)_key AndColor:(uint)_color
{
    self = [super init];
    if(self ==  nil)
        return self;
    self.x      = 0;
    self.y      = 0;
    self.index  = 0;
    [self setKey:_key];
    self.color  = _color;
    return self;
}

- (void)dealloc
{	
    [key release];
	[super dealloc];    
}
@end

@implementation CursorLayer
@synthesize parentChart, loupeWindow, chartCursors, chartCursorVisible, cursorX, cursorY, glass, mask;


- (id)initWithParentChart:(XYChart*)_parentChart
{
    self = [super init];
    if(self == nil)
        return self;
    self.parentChart        = _parentChart;
    self.chartCursors       = [[[NSMutableArray alloc] init] autorelease];
    self.chartCursorVisible = false;
    
    mask                    = [[UIImage imageNamed: @"loupe_alpha_mask.png"] retain];
    glass                   = [[UIImage imageNamed: @"loupe"] retain];
    loupeWindow             = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, glass.size.width, glass.size.height)];
    loupeWindow.windowLevel = UIWindowLevelStatusBar;
    loupeWindow.hidden = YES;

    
    CALayer* glassContainer           = [CALayer layer]; 
    glassContainer.frame              = loupeWindow.layer.frame;
    glassContainer.bounds             = loupeWindow.layer.bounds;
    glassContainer.anchorPoint        = CGPointMake(0,0);
    glassContainer.position           = CGPointMake(0, 0);
    glassContainer.contents           = (id)glass.CGImage;    
    glassContainer.borderWidth        = 0.0;
    [loupeWindow.layer addSublayer:glassContainer];
    
    
    
    CALayer* maskLayer                = [CALayer layer];    
    maskLayer.frame                   = CGRectMake(0, 0, glass.size.width, glass.size.height);
    maskLayer.anchorPoint             = CGPointMake(0,0);  
    maskLayer.position                = CGPointMake(0, 0);
    [maskLayer setContents:(id)mask.CGImage];  
    [loupeWindow.layer setMask:maskLayer];

    return self;
}

- (void)dealloc
{	
    [chartCursors removeAllObjects];
    [chartCursors release];
    [glass release];
    [mask release];
    [loupeWindow release];
	[super dealloc];    
}

- (void)showLoupe
{    
    CGPoint pt;
    
//    double cursor_intX = NAN;
//    for(ChartCursor *iCursor in chartCursors)
//    {
//        if(!isnan(iCursor.x))
//        {
//            cursor_intX = iCursor.x;
//            break;
//        }
//    }
    
    pt.x = cursorX - glass.size.width/2;
    pt.y = cursorY - glass.size.height;
    
    
    if(!CGRectContainsPoint(parentChart.plotArea.plot_rect, CGPointMake(parentChart.plotArea.plot_rect.origin.x+1, cursorY)))
    {
        loupeWindow.hidden = YES;
        return;
    }
    
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint worldCoords = [mainWindow convertPoint:pt fromView:self.parentChart.parentFChart];
    //loupeWindow.frame = CGRectMake(worldCoords.x, worldCoords.y, glass.size.width, glass.size.height);


   UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];//self.parentChart.parentFChart.lastOrientation;// [[UIDevice currentDevice] orientation];
    double angle = 0;
    double deltaX = worldCoords.x;
    double deltaY = worldCoords.y; 
    if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        angle = M_PI;
        deltaX -= loupeWindow.bounds.size.width;
        deltaY -= loupeWindow.bounds.size.width;
    }
    else
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        angle = -M_PI/2.0;
        deltaY -= loupeWindow.bounds.size.width;
    }
    else
    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        angle = M_PI/2.0;
        deltaX -= loupeWindow.bounds.size.width;
    }
    
    //loupeWindow.transform = CGAffineTransformMakeRotation (angle);
    loupeWindow.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(deltaX, deltaY), angle);
    loupeWindow.hidden = NO; 
}
- (void)hideLoupe
{    
    loupeWindow.hidden = YES;    
}


- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
            drawLoupe:(bool)onlyLoupe
{

    ///
    if(!self.chartCursorVisible)
        return; 
    
    PropertiesStore* style = self.parentChart.parentFChart.properties;
    CGColorRef rectColor = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_cursor_color"]) CGColor];
    CGColorRef textColor = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_cursor_textcolor"]) CGColor];
    CGColorRef lineColor = [HEXCOLOR(0xFFFFFFFF) CGColor];
    CGContextSetLineWidth(ctx, pen_1px);
    
    int c=0;
    double cursor_intX = NAN;
    for(ChartCursor *iCursor in chartCursors)
    {
        cursor_intX = iCursor.x;
        if(!onlyLoupe)
        {
            if(c==0)
            {
                //X cursor
                CGContextSaveGState(ctx);        
                CGContextSetBlendMode(ctx, kCGBlendModeDifference);  
                //draw vectical cursor line		
                CGContextSetStrokeColorWithColor(ctx, lineColor);
                CGContextMoveToPoint(ctx, iCursor.x, rect.origin.y);
                CGContextAddLineToPoint(ctx, iCursor.x, rect.origin.y+rect.size.height-pen_1px);
                CGContextDrawPath( ctx, kCGPathStroke);
                
                CGContextRestoreGState(ctx);
                
                //draw the time  
                if(self.parentChart == self.parentChart.parentFChart.mainChart)
                {
                    [parentChart.parentFChart.xAxis drawCursorTimeInContext:ctx 
                                                                  WithIndex:iCursor.index 
                                                              WithFillColor:rectColor 
                                                              WithTextColor:textColor 
                                                                     AndDPI:pen_1px];
                }
                
                //Y cursor
                if(CGRectContainsPoint(rect, CGPointMake(rect.origin.x+1, cursorY)))
                {
                    CGContextSaveGState(ctx);        
                    CGContextSetBlendMode(ctx, kCGBlendModeDifference);  
                    
                    //draw horizontal cursor line		
                    CGContextSetStrokeColorWithColor(ctx, lineColor);
                    CGContextMoveToPoint(ctx, rect.origin.x+pen_1px, cursorY);
                    CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width, cursorY);
                    CGContextDrawPath( ctx, kCGPathStroke);
                    CGContextRestoreGState(ctx);
                    
                    //draw the price
                    [self.parentChart.yAxis drawCursorPriceInContext:ctx 
                                                               WithY:cursorY 
                                                       WithFillColor:rectColor 
                                                       WithTextColor:textColor 
                                                              AndDPI:pen_1px];
                }
            }
           
            if(!isnan(iCursor.y))
            { 
                //draw circle 
                CGContextSetShouldAntialias(ctx, true);
                CGContextSetFillColorWithColor(ctx, [HEXCOLOR(iCursor.color) CGColor]);
                CGContextFillEllipseInRect(ctx, 
                                           CGRectMake(iCursor.x - CHART_CURSOR_RADIUS, 
                                                      iCursor.y - CHART_CURSOR_RADIUS, 
                                                      2*CHART_CURSOR_RADIUS,
                                                      2*CHART_CURSOR_RADIUS)
                                           );
                CGContextSetStrokeColorWithColor(ctx, rectColor);
                CGContextStrokeEllipseInRect(ctx, 
                                             CGRectMake(iCursor.x - CHART_CURSOR_RADIUS, 
                                                        iCursor.y - CHART_CURSOR_RADIUS, 
                                                        2*CHART_CURSOR_RADIUS,
                                                        2*CHART_CURSOR_RADIUS)
                                             );
                CGContextSetShouldAntialias(ctx, false);
            }   
        }
        c++;
    }
    if(onlyLoupe)
    {
        //draw loupe   
        if(isnan(cursor_intX) ||
           !CGRectContainsPoint(rect, CGPointMake(rect.origin.x+1, cursorY)))
            return; 
                                            

        CGRect rect_to_zoom = CGRectMake((cursorX - self.parentChart.parentFChart.contentOffset.x - glass.size.width/4)/pen_1px, 
                                         (cursorY - glass.size.height/4)/pen_1px, 
                                         (glass.size.width/2)/pen_1px, 
                                         (glass.size.height/2)/pen_1px);

        
        UIImage *img_to_zoom = UIGraphicsGetImageFromCurrentImageContext();
        UIImage *croppedImage = [self cropImage:img_to_zoom toRect:rect_to_zoom];    
        if(croppedImage!=nil)
            loupeWindow.layer.contents = (id)(croppedImage.CGImage);
        else
            [self hideLoupe];
    }
} 
static inline double radians (double degrees) {return degrees * M_PI/180;}
-(UIImage*)cropImage:(UIImage*)originalImage toRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([originalImage CGImage], rect);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    CGContextRef bitmap = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    
    if (originalImage.imageOrientation == UIImageOrientationLeft) 
    {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -rect.size.height);
        
    } else if (originalImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -rect.size.width, 0);
        
    } else if (originalImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (originalImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, rect.size.width, rect.size.height);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    int img_width = (int)CGImageGetWidth(imageRef);
    int img_height = (int)CGImageGetHeight(imageRef);
    CGContextSetFillColorWithColor(bitmap, [UIColor darkGrayColor].CGColor);
    CGContextFillRect(bitmap, CGRectMake(0, 0, rect.size.width, rect.size.height));
    CGContextDrawImage(bitmap, CGRectMake(((rect.origin.x<0)?1:-1)*(rect.size.width - img_width), 
                                          ((rect.origin.y<0)?-1:1)*(rect.size.height - img_height), 
                                          img_width, 
                                          img_height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    
    UIImage *resultImage=[UIImage imageWithCGImage:ref];
    CGImageRelease(imageRef);
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return resultImage;
}

-(void)setChartCursorValue:(NSString*)key pX:(double)_x pY:(double)_y Index:(int)_i
{
    for(ChartCursor* cur in chartCursors)
    {
        if([cur.key isEqualToString:key])
        {
            cur.x = _x;
            if(isnan(_y))
                cur.y   = _y;
            else
                cur.y   = _y; 
            cur.index = _i;      
        }
    }
}


-(void)setChartCursorKey:(NSString*)key AndColor:(uint)_color
{
    if (key == nil || [key length]==0)
        return;
    ChartCursor *cur = [[ChartCursor alloc] initWithKey:key AndColor:_color];
    [chartCursors addObject:cur];
    [cur release];
}
@end
