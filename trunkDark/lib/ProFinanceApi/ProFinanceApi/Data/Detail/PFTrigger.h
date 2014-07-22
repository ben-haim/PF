#import <Foundation/Foundation.h>

typedef void (^PFTriggerBlock)();

@class PFObject;
typedef BOOL (^PFObjectPredicate)( PFObject* object_ );

typedef enum
{
   PFTriggerUndefined
   , PFTriggerInvoked
   , PFTriggerPredicateFailed
   , PFTriggerExpired
} PFTriggerResult;

@interface PFTrigger : NSObject

@property ( nonatomic, assign, readonly ) BOOL removeAfterInvoke;

+(id)triggerWithBlock:( PFTriggerBlock )block_
            predicate:( PFObjectPredicate )predicate_
             timelive:( NSTimeInterval )timelive_
    removeAfterInvoke:( BOOL )remove_after_invoke_;

-(PFTriggerResult)invokeWithObject:( PFObject* )object_;

@end
