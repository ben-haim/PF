

#import "MailListCell.h"


@implementation MailListCell
@synthesize imgIcon,lblFrom, lblDate, lblSubject;

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
- (NSString *) reuseIdentifier 
{
		return @"MailListCell";
	
}


- (void)dealloc 
{
    [super dealloc];
}




@end
