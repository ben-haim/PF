
#import <Foundation/Foundation.h>


@interface Codec : NSObject 
{
	unsigned char key[32];
	int BytesReceived;
	unsigned char lastByteReceived;
	int BytesSent;
	unsigned char lastByteSent;
}

-(void)initWith:(char *)_key;
-(char*)getKey;
-(void)DecryptData:(char *)src OfLength:(UInt32)len;
-(void)EncryptData:(unsigned char *)src OfLength:(UInt32)len;
@end
