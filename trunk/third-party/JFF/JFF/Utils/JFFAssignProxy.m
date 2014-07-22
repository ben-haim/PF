#import "JFFAssignProxy.h"

@implementation JFFAssignProxy

@synthesize target = _target;

-(id)initWithTarget:( id )target_
{
   _target = target_;

   return self;
}

-(void)forwardInvocation:( NSInvocation* )invocation_
{
   SEL selector_ = [ invocation_ selector ];

   if ( [ self.target respondsToSelector: selector_ ] )
      [ invocation_ invokeWithTarget: self.target ];
}

-(NSMethodSignature*)methodSignatureForSelector:( SEL )selector_
{
   return [ self.target methodSignatureForSelector: selector_ ];
}

-(void)clear
{
   _target = nil;
}

-(NSUInteger)hash
{
   return (NSUInteger)_target;
}

-(BOOL)isEqual:( id )other_
{
   if ( [ self class ] != [ other_ class ] )
      return NO;

   JFFAssignProxy* other_proxy_ = ( JFFAssignProxy* )other_;
   return other_proxy_->_target == _target;
}

@end
