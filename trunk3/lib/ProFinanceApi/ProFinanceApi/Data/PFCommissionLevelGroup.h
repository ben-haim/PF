#import "Detail/PFObject.h"

@protocol PFCommissionLevelGroup < NSObject >

-(PFInteger)instrumentTypeId;
-(PFInteger)instrumentId;
-(NSString*)specifiedCurrency;
-(PFByte)type;

@end

@interface PFCommissionLevelGroup : PFObject < PFCommissionLevelGroup >

@property ( nonatomic, assign ) PFInteger instrumentTypeId;
@property ( nonatomic, assign ) PFInteger instrumentId;
@property ( nonatomic, strong ) NSString* specifiedCurrency;
@property ( nonatomic, assign ) PFByte type;

@property ( nonatomic, strong ) NSMutableArray* commissionGroup;

@end
