

#import "GetServer.h"

@implementation GetServer

@synthesize Data, Results, xmlParser, recordResults, timeoutTimer, theConnection;

- (bool) initConnection:(id)_caller withUrl:(NSString*)base_url
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"serverResolved" object:base_url];
    return YES;
}

-(void)connectionDied:(id)sender
{
	count++;
	if (count == timeout)
	{
		[theConnection cancel];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"serverDidntResolve" object:nil];
		
		timeoutTimer = nil;
	}	
}

/* Once the connection is made and no errors occur, it will start hitting the NSMutableURLRequest Delegates. We will now set this up */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	//clear any data that may be around.
	[Data setLength:0];
	timeoutTimer = nil;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [Data appendData:data];
	
	timeoutTimer = nil;
	
} 
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object if error occurs
    [connection release];
	theConnection = nil;
    [Data release];		
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"serverDidntResolve" object:nil];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *theXml = [[NSString alloc]initWithBytes:[Data mutableBytes] length:[Data length] encoding:NSUTF8StringEncoding];
    
	[theXml release];
	
	//release if xml is already init
	if( xmlParser )
	{
		[xmlParser release];
	}
	//xmlParse declared in the header
	
	xmlParser= [[NSXMLParser alloc] initWithData: Data];
	[xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
	[xmlParser parse];	
    [Data release];
	
	// release the connection, and the data object
    //[connection release];	
	if(theConnection)
	{
		[theConnection release];
		theConnection = nil;
		
		if (!responseSent)     // if the connection closed but address was not sent
			[[NSNotificationCenter defaultCenter] postNotificationName:@"serverDidntResolve" object:nil];
	}
	
	//if (timeoutTimer != nil)
		//[timeoutTimer invalidate];
	timeoutTimer = nil;

}

 
 - (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{
	
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
	//if at the HelloResult element, record the data to NSMutableString
	 if( recordResults )
     {
		 [Results appendString:string];
	 }
}
 - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
 

}
 
 //release our xmlParser
 - (void)dealloc 
 {
	 [xmlParser release];
	 if(theConnection)
	 {
		 [theConnection release];		
		 theConnection = nil;
	 }
	 [super dealloc];
 }
	
@end
