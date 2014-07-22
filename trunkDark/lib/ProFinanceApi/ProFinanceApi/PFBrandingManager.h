#import <Foundation/Foundation.h>

typedef void (^PFBrandingManagerDoneBlock)( NSDictionary* result_, NSError* error_ );

@class PFServerInfo;

@protocol PFBrandingManagerDelegate;

@interface PFBrandingManager : NSObject

-(id)initWithDelegate:( id< PFBrandingManagerDelegate > )delegate_
       brandingServer:( NSString* )branding_server_
          brandingKey:( NSString* )branding_key_;

-(void)getBrandingWithDoneBlock:( PFBrandingManagerDoneBlock )done_block_;

@end

@protocol PFBrandingManagerDelegate <NSObject>

-(void)brandingManager:( PFBrandingManager* )branding_manager_
      didFailWithError:( NSError* )error_;

@end



