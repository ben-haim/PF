#import "Balancecell.h"


@implementation Balancecell

@synthesize lblPL;
@synthesize lblBalance;
@synthesize lblDeposit;
@synthesize lblWithdrawal;

@synthesize lblTitlePL;
@synthesize lblTitleBalance;
@synthesize lblTitleDeposit;
@synthesize lblTitleWithdrawal;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (NSString *) reuseIdentifier 
{
	return @"BalanceCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
