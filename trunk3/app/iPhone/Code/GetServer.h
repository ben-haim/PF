

#import <Foundation/Foundation.h>


@interface GetServer : NSObject <NSXMLParserDelegate>
{
	NSMutableData *Data;
	NSMutableString *Results;
	NSXMLParser *xmlParser;
	NSURLConnection *theConnection;
	NSMutableURLRequest *theRequest;
	BOOL recordResults;
	id caller;
	NSTimer* timeoutTimer;
	int timeout;
	int count;
	
	bool responseSent;
}
@property( nonatomic, retain) NSMutableData *Data;
@property( nonatomic, retain) NSMutableString *Results;
@property( nonatomic, retain) NSXMLParser *xmlParser;
@property( nonatomic, retain) NSURLConnection *theConnection;
@property( assign ) BOOL recordResults;
@property( nonatomic, retain) NSTimer* timeoutTimer;

- (bool) initConnection:(id)_caller withUrl:(NSString*)base_url;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
