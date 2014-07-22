#import "PFViewController.h"

@class PFSegmentedControl;
@class PFTableView;
@class PFAccountSpeedometr;
@protocol PFAccount;

@interface PFAccountInfoViewController : PFViewController

@property ( nonatomic, weak ) IBOutlet UIImageView* headerView;
@property ( nonatomic, weak ) IBOutlet UIView* mainView;
@property ( nonatomic, weak ) IBOutlet UIView* buttonsView;
@property ( nonatomic, weak ) IBOutlet UIScrollView* contentScrollView;
@property ( nonatomic, weak ) IBOutlet UIButton* makeActiveButton;
@property ( nonatomic, weak ) IBOutlet UIButton* transferButton;
@property ( nonatomic, weak ) IBOutlet UIButton* reportsButton;
@property ( nonatomic, weak ) IBOutlet PFSegmentedControl* infoTypeSegmentedControl;
@property ( nonatomic, weak ) IBOutlet PFTableView* assetTable;
@property ( nonatomic, weak ) IBOutlet PFTableView* assetInfoTable;
@property ( nonatomic, weak ) IBOutlet UILabel* performanceTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* firstTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* secondTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* thirdTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* firstValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* secondValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* thirdValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fourthTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fifthTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* sixthTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fourthValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fifthValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* sixthValueLabel;
@property ( nonatomic, weak ) IBOutlet UIButton* moreButton;
@property ( nonatomic, weak ) IBOutlet PFAccountSpeedometr *accountSpeedometrView;
@property ( nonatomic, weak ) IBOutlet UILabel *realizedNetPlLabel;
@property ( nonatomic, weak ) IBOutlet UILabel *realizedNetPlCurrencyLabel;

+(id)infoControllerWithAccount:( id< PFAccount > )account_;

-(IBAction)moreInfoAction:( id )sender_;
-(IBAction)makeActiveAction:( id )sender_;
-(IBAction)transferAction:( id )sender_;
-(IBAction)reportsAction:( id )sender_;

+(void)displayMoneyStringWithLabel:( UILabel* )label_
                            amount:( double )amount_
                         precision:( double )precision_
                          currency:( NSString* )currency_
                         colorSign:( BOOL )color_sign_;

@end
