#import "NSDate+PFTimeStamp.h"

static NSTimeInterval PFMsecondsInSecond = 1000.0;

@implementation NSDate (PFTimeStamp)

+(id)dateWithMsecondsTimeStamp:( PFLong )mseconds_
{
   NSTimeInterval interval_ = mseconds_ / PFMsecondsInSecond;

   return [ self dateWithTimeIntervalSince1970: interval_ ];
}

-(PFLong)msecondsTimeStamp
{
   return ( PFLong )([ self timeIntervalSince1970 ] * PFMsecondsInSecond);
}

@end
