#import "PFQuoteServerDetails.h"

@implementation PFQuoteServerDetails

@synthesize server;
@synthesize load;

-(id)initWithString:( NSString* )string_
{
   NSArray* components_ = [ string_ componentsSeparatedByString: @"=" ];
   NSAssert( [ components_ count ] > 0, @"not enough information" );

   self = [ super init ];
   if ( self )
   {
      self.server = [ components_ objectAtIndex: 0 ];
      self.load = [ components_ count ] > 1
         ? [ [ components_ objectAtIndex: 1 ] integerValue ]
         : 0;
   }

   return self;
}

-(id)initWithServer:( NSString* )server_
               load:( NSUInteger )load_
{
   self = [ super init ];
   if ( self )
   {
      self.server = server_;
      self.load = load_;
   }
   
   return self;
}

+(id)lessLoadedServerFrom:( NSArray* )servers_
{
   PFQuoteServerDetails* found_server_ = nil;
   for ( PFQuoteServerDetails* server_ in servers_ )
   {
      if ( !found_server_ || found_server_.load > server_.load )
      {
         found_server_ = server_;
      }
   }
   return found_server_;
}

@end
