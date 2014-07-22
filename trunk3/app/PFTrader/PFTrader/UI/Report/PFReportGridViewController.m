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

@end
