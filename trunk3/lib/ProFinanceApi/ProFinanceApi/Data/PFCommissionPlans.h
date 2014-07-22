#import <Foundation/Foundation.h>

@class PFCommissionPlan;
@class PFQuote;
@protocol PFInstrument;
@protocol PFCommissionGroup;

@interface PFCommissionPlans : NSObject

@property (nonatomic, strong, readonly) NSDictionary* commissionPlans;

-(void)addCommissionPlan: (PFCommissionPlan*)spread_plan_;

-(double)transferCommissionWithCommissionPlan: ( int )plan_Id_;

-(NSArray*)commissionLevelWithInstrument: ( id< PFInstrument > )instrument_
                                      AndCommissionPlan: ( int )plan_Id_;

@end
