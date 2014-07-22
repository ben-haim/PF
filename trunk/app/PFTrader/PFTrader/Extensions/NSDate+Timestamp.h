#import <Foundation/Foundation.h>

@interface NSDate (Timestamp)

-(NSString*)shortTimestampString;
-(NSString*)shortDateString;
-(NSString*)shortTimeString;

+(NSDate*)GMTNow;
+(NSDate*)dateFromDateAndTime:( NSDate* )current_;

@end
