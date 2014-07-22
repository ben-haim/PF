#import "PFRegistrationViewController.h"

#import "PFTableView.h"
#import "PFLoadingView.h"

#import "PFTableViewCategory+Registration.h"
#import "PFBrandingSettings.h"
#import "NSUserDefaults+PFServerInfo.h"
#import "UIView+ResignFirstResponder.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFRegistrationViewController ()< PFDemoAccountManagerDelegate >

@property ( nonatomic, strong ) NSArray* categories;
@property ( nonatomic, strong ) PFDemoAccountManager* accountManager;
@property ( nonatomic, strong ) PFServerInfo* registrationServerInfo;

@end

@implementation PFRegistrationViewController

@synthesize categories = _categories;
@synthesize accountManager;
@synthesize registrationServerInfo;

@synthesize delegate;

-(id)initWithServerInfo:( PFServerInfo* )server_info_
{
   self = [ super init ];
   if ( self )
   {
      self.title = NSLocalizedString( @"REGISTRATION", nil );
      self.registrationServerInfo = server_info_;
   }
   return self;
}

-(NSArray*)categories
{
   if ( !_categories )
   {
      _categories = [ PFTableViewCategory registrationCategoriesWithController: self ];
   }
   return _categories;
}

-(void)registerAccount
{
   PFDemoAccount* account_ = [ PFDemoAccount new ];

   [ self.categories makeObjectsPerformSelector: @selector( performApplierForObject: )
                                     withObject: account_ ];
   account_.brandingKey = [ PFBrandingSettings sharedBranding ].brandingKey;

   if ( ![ account_.password isEqualToString: account_.confirmedPassword ] )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"INCORRECT_CONFIRM_PASSWORD", nil ) ];
      return;
   }

   [ self.tableView findAndResignFirstResponder ];

   self.navigationItem.leftBarButtonItem.enabled = NO;
   PFLoadingView* loading_view_ = [ PFLoadingView new ];

   [ loading_view_ showInView: self.view ];

   PFDemoAccountManager* account_manager_ = [ PFDemoAccountManager new ];
   account_manager_.delegate = self;
   
   if ( ![ account_manager_ connectToServerWithInfo: self.registrationServerInfo ] )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"CONNECTION_FAILED", nil ) ];
      return;
   }
   
   self.accountManager = account_manager_;

   [ self.accountManager registerDemoAccount: account_
                                   doneBlock: ^( NSString* result_, NSError* error_ )
    {
       if ( self.accountManager != account_manager_ )
          return;

       [ loading_view_ hide ];
       self.navigationItem.leftBarButtonItem.enabled = YES;

       if ( result_ )
       {
          [ self.delegate registrationController: self didCreateDemoAccount: account_ ];
       }
       else
       {
          [ error_ showAlertWithTitle: nil ];
       }
    }];
}

-(void)cancel
{
   self.accountManager = nil;

   [ self.delegate didCancelRegistrationController: self ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   UIBarButtonItem* done_item_ = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                  target: self
                                                                                  action: @selector( registerAccount ) ];

   self.navigationItem.leftBarButtonItem = done_item_;

   UIBarButtonItem* cancel_item_ = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                    target: self
                                                                                    action: @selector( cancel ) ];

   self.navigationItem.rightBarButtonItem = cancel_item_;

   self.tableView.categories = self.categories;
   [ self.tableView reloadData ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PF

-(void)demoAccountManager:( PFDemoAccountManager* )account_manager_
         didFailWithError:( NSError* )error_
{
   if ( self.accountManager == account_manager_ )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"CONNECTION_FAILED", nil ) ];
   }
}

@end
