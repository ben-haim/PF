
#import "ChooseIndicatorsController.h"
#import "PropertiesStore.h"
#import "EditPropertiesViewController.h"
#import "IndListViewController.h"

@implementation ChooseIndicatorsController
@synthesize default_properties,properties;
@synthesize indicatorsList;
@synthesize tbNormal, tbEditing, btnEdit, btnClose, lblCaption1, lblCaption2, btnDone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(indEditDlgClosed:)
                                                     name:@"indEditDlgClosed" 
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(indListSelected:)
                                                     name:@"indListSelected" 
                                                   object:nil];
        
    }
    return self;
}

- (void)indEditDlgClosed:(NSNotification *)notification
{
    //NSLog(@"indEditDlgClosed");
}

- (void)indListSelected:(NSNotification *)notification
{
    NSString* paramName = [notification object];
    
    //insert data to dictionary
    NSString* fullParamPath = [NSString stringWithFormat:@"indicators.%@", paramName];
    NSMutableDictionary* defIndParams = [NSMutableDictionary dictionaryWithDictionary:[[default_properties getDict:fullParamPath] copy]];
    
    bool alreadyExists = true;
    NSString* testParamName;
    int c = 1;
    do 
    {
        testParamName = [NSString stringWithFormat:@"%@_%d", paramName, c];
        NSString* testParamPath = [NSString stringWithFormat:@"indicators.%@", 
                                   testParamName];
        NSDictionary* searchIndParams = [properties getDict:testParamPath];
        alreadyExists = (searchIndParams!=nil);
        c++;
    } 
    while (alreadyExists);
    //NSLog(@"testParamName %@", testParamName);
    //[defIndParams setValue:testParamName forKey:@"code"];
    [properties cloneDict:default_properties FromPath:fullParamPath AtNewPath:@"indicators" AndNewName:testParamName];

    
    //insert record to order list
    NSMutableArray *indArr = nil;
    NSString *arrName = nil;
    NSString *arrParamPath = nil;
    
    if([defIndParams[@"mainchart"] intValue]==1)    
        arrName = @"user_main";
    else  
        arrName = @"user_add";    
    arrParamPath = [NSString stringWithFormat:@"indicators.%@", arrName];
    indArr = [NSMutableArray arrayWithArray:[properties getArray:arrParamPath]];
    
	[indArr addObject:testParamName];
    
    [properties setArray:arrName inPath:@"indicators" WithArray:indArr];
    [indicatorsList reloadData];
    //NSLog(@"%@", [properties getDict:@""] );
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [btnClose setTitle:NSLocalizedString(@"chart_btn_settings_back", @"Back")];
    [lblCaption1 setTitle:NSLocalizedString(@"chart_indicators", @"Back")];
    [lblCaption2 setTitle:NSLocalizedString(@"chart_indicators", @"Back")];
    [btnDone setTitle:NSLocalizedString(@"BUTTONS_DONE", @"Done")];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)ShowIndicators:(PropertiesStore*)store AndDefStore:(PropertiesStore*)def_store
{
    [self setProperties:store];
    [self setDefault_properties:def_store];
}
- (IBAction)btnClosePressed:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"settingsDlgClosed" object:properties];
}


- (IBAction)btnEditPressed:(id)sender 
{
    if([indicatorsList isEditing])
    {
        [self.indicatorsList setEditing:NO animated:YES];
        [tbEditing setHidden:YES];
        [tbNormal setHidden:NO];

    }
    else
    {
        [self.indicatorsList setEditing:YES animated:YES];
        [tbEditing setHidden:NO];
        [tbNormal setHidden:YES];
    
    }
    [btnEdit.customView setNeedsDisplay];
    [indicatorsList reloadData];
}

- (IBAction)btnAddPressed:(id)sender 
{
    IndListViewController *dlgList = [[IndListViewController alloc] initWithNibName:@"IndListViewController" bundle:nil];
    [dlgList ShowIndicators:default_properties];
    dlgList.rootViewController = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:dlgList];
        
        [navControl setModalPresentationStyle:UIModalPresentationPageSheet];
        
        [self presentModalViewController:navControl animated:YES];
        
        
        navControl.view.superview.autoresizingMask = 
		UIViewAutoresizingFlexibleTopMargin | 
		UIViewAutoresizingFlexibleBottomMargin;    
		navControl.view.superview.frame = CGRectMake(
													  navControl.view.superview.frame.origin.x,
													  navControl.view.superview.frame.origin.y,
													  540.0f,
													  650.0f
													  );
        CGPoint centerPt;
        UIInterfaceOrientation orientation = [self interfaceOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            centerPt = CGPointMake(768/2, 1024/2);
            // NSLog(@"portrait");
        }
        else
        {
            centerPt = CGPointMake(1024/2, 768/2);
            // NSLog(@"landscape");
        }
        navControl.view.superview.center = centerPt; 
    }
    else
    {
        dlgList.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [self presentModalViewController:dlgList animated:YES  ];
    }
    
    
    
}

- (bool)IsMainIndSection:(int)section
{
    return section==0 &&
            [[properties getArray:@"indicators.user_main"] count]>0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    int sections_count = 0;
    if([[properties getArray:@"indicators.user_main"] count]>0)
        sections_count++;
    if([[properties getArray:@"indicators.user_add"] count]>0)
        sections_count++;
    
    // Return the number of sections.
    return sections_count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{      
    if([self IsMainIndSection:(int)section])
    {
        return [[properties getArray:@"indicators.user_main"] count];
    }
    else
        return [[properties getArray:@"indicators.user_add"] count];
        
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([self IsMainIndSection:(int)section])
        return NSLocalizedString(@"chart_main_chart", nil);//@"Main chart";
    else
        return NSLocalizedString(@"chart_main_panels", nil);//@"Panels";
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//int pos = indexPath.row;
	//int cnt = [FavSymbols count];
	//return pos < cnt;
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	   toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath 
{
	if(sourceIndexPath.section == proposedDestinationIndexPath.section)
        return proposedDestinationIndexPath;
    else
        return sourceIndexPath;
}

// Process the row move. This means updating the data model to correct the item indices.

- (void)tableView:(UITableView *)tableView 
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
      toIndexPath:(NSIndexPath *)toIndexPath 
{ 
    NSMutableArray *indArr = nil;
    NSString *paramName = nil;
    NSString *fullParamPath = nil;
    
    if([self IsMainIndSection:(int)fromIndexPath.section])
        paramName = @"user_main";
    else  
        paramName = @"user_add";    
    fullParamPath = [NSString stringWithFormat:@"indicators.%@", paramName];
    indArr = [NSMutableArray arrayWithArray:[properties getArray:fullParamPath]];
              
	NSString *item = indArr[fromIndexPath.row];
	[indArr removeObject:item];
	[indArr insertObject:item atIndex:toIndexPath.row];
    
    [properties setArray:paramName inPath:@"indicators" WithArray:indArr];
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (editingStyle != UITableViewCellEditingStyleDelete) 
        return;
    
    NSMutableArray *indArr = nil;
    NSString *paramName = nil;
    NSString *fullParamPath = nil;
    
    //NSLog(@"%@", [properties getJSONString] );
    if([self IsMainIndSection:(int)indexPath.section])
        paramName = @"user_main";
    else  
        paramName = @"user_add";    
    fullParamPath = [NSString stringWithFormat:@"indicators.%@", paramName];
    indArr = [NSMutableArray arrayWithArray:[properties getArray:fullParamPath]];
    
    //remove this indicator data
    NSString* indCode = indArr[indexPath.row];
    NSDictionary *oldDict = [properties getDict:@"indicators"];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:oldDict];
    [newDict removeObjectForKey:indCode];
    [properties setDict:@"indicators" inPath:@"" WithDict:newDict];
    
    //remove record from the list of shown indicators    
    [indArr removeObjectAtIndex:indexPath.row];        
    [properties setArray:paramName inPath:@"indicators" WithArray:indArr];
    
    
    //NSLog(@"%@", [properties getJSONString] );
    [self.indicatorsList reloadData];
}
-(UITableViewCellAccessoryType)tableView:(UITableView *)tableView
        accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{ 
    return UITableViewCellAccessoryDisclosureIndicator; 
}
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    NSString *CellText = nil;
    NSArray *indicators = nil;
    if([self IsMainIndSection:(int)indexPath.section])
    {
        indicators = [properties getArray:@"indicators.user_main"];
    }
    else
    {
        indicators = [properties getArray:@"indicators.user_add"];
    }
        
    NSString *indPropPath = [NSString stringWithFormat:@"indicators.%@.title", 
                             indicators[indexPath.row]];
    CellText = NSLocalizedString([properties getParam:indPropPath], "ind localized title");

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero 
//                                       reuseIdentifier:CellIdentifier] autorelease];
    }    
    cell.textLabel.text = CellText;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    [indicatorsList deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *indicators = nil;
    if([self IsMainIndSection:(int)indexPath.section])
    {
        indicators = [properties getArray:@"indicators.user_main"];
    }
    else
    {
        indicators = [properties getArray:@"indicators.user_add"];
    }
    
    NSString *indID = indicators[indexPath.row];
    NSString *indPath = [NSString stringWithFormat:@"indicators.%@", indID]; 
    //NSLog(@"%@", indPath);
    EditPropertiesViewController *dlgEdit = [[EditPropertiesViewController alloc] initWithNibName:@"EditPropertiesView" bundle:nil];

    NSString *indPropPath = [NSString stringWithFormat:@"%@.title", indPath];
    NSString *indTitle = NSLocalizedString([properties getParam:indPropPath], "ind localized title");
    [dlgEdit ShowProperties:properties 
                  WithTitle:indTitle 
                    ForPath:indPath 
                 WithNotify:@"indEditDlgClosed"
     ];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
//        [dlgEdit setModalPresentationStyle:UIModalPresentationPageSheet];
//        [self presentModalViewController:dlgEdit animated:YES];
//        
//        dlgEdit.view.superview.autoresizingMask = 
//		UIViewAutoresizingFlexibleTopMargin | 
//		UIViewAutoresizingFlexibleBottomMargin;    
//		dlgEdit.view.superview.frame = CGRectMake(
//                                                     dlgEdit.view.superview.frame.origin.x,
//                                                     dlgEdit.view.superview.frame.origin.y,
//                                                     540.0f,
//                                                     650.0f
//                                                     );
//        CGPoint centerPt;
//        UIInterfaceOrientation orientation = [self interfaceOrientation];
//        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
//        {
//            centerPt = CGPointMake(768/2, 1024/2);
//            // NSLog(@"portrait");
//        }
//        else
//        {
//            centerPt = CGPointMake(1024/2, 768/2);
//            // NSLog(@"landscape");
//        }
//        dlgEdit.view.superview.center = centerPt;
        
        
        UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:dlgEdit];
        
        [navControl setModalPresentationStyle:UIModalPresentationPageSheet];
        
        [self presentModalViewController:navControl animated:YES];
        
        
        navControl.view.superview.autoresizingMask = 
		UIViewAutoresizingFlexibleTopMargin | 
		UIViewAutoresizingFlexibleBottomMargin;    
		navControl.view.superview.frame = CGRectMake(
                                                     navControl.view.superview.frame.origin.x,
                                                     navControl.view.superview.frame.origin.y,
                                                     540.0f,
                                                     650.0f
                                                     );
        CGPoint centerPt;
        UIInterfaceOrientation orientation = [self interfaceOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            centerPt = CGPointMake(768/2, 1024/2);
            // NSLog(@"portrait");
        }
        else
        {
            centerPt = CGPointMake(1024/2, 768/2);
            // NSLog(@"landscape");
        }
        navControl.view.superview.center = centerPt; 
    }
    else
    {
        dlgEdit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:dlgEdit animated:YES  ];
    }  
    
}

@end
