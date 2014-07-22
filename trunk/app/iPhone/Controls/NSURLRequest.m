
#import "NSURLRequest.h"


@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

@end