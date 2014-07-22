#import "PFOrderedSet.h"

@interface PFOrderedSet ()

@property ( nonatomic, strong ) NSMutableArray* mutableArray;
@property ( nonatomic, strong ) NSMutableSet* mutableSet;

@end

@implementation PFOrderedSet

@synthesize mutableArray;
@synthesize mutableSet;

-(id)initWithArray:( NSArray* )array_
{
   self = [ super init ];
   if ( self )
   {
      self.mutableArray = [ NSMutableArray arrayWithArray: array_ ];
      self.mutableSet = [ NSMutableSet setWithArray: array_ ];
   }
   return self;
}

-(id)init
{
   return [ self initWithArray: nil ];
}

+(id)orderedSetWithArray:( NSArray* )array_
{
   return [ [ self alloc ] initWithArray: array_ ];
}

-(NSArray*)array
{
   return self.mutableArray;
}

-(NSUInteger)count
{
   return self.mutableArray.count;
}

-(BOOL)containsObject:( id )object_
{
   return [ self.mutableSet containsObject: object_ ];
}

-(NSUInteger)countByEnumeratingWithState:( NSFastEnumerationState* )state_
                                 objects:( __unsafe_unretained id* )stackbuf_
                                   count:( NSUInteger )length_
{
   return [ self.mutableArray countByEnumeratingWithState: state_
                                                  objects: stackbuf_
                                                    count: length_ ];
}

@end

@implementation PFMutableOrderedSet

-(void)addObject:( id )object_
{
   [ self.mutableSet addObject: object_ ];
   [ self.mutableArray addObject: object_ ];
}

-(void)removeObject:( id )object_
{
   [ self.mutableSet removeObject: object_ ];
   [ self.mutableArray removeObject: object_ ];
}

@end


