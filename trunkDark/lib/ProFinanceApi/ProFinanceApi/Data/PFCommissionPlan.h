#import "Detail/PFObject.h"

@class PFCommissionGroup;
@protocol PFInstrument;

@interface PFCommissionPlan : PFObject

@property ( nonatomic, assign ) PFInteger planId;
@property ( nonatomic, assign ) PFDouble comissionForTransfer;
@property ( nonatomic, strong ) NSString* description;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, assign ) PFInteger counterAccountId;

-(BOOL)isValid;

-(NSArray*)commissionLevelForInstrument: ( id< PFInstrument > )instument_;

@end
