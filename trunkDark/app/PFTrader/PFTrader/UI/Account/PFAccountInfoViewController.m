#import "PFAccountInfoViewController.h"
#import "PFAccountGeneralInfoViewController.h"
#import "PFReportsViewController.h"
#import "PFAccountTransferViewController.h"
#import "PFTableViewCategory+AccountDetail.h"
#import "PFAccountSpeedometr.h"
#import "PFNavigationController.h"
#import "PFBrandingSettings.h"
#import "PFSegmentedControl.h"
#import "PFTableView.h"
#import "PFModalWindow.h"
#import "NSString+DoubleFormatter.h"
#import "UIColor+Skin.h"
#import "UILabel+Price.h"
#import "UIImage+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountInfoViewController () < PFSessionDelegate, PFSegmentedControlDelegate >

@property ( nonatomic, strong ) id< PFAccount > account;
@property ( nonatomic, assign ) BOOL activityMode;

@end

@implementation PFAccountInfoViewController

@synthesize account;
@synthesize activityMode;
@synthesize headerView;
@synthesize mainView;
@synthesize buttonsView;
@synthesize contentScrollView;
@synthesize makeActiveButton;
@synthesize transferButton;
@synthesize reportsButton;
@synthesize infoTypeSegmentedControl;
@synthesize assetTable;
@synthesize assetInfoTable;
@synthesize performanceTitleLabel;
@synthesize firstTitleLabel;
@synthesize secondTitleLabel;
@synthesize thirdTitleLabel;
@synthesize firstValueLabel;
@synthesize secondValueLabel;
@synthesize thirdValueLabel;
@synthesize fourthTitleLabel;
@synthesize fifthTitleLabel;
@synthesize sixthTitleLabel;
@synthesize fourthValueLabel;
@synthesize fifthValueLabel;
@synthesize sixthValueLabel;
@synthesize moreButton;
@synthesize accountSpeedometrView;
@synthesize realizedNetPlCurrencyLabel;
@synthesize realizedNetPlLabel;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)initWithAccount:( id< PFAccount > )account_
{
   if ( self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ] )
   {
      self.title = account_.name;
      self.account = account_;
   }
   return self;
}

+(id)infoControllerWithAccount:( id< PFAccount > )account_
{
   return [ [ self alloc ] initWithAccount: account_ ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ [ PFSession sharedSession ] addDelegate: self ];

   [ self.makeActiveButton setTitle: NSLocalizedString( @"MAKE_ACTIVE", nil ) forState: UIControlStateNormal ];
   [ self.transferButton setTitle: NSLocalizedString( @"TRANSFER_TITLE", nil ) forState: UIControlStateNormal ];
   [ self.reportsButton setTitle: NSLocalizedString( @"REPORTS", nil ) forState: UIControlStateNormal ];

   self.performanceTitleLabel.textColor = [ UIColor grayTextColor ];
   self.headerView.backgroundColor = [ UIColor navigationBarColor ];

   self.infoTypeSegmentedControl.font = [ UIFont systemFontOfSize: 17.f ];
   self.infoTypeSegmentedControl.items = [ NSArray arrayWithObjects: NSLocalizedString( @"TODAY", nil ), NSLocalizedString( @"ACTIVITY", nil ), nil ];
   self.infoTypeSegmentedControl.selectedSegmentIndex = 0;
   self.infoTypeSegmentedControl.delegate = self;

   if ( self.account.accountType == PFAccountTypeMultiAsset )
   {
      self.infoTypeSegmentedControl.hidden = YES;
      self.performanceTitleLabel.hidden = YES;
      self.contentScrollView.hidden = YES;
      self.assetTable.hidden = NO;
      self.assetInfoTable.hidden = NO;
      self.assetTable.tableView.scrollEnabled = NO;

      self.assetTable.categories = [ NSArray arrayWithObject: [ PFTableViewCategory assetAccountCategoryWithAccount: self.account ] ];
      self.assetInfoTable.categories = [ NSArray arrayWithObject: [ PFTableViewCategory generalAssetCategoryWithAccount: self.account ] ];
      self.assetInfoTable.tableFooterView = self.buttonsView;
   }
   else
   {
      self.infoTypeSegmentedControl.hidden = NO;
      self.performanceTitleLabel.hidden = NO;
      self.contentScrollView.hidden = NO;
      self.assetTable.hidden = YES;
      self.assetInfoTable.hidden = YES;

      self.assetTable.categories = [ NSArray new ];
      self.assetInfoTable.categories = [ NSArray new ];
      
      self.contentScrollView.contentSize = CGSizeMake( self.contentScrollView.frame.size.width, 430.f );

   }

   self.assetTable.backgroundColor = [ UIColor clearColor ];
   self.assetInfoTable.backgroundColor = [ UIColor clearColor ];
   [ self.assetTable reloadData ];

   [ self.moreButton setTitleColor: [ UIColor blueTextColor ] forState: UIControlStateNormal ];
   [ self.moreButton setTitleColor: [ UIColor blueTextColor ] forState: UIControlStateHighlighted ];

   [ self updateAccountInfo ];
   [ self updateButtons ];

   self.headerView.image = [ UIImage thinShadowImage ];

   self.firstTitleLabel.textColor = [UIColor grayTextColor];
   self.secondTitleLabel.textColor = [UIColor grayTextColor];
   self.thirdTitleLabel.textColor = [UIColor grayTextColor];
   self.firstValueLabel.textColor = [UIColor mainTextColor];
   self.secondValueLabel.textColor = [UIColor mainTextColor];
   self.thirdValueLabel.textColor = [UIColor mainTextColor];
   self.fourthTitleLabel.textColor = [UIColor grayTextColor];
   self.fifthTitleLabel.textColor = [UIColor grayTextColor];
   self.sixthTitleLabel.textColor = [UIColor grayTextColor];
   self.fourthValueLabel.textColor = [UIColor mainTextColor];
   self.fifthValueLabel.textColor = [UIColor mainTextColor];
   self.sixthValueLabel.textColor = [UIColor mainTextColor];
}

-(void)updateAccountInfo
{
   if ( self.account.accountType == PFAccountTypeMultiAsset )
   {
      self.assetInfoTable.categories = [ NSArray arrayWithObject: [ PFTableViewCategory generalAssetCategoryWithAccount: self.account ] ];
      [ self.assetInfoTable reloadData ];
   }
   else
   {
      if ( self.activityMode )
      {
         self.firstTitleLabel.text = NSLocalizedString( @"OPEN_GROSS_PL", nil );
         self.secondTitleLabel.text = NSLocalizedString( @"ORDERS_MARGIN", nil );
         self.thirdTitleLabel.text = NSLocalizedString( @"POSITIONS_MARGIN", nil );
         self.fourthTitleLabel.text = NSLocalizedString( @"OPEN_NET_PL", nil );
         self.fifthTitleLabel.text = NSLocalizedString( @"N_ORDERS", nil );
         self.sixthTitleLabel.text = NSLocalizedString( @"N_POSITIONS", nil );

         [ PFAccountInfoViewController displayMoneyStringWithLabel: self.firstValueLabel
                                     amount: self.account.totalGrossPl
                                  precision: self.account.precision
                                   currency: self.account.currency
                                  colorSign: YES ];

         [ self.firstValueLabel showPositiveNegativeColouredValue: self.account.totalGrossPl
                                                        precision: self.account.precision
                                                         currency: self.account.currency
                                                negativeTextColor: [UIColor redTextColor]
                                                positiveTextColor: [UIColor greenTextColor]
                                                    zeroTextColor: [UIColor mainTextColor]
                                                  dashIfValueZero: NO isPositiveSign: NO ];

         [ PFAccountInfoViewController displayMoneyStringWithLabel: self.secondValueLabel
                                                            amount: self.account.blockedForOrders
                                                         precision: self.account.precision
                                                          currency: self.account.currency
                                                         colorSign: NO ];

         [ PFAccountInfoViewController displayMoneyStringWithLabel: self.thirdValueLabel
                                                            amount: self.account.initMargin
                                                         precision: self.account.precision
                                                          currency: self.account.currency
                                                         colorSign: NO ];

         [ self.fourthValueLabel showPositiveNegativeColouredValue: self.account.totalNetPl
                                                         precision: self.account.precision
                                                          currency: self.account.currency
                                                 negativeTextColor: [UIColor redTextColor]
                                                 positiveTextColor: [UIColor greenTextColor]
                                                     zeroTextColor: [UIColor mainTextColor]
                                                   dashIfValueZero: NO isPositiveSign: NO ];

         self.fifthValueLabel.text = [ NSString stringWithFormat: @"%d", (int)self.account.orderSum ];
         self.sixthValueLabel.text = [ NSString stringWithFormat: @"%d", (int)self.account.positionSum ];

         if (self.account.accountType != PFAccountTypeMultiAsset)
         {
            [ self.accountSpeedometrView redrawWithPositiveValue: self.account.sumPositivePositionsNetPL
                                                andNegativeValue: self.account.sumNegativePositionsNetPL ];

            [ self.realizedNetPlLabel showPositiveNegativeColouredValue: self.account.realizedPositionsNetPl
                                                              precision: self.account.precision
                                                               currency: @""
                                                      negativeTextColor: [ UIColor redTextColor ]
                                                      positiveTextColor: [ UIColor greenTextColor ]
                                                          zeroTextColor: [ UIColor grayTextColor ]
                                                        dashIfValueZero: NO isPositiveSign: YES  ];

            self.realizedNetPlCurrencyLabel.text = self.account.currency;
            self.realizedNetPlCurrencyLabel.textColor = self.realizedNetPlLabel.textColor;
         }
      }
      else
      {
         self.firstTitleLabel.text = NSLocalizedString( @"GROSS_PL", nil );
         self.secondTitleLabel.text = NSLocalizedString( @"VOLUME", nil );
         self.thirdTitleLabel.text = NSLocalizedString( @"FEES", nil );
         self.fourthTitleLabel.text = NSLocalizedString( @"NET_PL", nil );
         self.fifthTitleLabel.text = NSLocalizedString( @"TRADES", nil );
         self.sixthTitleLabel.text = @"";

         [ self.firstValueLabel showPositiveNegativeColouredValue: self.account.grossPl
                                                        precision: self.account.precision
                                                         currency: self.account.currency
                                                negativeTextColor: [UIColor redTextColor]
                                                positiveTextColor: [UIColor greenTextColor]
                                                    zeroTextColor: [UIColor mainTextColor]
                                                  dashIfValueZero: NO isPositiveSign: NO ];

         [ self.fourthValueLabel showPositiveNegativeColouredValue: self.account.netPl
                                                         precision: self.account.precision
                                                          currency: self.account.currency
                                                 negativeTextColor: [UIColor redTextColor]
                                                 positiveTextColor: [UIColor greenTextColor]
                                                     zeroTextColor: [UIColor mainTextColor]
                                                   dashIfValueZero: NO isPositiveSign: NO ];

         [ PFAccountInfoViewController displayMoneyStringWithLabel: self.thirdValueLabel
                                                            amount: self.account.todayFees
                                                         precision: self.account.precision
                                                          currency: self.account.currency
                                                         colorSign: NO ];

         self.secondValueLabel.text = [ NSString stringWithAmount: self.account.amount ];
         self.fifthValueLabel.text = [ NSString stringWithFormat: @"%d", self.account.tradesCount ];
         self.sixthValueLabel.text = @"";

         if (self.account.accountType != PFAccountTypeMultiAsset)
         {
            [ self.accountSpeedometrView redrawWithPositiveValue: self.account.sumPositiveFilledOrdersNetPL
                                                andNegativeValue: self.account.sumNegativeFilledOrdersNetPL ];

            [ self.realizedNetPlLabel showPositiveNegativeColouredValue: self.account.realizedFilledOrdersNetPl
                                                              precision: self.account.precision
                                                               currency: @""
                                                      negativeTextColor: [ UIColor redTextColor ]
                                                      positiveTextColor: [ UIColor greenTextColor ]
                                                          zeroTextColor: [ UIColor grayTextColor ]
                                                        dashIfValueZero: NO isPositiveSign:YES ];

            self.realizedNetPlCurrencyLabel.text = self.account.currency;
            self.realizedNetPlCurrencyLabel.textColor = self.realizedNetPlLabel.textColor;
         }
      }
   }
}

-(void)updateButtons
{
   PFSession* session_ = [ PFSession sharedSession ];

   BOOL need_make_active_ = self.account != session_.accounts.defaultAccount;
   BOOL need_transfer_ = self.account.allowsWithdrawal ||
   ( session_.accounts.accounts.count > 1 && [ PFBrandingSettings sharedBranding ].useTransfer
    && self.account.allowTransfer && ( self.account.accountType != PFAccountTypeMultiAsset ) );
   BOOL need_reports_ = session_.supportedReportTypes.count > 0;

   self.buttonsView.hidden = !( need_make_active_ || need_transfer_ || need_reports_ );

   if ( !need_make_active_ )
   {
      self.reportsButton.frame = self.transferButton.frame;
      self.transferButton.frame = self.makeActiveButton.frame;
      self.makeActiveButton.hidden = YES;
   }

   if ( !need_transfer_ )
   {
      self.reportsButton.frame = self.transferButton.frame;
      self.transferButton.hidden = YES;
   }

   if ( !need_reports_ )
   {
      self.reportsButton.hidden = YES;
   }
}

-(void)showController:( UIViewController* )controller_
{
   [ self.pfNavigationController pushViewController: controller_
                                           animated: YES ];
}

+(void)displayMoneyStringWithLabel:( UILabel* )label_
                            amount:( double )amount_
                         precision:( double )precision_
                          currency:( NSString* )currency_
                         colorSign:( BOOL )color_sign_
{
   label_.text = [ [ NSString stringWithMoney: amount_ andPrecision: precision_ ] stringByAppendingFormat: @" %@", currency_ ];
   label_.textColor = color_sign_ ? ( amount_ >= 0.0 ? [ UIColor positivePriceColor ] : [ UIColor negativePriceColor ] ): [ UIColor mainTextColor ];
}

-(IBAction)moreInfoAction:( id )sender_
{
   [ PFModalWindow showWithController: [ PFAccountGeneralInfoViewController controllerWithAccount: self.account ] ];
}

-(IBAction)makeActiveAction:( id )sender_
{
   [ [ PFSession sharedSession ] selectDefaultAccount: self.account ];
   [ self updateAccountInfo ];
   [ self updateButtons ];
}

-(IBAction)transferAction:( id )sender_
{
   [ self showController: [ [ PFAccountTransferViewController alloc ] initWithAccount: self.account ] ];
}

-(IBAction)reportsAction:( id )sender_
{
   [ self showController: [ [ PFReportsViewController alloc ] initWithAccount: self.account ] ];
}

#pragma mark - PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_
   didSelectItemAtIndex:( NSInteger )index_
{
   self.activityMode = !self.activityMode;
   [ self updateAccountInfo ];
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   [ self updateAccountInfo ];
}

@end
