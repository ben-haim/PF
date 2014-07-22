#import "../PFTypes.h"

#import "PFMarketOperation.h"

#import <Foundation/Foundation.h>

typedef enum
{
   PFOrderValidityDay = 1
   , PFOrderValidityGtc
   , PFOrderValidityIoc
   , PFOrderValidityGtd
   , PFOrderValidityFok
   , PFOrderValidityMoo
   , PFOrderValidityMoc
} PFOrderValidityType;

typedef enum
{
   PFOrderStatusNone = 0
   , PFOrderStatusPendingNew = 1
   , PFOrderStatusPendingExecution = 2
   , PFOrderStatusPendingCancel = 3
   , PFOrderStatusPendingReplace = 4
   , PFOrderStatusPendingStp = 5
   , PFOrderStatusNew = 10
   , PFOrderStatusReplaced = 20
   , PFOrderStatusCancelled = 40
   , PFOrderStatusPartFilled = 30
   , PFOrderStatusFilled = 31
   , PFOrderStatusRefused = 41
} PFOrderStatusType;

@protocol PFMutableOrder;

@protocol PFOrder <PFMarketOperation>

-(PFInteger)clientOrderId;
-(PFInteger)boundToOrderId;
-(PFDouble)filledAmount;
-(PFOrderValidityType)validity;
-(PFDouble)stopPrice;
-(NSString*)comment;
-(NSDate*)expireAtDate;
-(PFByte)optionType;
-(PFBool)createdByBroker;
-(PFOrderStatusType)status;
-(PFBool)isOpenOrder;
-(PFBool)isFilled;
-(PFBool)isBase;

-(id<PFMutableOrder>)mutableOrder;

@end

@protocol PFMutableOrder <PFMutableMarketOperation, PFOrder>

-(void)setOrderType:( PFOrderType )type_;
-(void)setPrice:( PFDouble )price_;
-(void)setStopPrice:( PFDouble )price_;
-(void)setValidity:( PFOrderValidityType )validity_;
-(void)setClientOrderId:( PFInteger )client_order_id_;
-(void)setExpireAtDate:( NSDate* )date_;

@end

@protocol PFPosition;

@interface PFOrder : PFMarketOperation< PFMutableOrder >

@property ( nonatomic, assign ) PFInteger clientOrderId;
@property ( nonatomic, assign ) PFInteger boundToOrderId;
@property ( nonatomic, assign ) PFDouble filledAmount;
@property ( nonatomic, assign ) PFOrderValidityType validity;
@property ( nonatomic, assign ) PFDouble stopPrice;
@property ( nonatomic, strong ) NSString* comment;
@property ( nonatomic, strong ) NSDate* expireAtDate;
@property ( nonatomic, assign ) PFByte optionType;
@property ( nonatomic, assign ) PFBool createdByBroker;
@property ( nonatomic, assign ) PFOrderStatusType status;
@property ( nonatomic, assign, getter=isOpenOrder ) PFBool openOrder;
@property ( nonatomic, assign, readonly ) PFBool isFilled;

+(id)closeOrderWithPosition:( id< PFPosition > )position_;

+(id)stopOrderForMarketOperation:( id< PFMarketOperation > )market_operation_
                           price:( PFDouble )price_
                  stopLossOffset:( PFDouble )stop_loss_offset_;

+(id)limitOrderMarketOperation:( id< PFMarketOperation > )market_operation_
                         price:( PFDouble )price_;

+(id)stopOrderWithPosition:( id< PFPosition > )position_;
+(id)limitOrderWithPosition:( id< PFPosition > )position_;

-(BOOL)isEqualToOrder:( PFOrder* )order_;

@end
