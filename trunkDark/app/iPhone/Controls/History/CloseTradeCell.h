

#import <UIKit/UIKit.h>


@interface CloseTradeCell : UITableViewCell 
{
	IBOutlet UILabel *lblSymbol;
	IBOutlet UILabel *lblOrderNo;
	IBOutlet UILabel *lblVol;
	IBOutlet UILabel *lblType;
	IBOutlet UILabel *lblOpenTime;
	IBOutlet UILabel *lblCloseTime;
	IBOutlet UILabel *lblOpenPrice;
	IBOutlet UILabel *lblSL;
	IBOutlet UILabel *lblTP;
	IBOutlet UILabel *lblClosePrice;
	IBOutlet UILabel *lblSwap;	
	IBOutlet UILabel *lblCommission;
	IBOutlet UILabel *lblPL;
	BOOL isBuy;
	
	IBOutlet UILabel *lblTitleOrderNo;
	IBOutlet UILabel *lblTitleVol;
	IBOutlet UILabel *lblTitleType;
	IBOutlet UILabel *lblTitleOpenPrice;
	IBOutlet UILabel *lblTitleTP;
	IBOutlet UILabel *lblTitleClosePrice;
	IBOutlet UILabel *lblTitleSwap;	
	IBOutlet UILabel *lblTitleCommission;
	IBOutlet UILabel *lblTitlePL;
	IBOutlet UILabel *lblTitleSL;
	
	IBOutlet UIImageView *imgIcon;
}
@property (nonatomic, retain) IBOutlet UILabel *lblSymbol;
@property (nonatomic, retain) IBOutlet UILabel *lblOrderNo;
@property (nonatomic, retain) IBOutlet UILabel *lblVol;
@property (nonatomic, retain) IBOutlet UILabel *lblType;
@property (nonatomic, retain) IBOutlet UILabel *lblOpenTime;
@property (nonatomic, retain) IBOutlet UILabel *lblCloseTime;
@property (nonatomic, retain) IBOutlet UILabel *lblOpenPrice;
@property (nonatomic, retain) IBOutlet UILabel *lblSL;
@property (nonatomic, retain) IBOutlet UILabel *lblTP;
@property (nonatomic, retain) IBOutlet UILabel *lblClosePrice;
@property (nonatomic, retain) IBOutlet UILabel *lblPL;
@property (nonatomic, retain) IBOutlet UILabel *lblSwap;
@property (nonatomic, retain) IBOutlet UILabel *lblCommission;
@property (nonatomic, retain) IBOutlet UIImageView *imgIcon;

@property (nonatomic, retain) IBOutlet UILabel *lblTitleOrderNo;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleVol;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleType;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleOpenPrice;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleTP;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleClosePrice;
@property (nonatomic, retain) IBOutlet UILabel *lblTitlePL;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleSL;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleSwap;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleCommission;
@end

