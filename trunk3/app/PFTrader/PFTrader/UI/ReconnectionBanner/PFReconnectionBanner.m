#import "PFReconnectionBanner.h"

@implementation PFReconnectionBanner

@synthesize title;

-(PFReconnectionBanner*)initWithTitle:( NSString* )title_
{
   self = [ super init ];
   if ( self )
   {
      self.title = title_;
   }
   return self;
}

@end
