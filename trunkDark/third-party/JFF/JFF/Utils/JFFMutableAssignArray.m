#import "JFFMutableAssignArray.h"

#import "NSArray+BlocksAdditions.h"

#import "JFFAssignProxy.h"

#include "JFFUtilsBlockDefinitions.h"

#import "NSThread+AssertMainThread.h"

@interface JFFMutableAssignArray ()

@property ( nonatomic, strong ) NSMutableSet* mutableSet;

@end

@implementation JFFMutableAssignArray

@synthesize mutableSet = _mutableSet;

-(void)dealloc
{
   [ self removeAllObjects ];
}

-(NSSet*)set
{
   return self.mutableSet;
}

-(NSMutableSet*)mutableSet
{
   if ( !_mutableSet )
   {
      _mutableSet = [ NSMutableSet new ];
   }
   return _mutableSet;
}

-(void)addObject:( id )object_
{
   [ NSThread assertMainThread ];

   JFFAssignProxy* proxy_ = [ [ JFFAssignProxy alloc ] initWithTarget: object_ ];
   [ self.mutableSet addObject: proxy_ ];
}

-(BOOL)containsObject:( id )object_
{
   [ NSThread assertMainThread ];

   return [ self.mutableSet containsObject: object_ ];
}

-(void)removeObject:( id )object_
{
   [ NSThread assertMainThread ];

   JFFAssignProxy* proxy_ = [ [ JFFAssignProxy alloc ] initWithTarget: object_ ];
   [ self.mutableSet removeObject: proxy_ ];
}

-(void)removeAllObjects
{
   [ NSThread assertMainThread ];

   self.mutableSet = nil;
}

-(NSUInteger)count
{
   [ NSThread assertMainThread ];

   return [ _mutableSet count ];
}

@end
