#import "PFNewsViewController.h"

#import "PFNewsStoryCell.h"
#import "PFNewsStoryViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFNewsViewController ()

@property ( nonatomic, strong ) NSArray* stories;

@end

@implementation PFNewsViewController

@synthesize stories = _stories;

-(void)dealloc
{
   [ _stories release ];

   [ super dealloc ];
}

-(void)addStories:( NSArray* )stories_
{
   self.stories = [ PFSession sharedSession ].stories.stories;
   [ self.tableView reloadData ];
}

-(void)viewDidLoad 
{
	// Add the following line if you want the list to be editable
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	self.tableView.rowHeight = 60;
	self.tableView.separatorColor = [UIColor clearColor];
	
	self.navigationItem.title = NSLocalizedString(@"TABS_NEWS", nil);

	//self.tabBarController.moreNavigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];

	//self.navigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];
	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}

   [ super viewDidLoad ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [ self.stories count ];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// Set up the cell
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];

	if((storyIndex%2)==0)  		
		cell.backgroundColor = [UIColor colorWithRed: 241.0/255.0 green: 244.0/255.0 blue: 247.0/255.0 alpha: 1];
	else
		cell.backgroundColor = [UIColor whiteColor];
}

-(id< PFStory >)storyAtIndex:( NSUInteger )index_
{
   //NSUInteger reverse_index_ = [ self.stories count ] - index_ - 1;

   return [ self.stories objectAtIndex: index_ ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"PFNewsStoryCell";
	
	PFNewsStoryCell *cell_ = (PFNewsStoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if ( !cell_ )
	{
		cell_ = [ PFNewsStoryCell storyCell ];
	}

   id< PFStory > story_ = [ self storyAtIndex: indexPath.row ];

   cell_.headerLabel.text = story_.header;
   cell_.categoryLabel.text = story_.source;
   cell_.dateLabel.text = [ story_.date description ];

	return cell_;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic
	PFNewsStoryViewController* controller_ = [ PFNewsStoryViewController controllerWithStory: [ self storyAtIndex: indexPath.row ] ];

	[ self.navigationController pushViewController: controller_ animated: YES ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end

