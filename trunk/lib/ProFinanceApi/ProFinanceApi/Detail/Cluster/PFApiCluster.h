#import <Foundation/Foundation.h>

@class PFApi;

@interface PFApiCluster : NSObject

@property ( nonatomic, strong, readonly ) NSArray* apis;
@property ( nonatomic, assign, readonly ) BOOL transferFinished;

+(id)clusterWithApis:( NSArray* )apis_;

-(void)addApi:( PFApi* )api_;
-(void)removeApi:( PFApi* )api_;

-(PFApi*)apiWithServer:( NSString* )server_;

-(void)transferFinishedApi:( PFApi* )api_;

@end
