#import <Foundation/Foundation.h>

@interface PFMenu : NSObject

@property ( nonatomic, strong, readonly ) NSArray* items;

+(id)menuWithItems:( NSArray* )items_;

@end
