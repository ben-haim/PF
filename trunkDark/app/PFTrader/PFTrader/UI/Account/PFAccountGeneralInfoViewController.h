#import "PFViewController.h"

@protocol PFAccount;

@interface PFAccountGeneralInfoViewController : PFViewController

+(id)controllerWithAccount:( id< PFAccount > )account_;

@property (nonatomic, weak) IBOutlet UILabel* accountBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel* projectedBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* marginAvaliableLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentMarginLabel;
@property (nonatomic, weak) IBOutlet UILabel* marginWarningLabel;
@property (nonatomic, weak) IBOutlet UILabel* blockedBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel* cashBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel* withdrawalLabel;

@property (nonatomic, weak) IBOutlet UILabel* accountBalanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* projectedBalanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountValueValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* marginAvaliableValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentMarginValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* marginWarningValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* blockedBalanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* cashBalanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* withdrawalValueLabel;

@end
