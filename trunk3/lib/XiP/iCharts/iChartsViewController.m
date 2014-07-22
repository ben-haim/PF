
#import "iChartsViewController.h"
#import "AccelerationAnimation.h"
#import "Evaluate.h"
#import "EditPropertiesViewController.h"
#import "ChooseIndicatorsController.h"

@implementation iChartsViewController
@synthesize chartToolbar;
- (void)dealloc
{
    [pnlChart release];
    [chartToolbar release];
    [pnlChart release];
    [chartSensor release];
    [btnShowHideMenu release];

    pnlChart = nil;
    chartToolbar = nil;
    pnlChart = nil;
    chartSensor = nil;
    btnShowHideMenu = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(settingsDlgClosed:)
												 name:@"settingsDlgClosed" 
                                               object:nil];
    
    //REMOVE
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chart_eurusd_240" ofType:@"txt"];  
    NSString *myText = [NSString stringWithContentsOfFile:filePath 
                                encoding: NSUTF8StringEncoding
                                error: NULL];
    [pnlChart fillDefaultChartSettings];
    [pnlChart setParent:self];
    [pnlChart updateChartSensor:chartSensor];
    [pnlChart setCursorMode:CHART_MODE_NONE];
    
    [chartToolbar setTb_delegate:self];
    [chartToolbar setupChartToolbar];
    [self showSettingsToolbar:false];

    [self hideSettingsToolbar:false];
    [self ChartReceived:myText];
}
- (void)settingsDlgClosed:(NSNotification *)notification
{
	//SelectDateDialog *dateDlg = (SelectDateDialog *)[notification object];
    [pnlChart rebuild];
    //[chartToolbar alterColors];
}
/*-(void)restoreToolbarWithSettings:(IndicatorDesc*)ind_desc
{
    ToolbarButton* btn = [chartToolbar GetButtonWithTag:ID_BTN_CHART_TYPE];
    switch (pnlChart.chartType) 
    {
        case CHART_TYPE_CANDLES:
            btn.selectedSegmentTag = ID_SEG_TYPE_CANDLES;
            break;
        case CHART_TYPE_BARS:
            btn.selectedSegmentTag = ID_SEG_TYPE_BARS;
            break;
        case CHART_TYPE_LINE:
            btn.selectedSegmentTag = ID_SEG_TYPE_LINE;
            break;
        case CHART_TYPE_AREA:
            btn.selectedSegmentTag = ID_SEG_TYPE_AREA;
            break;
            
        default:
            break;
    }
    
}*/

- (IBAction)doBtnShowHideMenu:(id)sender 
{
	[self toggleSettingsToolbar:true];
}

-(void)showSettingsToolbar:(BOOL)withAnimation
{
    [chartToolbar collapseAllButtons];
    [chartToolbar setNeedsDisplay];
    chartToolbar.alpha = 1;
    // Move the two objects to the origin without animating
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

-(void)hideSettingsToolbar:(BOOL)withAnimation
{
    [chartToolbar HideDashBoard];
    if(withAnimation)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:CHART_TB_ANIM_DURATION];
    }
    
    chartToolbar.frame = CGRectMake(    0, 
                                        -chartToolbar.bounds.size.height, 
                                        self.view.bounds.size.width, 
                                        CHART_BTN_TOP_PADDING*2 + CHART_BTN_HEIGHT);
    
    chartToolbar.alpha = 0;

    if(withAnimation)
    {
        [UIView commitAnimations];
    }
}

-(void)toggleSettingsToolbar:(BOOL)withAnimation
{
    if(chartToolbar.alpha==1)
        [self hideSettingsToolbar:withAnimation];
    else
        [self showSettingsToolbar:withAnimation];
}
- (void)animate
{
    /*CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:0.35];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromTop;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 0.58;
    [animation setRemovedOnCompletion:NO];
    [[self.view layer] addAnimation:animation forKey:@"pageCurlAnimation"];*/
    
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
            break;            
        default:
            break;
    }
}
-(void)buttonClick:(struct HitTestInfo)ht
{
    if(ht.btn==nil)
        return;
    switch (ht.btn.tag) 
    {
        case ID_BTN_MAXMINIMIZE:
            {
                /*UIWindow *statusWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                statusWindow.windowLevel = UIWindowLevelStatusBar;
                statusWindow.hidden = NO;
                statusWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];

                
                UIView* uiView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

                
                [statusWindow addSubview:uiView];
                UITextField *textField;
                
                textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 200, 170)];
                [textField setText:@"My Label"];
                [uiView addSubview:textField];
                [textField becomeFirstResponder];
                
                
                
                
                
                
                [statusWindow makeKeyAndVisible];*/
            } 
            break;
        case ID_BTN_CHART_INTERVAL:
            {
                /*UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Range"
                                                             message:[pnlChart.chart_data getIntervalName]
                                                            delegate:self 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil];
                [av show];
                [av release];*/
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
                [pnlChart setCursorMode:cursorMode];
                if(cursorMode == CHART_MODE_DRAW)
                {
                    pnlChart.drawSubtype = ht.seg.selectedSegmentTag;
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
                [pnlChart setMainChartType:newChartType];
            }
            break;
        case ID_BTN_CHART_INDICATORS:
            {
                ChooseIndicatorsController *dlgIndicators = [[ChooseIndicatorsController alloc] initWithNibName:@"ChooseIndicatorsController" bundle:nil];
                [dlgIndicators ShowIndicators:pnlChart.properties 
                                  AndDefStore:pnlChart.default_properties];
                
                dlgIndicators.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentModalViewController:dlgIndicators animated:YES  ];
                [dlgIndicators release];
            }
            break;
        case ID_BTN_SETTINGS:
            {     
                EditPropertiesViewController *dlgEdit = [[EditPropertiesViewController alloc] initWithNibName:@"EditPropertiesView" bundle:nil];
                //[dlgEdit ShowFlatProperties:pnlChart.properties ForPath:@"style" withCaption:@"Style"];
                [dlgEdit ShowProperties:pnlChart.properties
                              WithTitle:NSLocalizedString(@"chart", "chart title") 
                                ForPath:@"style" 
                             WithNotify:@"settingsDlgClosed"];
                
                dlgEdit.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentModalViewController:dlgEdit animated:YES  ];
                [dlgEdit release];
                /*CAAnimation *topAnimation = [chartToolbar flipAnimationWithDuration:0.75 forLayerBeginningOnTop:YES scaleFactor:0.5f];
                CGFloat zDistance = 1000.0f;
                CATransform3D perspective = CATransform3DIdentity; 
                perspective.m34 = -1. / zDistance;
                ht.btn.transform = perspective;
                
                [CATransaction begin];
                [ht.btn addAnimation:topAnimation forKey:@"flip"];
                [CATransaction commit];  */
                
               /* [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:1.0];
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];

                
                [UIView commitAnimations];*/
                //[chartToolbar ShowDashBoardForSegment:ht.seg];
                
            }
            break;
    }
    NSLog(@"delegate called with %d / %d\n", ht.btn.tag, ht.seg.action);
}
- (PropertiesStore*)getPropertiesStore
{
    return pnlChart.properties;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    if(chartToolbar.alpha == 1)
        [self showSettingsToolbar:false];
    else
        [self hideSettingsToolbar:false];
	[pnlChart receivedRotate:interfaceOrientation];   
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(chartToolbar.alpha == 0)        
        [self hideSettingsToolbar:false];
    [chartToolbar HideDashBoard];
}

-(void)ChartReceived:(NSString*)data
{
    int digits = 5;
    int RangeType = 240;
    NSString *symbol=@"EURUSD";
    NSArray *commands = [data componentsSeparatedByString:@"$"];
    if(commands.count!=2)
    {
        return;
    }
    NSString *command = [commands objectAtIndex:0];     
    NSArray *cmdArgs = [command componentsSeparatedByString:@"|"];
    
    [pnlChart SetData:cmdArgs ForSymbol:symbol WithDigits:digits ForRangeType:RangeType];
    [[chartToolbar GetButtonWithTag:ID_BTN_CHART_INTERVAL] GetSegmentWithAction:ID_SEG_INTERVAL].selectedSegmentTag = RangeType;
    [chartToolbar setNeedsDisplay];
}


@end
