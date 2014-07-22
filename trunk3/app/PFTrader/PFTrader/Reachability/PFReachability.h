#import <Foundation/Foundation.h>

typedef NSUInteger PFReachabilityStatus;
extern const PFReachabilityStatus PFNoReachability;
extern const PFReachabilityStatus PFWiFiReachability;
extern const PFReachabilityStatus PFWWANReachability;

@protocol PFReachabilityDelegate;

@interface PFReachability : NSObject

@property ( nonatomic, assign, readonly ) PFReachabilityStatus status;
@property ( nonatomic, assign ) id< PFReachabilityDelegate > delegate;

+(PFReachability*)sharedReachability;

@end

@protocol PFReachabilityDelegate < NSObject >

-(void)reachabilityStatusChanged:( PFReachabilityStatus )new_status_;

@end
