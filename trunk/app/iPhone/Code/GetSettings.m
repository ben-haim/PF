

#import "GetSettings.h"


@implementation GetSettings

@synthesize Data, Results, xmlParser, recordResults;

- (bool) initConnection:(id)_caller withUrl:(NSString*)base_url
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"settingsResolved" object:base_url];
    
    return YES;
}
/* Once the connection is made and no errors occur, it will start hitting the NSMutableURLRequest Delegates. We will now set this up */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	//clear any data that may be around.
	[Data setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the Data
    // Data is declared in the header file
    [Data appendData:data];
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object if error occurs
    [connection release];
	theConnection = nil;
    [Data release];		
	[[NSNotificationCenter defaultCenter] postNotificationName:@"settingsDidntResolve" object:nil];
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
	}
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
