
#import "ToolbarButton.h"
#import "PlotToolbar.h"
#import "ToolbarButtonDraw.h"


@implementation ToolbarButton
@synthesize segments, isExpanded, tag, selectedSegmentTag, dummy_bounds, shouldCleanData,btnSkin;
@synthesize tb_delegate, btn;

- (id)initWithTag:(uint)_tag AndScale:(float)scale AndDelegate:(id)_tb_delegate
{
    self= [super init];
    if (self) 
    {         
        self.tag                = _tag;
        self.selectedSegmentTag = ID_SEG_NONE;
        self.tb_delegate        = _tb_delegate;
        
        /*self.backgroundColor    = [HEXCOLOR(CHART_BTN_FILL_COLOR) CGColor];
        self.opacity            = CHART_BTN_SEL_OPACITY;
        self.borderColor        = [HEXCOLOR(0x000000FF) CGColor];
        self.borderWidth        = CHART_BTN_BORDER_WIDTH*pen_1px;
        self.cornerRadius       = CHART_BTN_RADIUS;
        self.contentsScale      = scale;   
        self.contentsGravity    = kCAGravityLeft;*/
        btnSkin                 = [[UIImage imageNamed:@"chart_tb_btn.png"] retain];
        self.contentsScale      = scale;   
        self.contents           = (id)btnSkin.CGImage;
        self.contentsGravity    = kCAGravityResize;
        self.contentsCenter       = CGRectMake(10.0/btnSkin.size.width, 
                                               10.0/btnSkin.size.height, 
                                               (btnSkin.size.width-20.0)/btnSkin.size.width, 
                                               (btnSkin.size.height-20.0)/btnSkin.size.height);
        //self.contentsGravity    = kCAGravityLeft;
        //self.backgroundColor    = [HEXCOLOR(CHART_BTN_FILL_COLOR) CGColor];
         //self.masksToBounds      = YES;
        self.needsDisplayOnBoundsChange = YES;
        self.anchorPoint        = CGPointMake(0, 0);
        self.position           = CGPointMake(0, 0);
        segments                = [[NSMutableArray alloc] init];
        isExpanded              = false;
        shouldCleanData         = true;
        [self setNeedsDisplay];
        
        
        
        btn = [[ToolbarButtonDraw alloc] initWithButton:self AndScale:scale];
        //[btn setFrame:self.frame];
        [btn setAnchorPoint:CGPointMake(0, 0)];
        [btn setPosition:CGPointMake(0, 0)];
        [btn setBounds:self.bounds];
        [self addSublayer:btn];

    }
	return self;
	
}


- (id) initWithLayer:(id)layer 
{
    self = [super initWithLayer:layer];
    if(self)
    {
        if([layer isKindOfClass:[ToolbarButton class]]) 
        {
            ToolbarButton *other = (ToolbarButton*)layer;
            self.tag                = other.tag;
            self.selectedSegmentTag = other.selectedSegmentTag;
            self.segments           = other.segments;
            self.isExpanded         = other.isExpanded;
            self.shouldCleanData    = false;
            self.contentsScale      = other.contentsScale;
            self.anchorPoint        = other.anchorPoint;
            self.position           = other.position;
            self.tb_delegate        = other.tb_delegate;
            //btnSkin                 = [[UIImage imageNamed:@"chart_tb_btn.png"] retain];
            self.contents           = (id)btnSkin.CGImage;
            self.contentsGravity    = kCAGravityResize;
            self.contentsCenter       = CGRectMake(10.0/btnSkin.size.width, 
                                                   10.0/btnSkin.size.height, 
                                                   (btnSkin.size.width-20.0)/btnSkin.size.width, 
                                                   (btnSkin.size.height-20.0)/btnSkin.size.height);
        }
    }
    return self;
}

- (void)dealloc 
{
	if(segments!=nil && shouldCleanData)
    {
        [segments removeAllObjects];
		[segments release];
        [btnSkin release];
        segments = nil;
    }
    [super dealloc];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    /*CALayer *layer          = [CALayer layer];
    layer.opacity = 0.3;
    [layer setBounds:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [layer setAnchorPoint:CGPointMake(0, 0)];*/
    self.contents           = (id)btnSkin.CGImage;
    self.contentsGravity    = kCAGravityResize;
    self.contentsCenter       = CGRectMake(10.0/btnSkin.size.width, 
                                         10.0/btnSkin.size.height, 
                                         (btnSkin.size.width-20.0)/btnSkin.size.width, 
                                           (btnSkin.size.height-20.0)/btnSkin.size.height);
    //[btn setFrame:frame];
    [btn setBounds:self.bounds];

    [self setNeedsLayout];
    //[self insertSublayer:layer below:self];
    //[self setNeedsDisplay];
}
- (void) unselectAllSegments
{
    //self.selectedSegmentTag = ID_SEG_NONE;
    for (int i=0; i<[segments count]; i++)
    {
        ToolbarButtonSegment *seg = [segments objectAtIndex:i];
        seg.isDown = false;
    }
    
}
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if([key isEqualToString:@"dummy_bounds"]) 
    { 
        return YES; 
    } 
    return [super needsDisplayForKey:key]; 
}

- (ToolbarButtonSegment*)addSegment:(uint)Action WithText:(NSString*)Text AndImage:(UIImage*)image
{
    if(selectedSegmentTag == ID_SEG_NONE)
        selectedSegmentTag = Action;    //make the first added segment to be selected
    
    ToolbarButtonSegment *seg = [[ToolbarButtonSegment alloc] init];
    seg.action  = Action;
    seg.image   = image;
    seg.text    = Text;
    seg.tb_delegate = self.tb_delegate;
    seg.btn     = self;
    [segments addObject:seg];
    [seg release];
    return [segments objectAtIndex:[segments count]-1];
}
- (struct HitTestInfo) hitTestSegment:(CGPoint)where
{    
    [self removeAllAnimations];
    return [self drawInternal:nil orHitTest:true forPoint:where];
}


- (void)drawInContext:(CGContextRef)ctx
{   
    [btn drawInternal:ctx orHitTest:false forPoint:CGPointMake(0, 0)]; 
}
            
- (struct HitTestInfo)drawInternal:(CGContextRef)ctx orHitTest:(BOOL)isHittest forPoint:(CGPoint)where
{
    return [btn drawInternal:ctx orHitTest:isHittest forPoint:where];
}

- (ToolbarButtonSegment *) GetSegmentWithAction:(uint)_action
{
    ToolbarButtonSegment* res_seg = nil;
    for (int i=0; i<[segments count]; i++)
    {
        ToolbarButtonSegment *seg = [segments objectAtIndex:i];
        if(seg.action == _action)
        {
            res_seg = seg;
            break;
        }
    }
    return res_seg;
}
- (void)Expand
{
    self.isExpanded = true;

    CGRect oldBounds = self.bounds;
    CGRect newBounds = oldBounds;
    newBounds.size.width = CHART_BTN_RADIUS + CHART_BTN_SEG_WIDTH*[segments count];    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    animation.fromValue = [NSValue valueWithCGRect:oldBounds];
    animation.toValue = [NSValue valueWithCGRect:newBounds];
    animation.duration = CHART_SEG_ANIM_DURATION;
    animation.removedOnCompletion = NO; 
    animation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *dummy_animation = [CABasicAnimation animationWithKeyPath:@"dummy_bounds"];
    
    dummy_animation.fromValue = [NSValue valueWithCGRect:oldBounds];
    dummy_animation.toValue = [NSValue valueWithCGRect:newBounds];
    dummy_animation.duration = CHART_SEG_ANIM_DURATION;
    dummy_animation.removedOnCompletion = NO; 
    dummy_animation.fillMode = kCAFillModeForwards;      
    

    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    
    theGroup.duration = CHART_SEG_ANIM_DURATION;
    theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    
    theGroup.animations = [NSArray arrayWithObjects:dummy_animation, animation, nil]; // you can add more
    
    
    [self setBounds:newBounds];
    [btn setBounds:newBounds];
    self.contents = (id)btnSkin.CGImage;
    self.dummy_bounds = newBounds;
    //[self setNeedsLayout];
    [btn setNeedsDisplay];
    // Add the animation group to the layer
    //[self addAnimation:theGroup forKey:@"scaleit"];
    
}

- (void)Collapse:(BOOL)fast
{
    self.isExpanded = false;
    
    CGRect oldBounds = self.bounds;
    CGRect newBounds = oldBounds;
    newBounds.size.width = CHART_BTN_WIDTH; 
    
    if(!fast)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
        animation.fromValue = [NSValue valueWithCGRect:oldBounds];
        animation.toValue = [NSValue valueWithCGRect:newBounds];
        animation.duration = CHART_SEG_ANIM_DURATION;
        animation.removedOnCompletion = NO; 
        animation.fillMode = kCAFillModeForwards;
    
        CABasicAnimation *dummy_animation = [CABasicAnimation animationWithKeyPath:@"dummy_bounds"];
    
        dummy_animation.fromValue = [NSValue valueWithCGRect:oldBounds];
        dummy_animation.toValue = [NSValue valueWithCGRect:newBounds];
        dummy_animation.duration = CHART_SEG_ANIM_DURATION;
        dummy_animation.removedOnCompletion = NO; 
        dummy_animation.fillMode = kCAFillModeForwards;      
    
    
        CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    
        theGroup.duration = CHART_SEG_ANIM_DURATION;
        theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    
        theGroup.animations = [NSArray arrayWithObjects:dummy_animation, animation, nil]; // you can add more
    
    
        [self setBounds:newBounds];
        [btn setBounds:newBounds];
        self.contents = (id)btnSkin.CGImage;
        self.dummy_bounds = newBounds;
        [self setNeedsLayout];
        [btn setNeedsDisplay];
        // Add the animation group to the layer
        //[self addAnimation:theGroup forKey:@"scaleitdown"];
    }
    else
    {
        [self setBounds:newBounds];
        [btn setBounds:newBounds];
        self.contents = (id)btnSkin.CGImage;
        self.dummy_bounds = newBounds;
        [self setNeedsLayout];
        [btn setNeedsDisplay];
    }
}

- (void)MakeInvisible:(float)duration
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CABasicAnimation *opacityAnimation;     
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];  
    opacityAnimation.fromValue = [NSNumber numberWithDouble:CHART_BTN_SEL_OPACITY];     
    opacityAnimation.toValue = [NSNumber numberWithDouble:0];     
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];    
    opacityAnimation.fillMode = kCAFillModeForwards;  
    opacityAnimation.duration = duration;        
    
    opacityAnimation.removedOnCompletion = NO;
    
    group.animations = [NSArray arrayWithObjects: opacityAnimation, nil];
    self.opacity = 0;
    [self addAnimation:group forKey:@"opacityAnimationOut"];    
}

- (void)MakeVisible:(float)duration
{
    if(duration>0)
    {
        CAAnimationGroup *group = [CAAnimationGroup animation];
    
        CABasicAnimation *opacityAnimation;     
        opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];  
        opacityAnimation.fromValue = [NSNumber numberWithDouble:0];     
        opacityAnimation.toValue = [NSNumber numberWithDouble:CHART_BTN_SEL_OPACITY];     
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];    
        opacityAnimation.fillMode = kCAFillModeForwards;  
        opacityAnimation.duration = duration;        
        
        opacityAnimation.removedOnCompletion = NO;
        
        group.animations = [NSArray arrayWithObjects: opacityAnimation, nil];
        self.opacity = CHART_BTN_SEL_OPACITY;
        [self addAnimation:group forKey:@"opacityAnimationIn"];   
    }
    else
        self.opacity = CHART_BTN_SEL_OPACITY;
}
@end
