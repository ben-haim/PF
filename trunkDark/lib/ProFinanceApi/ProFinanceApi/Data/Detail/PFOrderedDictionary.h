#import <Foundation/Foundation.h>

@interface PFOrderedDictionary : NSObject< NSFastEnumeration >

@property ( nonatomic, strong, readonly ) NSArray* array;
@property ( nonatomic, assign, readonly ) NSUInteger count;

-(id)initWithObjects:( NSArray* )objects_
                keys:( NSArray* )keys_;

+(id)orderedDictionaryWithObjects:( NSArray* )objects_
                             keys:( NSArray* )keys_;

-(id)objectForKey:( id )key_;

@end

@interface PFMutableOrderedDictionary : PFOrderedDictionary

-(void)removeObjectForKey:( id )key_;
-(void)setObject:( id )object_ forKey:( id )key_;

@end