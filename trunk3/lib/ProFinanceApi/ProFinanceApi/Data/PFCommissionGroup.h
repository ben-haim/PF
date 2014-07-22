#import "Detail/PFObject.h"

typedef enum
{
   PFCommissionTypePerLot = 0,
   PFCommissionTypePerFill = 1,
   PFCommissionTypePertransaction = 2,
   PFCommissionTypePerphonetransaction = 3,
   PFCommissionTypeVat = 4,
   PFCommissionTypePercent = 5
} PFCommissionType;


typedef enum
{
   PFCommissionPaymentTypeAbsolute = 0,
   PFCommissionPaymentTypeVolumePercent = 1,
} PFCommissionPaymentType;

@protocol PFCommissionGroup < NSObject >

-(PFCommissionType)type;
-(PFCommissionPaymentType)paymentType;
-(PFInteger)counterAccountId;
-(PFBool)activateIb;
-(NSString*)applyOperationType;

@end

@interface PFCommissionGroup : PFObject < PFCommissionGroup >

@property ( nonatomic, assign ) PFCommissionType type;
@property ( nonatomic, assign ) PFCommissionPaymentType paymentType;
@property ( nonatomic, assign ) PFInteger counterAccountId;
@property ( nonatomic, assign ) PFBool activateIb;
@property ( nonatomic, strong ) NSString* applyOperationType;
@property ( nonatomic, strong ) NSString* currency;

@property ( nonatomic, strong ) NSMutableArray* value;
@property ( nonatomic, strong ) NSMutableArray* intervals;
@property ( nonatomic, assign ) bool hasBuySellShort;

-(void)reproductionByBudding;
-(void)addCommissionGroupFrom: (PFCommissionGroup*)comm_group_;

@end
