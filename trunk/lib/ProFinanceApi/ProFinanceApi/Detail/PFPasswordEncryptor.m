#import "PFPasswordEncryptor.h"

#import <CommonCrypto/CommonCryptor.h>

@implementation PFPasswordEncryptor

+(NSString*)encryptPassword: (NSString*)password_ whithKey: (NSString*)key_ andMode: (long) mode_
{
   switch ( mode_ )
   {
      case 0 :
         return [ [ PFXORUtility encryptData: [ password_ dataUsingEncoding: NSUTF8StringEncoding ]
                                     withKey: key_ ] base64Encoding ];
         
      case 1 :
         return [ [ PFAESUtility encryptData: [ password_ dataUsingEncoding: NSUTF8StringEncoding ]
                                     withKey: key_
                               algorithmMode: kCCOptionPKCS7Padding ] base64Encoding ];
         
      default:
         return password_;
   }
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PFAESUtility

+(NSData*)cryptData: (NSData*)plain_data_
            withKey: (NSString*)key_
        encryptMode: (BOOL)encrypt_mode_
      algorithmMode: (int)algorithm_mode_
{
   // 'key' should be 32 bytes for AES256, will be null-padded otherwise
   char keyPtr[ kCCKeySizeAES256 + 1 ]; // room for terminator (unused)
   bzero(keyPtr, sizeof(keyPtr));       // fill with zeroes (for padding)
   
   // fetch key data
   [ key_ getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF8StringEncoding ];
   
   NSUInteger dataLength = [ plain_data_ length ];
   
   //See the doc: For block ciphers, the output size will always be less than or
   //equal to the input size plus the size of one block.
   //That's why we need to add the size of one block here
   size_t bufferSize = dataLength + kCCBlockSizeAES128;
   void *buffer = malloc(bufferSize);
   
   uint8_t iv[] = { 0x49, 0x32, 0x76, 0x61, 0x6e, 0x20, 0x11, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x60, 0x76 };
   
   size_t numBytesEncrypted = 0;
   CCCryptorStatus cryptStatus = CCCrypt(encrypt_mode_ ? kCCEncrypt : kCCDecrypt, kCCAlgorithmAES128, algorithm_mode_,
                                         keyPtr, kCCKeySizeAES256,
                                         iv,
                                         [ plain_data_ bytes ], dataLength, /* input */
                                         buffer, bufferSize, /* output */
                                         &numBytesEncrypted);
   if (cryptStatus == kCCSuccess)
   {
      //the returned NSData takes ownership of the buffer and will free it on deallocation
      return [ NSData dataWithBytesNoCopy: buffer length: numBytesEncrypted ];
   }
   
   free(buffer); //free the buffer;
   return nil;
}

+(NSData*)encryptData: (NSData*)data_ withKey: (NSString*)key_ algorithmMode: (int)algorithm_mode_
{
   return [ PFAESUtility cryptData: data_
                           withKey: key_
                       encryptMode: YES
                     algorithmMode: algorithm_mode_ ];
}

+(NSData*)decryptData: (NSData*)data_ withKey: (NSString*)key_ algorithmMode: (int)algorithm_mode_
{
   return [ PFAESUtility cryptData: data_
                           withKey: key_
                       encryptMode: NO
                     algorithmMode: algorithm_mode_ ];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PFXORUtility

+(NSData*)encryptData: (NSData*)data_ withKey: (NSString*)key_
{
   NSMutableData* string_data_ = [ data_ mutableCopy ];
   NSMutableData* real_key_data_ = [ data_ mutableCopy ];
   NSData* key_data_ = [ key_ dataUsingEncoding: NSUTF8StringEncoding ];
   
   uint8_t* string_bytes_ = (uint8_t *)[  string_data_ mutableBytes ];
   uint8_t* real_key_bytes_ = (uint8_t *)[  real_key_data_ mutableBytes ];
   uint8_t* key_bytes_ = (uint8_t *)[ key_data_ bytes ];
   
   uint8_t iv_[] = { 0x49, 0x32, 0x76, 0x61, 0x6e, 0x20, 0x11, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x60, 0x76};
   const int iv_length_ = 16;
   
   
   for (int i = 0; i < real_key_data_.length; i++)
   {
      real_key_bytes_[i] = key_bytes_[ i % key_data_.length ] ^ iv_[ i % iv_length_ ];
   }
   
   for (int i = 0; i < string_data_.length; i++)
   {
      string_bytes_[i] ^= real_key_bytes_[i];
   }
   
   return [ NSData dataWithBytes: string_bytes_ length: string_data_.length ];
}

+(NSData*)decryptData: (NSData*)data_ withKey: (NSString*)key_
{
   return [ PFXORUtility decryptData: data_
                             withKey: key_ ];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSData (Base64String)

static char encodingTable[64] =
{
   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
   'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
   'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
   'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/'
};

-(NSString*)base64Encoding
{
   return [self base64EncodingWithLineLength:0];
}

-(NSString*)base64EncodingWithLineLength: (NSUInteger)line_length_
{
   const unsigned char* bytes = [ self bytes ];
   NSMutableString* result = [NSMutableString stringWithCapacity:self.length];
   unsigned long ixtext = 0;
   unsigned long lentext = self.length;
   long ctremaining = 0;
   unsigned char inbuf[3], outbuf[4];
   unsigned short i = 0;
   unsigned short charsonline = 0, ctcopy = 0;
   unsigned long ix = 0;
   
   while( YES )
   {
      ctremaining = lentext - ixtext;
      if( ctremaining <= 0 ) break;
      
      for( i = 0; i < 3; i++ )
      {
         ix = ixtext + i;
         if( ix < lentext ) inbuf[i] = bytes[ix];
         else inbuf [i] = 0;
      }
      
      outbuf [0] = (inbuf [0] & 0xFC) >> 2;
      outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
      outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
      outbuf [3] = inbuf [2] & 0x3F;
      ctcopy = 4;
      
      switch( ctremaining )
      {
         case 1:
            ctcopy = 2;
            break;
         case 2:
            ctcopy = 3;
            break;
      }
      
      for( i = 0; i < ctcopy; i++ )
         [result appendFormat:@"%c", encodingTable[outbuf[i]]];
      
      for( i = ctcopy; i < 4; i++ )
         [result appendString:@"="];
      
      ixtext += 3;
      charsonline += 4;
      
      if( line_length_ > 0 )
      {
         if( charsonline >= line_length_ )
         {
            charsonline = 0;
            [result appendString:@"\n"];
         }
      }
   }
   
   return [NSString stringWithString:result];
}

@end