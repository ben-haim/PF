#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@protocol PFOrders <NSObject>

-(NSArray*)orders;
-(NSArray*)activeOrders;

@end

@class PFMessage;
@class PFOrder;
@class PFSymbols;

@protocol PFOrdersDelegate;

@interface PFOrders : NSObject< PFOrders >

@property ( nonatomic, strong, readonly ) NSArray* orders;
@property ( nonatomic, strong, readonly ) NSArray* activeOrders;

-(PFOrder*)orderWithId:( PFInteger )order_id_;

-(PFOrder*)updateOrderWithMessage:( PFMessage* )message_
                         delegate:( id< PFOrdersDelegate > )delegate_;

-(void)updateOrder:( PFOrder* )order_
          delegate:( id< PFOrdersDelegate > )delegate_;

-(void)connectToSymbols:( PFSymbols* )symbols_;

@end

@protocol PFOrdersDelegate< NSObject >

-(void)orders:( PFOrders* )orders_
didUpdateOrder:( PFOrder* )order_;

-(void)orders:( PFOrders* )orders_
didRemoveOrder:( PFOrder* )order_;

-(void)orders:( PFOrders* )orders_
  didAddOrder:( PFOrder* )order_;

@end
