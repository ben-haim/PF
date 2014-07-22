#import "NSURL+SafeInit.h"

@implementation NSURL (SafeInit)

+(id)safeURLWithString:( NSString* )string_
{
   if ( [ string_ length ] == 0 )
      return nil;
   
   if ( [ string_ hasPrefix: @"www." ] )
      return [ self URLWithString: [ @"http://" stringByAppendingString: string_ ] ];

   return [ self URLWithString: string_ ];
}

@end
