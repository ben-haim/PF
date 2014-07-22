

#import "DepositCell.h"


@implementation DepositCell


@synthesize lblOrderNo;
@synthesize lblType;
@synthesize lblCloseTime;
@synthesize lblPL;
@synthesize imgIcon;

@synthesize lblTitleOrderNo;
@synthesize lblTitleBalance;
@synthesize lblTitleTransactionTime;
@synthesize lblTitleAmount;

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
	if(isBuy)
		return @"DepositCell";
	else
		return @"WithdrawalCell";
	
}

- (void)dealloc {
	[lblTitleAmount release];
	[lblTitleBalance release];
	[lblTitleOrderNo release];
	[lblTitleTransactionTime release];
    [super dealloc];
}


@end
