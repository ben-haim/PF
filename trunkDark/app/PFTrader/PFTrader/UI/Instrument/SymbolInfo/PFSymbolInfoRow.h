#import <Foundation/Foundation.h>

@protocol PFSymbolInfoRow < NSObject >

-(NSString*)name;
-(NSString*)value;

@end

@interface PFSymbolInfoRow : NSObject < PFSymbolInfoRow >

@property ( nonatomic, strong, readonly ) NSString* name;
@property ( nonatomic, strong, readonly ) NSString* value;

+(id)infoRowWithName:( NSString* )name_
            andValue:( NSString* )value_;

@end
