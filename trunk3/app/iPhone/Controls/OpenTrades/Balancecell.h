
#import <UIKit/UIKit.h>


@interface Balancecell : UITableViewCell 
{
	
		IBOutlet UILabel *lblPL;
		IBOutlet UILabel *lblBalance;
		IBOutlet UILabel *lblDeposit;
		IBOutlet UILabel *lblWithdrawal;
	
		IBOutlet UILabel *lblTitlePL;
			IBOutlet UILabel *lblTitleBalance;
		IBOutlet UILabel *lblTitleDeposit;
		IBOutlet UILabel *lblTitleWithdrawal;
}
	@property (nonatomic, retain) IBOutlet UILabel *lblPL;
	@property (nonatomic, retain) IBOutlet UILabel *lblBalance;
	@property (nonatomic, retain) IBOutlet UILabel *lblDeposit;
	@property (nonatomic, retain) IBOutlet UILabel *lblWithdrawal;	

	@property (nonatomic, retain) IBOutlet UILabel *lblTitlePL;
	@property (nonatomic, retain) IBOutlet UILabel *lblTitleBalance;
	@property (nonatomic, retain) IBOutlet UILabel *lblTitleDeposit;
	@property (nonatomic, retain) IBOutlet UILabel *lblTitleWithdrawal;
	
@end
