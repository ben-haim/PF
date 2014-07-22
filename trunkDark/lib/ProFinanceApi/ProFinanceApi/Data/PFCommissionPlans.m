#import "PFCommissionPlans.h"
#import "PFCommissionPlan.h"
#import "PFCommissionGroup.h"
#import "PFInstrument.h"
#import "PFInstrumentGroup.h"
#import "PFQuote.h"

@interface PFCommissionPlans ()

@property (nonatomic, strong) NSMutableDictionary* mutableCommissionPlans;

-(PFCommissionPlan*)commissionPlanWithId: (int)plan_Id_;

@end

@implementation PFCommissionPlans

@synthesize mutableCommissionPlans;

-(NSDictionary*)commissionPlans
{
   return mutableCommissionPlans;
}

-(void)addCommissionPlan: (PFCommissionPlan*)commission_plan_
{
   if ( !self.mutableCommissionPlans )
   {
      self.mutableCommissionPlans = [ NSMutableDictionary new ];
   }
   
   (self.mutableCommissionPlans)[@(commission_plan_.planId)] = commission_plan_;
}

-(PFCommissionPlan*)commissionPlanWithId: (int)plan_Id_
{
   return (self.mutableCommissionPlans)[@(plan_Id_)];
}

-(double)transferCommissionWithCommissionPlan: ( int )plan_Id_
{
   PFCommissionPlan* current_plan_ = [ self commissionPlanWithId: plan_Id_ ];
   return current_plan_ ? current_plan_.comissionForTransfer : 0.0;
}

-(NSArray*)commissionLevelWithInstrument: ( id< PFInstrument > )instrument_
                                      AndCommissionPlan: ( int )plan_Id_
{
   PFCommissionPlan* current_plan_ = [ self commissionPlanWithId: plan_Id_ ];
   return current_plan_ ? [ current_plan_ commissionLevelForInstrument: instrument_ ] : nil;
}

@end
