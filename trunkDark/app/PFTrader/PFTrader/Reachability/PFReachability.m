#import "PFReachability.h"

#import <NetworkReachability/Reachability.h>

const PFReachabilityStatus PFNoReachability = NotReachable;
const PFReachabilityStatus PFWiFiReachability = ReachableViaWiFi;
const PFReachabilityStatus PFWWANReachability = ReachableViaWWAN;

@interface PFReachability ()

@property ( nonatomic, strong ) Reachability* reachability;
@property ( nonatomic, assign ) PFReachabilityStatus status;

@end

@implementation PFReachability

@synthesize delegate;

@synthesize reachability;
@synthesize status;

-(void)dealloc
{
   [ self.reachability stopNotifer ];
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

-(void)calculateStatus
{
   self.status = self.reachability.currentReachabilityStatus;
   NSLog( @"RIReachability status: %d", (int)self.status );
   
   if ( self.delegate )
   {
      [ self.delegate reachabilityStatusChanged: self.status ];
   }
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.reachability = [ Reachability reachabilityForInternetConnection ];

      [ self calculateStatus ];

      [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                  selector: @selector( calculateStatus )
                                                      name: kReachabilityChangedNotification
                                                    object: self.reachability ];

      [ self.reachability startNotifer ];
   }
   return self;
}

+(PFReachability*)sharedReachability
{
   static PFReachability* reachability_ = nil;
   if ( !reachability_ )
   {
      reachability_ = [ self new ];
   }
   return reachability_;
}

@end
