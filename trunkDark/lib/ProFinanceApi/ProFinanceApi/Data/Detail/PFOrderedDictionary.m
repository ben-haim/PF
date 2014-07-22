#import "PFOrderedDictionary.h"

@interface PFOrderedDictionary ()

@property ( nonatomic, strong ) NSMutableArray* mutableArray;
@property ( nonatomic, strong ) NSMutableDictionary* mutableDictionary;

@end

@implementation PFOrderedDictionary

@synthesize mutableArray;
@synthesize mutableDictionary;

-(id)initWithCapacity:( NSUInteger )capacity_
{
   self = [ super init ];
   if ( self )
   {
      self.mutableArray = [ [ NSMutableArray alloc ] initWithCapacity: capacity_ ];
      self.mutableDictionary = [ [ NSMutableDictionary alloc ] initWithCapacity: capacity_ ];
   }
   return self;
}

-(id)initWithObjects:( NSArray* )objects_
                keys:( NSArray* )keys_
{
   self = [ super init ];

   if ( self )
   {
      self.mutableArray = [ NSMutableArray arrayWithArray: objects_ ];
      self.mutableDictionary = [ NSMutableDictionary dictionaryWithObjects: objects_
                                                                   forKeys: keys_ ];
   }

   return self;
}

+(id)orderedDictionaryWithObjects:( NSArray* )objects_
                             keys:( NSArray* )keys_
{
   return [ [ self alloc ] initWithObjects: objects_
                                      keys: keys_ ];
}

-(id)init
{
   return [ self initWithCapacity: 10 ];
}

-(NSUInteger)count
{
   return [ self.mutableArray count ];
}

-(id)objectForKey:( id )key_
{
   return (self.mutableDictionary)[key_];
}

-(NSArray*)array
{
   return self.mutableArray;
}

-(NSUInteger)countByEnumeratingWithState:( NSFastEnumerationState* )state_
                                 objects:( __unsafe_unretained id* )stackbuf_
                                   count:( NSUInteger )length_
{
   return [ self.mutableArray countByEnumeratingWithState: state_
                                                  objects: stackbuf_
                                                    count: length_ ];
}

-(NSString*)description
{
   return [ self.mutableArray description ];
}

@end

@implementation PFMutableOrderedDictionary

-(void)removeObjectForKey:( id )key_
{
   id found_object_ = (self.mutableDictionary)[key_];
   if ( found_object_ )
   {
      [ self.mutableDictionary removeObjectForKey: key_ ];
      [ self.mutableArray removeObject: found_object_ ];
   }
}

-(void)setObject:( id )object_ forKey:( id )key_
{
   id found_object_ = (self.mutableDictionary)[key_];
   (self.mutableDictionary)[key_] = object_;

   if ( found_object_ )
   {
      NSUInteger found_object_index_ = [ self.mutableArray indexOfObject: found_object_ ];
      NSAssert( found_object_index_ != NSNotFound, @"invalid index" );
      (self.mutableArray)[found_object_index_] = object_;
   }
   else
   {
      [ self.mutableArray addObject: object_ ];
   }
}

@end
