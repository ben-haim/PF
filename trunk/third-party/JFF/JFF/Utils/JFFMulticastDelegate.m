#import "JFFMulticastDelegate.h"

#import "JFFMutableAssignArray.h"

#import "JFFAssignProxy.h"

@interface JFFMulticastDelegate ()

@property ( nonatomic, strong ) JFFMutableAssignArray* delegates;

@end

@implementation JFFMulticastDelegate

@synthesize delegates = _delegates;

-(NSUInteger)count
{
   return [ _delegates count ];
}

-(JFFMutableAssignArray*)delegates
{
   if ( !_delegates )
   {
      _delegates = [ JFFMutableAssignArray new ];
   }
   return _delegates;
}

-(void)addDelegate:( id )delegate_
{
   if ( ![ self.delegates containsObject: delegate_ ] )
   {
      [ self.delegates addObject: delegate_ ];
   }
}

-(void)removeDelegate:( id )delegate_
{
   [ _delegates removeObject: delegate_ ];
}

-(void)removeAllDelegates
{
   [ _delegates removeAllObjects ];
}

-(void)forwardInvocation:( NSInvocation* )invocation_
{
   SEL selector_ = [ invocation_ selector ];

   NSSet* copy_ = [ _delegates.set copy ];

   for ( JFFAssignProxy* proxy_ in copy_ )
   {
      if ( [ proxy_.target respondsToSelector: selector_ ] )
      {
         [ invocation_ invokeWithTarget: proxy_.target ];
      }
   }
}

-(NSMethodSignature*)methodSignatureForSelector:( SEL )selector_
{
   NSSet* copy_ = [ _delegates.set copy ];

   for ( JFFAssignProxy* proxy_ in copy_ )
   {
      NSMethodSignature* result_ = [ proxy_.target methodSignatureForSelector: selector_ ];
      if( result_ )
         return result_;
   }

   return [ [ self class ] instanceMethodSignatureForSelector: @selector( doNothing ) ];
}

-(void)doNothing
{
}

@end
