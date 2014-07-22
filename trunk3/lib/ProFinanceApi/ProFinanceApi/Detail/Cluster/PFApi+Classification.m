#import "PFApi+Classification.h"

#import "PFTradeApi.h"

@implementation PFApi (Classification)

-(BOOL)isTradeApi
{
   return NO;
}

@end

@implementation PFTradeApi (Classification)

-(BOOL)isTradeApi
{
   return YES;
}

@end
