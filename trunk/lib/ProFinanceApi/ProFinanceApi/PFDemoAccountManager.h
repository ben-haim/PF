#import <Foundation/Foundation.h>

typedef void (^PFDemoAccountManagerDoneBlock)( NSString* result_, NSError* error_ );

@class PFServerInfo;

@protocol PFDemoAccount;

@protocol PFDemoAccountManagerDelegate;

@interface PFDemoAccountManager : NSObject

@property ( nonatomic, weak ) id< PFDemoAccountManagerDelegate > delegate;

-(BOOL)connectToServerWithInfo:( PFServerInfo* )server_info_;
-(void)disconnect;

-(void)registerDemoAccount:( id< PFDemoAccount > )demo_account_
                 doneBlock:( PFDemoAccountManagerDoneBlock )done_block_;

@end

@protocol PFDemoAccountManagerDelegate <NSObject>

-(void)demoAccountManager:( PFDemoAccountManager* )account_manager_
         didFailWithError:( NSError* )error_;

@end
