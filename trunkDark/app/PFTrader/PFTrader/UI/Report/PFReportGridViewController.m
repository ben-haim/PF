#import "PFReportGridViewController.h"
#import "PFReportColumn.h"
#import "UIColor+Skin.h"

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

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   if ( self.table.isTransformed )
   {
      self.elements = [ self.table.rows map: ^id( id row_ )
      {
         NSMutableDictionary* rows_dictionary_ = (NSMutableDictionary*)row_;
         rows_dictionary_[(self.table.header)[0]] = NSLocalizedString( rows_dictionary_[(self.table.header)[0]], nil );
         
         return rows_dictionary_;
      } ];
   }
   else
   {
      self.elements = self.table.rows;
   }

   self.columns = [ self.table.header map: ^id( id header_ ) { return [ PFReportColumn reportColumnWithName: ( NSString* )header_ ]; } ];
   [ self setSummaryButtonHidden: YES ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      [ self setDarkNavigationBar ];
      self.view.backgroundColor = [ UIColor backgroundLightColor ];
   }
}

-(BOOL)isPaginal
{
   return NO;
}

-(CGFloat)widthOfFixedColumnInGridView:( PFGridView* )grid_view_
{
   return 0.f;
}

-(CGFloat)gridView:( PFGridView* )grid_view_ widthOfColumnAtIndex:( NSUInteger )column_index_
{
   return self.table.isTransformed ? ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 401.f : 160.f ) : 100.f;
}

@end
