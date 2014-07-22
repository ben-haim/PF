#import "PFSecureLogsController.h"

#import "PFLoadingView.h"
#import "PFTableView.h"
#import "PFBrandingSettings.h"
#import "PFPrivateLogsManager.h"

#import "PFTableViewCategory+SecureLog.h"
#import "UIColor+Skin.h"
#import "UIImage+PFTableView.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFSecureLogsController ()

@property ( nonatomic, strong ) NSArray* categories;
@property ( nonatomic, strong ) PFLoadingView* loadingView;

@end

@implementation PFSecureLogsController

@synthesize textView;
@synthesize categories = _categories;
@synthesize loadingView = _loadingView;
@synthesize textViewBackground;

-(NSArray*)categories
{
   if ( !_categories )
   {
      _categories = @[[ PFTableViewCategory logDateCategoryWithController: self ]];
   }
   return _categories;
}

-(PFLoadingView*)loadingView
{
   if ( !_loadingView )
   {
      _loadingView = [ PFLoadingView new ];
   }
   return _loadingView;
}

-(id)init
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"SECURE_LOG", nil );
   }
   
   return self;
}

- (void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.textView.editable = NO;
   self.view.backgroundColor = [ UIColor backgroundDarkColor ];
   self.textView.textColor = [ UIColor mainTextColor ];
   self.tableView.categories = self.categories;
   self.tableView.tableView.scrollEnabled = NO;
   self.textViewBackground.image = [ UIImage singleGroupedCellBackgroundImage ];
   
   [ self.tableView reloadData ];
   
   [ self showReportWithDate: [ NSDate date ] ];
}

+(BOOL)isAvailable
{
   return [ PFBrandingSettings sharedBranding ].usePrivateLogs;
}

-(void)showReportWithDate:( NSDate* )date_
{
   [ self.loadingView showInView: self.view ];
   
   [ [ PFPrivateLogsManager manager ] readLogWithDate: date_
                                         andDoneBlock: ^(NSString* log_content_)
    {
       self.textView.text = log_content_;
       [ self.loadingView hide ];
    } ];
}

@end
