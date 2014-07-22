#import <Foundation/Foundation.h>

@interface NSDictionary (URLHelpers)

-(NSString*)URLArguments;

@end

@interface NSMutableDictionary (URLHelpers)

-(void)setIfNotNilObject:( NSObject* )object_ forKey:( NSString* )key_;

@end
