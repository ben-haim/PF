#import <Foundation/Foundation.h>

@protocol PFCommander <NSObject>

-(void)logonWithLogin:( NSString* )login_
             password:( NSString* )password_
 verificationPassword:( NSString* )verification_password_
       verificationId:( int )verification_id_
            ipAddress:( NSString* )ip_address_;

-(void)applyNewPassword:( NSString* )new_password_
            oldPassword:( NSString* )old_password_
   verificationPassword:(NSString *)verification_password_
                 userId:( int )user_id_
              accountId:( int )account_id_;

-(void)logout;

-(void)disconnect;

@end
