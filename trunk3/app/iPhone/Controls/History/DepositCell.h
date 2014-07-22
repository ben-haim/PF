

#import <UIKit/UIKit.h>


@interface DepositCell : UITableViewCell 
{
	IBOutlet UILabel *lblOrderNo;
	IBOutlet UILabel *lblType;
	IBOutlet UILabel *lblCloseTime;
	IBOutlet UILabel *lblPL;
	BOOL isBuy;
	
	IBOutlet UILabel *lblTitleOrderNo;
	IBOutlet UILabel *lblTitleBalance;
	IBOutlet UILabel *lblTitleTransactionTime;
	IBOutlet UILabel *lblTitleAmount;
	
	IBOutlet UIImageView *imgIcon;
}
@property (nonatomic, retain) IBOutlet UILabel *lblOrderNo;
@property (nonatomic, retain) IBOutlet UILabel *lblType;
@property (nonatomic, retain) IBOutlet UILabel *lblCloseTime;
@property (nonatomic, retain) IBOutlet UILabel *lblPL;
@property (nonatomic, retain) IBOutlet UIImageView *imgIcon;

@property (nonatomic, retain) IBOutlet UILabel *lblTitleOrderNo;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleBalance;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleTransactionTime;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleAmount;

@end
