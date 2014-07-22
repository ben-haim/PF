#import "PFTrigger.h"

@interface PFTrigger ()

@property ( nonatomic, strong ) NSDate* createdDate;
@property ( nonatomic, copy ) PFTriggerBlock block;
@property ( nonatomic, copy ) PFObjectPredicate predicate;
@property ( nonatomic, assign ) NSTimeInterval timelive;
@property ( nonatomic, assign ) BOOL removeAfterInvoke;

@end

@implementation PFTrigger

@synthesize createdDate;
@synthesize block;
@synthesize predicate;
@synthesize timelive;
@synthesize removeAfterInvoke;

-(id)initWithBlock:( PFTriggerBlock )block_
         predicate:( PFObjectPredicate )predicate_
          timelive:( NSTimeInterval )timelive_
 removeAfterInvoke:( BOOL )remove_after_invoke_
{
   NSAssert( block_, @"block must be initialized" );

   self = [ super init ];
   if ( self )
   {
      self.createdDate = [ NSDate date ];
      self.block = block_;
      self.predicate = predicate_;
      self.timelive = timelive_;
      self.removeAfterInvoke = remove_after_invoke_;
   }
   return self;
}

+(id)triggerWithBlock:( PFTriggerBlock )block_
            predicate:( PFObjectPredicate )predicate_
             timelive:( NSTimeInterval )timelive_
    removeAfterInvoke:( BOOL )remove_after_invoke_
{
   return [ [ self alloc ] initWithBlock: block_
                               predicate: predicate_
                                timelive: timelive_
                       removeAfterInvoke: remove_after_invoke_];
}

-(BOOL)checkObject:( PFObject* )object_
{
   if ( !self.predicate )
      return YES;
   
   return self.predicate( object_ );
}

-(PFTriggerResult)invokeWithObject:( PFObject* )object_
{
   if ( ![ self checkObject: object_ ] )
      return PFTriggerPredicateFailed;

   if ( -[ self.createdDate timeIntervalSinceNow ] > self.timelive )
   {
      self.block = nil;
      return PFTriggerExpired;
   }

   self.block();
   if ( self.removeAfterInvoke )
   {
      self.block = nil;
   }

   return PFTriggerInvoked;
}

@end
