#import <Foundation/Foundation.h>

@interface PFPasswordEncryptor : NSObject

+(NSString*)encryptPassword: (NSString*)password_ whithKey: (NSString*)key_ andMode: (long) mode_;

@end

@interface PFAESUtility : NSObject

+(NSData*)encryptData: (NSData*)data_ withKey: (NSString*)key_ algorithmMode: (int)algorithm_mode_;
+(NSData*)decryptData: (NSData*)data_ withKey: (NSString*)key_ algorithmMode: (int)algorithm_mode_;

@end

@interface PFXORUtility : NSObject

+(NSData*)encryptData: (NSData*)data_ withKey: (NSString*)key_;
+(NSData*)decryptData: (NSData*)data_ withKey: (NSString*)key_;

@end

@interface NSData (Base64String)

-(NSString*)base64Encoding;

-(NSString*)base64EncodingWithLineLength: (NSUInteger)line_length_;

@end
