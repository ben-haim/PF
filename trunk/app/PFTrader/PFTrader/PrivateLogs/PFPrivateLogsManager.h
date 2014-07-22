#import <Foundation/Foundation.h>

typedef void (^PFPrivateLogsDoneBlock)(NSString* log_content_);

@interface PFPrivateLogsManager : NSObject

+(PFPrivateLogsManager*)manager;

-(void)writeToLog:( NSString* )message_;

-(void)readTodayLogWithDoneBlock:( PFPrivateLogsDoneBlock )done_block_;
-(void)readLogWithDate:( NSDate* )date_ andDoneBlock:( PFPrivateLogsDoneBlock )done_block_;

@end
