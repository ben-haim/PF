
#import <Foundation/Foundation.h>


@interface GetToken : NSObject <NSXMLParserDelegate>

{
	NSMutableData *Data;
	NSMutableString *Results;
	NSXMLParser *xmlParser;
	NSURLConnection *theConnection;
	NSMutableURLRequest *theRequest;
	BOOL recordResults;
	id caller;
}
@property( nonatomic, retain) NSMutableData *Data;
@property( nonatomic, retain) NSMutableString *Results;
@property( nonatomic, retain) NSXMLParser *xmlParser;
@property( assign ) BOOL recordResults;

- (bool) initConnection:(id)_caller withUrl:(NSString*)base_url;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
