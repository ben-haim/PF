
#import "ToolbarButtonSegment.h"
#import <XiPFramework/PropertiesStore.h>
#import "PlotToolbar.h"

@implementation ToolbarButtonSegment
@synthesize action, text, image, isDown, isVisible, subsegments, selectedSegmentTag, rows_count, cols_count; 
@synthesize tb_delegate, btn;
-(id) init
{
	self = [super init];
    if(self)
    {
        action = ID_SEG_NONE; 
        text = nil;
        image = nil;
        isDown = false;
        isVisible = true;
        subsegments = [[NSMutableArray alloc] init];
        selectedSegmentTag = ID_SEG_NONE;
        rows_count = 0;
        cols_count = 0;
    }
    return self;
}

- (void)dealloc 
{
	if(text!=nil)
		[text release];
	if(image!=nil)
		[image release];
	if(subsegments!=nil)
		[subsegments release];
    [super dealloc];
}

- (ToolbarButtonSegment *) hitTestSegment:(CGPoint)where
{
    
    return nil;
}

- (ToolbarButtonSegment*)addSubSegment:(uint)Action WithText:(NSString*)Text AndImage:(UIImage*)Image
{
    if(selectedSegmentTag == ID_SEG_NONE)
        selectedSegmentTag = Action;    //make the first added segment to be selected
    
    ToolbarButtonSegment *seg = [[ToolbarButtonSegment alloc] init];
    seg.action  = Action;
    seg.image   = Image;
    seg.text    = Text;
    [subsegments addObject:seg];
    [seg release];
    return [subsegments objectAtIndex:[subsegments count]-1];
}

- (ToolbarButtonSegment *) GetSegmentWithAction:(uint)_action
{
    ToolbarButtonSegment* res_seg = nil;
    for (int i=0; i<[subsegments count]; i++)
    {
        ToolbarButtonSegment *seg = [subsegments objectAtIndex:i];
        if(seg.action == _action)
        {
            res_seg = seg;
            break;
        }
    }
    return res_seg;
}

- (void)drawInContext:(CGContextRef)ctx 
                InRect:(CGRect)rect
                IconXOffset:(int)icon_offset
                Line1px:(float)line1px
                AndSeparatorIsShown:(BOOL)isSeparatorShown 
                IsSelected:(BOOL)isSelected;
{ 
    if(selectedSegmentTag!= ID_SEG_NONE)
    {
        ToolbarButtonSegment* res_seg = [self GetSegmentWithAction:selectedSegmentTag];
        [res_seg drawInContext:ctx 
                    InRect:rect 
                    IconXOffset:icon_offset 
                    Line1px:line1px 
                    AndSeparatorIsShown:isSeparatorShown 
                    IsSelected:isSelected];
        return;
    }
    if(image!=nil)
    {
        CGRect draw_icon_rect = CGRectMake(rect.origin.x + (rect.size.width - CHART_BTN_ICON_SIZE)/2.0-icon_offset, 
                                           rect.origin.y + (rect.size.height - CHART_BTN_ICON_SIZE)/2.0, 
                                           CHART_BTN_ICON_SIZE, 
                                           CHART_BTN_ICON_SIZE);
        if(isSeparatorShown)
        {
            CGContextSaveGState(ctx);
            CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
            CGFloat components [12] = { 0.0, 0.0, 0.0, 0.5,
                                        0.5, 0.5, 0.5, 0.5,
                                        1.0, 1.0, 1.0, 0.3};
            CGFloat locations[3] =  {0.0, 0.5, 1};
            
            CGGradientRef gradient =
            CGGradientCreateWithColorComponents(colorSpace,
                                                components,
                                                locations,
                                                (size_t)3);
            
            CGContextClipToRect(ctx, CGRectMake(Round_05(rect.origin.x) + rect.size.width, 
                                                rect.origin.y, 
                                                line1px, 
                                                rect.size.height-1));
            CGContextDrawLinearGradient(ctx,
                                        gradient,
                                        CGPointMake(Round_05(rect.origin.x) + rect.size.width, rect.origin.y),
                                        CGPointMake(Round_05(rect.origin.x) + rect.size.width, rect.origin.y + rect.size.height-1),
                                        (CGGradientDrawingOptions)NULL);
            CGColorSpaceRelease(colorSpace);
            CGContextRestoreGState(ctx);
            CGGradientRelease(gradient);
        }
        
        //draw icon
        float move1 = draw_icon_rect.origin.y + draw_icon_rect.size.height+(rect.size.height - CHART_BTN_ICON_SIZE)/2.0;
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, 
                              0.0, 
                              move1);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        
        //increase transparency
        CGContextBeginTransparencyLayer(ctx, nil);
        CGContextSetAlpha( ctx, (isDown || isSelected)?CHART_BTN_SEL_OPACITY:CHART_BTN_NORM_OPACITY );
        
        //give it some tint
        CGContextSaveGState(ctx);
        CGContextClipToMask(ctx, draw_icon_rect, image.CGImage);
        CGContextSetFillColorWithColor(ctx, [HEXCOLOR(CHART_BTN_ICON_COLOR) CGColor]);
        CGContextFillRect(ctx, draw_icon_rect);        
        CGContextRestoreGState(ctx);
        
        //CGContextSetBlendMode(ctx, kCGBlendModeMultiply);        
        //CGContextDrawImage(ctx, draw_icon_rect, image.CGImage);        
        
        CGContextEndTransparencyLayer(ctx);        
        CGContextRestoreGState(ctx);  
        
        //end draw icon
    }
    else
    {
        UIFont* font = [UIFont systemFontOfSize:CHART_BTN_FONT_BASE_SIZE];
		CGContextSelectFont(ctx, [font.fontName UTF8String], CHART_BTN_FONT_BASE_SIZE, kCGEncodingMacRoman); 
		
        //measure the string
        CGContextSetTextDrawingMode(ctx, kCGTextInvisible); 
        CGContextSetTextPosition(ctx, rect.origin.x, rect.origin.y);
		CGContextShowText(ctx, [self.text UTF8String], strlen([self.text UTF8String]));
        
        CGPoint pt = CGContextGetTextPosition(ctx);	
        float textPixelLength = pt.x - rect.origin.x;
		float textPixelHeight = font.capHeight;
        float fontSizeDiscrepancy = (CHART_BTN_FONT_BASE_SIZE - textPixelHeight);
       
        float textHPos = rect.origin.x + (rect.size.width - textPixelLength)/2.0;
        float textVPos = rect.origin.y + (rect.size.height - textPixelHeight)/2.0 - fontSizeDiscrepancy;
        
        //draw the string
        UIGraphicsPushContext(ctx);    
        CGContextBeginTransparencyLayer(ctx, nil);
        CGContextSetAlpha( ctx, (isDown || isSelected)?CHART_BTN_SEL_OPACITY:CHART_BTN_NORM_OPACITY );
		CGContextSetFillColorWithColor(ctx, [HEXCOLOR(CHART_BTN_ICON_COLOR) CGColor]); 
		CGContextSetTextDrawingMode(ctx, kCGTextFill); 
        [self.text drawAtPoint:CGPointMake(textHPos, textVPos) withFont:font];
        CGContextEndTransparencyLayer(ctx);      

        UIGraphicsPopContext();
    }
}


@end

