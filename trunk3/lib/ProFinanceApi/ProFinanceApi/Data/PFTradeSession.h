#import "Detail/PFObject.h"

typedef enum
{
   PFTradeSessionDayPeriodTypePreOpen
   , PFTradeSessionDayPeriodTypeMain
   , PFTradeSessionDayPeriodTypePostClose
} PFTradeSessionDayPeriodType;

typedef enum
{
   PFTradeSessionPeriodTypeAuctionPreOpen
   , PFTradeSessionPeriodTypeContinuous
   , PFTradeSessionPeriodTypeAuctionPreClose
   , PFTradeSessionPeriodTypeAuctionPreMainOpen
   , PFTradeSessionPeriodTypeAuctionOpen
   , PFTradeSessionPeriodTypeInBetweenClearing
   , PFTradeSessionPeriodTypeAuctionClose
   , PFTradeSessionPeriodTypeClearing
   , PFTradeSessionPeriodTypeSettlementClearing
   , PFTradeSessionPeriodTypeAuctionPostOpen
   , PFTradeSessionPeriodTypeAuctionPostClose
} PFTradeSessionPeriodType;

typedef enum
{
   PFTradeSessionSubPeriodTypeAuctionPreCross
   , PFTradeSessionSubPeriodTypeAuctionFreeze
   , PFTradeSessionSubPeriodTypeContinuous
   , PFTradeSessionSubPeriodTypeInBetweenClearing
   , PFTradeSessionSubPeriodTypeSettlementClearing
} PFTradeSessionSubPeriodType;

typedef enum
{
   PFTradeSessionAllowedOperationTypeOrderEntry
   , PFTradeSessionAllowedOperationTypeModify
   , PFTradeSessionAllowedOperationTypeCancel
} PFTradeSessionAllowedOperationType;

@protocol PFTradeSessionDay;

@protocol PFTradeSession < NSObject >

-(PFBool)isIntraday;
-(PFTradeSessionDayPeriodType)dayPeriodType;
-(PFTradeSessionPeriodType)periodType;
-(PFTradeSessionSubPeriodType)subPeriodType;
-(NSString*)name;
-(NSArray*)sessionDays;
-(NSArray*)allowedOrderTypes;
-(NSArray*)allowedOperations;
-(id< PFTradeSessionDay >)currentTradeDayWithTypeDay: (BOOL) shortedDay;

@end

@interface PFTradeSession : PFObject < PFTradeSession >

@property ( nonatomic, assign, readonly ) PFLong tradeSessionId;
@property ( nonatomic, assign, readonly ) PFBool isIntraday;
@property ( nonatomic, assign, readonly ) PFTradeSessionDayPeriodType dayPeriodType;
@property ( nonatomic, assign, readonly ) PFTradeSessionPeriodType periodType;
@property ( nonatomic, assign, readonly ) PFTradeSessionSubPeriodType subPeriodType;
@property ( nonatomic, strong, readonly ) NSString* name;
@property ( nonatomic, strong, readonly ) NSArray* sessionDays;
@property ( nonatomic, strong, readonly ) NSArray* allowedOrderTypes;
@property ( nonatomic, strong, readonly ) NSArray* allowedOperations;

@property ( nonatomic, strong ) NSTimeZone* currentTimeZone;

@end
