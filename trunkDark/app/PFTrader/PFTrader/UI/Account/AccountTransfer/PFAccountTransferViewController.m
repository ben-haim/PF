#import "PFAccountTransferViewController.h"
#import "PFAccountOperationsSource.h"
#import "PFSegmentedControl.h"
#import "PFActionSheetButton.h"
#import "PFTableView.h"
#import "UIColor+Skin.h"
#import "UIImage+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountTransferViewController ()

@property ( nonatomic, strong ) NSArray* dataSources;
@property ( nonatomic, strong ) id< PFAccountOperationsSource > activeDataSource;

@end

@implementation PFAccountTransferViewController

@synthesize headerView;
@synthesize modeSelector;
@synthesize modeButton;
@synthesize submitButton;
@synthesize sourceAccount;
@synthesize targetAccount;
@synthesize dataSources;
@synthesize activeDataSource;

-(id)initWithNibName:( NSString* )nib_name_
              bundle:( NSBundle* )bundle_
{
   self = [ super initWithNibName: nib_name_ bundle: bundle_ ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"TRANSFER_TITLE", nil );
   }
   
   return self;
}

-(id)init
{
   return [ self initWithNibName: NSStringFromClass( [ self class ] )
                          bundle: nil ];
}

-(id)initWithAccount:( id< PFAccount > )account_
{
   self = [ [ PFAccountTransferViewController alloc ] init ];
   
   if ( self )
   {
      self.sourceAccount = account_;
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   if ( self.sourceAccount.accountType == PFAccountTypeMultiAsset || !self.sourceAccount.allowTransfer || ([ [PFSession sharedSession].accounts.accounts count ] == 1) )
   {
      self.dataSources = @[ [ PFAccountWithdrawalSource new ] ];
      
      self.headerView.hidden = YES;
      CGRect table_frame_ = self.tableView.frame;
      table_frame_.origin.y = self.headerView.frame.origin.y;
      table_frame_.size.height += self.headerView.frame.size.height;
      self.tableView.frame = table_frame_;
      
      [ self activateModeWithIndex: 0 ];
   }
   else
   {
      self.dataSources = @[ [ PFAccountTransferSource new ], [ PFAccountWithdrawalSource new ] ];
      
      if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
      {
         self.headerView.backgroundColor = [ UIColor backgroundLightColor ];
         self.headerView.image = [ UIImage thinShadowImage ];
         self.modeSelector.hidden = NO;
         self.modeButton.hidden = YES;
         
         self.modeSelector.items = [ self.dataSources valueForKeyPath: @"@unionOfObjects.title" ];
         self.modeSelector.selectedSegmentIndex = 0;
      }
      else
      {
         self.modeSelector.hidden = YES;
         self.modeButton.hidden = NO;
         
         [ self.modeButton.button setTitleColor: [ UIColor blueTextColor ] forState: UIControlStateNormal ];
         [ self.modeButton.button setTitleColor: [ UIColor blueTextColor ] forState: UIControlStateHighlighted ];
         self.modeButton.button.titleLabel.font = [ UIFont systemFontOfSize: 16.f ];
         self.modeButton.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
         self.modeButton.button.contentEdgeInsets = UIEdgeInsetsMake( 0.f, 10.f, 0.f, 0.f );
         
         self.modeButton.choices = @[ @( 0 ) , @( 1 ) ];
         self.modeButton.prompt = NSLocalizedString( @"SELECT_MODE", nil );
         self.modeButton.toStringBlock = ^( id choice_ ) { return [ [ self.dataSources objectAtIndex: [ choice_ integerValue ] ] title ]; };
         self.modeButton.currentChoice = @( 0 );
      }

   }
}

-(void)updateTargetAccount
{
   [ self.activeDataSource updateTargetAccount ];
}

-(void)activateModeWithIndex:( NSInteger )index_
{
   [ self.activeDataSource deactivate ];
   self.activeDataSource = [ self.dataSources objectAtIndex: index_ ];
   [ self.activeDataSource activateInController: self andAccount: self.sourceAccount ];
}

-(IBAction)submitAction:( id )sender_
{
   [ self.activeDataSource submitAction ];
}

-(IBAction)modeChangedAction:( id )sender_
{
   [ self activateModeWithIndex: [ [ sender_ currentChoice ] integerValue ] ];
}

#pragma mark - PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_
   didSelectItemAtIndex:( NSInteger )index_
{
   [ self activateModeWithIndex: index_ ];
}

@end
