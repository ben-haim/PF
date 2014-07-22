#import <Foundation/Foundation.h>

@class PFSpreadPlan;
@class PFQuote;
@protocol PFInstrument;

@interface PFSpreadPlans : NSObject

@property (nonatomic, strong, readonly) NSDictionary* spreadPlans;

-(void)addSpreadPlan: (PFSpreadPlan*)spread_plan_;

-(PFQuote*)createlevel1QuoteWithQuote: ( PFQuote* )real_quote_
                        AndSpreadPlan: ( int )plan_Id_;

-(void)recalcChartQuotesWithQuotes: ( NSArray* )quotes_
                     AndInstrument: ( id<PFInstrument> )instrument_
                     AndSpreadPlan: ( int )plan_Id_;

-(void)recalcLevel2QuotesWithBidQuotes: ( NSArray* )bid_quotes_
                          AndAskQuotes: ( NSArray* )ask_quotes_
                         AndInstrument: ( id<PFInstrument> )instrument_
                         AndSpreadPlan: ( int )plan_Id_
                          AndLevel1Bid: ( double )bid_
                          AndLevel1Ask: ( double )ask_;

@end
