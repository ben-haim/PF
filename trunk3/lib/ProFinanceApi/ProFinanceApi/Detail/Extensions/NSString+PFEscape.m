#import "NSString+PFEscape.h"

@implementation NSString (PFEscape)

-(NSString*)stringByAddingPFEscapes
{
   NSString* unsafe_ = @" <>#%'\";?:&=+$,{}|\\^~[]`!()/";

   return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault
                                                                               , (__bridge CFStringRef)self
                                                                               , NULL
                                                                               , (__bridge CFStringRef)unsafe_
                                                                               , kCFStringEncodingUTF8 );;
}

@end
