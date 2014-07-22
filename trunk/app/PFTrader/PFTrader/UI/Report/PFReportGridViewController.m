#import "PFReportGridViewController.h"

#import "PFReportColumn.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFReportGridViewController ()

@property ( nonatomic, strong ) id< PFReportTable > table;

@end

@implementation PFReportGridViewController

@synthesize table;

-(id)initWithReportTable:( id< PFReportTable > )table_
{
   self = [ self init ];

   if ( self )
   {
      self.table = table_;
   }

   return self;
}

- (void)viewDidLoad
{
   self.elements = self.table.rows;

   self.columns = [ self.table.header map: ^id( id header_ )
                   {
                      return [ PFReportColumn reportColumnWithName: ( NSString* )header_ ];
                   }];

   [ self setSummaryButtonHidden: YES ];
   
   [ super viewDidLoad ];
}

-(BOOL)shouldAutorotate
{
   return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskAll;
}

-(BOOL)isPaginal
{
   return NO;
}

-(BOOL)shouldHideNavigationBarForOrientation:( UIInterfaceOrientation )interface_orientation_
{
    return UIInterfaceOrientationIsLandscape( interface_orientation_ );
}

-(void)willRotateToInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
                               duration:( NSTimeInterval )duration_
{
    BOOL is_hidden_ = self.navigationController.navigationBarHidden;
    BOOL should_hide_ = [ self shouldHideNavigationBarForOrientation: interface_orientation_ ];

    if ( is_hidden_ != should_hide_ )
    {
        [ self.navigationController setNavigationBarHidden: should_hide_ animated: YES ];
    }
}

@end
