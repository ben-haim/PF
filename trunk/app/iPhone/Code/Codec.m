
#import "Codec.h"


@implementation Codec


-(void)initWith:(char *)_key
{	
	for(int i=0; i<32; i++)	
		key[i] = _key[i];						
								
	BytesReceived = 0;
	lastByteReceived = 0;
	BytesSent = 0;
	lastByteSent = 0;	
}
-(char*)getKey
{
	return (char*)key;
}
-(void)DecryptData:(char *)src OfLength:(UInt32)len
{

}
-(void)EncryptData:(unsigned char *)src OfLength:(UInt32)len
{
	
}


@end
