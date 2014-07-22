

#import "ChartViewController.h"
#import "ParamsStorage.h"
#import "TradeRecord.h"
#import "IncomingChartInfo.h"
#import "iTraderAppDelegate.h"
#import "AccelerationAnimation.h"
#import "Evaluate.h"
#import <XiPFramework/EditPropertiesViewController.h>
#import <XiPFramework/ChooseIndicatorsController.h>
#import "OpenPosWatch.h"


@implementation ChartViewController
@synthesize chart_view, chartSensor, parentVC, requestSent, storage, sym, progressView, bgView, mytype;
@synthesize isMaximized, origFrame, fullscreenWindow;

-(void)ShowForSymbol:(SymbolInfo *)si AndParams:(ParamsStorage*)p;
{
	sym = si;
	storage = p;
	
	if (si == nil) 
		return;
    
    chart_view.showAddIndicators = false;
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(settingsDlgClosed:)
												 name:@"settingsDlgClosed" 
                                               object:nil];
    
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *interval = [wnd chartInterval];
	[self GetChart:sym AndRange:interval]; 
}

- (void)needSaveSettings
{
    [self SaveSettings];
}

- (void)SaveSettings
{
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
    wnd.storage.chartSettings = [chart_view.properties getJSONString];
    [wnd.storage SaveSettings];   
}


-(void)ApplySettings
{
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
    [chart_view setChartSettingsWithString:wnd.storage.chartSettings];  
    int savedChartType = [[chart_view.properties getParam:@"view.chartType"] intValue];  
    
    int newChartType = 0;
    if(savedChartType == CHART_TYPE_CANDLES)
        newChartType = ID_SEG_TYPE_CANDLES;
    else
        if(savedChartType == CHART_TYPE_BARS)
            newChartType = ID_SEG_TYPE_BARS;
        else
            if(savedChartType == CHART_TYPE_LINE)
                newChartType = ID_SEG_TYPE_LINE;
            else
                if(savedChartType == CHART_TYPE_AREA)
                    newChartType = ID_SEG_TYPE_AREA;
    
    ToolbarButton* btnChartType = [chartToolbar GetButtonWithTag:ID_BTN_CHART_TYPE];
    [btnChartType setSelectedSegmentTag:newChartType];
    [btnChartType GetSegmentWithAction:newChartType].isDown = true;
    [btnChartType Collapse:false];
    
    
    [[chartToolbar GetButtonWithTag:ID_BTN_SETTINGS] GetSegmentWithAction:ID_SEG_SETTINGS].selectedSegmentTag = ID_SEG_NONE;
    [[chartToolbar GetButtonWithTag:ID_BTN_SETTINGS] Collapse:false];
    //[chartToolbar setNeedsLayout];
    //[chartToolbar setNeedsDisplay];
}

- (void)settingsDlgClosed:(NSNotification *)notification
{
    if(notification.object!=chart_view.properties)
        return;
    [self SaveSettings];
    [chart_view rebuild];
}

-(void)GetChart:(SymbolInfo*)symbol AndRange:(NSString*)RangeType
{
    [self.view bringSubviewToFront:progressView];

    ToolbarButton* btn = [chartToolbar GetButtonWithTag:ID_BTN_CHART_INTERVAL];
    [btn GetSegmentWithAction:ID_SEG_INTERVAL].selectedSegmentTag = [RangeType intValue];
    [btn Collapse:false];
	sym = symbol;	
	requestSent = YES;
	[storage.charts GetChart:sym AndRange:RangeType];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	[self.view setAutoresizesSubviews:YES]; 
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
    [chart_view fillDefaultChartSettings:wnd.storage.chartDefSettings];  
    
    [chart_view setParent:self];
    [chart_view updateChartSensor:chartSensor];
    [chart_view setCursorMode:CHART_MODE_NONE];
    
    [chartToolbar setTb_delegate:self];
    [chartToolbar setupChartToolbar];
    [self showSettingsToolbar:false];
    [self ApplySettings];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(chartReceived:)
												 name:@"chart" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(priceChanged:)
												 name:@"priceChangedChart" object:nil];	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(chart_newbar:)
                                                 name:@"chart_newbar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(new_openpos:)
                                                 name:@"newOpenPosition" object:nil];	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(remove_openpos:)
                                                 name:@"removeOpenPosition" object:nil];		
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncUIControls:)
                                                 name:@"syncUIControls" object:nil];			
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideChart:)
                                                 name:@"hideChart" object:nil];	
    
	
	
	if (self.sym == nil)
		return;
    
}

-(void)showSettingsToolbar:(BOOL)withAnimation
{
    [chartToolbar collapseAllButtons];
    [chartToolbar setNeedsDisplay];
    chartToolbar.alpha = 1;
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    chartToolbar.frame = CGRectMake(0, 
                                    0, 
                                    self.view.bounds.size.width, 
                                    CHART_BTN_TOP_PADDING*2 + CHART_BTN_HEIGHT);
    
	[CATransaction commit];	
	[CATransaction flush];
    if(withAnimation)
    {
        [chartToolbar.layer setAnchorPoint:CGPointMake(0, 0)];
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
        [CATransaction setValue:[NSNumber numberWithFloat:1.5] forKey:kCATransactionAnimationDuration];
        [[chartToolbar layer] setPosition:CGPointMake(0, 0)];
        AccelerationAnimation *animation =
        [AccelerationAnimation animationWithKeyPath:@"position.y"
                                         startValue:-self.view.bounds.size.width
                                           endValue:0
                                   evaluationObject:[[[SecondOrderResponseEvaluator alloc] 
                                                      initWithOmega:20.0 
                                                      zeta:0.43] autorelease]
                                  interstitialSteps:200];
        [animation setDelegate:self];
        [animation setDuration:3*CHART_TB_ANIM_DURATION];
        [[chartToolbar layer] setValue:[NSNumber numberWithDouble:0] forKeyPath:@"position.y"];
        [[chartToolbar layer] addAnimation:animation forKey:@"position"];
        [CATransaction commit];
    }
}

- (void)viewDidAppear:(BOOL)animate 
{
	[chart_view RecalcScroll];
	[storage.charts setCurrentSymbol:[sym Symbol] ForScreen:[self mytype]];
	NSLog(@"ChartViewController viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated
{
	[storage.charts setCurrentSymbol:@"" ForScreen:[self mytype]];
}

- (void)chartReceived:(NSNotification *)notification
{
	IncomingChartInfo *incomingChartInfo = (IncomingChartInfo *)[notification object];
	HLOCDataSource *chart = [incomingChartInfo chart];
	NSString *symbolName = [sym Symbol];
    
	if (symbolName != nil && [[incomingChartInfo symbol] isEqualToString:symbolName])
	{
		[chart_view clearOrderLevels];
        [self ApplySettings];
        [chart_view SetData:chart ForSymbol:sym.Symbol];

        for (TradeRecord *tr in storage.trades)
        {
            if([tr.symbol compare:self.sym.Symbol] == NSOrderedSame)
            {
                [chart_view addOrderLevel:tr.order WithCmd:tr.cmd AtPrice:tr.open_price];
            }
        }

		[self.view sendSubviewToBack:progressView];
	}
}

- (void)priceChanged:(NSNotification *)notification
{
    NSString *symbol = (NSString*)[notification object];;
    if([symbol compare:chart_view.symbol]==0)
        [chart_view tickAdded];
}

- (void)chart_newbar:(NSNotification *)notification
{
	[chart_view newBarAdded];
}

- (void)new_openpos:(NSNotification *)notification
{
    TradeRecord *tr = (TradeRecord *)[notification object];
	[chart_view addOrderLevel:tr.order WithCmd:tr.cmd AtPrice:tr.open_price];
}

- (void)remove_openpos:(NSNotification *)notification
{
    TradeRecord *tr = (TradeRecord *)[notification object];
	[chart_view deleteOrderLevel:tr.order];
}

- (void)syncUIControls:(NSNotification *)notification
{
    if(notification.object!=self.parentVC.parentViewController)
        return;
	[self ApplySettings];  
    [chart_view rebuild];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // if(chartToolbar.alpha == 1)
    //    [self showSettingsToolbar:false];
    //else
    //     [self hideSettingsToolbar:false];
	[chart_view receivedRotate:interfaceOrientation];   
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    chart_view.lastOrientation = toInterfaceOrientation;
    //if(chartToolbar.alpha == 0)        
    //    [self hideSettingsToolbar:false];
    //[chartToolbar HideDashBoard];
}


-(void)buttonClick:(struct HitTestInfo)ht
{
    if(ht.btn==nil)
        return;
    /*UIWindow *window = [[UIApplication sharedApplication] keyWindow];
     UIView *view = [window.subviews objectAtIndex:0];
     [view removeFromSuperview];
     [window addSubview:view];*/
    switch (ht.btn.tag) 
    {
        case ID_BTN_MAXMINIMIZE:
        {
            [self needMaximizeMinimize];
            [chart_view draw];
        } 
            break;
        case ID_BTN_CHART_INTERVAL:
        {            
            //NSString* rangeType = [NSString stringWithFormat:@"%d", ht.seg.selectedSegmentTag];
            NSString * rangeType;
            switch (ht.seg.selectedSegmentTag) 
            {
                case 1:
                    rangeType = @"1";
                    break;			
                case 5:
                    rangeType = @"5";
                    break;
                case 15:
                    rangeType = @"15";
                    break;
                case 30:
                    rangeType = @"30";
                    break;
                case 60:
                    rangeType = @"60";
                    break;   
                case 240:
                    rangeType = @"240";
                    break;
                case 1440:
                    rangeType = @"1440";
                    break;
                case 10080:
                    rangeType = @"10080";
                    break;			
                case 43200:
                    rangeType = @"43200"; 
                    break;
                default:
                    rangeType = @"1"; 
                    break; 
            }
            storage.currentChartInterval = rangeType;
            iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
            wnd.chartInterval = rangeType;
            
            [self GetChart:sym AndRange:rangeType];  
            [self SaveSettings];        
        }
            break;
        case ID_BTN_CHART_MODE:
        {
            int cursorMode = 0;
            if(ht.seg.action == ID_SEG_MODE_NONE)
                cursorMode = CHART_MODE_NONE;
            else
                if(ht.seg.action == ID_SEG_MODE_RESIZE) 
                    cursorMode = CHART_MODE_RESIZE;
                else
                    if(ht.seg.action == ID_SEG_MODE_DELETE) 
                        cursorMode = CHART_MODE_DELETE;
                    else   
                        if(ht.seg.action == ID_SEG_MODE_DRAW) 
                            cursorMode = CHART_MODE_DRAW;
                        else     
                            if(ht.seg.action == ID_SEG_MODE_SPLITTER) 
                                cursorMode = CHART_MODE_SPLITTER;
                            else 
                                if(ht.seg.action == ID_SEG_MODE_CROSSHAIR) 
                                    cursorMode = CHART_MODE_CROSSHAIR;  
            
            /*if(cursorMode == CHART_MODE_SPLITTER && !isMaximized)
             {
             [chart_view setCursorMode:ID_SEG_MODE_NONE];
             [chartToolbar GetButtonWithTag:ID_BTN_CHART_MODE].selectedSegmentTag = ID_SEG_MODE_NONE;
             [[chartToolbar GetButtonWithTag:ID_BTN_CHART_MODE] Collapse:false];
             break;
             }*/
            [chart_view setCursorMode:cursorMode];
            if(cursorMode == CHART_MODE_DRAW)
            {
                chart_view.drawSubtype = ht.seg.selectedSegmentTag;
            }
        }
            break;
        case ID_BTN_CHART_TYPE:
        {
            int newChartType = 0;
            if(ht.seg.action == ID_SEG_TYPE_CANDLES)
                newChartType = CHART_TYPE_CANDLES;
            else
                if(ht.seg.action == ID_SEG_TYPE_BARS)
                    newChartType = CHART_TYPE_BARS;
                else
                    if(ht.seg.action == ID_SEG_TYPE_LINE)
                        newChartType = CHART_TYPE_LINE;
                    else
                        if(ht.seg.action == ID_SEG_TYPE_AREA)
                            newChartType = CHART_TYPE_AREA;
            [chart_view setMainChartType:newChartType];
            [self SaveSettings];
        }
            break;
        case ID_BTN_CHART_INDICATORS:
        {
            UIViewController *container = self.parentVC.parentViewController.parentViewController;
            if(isMaximized)
                container = self;
            ChooseIndicatorsController *dlgIndicators = [[ChooseIndicatorsController alloc] initWithNibName:@"ChooseIndicatorsController" bundle:nil];
            [dlgIndicators ShowIndicators:chart_view.properties 
                              AndDefStore:chart_view.default_properties];
            dlgIndicators.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [container presentModalViewController:dlgIndicators animated:YES];
            [dlgIndicators release];
        }
            break;
        case ID_BTN_SETTINGS:
        {     
            int color_scheme = ht.seg.selectedSegmentTag;
            
            if(color_scheme== ID_SUBSEG_S6)
            {                
                UIViewController *container = self.parentVC.parentViewController.parentViewController;
                if(isMaximized)
                    container = self;
                EditPropertiesViewController *dlgEdit = [[EditPropertiesViewController alloc] initWithNibName:@"EditPropertiesView" bundle:nil];
                
                [dlgEdit ShowProperties:chart_view.properties
                              WithTitle:NSLocalizedString(@"chart", "chart title") 
                                ForPath:@"style" 
                             WithNotify:@"settingsDlgClosed"];
                
                dlgEdit.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [container presentModalViewController:dlgEdit animated:YES];
                [dlgEdit release];
            }
            else
                [self applyColorScheme:color_scheme];
        }
            break;
    }
}

- (void)hideChart:(NSNotification *)notification
{
    UIViewController *container = self.parentVC.parentViewController.parentViewController;
    if(isMaximized)
    {
//        [self needMaximizeMinimize];
        container = self;
    }
    [container dismissModalViewControllerAnimated:NO];
    if(isMaximized)
    {
        [self needMaximizeMinimize];
    }
    [chartToolbar HideDashBoard];
}

- (void)needMaximizeMinimize
{
    int startIndex =chart_view.startIndex;
    chart_view.showAddIndicators = !isMaximized;
    if(!isMaximized)
    {
        origFrame = self.view.frame;
        fullscreenWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        fullscreenWindow.hidden = NO;
        fullscreenWindow.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:00];
        UIView *v = self.view;
        [v removeFromSuperview];
        [v setFrame:[[UIScreen mainScreen] applicationFrame]];               
        [fullscreenWindow addSubview:v]; 
        //[fullscreenWindow makeKeyAndVisible];
    }
    else
    {
        UIView *v = [fullscreenWindow.subviews objectAtIndex:0]; 
        [v removeFromSuperview];   
        [v setTransform:CGAffineTransformMakeRotation(0)];
        [v setFrame:origFrame];
        [self.parentVC.view addSubview:v];
        //[fullscreenWindow resignKeyWindow];
        [fullscreenWindow release];
        chart_view.lastOrientation = UIInterfaceOrientationPortrait;
        
        UIViewController *container = self.parentVC.parentViewController.parentViewController;
        UIViewController *vc = [[[UIViewController alloc] init] autorelease];
        [container presentModalViewController:vc animated:false];
        [container dismissModalViewControllerAnimated:false];
    }
    [chart_view redraw];
    isMaximized = !isMaximized;
    if([chartToolbar GetButtonWithTag:ID_BTN_MAXMINIMIZE].selectedSegmentTag == ID_SEG_MAXIMIZE)
        [chartToolbar GetButtonWithTag:ID_BTN_MAXMINIMIZE].selectedSegmentTag = ID_SEG_MINIMIZE;
    else
        [chartToolbar GetButtonWithTag:ID_BTN_MAXMINIMIZE].selectedSegmentTag = ID_SEG_MAXIMIZE;
    [[chartToolbar GetButtonWithTag:ID_SEG_MINIMIZE] setNeedsDisplay];
    [self showSettingsToolbar:false];
    [chart_view scrollToBar:startIndex];
    //[chart_view RecalcScroll];
    [chart_view redraw];    
}
- (PropertiesStore*)getPropertiesStore
{
    return chart_view.properties;
}

- (void)setCursorMode:(uint)ChartModeValue
{
    struct HitTestInfo ht = {0};
    switch (ChartModeValue) 
    {
        case CHART_MODE_RESIZE:
            ht.btn = [chartToolbar GetButtonWithTag:ID_BTN_CHART_MODE];
            ht.seg = [ht.btn GetSegmentWithAction:ID_SEG_MODE_RESIZE];
            [ht.btn setSelectedSegmentTag:ID_SEG_MODE_RESIZE];
            [ht.btn.btn setNeedsDisplay];
            
            [[chartToolbar GetButtonWithTag:ID_BTN_CHART_MODE] GetSegmentWithAction:ID_SEG_MODE_DRAW].selectedSegmentTag = ID_SEG_NONE;
            break;            
        default:
            break;
    }
}
/*
 uint chart_nes_colors[] = {0x00000000, 0xFF0000FF,0x00FF00FF,0x0000FFFF, 0xFFFF00FF,0xFF00FFFF,
 0x00FFFFFF,0x800000FF,0x008000FF,0x000080FF,0x808000FF,0x800080FF,0x008080FF,
 0xC0C0C0FF,0x808080FF,0x9999FFFF,0x316396FF,0x993366FF,0xFFFFCCFF,0xCCFFFFFF,0x660066FF,
 0xFF8080FF,0x0066CCFF,0xCCCCFFFF,0x000080FF,0xFF00FFFF,0xFFFF00FF,0x00FFFFFF,
 0x800080FF,0x800000FF,0x008080FF,0x0000FFFF,0x00CCFFFF,0xCCFFFFFF,0xCCFFCCFF,
 0xFFFF99FF,0x99CCFFFF,0xFF99CCFF,0xCC99FFFF,0xFFCC99FF,0x3366FFFF,0x33CCCCFF,
 0x99CC00FF,0xFFCC00FF,0xFF9900FF,0xFF6600FF,0x666699FF,0x969696FF,
 0x000000FF,0x003300FF,0xCCCCCCFF,0xEEEEEEFF,0xFFFFFFFF,0x3333FFFF, 0xFF3333FF,
 0x339966FF,0x003300FF,0x333300FF,0x993300FF,0x993366FF,0x333399FF,0x333333FF,
 0x96C984FF,0x288728FF,0xD86363FF,0x881000FF};
 */
- (void)applyColorScheme:(int)scheme
{
    switch (scheme) 
    {
        case ID_SUBSEG_S1://mt4 black
            [chart_view.properties setParam:@"style.chart_general.chart_bg_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_frame_color" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_grid_color" WithValue:@"0x778899FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_margin_color" WithValue:@"0x000000FF"];
            
            [chart_view.properties setParam:@"style.chart_general.chart_font_color" WithValue:@"0xEEEEEEFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_color" WithValue:@"0xEEEEEEFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_textcolor" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.draw.color" WithValue:@"0xFF0000FF"];
            
            [chart_view.properties setParam:@"style.candles.candle_up" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.candles.candle_up_border" WithValue:@"0x00FF00FF"];
            [chart_view.properties setParam:@"style.candles.candle_down" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.candles.candle_down_border" WithValue:@"0x00FF00FF"];
            
            [chart_view.properties setParam:@"style.bars.chart_bars_color" WithValue:@"0x00FF00FF"];
            [chart_view.properties setParam:@"style.main_line.color" WithValue:@"0x00FF00FF"];
            [chart_view.properties setParam:@"style.area.area_fill_color" WithValue:@"0xFF9900FF"];
            [chart_view.properties setParam:@"style.area.area_stroke_color" WithValue:@"0xEEEEEEFF"];
            
            [chart_view.properties setParam:@"style.annotations.chart_bid_color" WithValue:@"0xFFFFFFFF"];
            break;
            
        case ID_SUBSEG_S2: //orig white
            [chart_view.properties setParam:@"style.chart_general.chart_bg_color" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_frame_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_grid_color" WithValue:@"0xCCCCCCFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_margin_color" WithValue:@"0xFFFFFFFF"];
            
            [chart_view.properties setParam:@"style.chart_general.chart_font_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_textcolor" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.draw.color" WithValue:@"0x000000FF"];
            
            [chart_view.properties setParam:@"style.candles.candle_up" WithValue:@"0x96C984FF"];
            [chart_view.properties setParam:@"style.candles.candle_up_border" WithValue:@"0x288728FF"];
            [chart_view.properties setParam:@"style.candles.candle_down" WithValue:@"0xD86363FF"];
            [chart_view.properties setParam:@"style.candles.candle_down_border" WithValue:@"0x881000FF"];
            
            [chart_view.properties setParam:@"style.bars.chart_bars_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.main_line.color" WithValue:@"0x316396FF"];
            [chart_view.properties setParam:@"style.area.area_fill_color" WithValue:@"0x3333FFFF"];
            [chart_view.properties setParam:@"style.area.area_stroke_color" WithValue:@"0x316396FF"];
            
            [chart_view.properties setParam:@"style.annotations.chart_bid_color" WithValue:@"0x0000FFFF"];
            break;
            
        case ID_SUBSEG_S3: //Reuters white
            [chart_view.properties setParam:@"style.chart_general.chart_bg_color" WithValue:@"0xF4F9FCFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_frame_color" WithValue:@"0x868A8DFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_grid_color" WithValue:@"0xCCD1D5FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_margin_color" WithValue:@"0xFFFFFFFF"];
            
            [chart_view.properties setParam:@"style.chart_general.chart_font_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_textcolor" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.draw.color" WithValue:@"0x000000FF"];
            
            [chart_view.properties setParam:@"style.candles.candle_up" WithValue:@"0x99CC00FF"];
            [chart_view.properties setParam:@"style.candles.candle_up_border" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.candles.candle_down" WithValue:@"0x993366FF"];
            [chart_view.properties setParam:@"style.candles.candle_down_border" WithValue:@"0x000000FF"];
            
            [chart_view.properties setParam:@"style.bars.chart_bars_color" WithValue:@"0xFF9900FF"];
            [chart_view.properties setParam:@"style.main_line.color" WithValue:@"0xFF0000FF"];
            [chart_view.properties setParam:@"style.area.area_fill_color" WithValue:@"0x008000FF"];
            [chart_view.properties setParam:@"style.area.area_stroke_color" WithValue:@"0x000000FF"];
            
            [chart_view.properties setParam:@"style.annotations.chart_bid_color" WithValue:@"0x0000FFFF"];
            break;
            
        case ID_SUBSEG_S4: //Bloomberg black
            [chart_view.properties setParam:@"style.chart_general.chart_bg_color" WithValue:@"0x23313CFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_frame_color" WithValue:@"0xBFC6CCFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_grid_color" WithValue:@"0x545b65FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_margin_color" WithValue:@"0x000000FFF"];
            
            [chart_view.properties setParam:@"style.chart_general.chart_font_color" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_color" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_textcolor" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.draw.color" WithValue:@"0xFFFFFFFF"];
            
            [chart_view.properties setParam:@"style.candles.candle_up" WithValue:@"0x0E7C95FF"];
            [chart_view.properties setParam:@"style.candles.candle_up_border" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.candles.candle_down" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.candles.candle_down_border" WithValue:@"0x000000FF"];
            
            [chart_view.properties setParam:@"style.bars.chart_bars_color" WithValue:@"0xFF9900FF"];
            [chart_view.properties setParam:@"style.main_line.color" WithValue:@"0xFF9900FF"];
            [chart_view.properties setParam:@"style.area.area_fill_color" WithValue:@"0x0E7C95FF"];
            [chart_view.properties setParam:@"style.area.area_stroke_color" WithValue:@"0xFFFFFFFF"];
            
            [chart_view.properties setParam:@"style.annotations.chart_bid_color" WithValue:@"0x0E7C95FF"];
            break;
            
        case ID_SUBSEG_S5: //vivid white
            [chart_view.properties setParam:@"style.chart_general.chart_bg_color" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_frame_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_grid_color" WithValue:@"0xCCCCCCFF"];
            [chart_view.properties setParam:@"style.chart_general.chart_margin_color" WithValue:@"0xEEEEEEFF"];
            
            [chart_view.properties setParam:@"style.chart_general.chart_font_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.chart_general.chart_cursor_textcolor" WithValue:@"0xFFFFFFFF"];
            [chart_view.properties setParam:@"style.draw.color" WithValue:@"0x000000FF"];
            
            [chart_view.properties setParam:@"style.candles.candle_up" WithValue:@"0x00FF00FF"];
            [chart_view.properties setParam:@"style.candles.candle_up_border" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.candles.candle_down" WithValue:@"0xFF0000FF"];
            [chart_view.properties setParam:@"style.candles.candle_down_border" WithValue:@"0x000000FF"];
            
            [chart_view.properties setParam:@"style.bars.chart_bars_color" WithValue:@"0x000000FF"];
            [chart_view.properties setParam:@"style.main_line.color" WithValue:@"0x316396FF"];
            [chart_view.properties setParam:@"style.area.area_fill_color" WithValue:@"0x3333FFFF"];
            [chart_view.properties setParam:@"style.area.area_stroke_color" WithValue:@"0x316396FF"];
            
            [chart_view.properties setParam:@"style.annotations.chart_bid_color" WithValue:@"0x0000FFFF"];
            break;            
        default:
            break;
    }
    [self SaveSettings];
    [chart_view rebuild];
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [chart_view release];
    [chartToolbar release];
    [chartSensor release];
    [super dealloc];
}


- (void)viewDidUnload {
    [chart_view release];
    chart_view = nil;
    [chartToolbar release];
    chartToolbar = nil;
    [chartSensor release];
    chartSensor = nil;
    [super viewDidUnload];
}
@end
