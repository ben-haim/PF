#import "PFMessage.h"

#import <Foundation/Foundation.h>

@protocol PFOrder;

@interface PFMessage (PFOrder)

+(id)messageWithCancelOrder:( id< PFOrder > )order_;
+(id)messageWithCreateOrder:( id< PFOrder > )order_;
+(id)messageWithReplaceOrder:( id< PFOrder > )order_;

@end
