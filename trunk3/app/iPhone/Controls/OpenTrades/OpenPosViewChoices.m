//
//  WEPopoverContentViewController.m
//  WEPopover
//
//  Created by Werner Altewischer on 06/11/10.
//  Copyright 2010 Werner IT Consultancy. All rights reserved.
//

#import "OpenPosViewChoices.h"
#import "OpenPosWatch.h"


@implementation OpenPosViewChoices

@synthesize ViewChoices;
@synthesize ParentController;
@synthesize CurrentView;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
//        switch (self.CurrentView)
//        {
//            case OPEN_TRADE_VIEW_DEPOSIT_CUR:
//                self.ViewChoices = [NSArray arrayWithObjects:@"Collective View", @"As Points", nil];
//                break;
//            case OPEN_TRADE_VIEW_POINTS:
//                self.ViewChoices = [NSArray arrayWithObjects:@"Collective View", @"As Depos. Cur.", nil];
//                break;
//            case OPEN_TRADE_VIEW_AGR:
//                self.ViewChoices = [NSArray arrayWithObjects:@"Normal View", @"As Points", nil];
//                break;
//            default:
//                self.ViewChoices = [NSArray arrayWithObjects:@"Collective View", @"As Points", nil];
//                break;
//        }
//		self.contentSizeForViewInPopover = CGSizeMake(180, [self.ViewChoices count] * 44 - 1);
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.rowHeight = 44.0;
	self.view.backgroundColor = [UIColor clearColor];
    ((UIScrollView*)self.view).bounces = NO;
    ((UIScrollView*)self.view).showsVerticalScrollIndicator = NO;
    switch (self.CurrentView)
    {
        case OPEN_TRADE_VIEW_DEPOSIT_CUR:
            self.ViewChoices = [NSArray arrayWithObjects:NSLocalizedString(@"popover_collective", nil), NSLocalizedString(@"popover_points" ,nil), nil];
            break;
        case OPEN_TRADE_VIEW_POINTS:
            self.ViewChoices = [NSArray arrayWithObjects:NSLocalizedString(@"popover_collective", nil), NSLocalizedString(@"popover_normal", nil), nil];
            break;
        case OPEN_TRADE_VIEW_AGR:
            self.ViewChoices = [NSArray arrayWithObjects:NSLocalizedString(@"popover_normal", nil), NSLocalizedString(@"popover_points" ,nil), nil];
            break;
        default:
            self.ViewChoices = [NSArray arrayWithObjects:NSLocalizedString(@"popover_collective", nil), NSLocalizedString(@"popover_points" ,nil), nil];
            break;
    }
    self.contentSizeForViewInPopover = CGSizeMake(180, [self.ViewChoices count] * 44 - 1);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.ViewChoices count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
//    if ([indexPath row] == [ViewChoices count] -1)
//    {
//        tableView.separatorColor = [UIColor clearColor];
//    }
//    else
//    {
//        tableView.separatorColor = nil;
//    }   
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString *optionTitle = [self.ViewChoices objectAtIndex:[indexPath row]];
	cell.textLabel.text = [NSString stringWithFormat:@"%@", optionTitle]; 
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
//	[cell.textLabel sizeToFit];
	cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.
    OpenTradesViewType openTradesViewTypeToSet = OPEN_TRADE_VIEW_DEPOSIT_CUR;
    switch (self.CurrentView)
    {
        case OPEN_TRADE_VIEW_DEPOSIT_CUR:
            switch (indexPath.row)
            {
                case 0:
                    openTradesViewTypeToSet = OPEN_TRADE_VIEW_AGR; 
                    break;
                case 1:
                    openTradesViewTypeToSet = OPEN_TRADE_VIEW_POINTS;
                    break;
                default:
                    break;
            }
            break;
        case OPEN_TRADE_VIEW_POINTS:
            switch (indexPath.row)
            {
                case 0:
                    openTradesViewTypeToSet = OPEN_TRADE_VIEW_AGR;
                    break;
                case 1:
                    openTradesViewTypeToSet = OPEN_TRADE_VIEW_DEPOSIT_CUR;
                    break;
                default:
                    break;
            }
            break;
        case OPEN_TRADE_VIEW_AGR:
            switch (indexPath.row)
            {
                case 0:
                    openTradesViewTypeToSet = OPEN_TRADE_VIEW_DEPOSIT_CUR;
                    break;
                case 1:
                    openTradesViewTypeToSet = OPEN_TRADE_VIEW_POINTS;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    [ParentController dismissPopoverAndChangeToView:openTradesViewTypeToSet];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

