
#import "PlotToolbar.h"
#import "Animation/AccelerationAnimation.h"
#import "Animation/Evaluate.h"
/*
@implementation PlotToolbarButton
@synthesize action, text, image, isDown, isVisible; 

-(id) init
{
	self = [super init];
	text = nil;
    image = nil;
    isDown = false;
    isVisible = true;
    return self;
}

- (void)dealloc 
{
	if(text!=nil)
		[text release];
	if(image!=nil)
		[image release];
    [super dealloc];
}
@end*/

@implementation PlotToolbar
@synthesize buttons, timerAutoCollapse, tb_delegate, dashboard;





- (id)initWithCoder:(NSCoder*)coder 
{
    self=[super initWithCoder:coder];
    if (self) 
    {  
        float current_scale = [self layer].contentsScale;      
        dashboard = [[ToolbarSegDashboard alloc] initWithScale:current_scale AndDelegate:nil ];       
        [self.layer addSublayer:dashboard];
        [self HideDashBoard];
        
        buttons = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [buttons removeAllObjects];
    [buttons release];
    if(timerAutoCollapse!=nil)
    {
        [timerAutoCollapse invalidate];
        timerAutoCollapse = nil;
    }
    [dashboard release];
}

- (void)drawRect:(CGRect)rect
{
    /*CGContextRef context = UIGraphicsGetCurrentContext();
    if(dashboard.opacity!=0) //visible
    {
        [dashboard drawInContext:context 
                InRect:CGRectMake(dashboard.frame.origin.x, 
                                  dashboard.frame.origin.y, 
                                  dashboard.bounds.size.width, 
                                  dashboard.bounds.size.height)];
    }*/
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [HEXCOLOR(0xFFFF127F) CGColor]);
    //CGContextFillRect(context, rect); 
}

- (void)setupChartToolbar
{
    float current_x = CHART_BTN_X_PADDING_FIRST;
    float current_scale = [self layer].contentsScale;
    ToolbarButton *btn = nil; 
    
    btn = [[ToolbarButton alloc] initWithTag:ID_BTN_CHART_MODE AndScale:current_scale AndDelegate:tb_delegate];
    [btn addSegment:ID_SEG_MODE_NONE WithText:nil AndImage:[UIImage imageNamed:@"draw_none.png"]];
    [btn addSegment:ID_SEG_MODE_RESIZE WithText:nil AndImage:[UIImage imageNamed:@"draw_pan.png"]];
    [btn addSegment:ID_SEG_MODE_DELETE WithText:nil AndImage:[UIImage imageNamed:@"draw_delete.png"]];
    ToolbarButtonSegment* seg_draw = [btn addSegment:ID_SEG_MODE_DRAW WithText:nil AndImage:[UIImage imageNamed:@"draw_pencil.png"]];
    [btn addSegment:ID_SEG_MODE_SPLITTER WithText:nil AndImage:[UIImage imageNamed:@"hsplit.png"]];
    [btn addSegment:ID_SEG_MODE_CROSSHAIR WithText:nil AndImage:[UIImage imageNamed:@"crosshair.png"]];
    btn.frame = CGRectIntegral(CGRectMake(current_x, CHART_BTN_TOP_PADDING, CHART_BTN_WIDTH, CHART_BTN_HEIGHT)); 
    [self.layer addSublayer:btn];
    [buttons addObject:btn];
    [btn release];
    current_x += (CHART_BTN_WIDTH + CHART_BTN_X_PADDING); 
    
    btn = [[ToolbarButton alloc] initWithTag:ID_BTN_CHART_TYPE AndScale:current_scale AndDelegate:tb_delegate];
    [btn addSegment:ID_SEG_TYPE_CANDLES WithText:nil AndImage:[UIImage imageNamed:@"types_candles.png"]];
    [btn addSegment:ID_SEG_TYPE_BARS WithText:nil AndImage:[UIImage imageNamed:@"types_bars.png"]];
    [btn addSegment:ID_SEG_TYPE_AREA WithText:nil AndImage:[UIImage imageNamed:@"types_area.png"]];
    [btn addSegment:ID_SEG_TYPE_LINE WithText:nil AndImage:[UIImage imageNamed:@"types_line.png"]];
    btn.frame = CGRectIntegral(CGRectMake(current_x, CHART_BTN_TOP_PADDING, CHART_BTN_WIDTH, CHART_BTN_HEIGHT)); 
    [self.layer addSublayer:btn];
    [buttons addObject:btn];
    [btn release];
    current_x += (CHART_BTN_WIDTH + CHART_BTN_X_PADDING); 
    
    btn = [[ToolbarButton alloc] initWithTag:ID_BTN_CHART_INTERVAL AndScale:current_scale AndDelegate:tb_delegate];
    ToolbarButtonSegment* seg_intl = [btn addSegment:ID_SEG_INTERVAL WithText:@"M10" AndImage:[UIImage imageNamed:nil]];
    btn.frame = CGRectIntegral(CGRectMake(current_x, CHART_BTN_TOP_PADDING, CHART_BTN_WIDTH, CHART_BTN_HEIGHT)); 
    [self.layer addSublayer:btn];
    [buttons addObject:btn];
    [btn release];
    current_x += (CHART_BTN_WIDTH + CHART_BTN_X_PADDING); 
    
    btn = [[ToolbarButton alloc] initWithTag:ID_BTN_CHART_INDICATORS AndScale:current_scale AndDelegate:tb_delegate];
    [btn addSegment:ID_SEG_INDICATOR WithText:nil AndImage:[UIImage imageNamed:@"indicators.png"]];
    btn.frame = CGRectIntegral(CGRectMake(current_x, CHART_BTN_TOP_PADDING, CHART_BTN_WIDTH, CHART_BTN_HEIGHT)); 
    [self.layer addSublayer:btn];
    [buttons addObject:btn];
    [btn release]; 
    current_x += (CHART_BTN_WIDTH + CHART_BTN_X_PADDING); 
    
    //setup sub segments for chart time intervals button
    seg_intl.rows_count = 3;
    seg_intl.cols_count = 3;
    [seg_intl addSubSegment:ID_SUBSEG_M1         WithText:@"M1"      AndImage:nil];
    [seg_intl addSubSegment:ID_SUBSEG_M5         WithText:@"M5"      AndImage:nil];         
    [seg_intl addSubSegment:ID_SUBSEG_M15        WithText:@"M15"     AndImage:nil]; 
    [seg_intl addSubSegment:ID_SUBSEG_M30        WithText:@"M30"     AndImage:nil]; 
    [seg_intl addSubSegment:ID_SUBSEG_H1         WithText:@"H1"      AndImage:nil];  
    [seg_intl addSubSegment:ID_SUBSEG_H4         WithText:@"H4"      AndImage:nil];       
    [seg_intl addSubSegment:ID_SUBSEG_D1         WithText:@"D1"      AndImage:nil];  
    [seg_intl addSubSegment:ID_SUBSEG_W1         WithText:@"W1"      AndImage:nil];  
    [seg_intl addSubSegment:ID_SUBSEG_MN1        WithText:@"MN1"     AndImage:nil];     
    
    
    //setup sub segments for chart tech analysis
    seg_draw.rows_count = 3;
    seg_draw.cols_count = 3;
    [seg_draw addSubSegment:ID_SUBSEG_DRAW_LINE        WithText:nil        AndImage:[UIImage imageNamed:@"ta_line.png"]];
    [seg_draw addSubSegment:ID_SUBSEG_DRAW_RAY         WithText:nil        AndImage:[UIImage imageNamed:@"ta_ray.png"]];        
    [seg_draw addSubSegment:ID_SUBSEG_DRAW_SEG         WithText:nil        AndImage:[UIImage imageNamed:@"ta_seg.png"]]; 
    [seg_draw addSubSegment:ID_SUBSEG_DRAW_CHANNEL     WithText:nil        AndImage:[UIImage imageNamed:@"ta_channel.png"]]; 
    [seg_draw addSubSegment:ID_SUBSEG_VLINE            WithText:nil        AndImage:[UIImage imageNamed:@"ta_vline.png"]];    
    [seg_draw addSubSegment:ID_SUBSEG_HLINE            WithText:nil        AndImage:[UIImage imageNamed:@"ta_hline.png"]];
    [seg_draw addSubSegment:ID_SUBSEG_FIB_RETR         WithText:nil        AndImage:[UIImage imageNamed:@"ta_fib_retr.png"]];  
    [seg_draw addSubSegment:ID_SUBSEG_FIB_CIRC         WithText:nil        AndImage:[UIImage imageNamed:@"ta_fib_circ.png"]];      
    [seg_draw addSubSegment:ID_SUBSEG_FIB_FAN          WithText:nil        AndImage:[UIImage imageNamed:@"ta_fib_fan.png"]];      
    
    btn = [[ToolbarButton alloc] initWithTag:ID_BTN_SETTINGS AndScale:current_scale AndDelegate:tb_delegate];
    [btn addSegment:ID_SEG_SETTINGS WithText:nil AndImage:[UIImage imageNamed:@"menu_show.png"]];
    btn.frame = CGRectIntegral(CGRectMake(current_x, CHART_BTN_TOP_PADDING, CHART_BTN_WIDTH, CHART_BTN_HEIGHT)); 
    [self.layer addSublayer:btn];
    [buttons addObject:btn];
    [btn release];  
    current_x += (CHART_BTN_WIDTH + CHART_BTN_X_PADDING); 
    
    
    btn = [[ToolbarButton alloc] initWithTag:ID_BTN_MAXMINIMIZE AndScale:current_scale AndDelegate:tb_delegate];    
    [btn addSegment:ID_SEG_MAXIMIZE WithText:nil AndImage:[UIImage imageNamed:@"maximize.png"]];
    [btn addSegment:ID_SEG_MINIMIZE WithText:nil AndImage:[UIImage imageNamed:@"minimize.png"]];
    btn.frame = CGRectIntegral(CGRectMake(current_x, CHART_BTN_TOP_PADDING, CHART_BTN_WIDTH, CHART_BTN_HEIGHT)); 
    [self.layer addSublayer:btn];
    [buttons addObject:btn];
    [btn release];   
    
    dashboard.zPosition = 66666;
}

- (void) unselectAllButtons
{
    for (int i=0; i<[buttons count]; i++)
    {
        ToolbarButton *btn = [buttons objectAtIndex:i];
        [btn unselectAllSegments];
        [btn setContents:(id)btn.btnSkin.CGImage];
        //[btn setNeedsDisplay];
    }
    [dashboard hitTestSegment:CGPointMake(-1, -1)];//unselect
    [self setNeedsDisplay];
    
}

- (void) collapseAllButtons
{
    for (int i=0; i<[buttons count]; i++)
    {
        ToolbarButton *btn = [buttons objectAtIndex:i];
        [btn Collapse:true];
        [btn MakeVisible:0];
        //[btn setNeedsDisplay];
    }
    
}

-(void) startAutoCollapse:(uint)button_tag
{    
    timerAutoCollapse = [NSTimer scheduledTimerWithTimeInterval:5 
                                 target:self
                                 selector:@selector(AutoCollapseProc:)
                                 userInfo:[self GetButtonWithTag:button_tag] 
                                 repeats:NO]; 
}

-(void) stopAutoCollapse 
{
    if(timerAutoCollapse!=nil)
    {
        [timerAutoCollapse invalidate];
        timerAutoCollapse = nil;
    }
}
- (void)AutoCollapseProc:(NSTimer *)timer 
{
    ToolbarButton *btn = (ToolbarButton *)[timer userInfo];
    struct HitTestInfo ht;
    ht.btn = btn;
    ht.seg = [btn GetSegmentWithAction:[btn selectedSegmentTag]];
    [self ProcessClick:ht];
}

- (struct HitTestInfo)hitTestSegment:(CGPoint)where 
{
    struct HitTestInfo res;
    res.seg = nil;
    res.btn = nil;
    CALayer * layer = [[self layer] hitTest:where];
    
    if (layer) 
    {
        if ([layer isKindOfClass:[ToolbarButton class]]) 
        {
            CGPoint layerPoint = [[self layer] convertPoint:where toLayer:layer];
            res = [(ToolbarButton *)layer hitTestSegment:layerPoint];
        }
        else            
        if ([layer isKindOfClass:[ToolbarButtonDraw class]]) 
        {
            CGPoint layerPoint = [[self layer] convertPoint:where toLayer:layer];
            ToolbarButtonDraw* parent = (ToolbarButtonDraw *)layer;
            res = [parent.btn hitTestSegment:layerPoint];
        }
        else            
        if ([layer isKindOfClass:[ToolbarSegDashboard class]]) 
        {
            CGPoint layerPoint = [[self layer] convertPoint:where toLayer:layer];
            ToolbarSegDashboard* parent = (ToolbarSegDashboard *)layer;
            res = [parent hitTestSegment:layerPoint];
            [parent setNeedsDisplay];
        }
    }
    
    return res;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self unselectAllButtons];

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    [[self layer] hitTest:location];
    
    struct HitTestInfo ht = [self hitTestSegment:location];
    if(ht.seg!=nil && ht.btn!=nil)
    {
        ht.btn.selectedSegmentTag = ht.seg.action;
        ht.seg.isDown = true;
    }
    [self setNeedsDisplay];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [self unselectAllButtons];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [self unselectAllButtons];
    [self stopAutoCollapse];

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    struct HitTestInfo ht = [self hitTestSegment:location];
    if(ht.seg!=nil && ht.btn!=nil)
    {
        ht.btn.selectedSegmentTag = ht.seg.action;
        ht.seg.isDown = true;
    }
    
    [self setNeedsDisplay];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self unselectAllButtons];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    struct HitTestInfo ht = [self hitTestSegment:location];

    
    if(ht.seg==nil && ht.btn==nil)
    {
        if(dashboard.bounds.size.width!=0)
            [self HideDashBoard];
        return;    
    }
    [self ProcessClick:ht];
}

- (void) ProcessClick:(struct HitTestInfo)ht
{
    bool dashboard_was_visible = (dashboard.bounds.size.width!=0);
    [self stopAutoCollapse];
    [self HideDashBoard];
    switch(ht.btn.tag)
    {
        case ID_BTN_MAXMINIMIZE:
            if([self GetButtonWithTag:ID_BTN_MAXMINIMIZE].selectedSegmentTag == ID_SEG_MAXIMIZE)
                [self GetButtonWithTag:ID_BTN_MAXMINIMIZE].selectedSegmentTag = ID_SEG_MINIMIZE;
            else
                [self GetButtonWithTag:ID_BTN_MAXMINIMIZE].selectedSegmentTag = ID_SEG_MAXIMIZE;
            [[self GetButtonWithTag:ID_SEG_MINIMIZE] setNeedsDisplay];
            break;
        case ID_BTN_CHART_TYPE:
            if(ht.btn.isExpanded)
            {
                [[self GetButtonWithTag:ID_BTN_CHART_INDICATORS] MakeVisible:0.2];
                [[self GetButtonWithTag:ID_BTN_CHART_INTERVAL] MakeVisible:0.13];  
                [[self GetButtonWithTag:ID_BTN_SETTINGS] MakeVisible:0.07];         
                [ht.btn Collapse:false];
            }
            else
            {
                [self collapseAllButtons];
                [[self GetButtonWithTag:ID_BTN_CHART_INDICATORS] MakeInvisible:0.07];
                [[self GetButtonWithTag:ID_BTN_CHART_INTERVAL] MakeInvisible:0.13];  
                [[self GetButtonWithTag:ID_BTN_SETTINGS] MakeInvisible:0.2];         
                [ht.btn Expand];
                [self startAutoCollapse:ht.btn.tag];
            }
            break;
        case ID_BTN_CHART_MODE:
            if(ht.btn.isExpanded)
            {
                if(ht.seg.action == ID_SEG_MODE_DRAW)
                {
                    if(!dashboard_was_visible)
                    {
                        [self ShowDashBoardForSegment:ht.seg];
                        ht.btn = nil;
                    }
                    else
                    {
                        //[ht.btn Collapse:true];
                        [self HideDashBoard];                        
                        [[self GetButtonWithTag:ID_BTN_CHART_TYPE] MakeVisible:0.20];
                        [[self GetButtonWithTag:ID_BTN_CHART_INTERVAL] MakeVisible:0.15];
                        [[self GetButtonWithTag:ID_BTN_CHART_INDICATORS] MakeVisible:0.10];
                        [[self GetButtonWithTag:ID_BTN_SETTINGS] MakeVisible:0.05];
                        [ht.btn Collapse:false];                        
                    }                    
                }
                else
                {
                    [[self GetButtonWithTag:ID_BTN_CHART_TYPE] MakeVisible:0.20];
                    [[self GetButtonWithTag:ID_BTN_CHART_INTERVAL] MakeVisible:0.15];
                    [[self GetButtonWithTag:ID_BTN_CHART_INDICATORS] MakeVisible:0.10];
                    [[self GetButtonWithTag:ID_BTN_SETTINGS] MakeVisible:0.05];
                    [ht.btn Collapse:false];
                }
            }
            else
            {
                [self collapseAllButtons];

                [[self GetButtonWithTag:ID_BTN_CHART_TYPE] MakeInvisible:0.05];
                [[self GetButtonWithTag:ID_BTN_CHART_INTERVAL] MakeInvisible:0.10];    
                [[self GetButtonWithTag:ID_BTN_CHART_INDICATORS] MakeInvisible:0.15];
                [[self GetButtonWithTag:ID_BTN_SETTINGS] MakeInvisible:0.20];            
                [ht.btn Expand];
                [self startAutoCollapse:ht.btn.tag];
            }
            break;
        case ID_BTN_CHART_INTERVAL:
            if(!dashboard_was_visible)
            {
                [self ShowDashBoardForSegment:ht.seg];
                ht.btn = nil;
            }
            else
            {
                [ht.btn Collapse:true];
                [self HideDashBoard];
                //[[self GetButtonWithTag:ID_BTN_CHART_INTERVAL] setNeedsDisplay];
            }
            break;
    }    
    [self setNeedsDisplay];
    [tb_delegate buttonClick:ht];
}
- (ToolbarButton *) GetButtonWithTag:(uint)tag
{
    ToolbarButton* res_button = nil;
    for (int i=0; i<[buttons count]; i++)
    {
        ToolbarButton *btn = [buttons objectAtIndex:i];
        if(btn.tag == tag)
        {
            res_button = btn;
            break;
        }
    }
    return res_button;
}
- (void)ShowDashBoardForSegment:(ToolbarButtonSegment*)seg;
{    
    //[self setBounds:CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height)]; 
    
    float dash_width = seg.cols_count*CHART_DASH_BTNSEG_WIDTH;
    float dash_height = seg.rows_count*CHART_DASH_BTNSEG_HEIGHT;
    float dash_left = Round_05(//self.superview.frame.origin.x + 
                               (self.superview.bounds.size.width - dash_width)/2.0);
    float dash_top = Round_05(//self.superview.frame.origin.y + 
                              (CHART_BTN_HEIGHT + 2*CHART_BTN_TOP_PADDING) + 
                              (self.superview.bounds.size.height -  
                               (CHART_BTN_HEIGHT + 2*CHART_BTN_TOP_PADDING) -
                               dash_height)/2.0);
    
    [dashboard setFrame:CGRectMake(dash_left + dash_width/2, dash_top + dash_height/2, 0, 0)]; 
        [CATransaction commit];
    [dashboard setFrame:CGRectMake(dash_left, dash_top, dash_width, dash_height)];   

    [dashboard setOpacity:CHART_BTN_SEL_OPACITY];
    [dashboard setParent_segment:seg];
    [dashboard setTb_delegate:self.tb_delegate];
    AccelerationAnimation *animation = [AccelerationAnimation animationWithKeyPath:@"transform.scale"
                                                                        startValue:0.005
                                                                          endValue:1
                                                                  evaluationObject:[[[SecondOrderResponseEvaluator alloc] initWithOmega:20.0 zeta:0.33] autorelease]
                                                                 interstitialSteps:200];
    [animation setDelegate:self];
    [animation setDuration:3*CHART_TB_ANIM_DURATION];
    animation.removedOnCompletion=NO;
    [dashboard addAnimation:animation forKey:@"shrink"];
    
}
- (void)HideDashBoard
{
    [self setBounds:CGRectMake(0, 0, self.superview.bounds.size.width, CHART_BTN_HEIGHT + 2*CHART_BTN_TOP_PADDING)];   
    [dashboard setOpacity:0];
    [dashboard setFrame:CGRectMake(0, 0, 0, 0)];  
    [CATransaction commit];
}

@end
