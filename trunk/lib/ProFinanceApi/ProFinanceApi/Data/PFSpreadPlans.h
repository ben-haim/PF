#import <Foundation/Foundation.h>

@class PFSpreadPlan;
@class PFQuote;
@protocol PFInstrument;
@protocol PFCommissionLevel;

@interface PFSpreadPlans : NSObject

@property (nonatomic, strong, readonly) NSDictionary* spreadPlans;

-(void)addSpreadPlan: (PFSpreadPlan*)spread_plan_;

-(PFQuote*)createlevel1QuoteWithQuote: ( PFQuote* )real_quote_
                        AndSpreadPlan: ( int )plan_Id_;

-(id< PFCommissionLevel >)commissionLevelWithInstrument: ( id< PFInstrument > )instrument_
                                      AndCommissionPlan: ( int )plan_Id_;

-(void)recalcChartQuotesWithQuotes: ( NSArray* )quotes_
                     AndInstrument: ( id<PFInstrument> )instrument_
                     AndSpreadPlan: ( int )plan_Id_;

-(void)recalcLevel2QuotesWithBidQuotes: ( NSArray* )bid_quotes_
                          AndAskQuotes: ( NSArray* )ask_quotes_
                         AndInstrument: ( id<PFInstrument> )instrument_
                         AndSpreadPlan: ( int )plan_Id_
                          AndLevel1Bid: ( double )bid_
                          AndLevel1Ask: ( double )ask_;

-(double)calcSpreadBidWithBid: ( double )bid_
                          ask: ( double )ask_
                   instrument: ( id< PFInstrument > )instrument_
                 spreadPlanId: ( int )plan_Id_;

-(double)calcSpreadAskWithBid: ( double )bid_
                          ask: ( double )ask_
                   instrument: ( id< PFInstrument > )instrument_
                 spreadPlanId: ( int )plan_Id_;

@end
