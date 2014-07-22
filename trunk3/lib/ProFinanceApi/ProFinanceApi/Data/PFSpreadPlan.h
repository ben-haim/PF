#import "Detail/PFObject.h"

@class PFSpreadLevel;
@protocol PFInstrument;

@interface PFSpreadPlan : PFObject

@property ( nonatomic, assign ) PFInteger planId;
@property ( nonatomic, strong ) NSString* description;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, assign ) PFInteger counterAccountId;

-(BOOL)isValid;

-(PFSpreadLevel*)spreadLevelForInstrument: ( id< PFInstrument > )instument_;

@end