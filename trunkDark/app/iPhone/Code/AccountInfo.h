
#import <Foundation/Foundation.h>


@interface AccountInfo : NSObject {

	NSString *account;
	NSString *password;
	NSString *serverAlias;
}

@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *serverAlias;

-(void)saveAccount;

@end
