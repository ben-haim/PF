#import <Foundation/Foundation.h>

@interface PFQuoteHistory : NSObject

@property ( nonatomic, strong, readonly ) NSArray* quotes;

+(id)historyWithData:( NSData* )data_ error:( NSError** )error_;

@end
