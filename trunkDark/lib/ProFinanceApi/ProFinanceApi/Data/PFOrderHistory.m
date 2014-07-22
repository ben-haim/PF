#import "PFOrderHistory.h"

#import "PFOrder.h"

@interface PFOrderHistory ()

@property ( nonatomic, strong ) NSMutableArray* mutableOrders;

@end


@implementation PFOrderHistory

@synthesize mutableOrders;

+(NSSet*)historyStatuses
{
   static NSSet* history_statuses_ = nil;
   if ( !history_statuses_ )
   {
      history_statuses_ = [ NSSet setWithObjects: @(PFOrderStatusNew)
                           , @(PFOrderStatusReplaced)
                           , @(PFOrderStatusCancelled)
                           , @(PFOrderStatusPartFilled)
                           , @(PFOrderStatusFilled)
                           , nil ];
   }
   return history_statuses_;
}

-(BOOL)shouldArchiveOrder:( PFOrder* )order_
{
   return [ [ [ self class ] historyStatuses ] containsObject: @(order_.status) ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.mutableOrders = [ NSMutableArray new ];
   }
   return self;
}

-(NSArray*)orders
{
   return self.mutableOrders;
}

-(void)addOrder:( PFOrder* )order_
       delegate:( id< PFOrderHistoryDelegate > )delegate_
{
   if ( order_.symbol && [ self shouldArchiveOrder: order_ ] )
   {
      PFOrder* archived_order_ = [ order_ copy ];
      [ self.mutableOrders addObject: archived_order_ ];
      [ delegate_ orderHistory: self didAddOrder: archived_order_ ];
   }
}

@end
