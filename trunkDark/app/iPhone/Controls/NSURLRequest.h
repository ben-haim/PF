

#import <Foundation/Foundation.h>


@interface NSURLRequest (NSURLRequestWithIgnoreSSL) //{

//}

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

@end
