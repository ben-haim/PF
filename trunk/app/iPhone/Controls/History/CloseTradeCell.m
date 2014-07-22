

#import "CloseTradeCell.h"


@implementation CloseTradeCell
@synthesize lblSymbol;
@synthesize lblOrderNo;
@synthesize lblSwap;
@synthesize lblCommission;
@synthesize lblVol;
@synthesize lblType;
@synthesize lblOpenTime;
@synthesize lblCloseTime;
@synthesize lblOpenPrice;
@synthesize lblSL;
@synthesize lblTP;
@synthesize lblClosePrice;
@synthesize lblPL;
@synthesize imgIcon;

@synthesize lblTitleOrderNo;
@synthesize lblTitleSwap;
@synthesize lblTitleCommission;
@synthesize lblTitleVol;
@synthesize lblTitleType;
@synthesize lblTitleOpenPrice;
@synthesize lblTitleTP;
@synthesize lblTitleClosePrice;
@synthesize lblTitlePL;
@synthesize lblTitleSL;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setIsUp:(BOOL)up
{
	isBuy = up;
}
- (NSString *) reuseIdentifier 
{
	//if(isBuy)
		return @"CloseTradeCell";
	//else
	//	return @"CTSell";
	
}

- (void)dealloc {
    [super dealloc];
}


@end
