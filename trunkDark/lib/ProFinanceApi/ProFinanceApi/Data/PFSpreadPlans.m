#import "PFSpreadPlans.h"
#import "PFSpreadPlan.h"

#import "PFSpreadLevel.h"

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
   
   (self.mutableSpreadPlans)[@(spread_plan_.planId)] = spread_plan_;
}

-(PFSpreadPlan*)spreadPlanWithId: (int)plan_Id_
{
   return (self.mutableSpreadPlans)[@(plan_Id_)];
}

-(PFQuote*)createlevel1QuoteWithQuote: ( PFQuote* )real_quote_
                        AndSpreadPlan: ( int )plan_Id_
{
   PFSpreadPlan* current_plan_ = [ self spreadPlanWithId: plan_Id_ ];
   
   if ( current_plan_ )
   {
      PFSpreadLevel* current_spread_level_ = [ current_plan_ spreadLevelForInstrument: real_quote_.instrument ];
      
      if (  current_spread_level_ )
      {
         PFQuote* changed_quote_ = [ real_quote_ copy ];
         [ current_spread_level_ recalcLevel1Quote: changed_quote_ ];
         return changed_quote_;
      }
   }
   
   return real_quote_;
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

@end
