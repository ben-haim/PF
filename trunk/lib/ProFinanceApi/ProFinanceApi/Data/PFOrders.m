#import "PFOrders.h"

#import "PFOrder.h"
#import "PFSymbols.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFOrderedDictionary+PFConstructors.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFOrders ()

@property ( nonatomic, strong ) PFMutableOrderedDictionary* ordersById;
@property ( nonatomic, strong ) PFMutableOrderedDictionary* activeOrdersById;
@property ( nonatomic, strong ) PFSymbols* symbols;

@end

@implementation PFOrders

@synthesize activeOrdersById;
@synthesize ordersById;
@synthesize symbols;

@dynamic orders;

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.ordersById = [ PFMutableOrderedDictionary new ];
   }
   return self;
}

-(NSArray*)orders
{
   return self.ordersById.array;
}

-(NSArray*)activeOrders
{
   return self.activeOrdersById.array;
}

-(PFOrder*)orderWithId:( PFInteger )order_id_
{
   return [ self.ordersById objectForKey: @(order_id_) ];
}

-(PFOrder*)orderWithMessageMessage:( PFMessage* )message_
{
   PFInteger order_id_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldOrderId ] integerValue ];

   PFOrder* order_ = [ self orderWithId: order_id_ ];
   if ( !order_ )
   {
      return [ PFOrder objectWithFieldOwner: message_ ];
   }

   [ order_ readFromFieldOwner: message_ ];
   
   return order_;
}

-(PFOrder*)updateOrderWithMessage:( PFMessage* )message_
                         delegate:( id< PFOrdersDelegate > )delegate_
{
   PFOrder* order_ = [ self orderWithMessageMessage: message_ ];
   [ self updateOrder: order_ delegate: delegate_ ];
   return order_;
}

-(void)updateOrder:( PFOrder* )order_
          delegate:( id< PFOrdersDelegate > )delegate_
{
   id order_key_ = @(order_.orderId);

   BOOL inconnected_ = self.symbols && [ self.symbols addSymbolConnection: order_ ] == nil;

   if ( order_.status == PFOrderStatusCancelled || order_.status == PFOrderStatusRefused || order_.isFilled )
   {
      [ self.activeOrdersById removeObjectForKey: order_key_ ];
      [ self.ordersById removeObjectForKey: order_key_ ];
      [ delegate_ orders: self didRemoveOrder: order_ ];
      return;
   }

   if ( inconnected_ )
   {
      NSLog( @"Could not connect order: %@", order_ );
      return;
   }

   BOOL is_new_ = [ self orderWithId: order_.orderId ] == nil;
   [ self.ordersById setObject: order_ forKey: order_key_ ];

   if ( order_.isBase )
   {
      [ self.activeOrdersById setObject: order_ forKey: order_key_ ];
   }

   if ( is_new_ )
   {
      [ delegate_ orders: self didAddOrder: order_ ];
   }
   else
   {
      [ delegate_ orders: self didUpdateOrder: order_ ];
   }
}

-(void)connectToSymbols:( PFSymbols* )symbols_
{
   NSArray* connected_ = [ symbols_ addSymbolConnections: self.ordersById.array ];
   if ( [ connected_ count ] != [ self.ordersById count ] )
   {
      self.ordersById = [ PFMutableOrderedDictionary dictionaryWithOrders: connected_ ];
   }

   NSArray* base_orders_ = [ connected_ select: ^BOOL( id object_ )
                            {
                               return [ object_ isBase ];
                            }];

   self.activeOrdersById = [ PFMutableOrderedDictionary dictionaryWithOrders: base_orders_ ];

   self.symbols = symbols_;
}

@end
