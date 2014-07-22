#import <Foundation/Foundation.h>

@interface JFFMutableAssignArray : NSObject

@property ( nonatomic, strong, readonly ) NSSet* set;

-(void)addObject:( id )object_;
-(BOOL)containsObject:( id )object_;
-(void)removeObject:( id )object_;
-(void)removeAllObjects;

-(NSUInteger)count;

@end
