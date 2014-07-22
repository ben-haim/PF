#import <Foundation/Foundation.h>

@protocol PFOrderHistory <NSObject>

-(NSArray*)orders;

@end

@class PFOrder;

@protocol PFOrderHistoryDelegate;

@interface PFOrderHistory : NSObject

@property ( nonatomic, strong, readonly ) NSArray* orders;

-(void)addOrder:( PFOrder* )order_
       delegate:( id< PFOrderHistoryDelegate > )delegate_;

@end

@protocol PFOrderHistoryDelegate <NSObject>

-(void)orderHistory:( PFOrderHistory* )history_
        didAddOrder:( PFOrder* )order_;

@end
