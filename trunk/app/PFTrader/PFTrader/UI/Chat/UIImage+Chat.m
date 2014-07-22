#import "UIImage+Chat.h"

#import "UIImage+Stretch.h"

@implementation UIImage (Chat)

+(UIImage*)userMessageBackground
{
   return [ [ UIImage imageNamed: @"PFChatBaloonUser" ] symmetricStretchableImage ];
}

+(UIImage*)adminMessageBackground
{
   return [ [ UIImage imageNamed: @"PFChatBaloonAdmin" ] symmetricStretchableImage ];
}

@end
