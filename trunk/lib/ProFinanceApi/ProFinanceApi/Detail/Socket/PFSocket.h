#import <Foundation/Foundation.h>

@protocol PFSocketDelegate;

@protocol PFSocket <NSObject>

-(void)setDelegate:( id< PFSocketDelegate > )delegate_;

-(BOOL)connectToHost:( NSString* )host_
                port:( NSInteger )port_
              secure:( BOOL )secure_;

-(void)disconnect;

-(void)sendData:( NSData* )data_;

@end

@protocol PFSocketDelegate <NSObject>

-(void)didConnectSocket:( id< PFSocket > )socket_;
-(void)socket:( id< PFSocket > )socket_ didFailWithError:( NSError* )error_;
-(void)socket:( id< PFSocket > )socket_ didReceiveData:( NSData* )data_;

@end
