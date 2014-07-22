#import "Detail/PFObject.h"

@class PFSpreadLevel;
@class PFCommissionLevel;
@protocol PFInstrument;

@interface PFSpreadPlan : PFObject

@property ( nonatomic, assign ) PFInteger planId;
@property ( nonatomic, strong ) NSString* specifiedCurrency;

-(BOOL)isValid;

-(PFSpreadLevel*)spreadLevelForInstrument: ( id< PFInstrument > )instument_;
-(PFCommissionLevel*)commissionLevelForInstrument: ( id< PFInstrument > )instument_;

@end
