#import <Foundation/Foundation.h>
#import <ProFinanceApi/ProFinanceApi.h>

@interface PFSoundManager : NSObject < PFSessionDelegate >

+(PFSoundManager*)sharedManager;
+(void)destroySharedManager;

-(void)playConfirmationSound;
-(void)playNegativeSound;

@end
