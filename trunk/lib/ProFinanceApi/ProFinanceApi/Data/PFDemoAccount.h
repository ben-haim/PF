#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@protocol PFDemoAccount <NSObject>

-(NSString*)brandingKey;
-(NSString*)login;
-(NSString*)password;
-(NSString*)firstName;
-(NSString*)lastName;
-(NSString*)email;
-(NSString*)phone;
-(NSString*)currency;
-(PFBool)isOnePosition;
-(PFInteger)countryId;
-(PFLong)balance;

@end

@interface PFDemoAccount : NSObject< PFDemoAccount >

@property ( nonatomic, strong ) NSString* brandingKey;
@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, strong ) NSString* password;
@property ( nonatomic, strong ) NSString* confirmedPassword;
@property ( nonatomic, strong ) NSString* firstName;
@property ( nonatomic, strong ) NSString* lastName;
@property ( nonatomic, strong ) NSString* email;
@property ( nonatomic, strong ) NSString* phone;
@property ( nonatomic, strong ) NSString* currency;
@property ( nonatomic, assign ) PFBool isOnePosition;
@property ( nonatomic, assign ) PFInteger countryId;
@property ( nonatomic, assign ) PFLong balance;

@end
