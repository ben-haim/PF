#import <Foundation/Foundation.h>

@interface PFQuoteServerDetails : NSObject

@property ( nonatomic, strong ) NSString* server;
@property ( nonatomic, assign ) NSUInteger load;

-(id)initWithString:( NSString* )string_;

-(id)initWithServer:( NSString* )server_
               load:( NSUInteger )load_;

+(id)lessLoadedServerFrom:( NSArray* )servers_;

@end
