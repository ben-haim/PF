
#import "LegendKey.h"


@implementation LegendKey
@synthesize key, text, color1, color2;

- (id)initWithKey:(NSString*)_legendKeyString color1:(uint)_legendColor color2:(uint)_legendColor2
{    
    self  = [super init];
    if(self == nil)
        return self;
    [self setKey:_legendKeyString];
    [self setText:@""];
    self.color1 = _legendColor;
    self.color2 = _legendColor2;
    return self;
}

-(void)dealloc
{	
    //[key release];
    [text release];
	[super dealloc];    
}


@end
