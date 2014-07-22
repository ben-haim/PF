#import "PFSpreadPlans.h"
#import "PFSpreadPlan.h"

#import "PFSpreadLevel.h"
#import "PFCommissionLevel.h"

#import "PFQuote.h"

@interface PFSpreadPlans ()

@property (nonatomic, strong) NSMutableDictionary* mutableSpreadPlans;

-(PFSpreadPlan*)spreadPlanWithId: (int)plan_Id_;

@end

@implementation PFSpreadPlans

@synthesize mutableSpreadPlans;

-(NSDictionary*)spreadPlans
{
   return mutableSpreadPlans;
}

-(void)addSpreadPlan: (PFSpreadPlan*)spread_plan_
{
   if ( !self.mutableSpreadPlans )
   {
      self.mutableSpreadPlans = [ NSMutableDictionary new ];
   }
   
   [ self.mutableSpreadPlans setObject: spread_plan_ forKey: @(spread_plan_.planId) ];
}

-(PFSpreadPlan*)spreadPlanWithId: (int)plan_Id_
{
   return [ self.mutableSpreadPlans objectForKey: @(plan_Id_) ];
}

-(PFQuote*)createlevel1QuoteWithQuote: ( PFQuote* )real_quote_
                        AndSpreadPlan: ( int )plan_Id_
{
   PFSpreadPlan* current_plan_ = [ self spreadPlanWithId: plan_Id_ ];
   
   if ( current_plan_ )
   {
      PFQuote* changed_quote_ = [ real_quote_ copy ];
      [ [ current_plan_ spreadLevelForInstrument: real_quote_.instrument ] recalcLevel1Quote: changed_quote_ ];
      return changed_quote_;
   }
   else
   {
      return real_quote_;
   }
}

-(id< PFCommissionLevel >)commissionLevelWithInstrument: ( id< PFInstrument > )instrument_
                                      AndCommissionPlan: ( int )plan_Id_
{
   PFSpreadPlan* current_plan_ = [ self spreadPlanWithId: plan_Id_ ];
   return current_plan_ ? [ current_plan_ commissionLevelForInstrument: instrument_ ] : nil;
}

-(void)recalcChartQuotesWithQuotes: ( NSArray* )quotes_
                     AndInstrument: ( id<PFInstrument> )instrument_
                     AndSpreadPlan: (int)plan_Id_
{
   PFSpreadPlan* current_plan_ = [ self spreadPlanWithId: plan_Id_ ];
   
   if ( current_plan_ )
   {
      [ [ current_plan_ spreadLevelForInstrument: instrument_ ] recalcChartQuotesArrayWithQuotes: quotes_ ];
   }
}

-(void)recalcLevel2QuotesWithBidQuotes: ( NSArray* )bid_quotes_
                          AndAskQuotes: ( NSArray* )ask_quotes_
                         AndInstrument: ( id<PFInstrument> )instrument_
                         AndSpreadPlan: ( int )plan_Id_
                          AndLevel1Bid: ( double )bid_
                          AndLevel1Ask: ( double )ask_
{
   PFSpreadPlan* current_plan_ = [ self spreadPlanWithId: plan_Id_ ];
   
   if ( current_plan_ )
   {
      [ [ current_plan_ spreadLevelForInstrument: instrument_ ] recalcLevel2QuotesWithBidQuotes: bid_quotes_
                                                                                   AndAskQuotes: ask_quotes_
                                                                                   AndLevel1Bid: bid_
                                                                                   AndLevel1Ask: ask_ ];
   }
}

-(double)calcSpreadBidWithBid: ( double )bid_
                          ask: ( double )ask_
                   instrument: ( id< PFInstrument > )instrument_
                 spreadPlanId: ( int )plan_Id_
{
   PFSpreadPlan* current_plan_ = [ self spreadPlanWithId: plan_Id_ ];
   return current_plan_ ? [ [ current_plan_ spreadLevelForInstrument: instrument_ ] calculateBidWithAsk: ask_ AndBid: bid_ ] : bid_;
}

-(double)calcSpreadAskWithBid: ( double )bid_
                          ask: ( double )ask_
                   instrument: ( id< PFInstrument > )instrument_
                 spreadPlanId: ( int )plan_Id_
{
   PFSpreadPlan* current_plan_ = [ self spreadPlanWithId: plan_Id_ ];
   return current_plan_ ? [ [ current_plan_ spreadLevelForInstrument: instrument_ ] calculateAskWithAsk: ask_ AndBid: bid_ ] : ask_;
}

@end
