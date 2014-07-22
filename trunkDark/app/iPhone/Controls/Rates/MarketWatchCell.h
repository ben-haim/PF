
#import <UIKit/UIKit.h>


@interface MarketWatchCell : UITableViewCell
{
	IBOutlet UIButton *lblSymbol;
	IBOutlet UILabel *lblBid;
	IBOutlet UILabel *lblAsk;
	IBOutlet UILabel *lblHigh;
	IBOutlet UILabel *lblLow;
	IBOutlet UIImageView *imgArrow;
	BOOL isUP;
	
	IBOutlet UILabel *lblTitleAsk;
	IBOutlet UILabel *lblTitleBid;
	IBOutlet UILabel *lblTitleHigh;
	IBOutlet UILabel *lblTitleLow;
	
}
@property (nonatomic, retain) IBOutlet UIButton *lblSymbol;
@property (nonatomic, retain) IBOutlet UILabel *lblBid;
@property (nonatomic, retain) IBOutlet UILabel *lblAsk;
@property (nonatomic, retain) IBOutlet UILabel *lblHigh;
@property (nonatomic, retain) IBOutlet UILabel *lblLow;
@property (nonatomic, retain) IBOutlet UIImageView *imgArrow;

@property (nonatomic, retain) IBOutlet UILabel *lblTitleAsk;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleBid;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleHigh;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleLow;

-(void)setIsUp:(BOOL)up;
- (IBAction) btnTrade_Clicked:(id)sender;
@end
