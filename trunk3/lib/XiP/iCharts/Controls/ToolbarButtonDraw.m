//
//  ToolbarButtonDraw.m
//  XiP
//
//  Created by Xogee MacBook on 09/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "ToolbarButtonDraw.h"
#import "ToolbarButton.h"
#import "ToolbarButtonSegment.h"

@implementation ToolbarButtonDraw
@synthesize btn;
-(id)initWithButton:(ToolbarButton*)_btn AndScale:(float)scale
{
    
    self= [super init];
    if (self) 
    {         
        self.contentsScale      = scale; 
        [self setNeedsDisplay];  
        self.btn = _btn;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    if(self.btn==nil)
        return;
    [self drawInternal:ctx orHitTest:false forPoint:CGPointZero];    
}


- (struct HitTestInfo)drawInternal:(CGContextRef)ctx orHitTest:(BOOL)isHittest forPoint:(CGPoint)where
{
    struct HitTestInfo res;
    res.btn = nil;
    res.seg = nil;
    
    
    //CGContextSetFillColorWithColor(ctx, [HEXCOLOR(0x12FF127F) CGColor]);
    //CGContextFillRect(ctx, self.frame);
    if(btn.isExpanded)
    {
        double pen_1px = 1;
        CGContextRef bmpContext = nil;
        CGRect seg_rect = CGRectMake(CHART_BTN_RADIUS/2, 
                                     0, 
                                     CHART_BTN_SEG_WIDTH, 
                                     CHART_BTN_HEIGHT);
        if(!isHittest)
        {
            CGFloat XScale = 1.0;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
            {
                XScale = [UIScreen mainScreen].scale;
                UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, XScale);
            }
            else 
                UIGraphicsBeginImageContext(self.frame.size);
            pen_1px = 1/XScale; //a dirty hack to have perfect 1px lines on retina
            bmpContext = UIGraphicsGetCurrentContext();
        }
        
        int IconXOffset = 0;
        
        for(int i=0; i<[btn.segments count]; i++)
        {
            ToolbarButtonSegment *seg = [btn.segments objectAtIndex:i];
            if(i==0)
            {
                IconXOffset = (CHART_BTN_SEG_WIDTH + CHART_BTN_RADIUS - CHART_BTN_WIDTH)/2.0;
            }
            
            
            if(!isHittest)
            {
                [seg drawInContext:bmpContext 
                            InRect:seg_rect
                       IconXOffset:IconXOffset
                           Line1px:pen_1px
               AndSeparatorIsShown:i<[btn.segments count]-1
                        IsSelected:(btn.selectedSegmentTag==seg.action)];            
            }
            else
            {
                CGRect r = seg_rect;
                if(i==0)
                {
                    r.origin.x-=CHART_BTN_RADIUS/2;
                    r.size.width+=CHART_BTN_RADIUS/2;
                }
                else
                if(i==[btn.segments count]-1)
                    r.size.width+=CHART_BTN_RADIUS/2;
                if(CGRectContainsPoint(r, where))
                {
                    res.btn = self.btn;
                    res.seg = seg;
                    btn.selectedSegmentTag = seg.action;
                    return res;
                }
            }
            if(i==0)
            {
                IconXOffset = 0;
            }
            
            seg_rect.origin.x+=CHART_BTN_SEG_WIDTH;
            if(seg_rect.origin.x + CHART_BTN_SEG_WIDTH > 
               self.btn.dummy_bounds.origin.x + self.btn.dummy_bounds.size.width)
                break;
        }
        if(!isHittest)
        {	            
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext(); 
            
            CGContextTranslateCTM(ctx, 
                                  0.0, 
                                  self.frame.size.height);
            CGContextScaleCTM(ctx, 1.0, -1.0);
            
            CGContextDrawImage(ctx, self.bounds, img.CGImage);  
        }
    }
    else
    {
        ToolbarButtonSegment *seg = [self.btn GetSegmentWithAction:btn.selectedSegmentTag];
        CGRect seg_rect = CGRectMake(0, 
                                     0, 
                                     CHART_BTN_WIDTH, 
                                     CHART_BTN_HEIGHT);
        
        
        if(!isHittest)
            [seg drawInContext:ctx 
                        InRect:seg_rect 
                   IconXOffset:0
                       Line1px:1 
           AndSeparatorIsShown:false 
                    IsSelected:false]; 
        else
        {
            if(CGRectContainsPoint(seg_rect, where))
            {
                res.btn = self.btn;
                res.seg = seg;
                
                return res;
            }
        }
        
    }
    return res;
}

@end
