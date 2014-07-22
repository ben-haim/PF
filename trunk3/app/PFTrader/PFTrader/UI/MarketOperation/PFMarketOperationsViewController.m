#import "PFMarketOperationsViewController.h"

#import "PFSegmentedControl.h"

#import "PFMarketOperationsDataSource.h"

@class PFGridFooterView;

@interface PFMarketOperationsViewController ()

@property ( nonatomic, strong ) NSArray* dataSources;
@property ( nonatomic, strong ) id< PFMarketOperationsDataSource > activeDataSource;
@property ( nonatomic, weak ) NSTimer* updateTimer;

@end

@implementation PFMarketOperationsViewController

@synthesize typeControl;

@synthesize dataSources;
@synthesize activeDataSource;
@synthesize updateTimer;

-(void)dealloc
{
   [ self.activeDataSource deactivate ];

   self.dataSources = nil;
   self.activeDataSource = nil;
}

-(id)initWithNibName:( NSString* )nib_name_
              bundle:( NSBundle* )bundle_
{
   self = [ super initWithNibName: nib_name_ bundle: bundle_ ];

   if ( self )
   {
      self.title = NSLocalizedString( @"ORDERS", nil );
   }

   return self;
}

-(id)init
{
   return [ self initWithNibName: NSStringFromClass( [ self class ] )
                          bundle: nil ];
}

-(NSArray*)operationDataSources
{
   return @[ [ PFActiveOperationsDataSource new ]
   , [ PFFilledOperationsDataSource new ]
   , [ PFAllOperationsDataSource new ] ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   self.dataSources = [ self operationDataSources ];

   self.typeControl.items = [ self.dataSources valueForKeyPath: @"@unionOfObjects.title" ];
   self.typeControl.selectedSegmentIndex = 0;
}

-(void)viewDidAppear:( BOOL )animated_
{
   [ super viewDidAppear: animated_ ];
   
   self.updateTimer = [ NSTimer scheduledTimerWithTimeInterval: 1.0
                                                        target: self
                                                      selector: @selector(updateRows)
                                                      userInfo: nil
                                                       repeats: YES ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self.updateTimer invalidate ];
   self.updateTimer = nil;
}

-(void)gridView:( PFGridView* )grid_view_
didSelectRowAtIndex:( NSUInteger )row_index_
{
   [ self.activeDataSource selectElementAtIndex: row_index_ ];
}

-(void)didTapSummaryInFootterView:( PFGridFooterView* )footer_view_
{
   [ self.activeDataSource showSummaryActions ];
}

#pragma mark PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_
   didSelectItemAtIndex:( NSInteger )index_
{
   [ self.activeDataSource deactivate ];
   self.activeDataSource = [ self.dataSources objectAtIndex: index_ ];
   [ self.activeDataSource activateInController: self ];
}

@end
