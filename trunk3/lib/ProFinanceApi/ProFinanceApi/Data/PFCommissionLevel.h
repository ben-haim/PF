#import "Detail/PFObject.h"

typedef enum
{
   PFCommissionTypePerLotInServerCCY = 0
   , PFCommissionTypePerLotInInstrumentCCY = 1
   , PFCommissionTypePercentOfTrade = 2
   , PFCommissionTypePerPips =3
   , PFCommissionTypePercentOfTradeInInstrumentCCY = 4
   , PFCommissionTypePerHit = 5
   , PFCommissionTypePerLotInSpecified = 6
   
}PFCommissionType;


@protocol PFCommissionLevel < NSObject >

-(PFLong)commissionLevelId;
-(PFInteger)instrumentTypeId;
-(PFInteger)instrumentId;
-(NSString*)comment;
-(NSString*)specifiedCurrency;
-(PFDouble)perOrderPrice;
-(PFDouble)closePrice;
-(PFDouble)openPrice;
-(PFDouble)freeAmount;
-(PFDouble)dealerCommission;
-(PFCommissionType)type;
-(PFDouble)minPerOrder;
-(PFDouble)maxPerOrder;

@end

@interface PFCommissionLevel : PFObject < PFCommissionLevel >

@property ( nonatomic, assign ) PFLong commissionLevelId;
@property ( nonatomic, assign ) PFInteger instrumentTypeId;
@property ( nonatomic, assign ) PFInteger instrumentId;
@property ( nonatomic , strong ) NSString* comment;
@property ( nonatomic , strong ) NSString* specifiedCurrency;
@property ( nonatomic, assign ) PFDouble perOrderPrice;
@property ( nonatomic, assign ) PFDouble closePrice;
@property ( nonatomic, assign ) PFDouble openPrice;
@property ( nonatomic, assign ) PFDouble freeAmount;
@property ( nonatomic, assign ) PFDouble dealerCommission;
@property ( nonatomic, assign ) PFCommissionType type;
@property ( nonatomic, assign ) PFDouble minPerOrder;
@property ( nonatomic, assign ) PFDouble maxPerOrder;

@end
