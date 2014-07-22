#import <Foundation/Foundation.h>

@class PFServerInfo;

@protocol PFServerFactoryDelegate;

@interface PFServerFactory : NSObject

@property ( nonatomic, weak ) id< PFServerFactoryDelegate > delegate;

+(id)factoryWithServerInfo:( PFServerInfo* )server_info_;


-(BOOL)connect;
-(void)disconnect;

@end

@class PFServer;

@protocol PFServerFactoryDelegate <NSObject>

-(void)serverFactory:( PFServerFactory* )factory_
    didConnectServer:( PFServer* )server_;

-(void)serverFactory:( PFServerFactory* )factory_
    didFailWithError:( NSError* )error_;

@end
