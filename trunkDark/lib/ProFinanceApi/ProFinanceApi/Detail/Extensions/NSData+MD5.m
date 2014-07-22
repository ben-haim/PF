#import "NSData+MD5.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSData (MD5)

-(NSString*)MD5
{
   unsigned char md5_buffer_[CC_MD5_DIGEST_LENGTH];

   CC_MD5( self.bytes, (CC_LONG)self.length, md5_buffer_ );

   NSMutableString* output_ = [ NSMutableString stringWithCapacity: CC_MD5_DIGEST_LENGTH * 2 ];
   for ( int i_ = 0; i_ < CC_MD5_DIGEST_LENGTH; ++i_ )
   {
      [ output_ appendFormat: @"%02x", md5_buffer_[ i_ ] ];
   }
   
   return output_;
}

@end
