#import "UIColor+Chat.h"

@implementation UIColor (Chat)

+(UIColor*)userMessageColor
{
   return [ UIColor colorWithWhite: 0.94f alpha: 1.f ];
}

+(UIColor*)adminMessageColor
{
   return [ UIColor colorWithWhite: 0.71f alpha: 1.f ];
}

@end
