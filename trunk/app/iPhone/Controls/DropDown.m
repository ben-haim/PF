
#import "DropDown.h"


@implementation DropDown
@synthesize selectedIndex;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
	selectedIndex = -1;
    return self;
}

- (id)init
{
	self = [super init];
	selectedIndex = -1;
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	selectedIndex = -1;
	return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
