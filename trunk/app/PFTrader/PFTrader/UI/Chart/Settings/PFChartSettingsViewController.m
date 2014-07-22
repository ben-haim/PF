#import "PFChartSettingsViewController.h"

#import "PFChartSettings.h"

#import "PFTableView.h"
#import "PFTableViewCategory+ChartSettings.h"

@interface PFChartSettingsViewController ()

@property ( nonatomic, strong ) PFChartSettings* settings;
@property ( nonatomic, strong ) NSArray* categories;

@end

@implementation PFChartSettingsViewController

@synthesize categories = _categories;
@synthesize settings;
@synthesize delegate;

-(id)initWithSettings:( PFChartSettings* )chart_settings_
{
   self = [ super init ];
   if ( self )
   {
      self.settings = chart_settings_;
      self.title = NSLocalizedString( @"СHART_SETTINGS", nil );
   }
   return self;
}

-(NSArray*)categories
{
   if ( !_categories )
   {
      _categories = [ NSArray arrayWithObjects:
                     [ PFTableViewCategory generalCategoryWithSettings: self.settings ]
                     , [ PFTableViewCategory tradingLayersCategoryWithSettings: self.settings ]
                     , [ PFTableViewCategory additionalCategoryWithSettings: self.settings ]
                     , nil ];
   }
   return _categories;
}

-(void)done
{
   [ self.categories makeObjectsPerformSelector: @selector( performApplierForObject: )
                                     withObject: self.settings ];

   [ self.settings save ];

   [ self.delegate didCompleteSettingsController: self ];
}

-(void)cancel
{
   [ self.delegate didCompleteSettingsController: self ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   self.navigationItem.leftBarButtonItem =
   [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                    target: self
                                                    action: @selector( done ) ];

   self.navigationItem.rightBarButtonItem =
   [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                    target: self
                                                    action: @selector( cancel ) ];
   
   self.tableView.categories = self.categories;
   [ self.tableView reloadData ];
}

-(void)dealloc
{
    self.categories = nil;
}

-(BOOL)shouldAutorotate
{
   return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
{
   return UIInterfaceOrientationIsPortrait( interface_orientation_ );
}

-(NSUInteger)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(void)willRotateToInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
                               duration:( NSTimeInterval )duration_
{
   [ super willRotateToInterfaceOrientation: interface_orientation_ duration: duration_ ];
   [ self.delegate willRotateToInterfaceOrientation: interface_orientation_ duration: duration_ ];
}

@end
