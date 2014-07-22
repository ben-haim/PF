#import "PFChartSettingsViewController.h"
#import "PFChartSettings.h"
#import "PFTableView.h"
#import "PFTableViewCategory+ChartSettings.h"
#import "UIColor+Skin.h"

@interface PFChartSettingsViewController ()

@property ( nonatomic, strong ) PFChartSettings* settings;
@property ( nonatomic, strong ) NSArray* categories;

@end

@implementation PFChartSettingsViewController

@synthesize categories = _categories;
@synthesize settings;
@synthesize delegate;

-(void)dealloc
{
   self.categories = nil;
}

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
      _categories = @[[ PFTableViewCategory generalCategoryWithSettings: self.settings ]
                     , [ PFTableViewCategory tradingLayersCategoryWithSettings: self.settings ]
                     , [ PFTableViewCategory additionalCategoryWithSettings: self.settings ]];
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

//   self.navigationItem.leftBarButtonItem =
//   [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
//                                                    target: self
//                                                    action: @selector( cancel ) ];
   
   self.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFCloseButtonModal" ]
                                                                                style: UIBarButtonItemStylePlain
                                                                               target: self
                                                                               action: @selector( done ) ];
   
   self.tableView.categories = self.categories;
   [ self.tableView reloadData ];
   
   self.view.backgroundColor = [ UIColor backgroundLightColor ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   [ self setDarkNavigationBar ];
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
