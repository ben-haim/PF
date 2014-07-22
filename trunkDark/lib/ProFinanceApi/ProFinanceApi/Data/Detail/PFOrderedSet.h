#import <Foundation/Foundation.h>

@interface PFOrderedSet : NSObject< NSFastEnumeration >

@property ( nonatomic, strong, readonly ) NSArray* array;
@property ( nonatomic, assign, readonly ) NSUInteger count;

-(id)initWithArray:( NSArray* )array_;
+(id)orderedSetWithArray:( NSArray* )array_;

-(BOOL)containsObject:( id )object_;

@end

@interface PFMutableOrderedSet : PFOrderedSet

-(void)addObject:( id )object_;
-(void)removeObject:( id )object_;

@end
