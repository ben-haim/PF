#import "Detail/PFObject.h"

typedef enum
{
   PFSpreadModeNotFixed = 0
   , PFSpreadModeAsk
   , PFSpreadModeBid
   , PFSpreadModeBidAsk
   , PFSpreadModeLimen
} PFSpreadMode;


typedef enum
{
   PFSpreadMeasurePips = 0
   , PFSpreadMeasureCurrency
} PFSpreadMeasure;

@class PFQuote;

@interface PFSpreadLevel : PFObject

@property (nonatomic, assign) PFLong spredLevelId;
@property (nonatomic, assign) PFInteger instrumentTypeId;
@property (nonatomic, assign) PFInteger instrumentId;
@property (nonatomic, assign) PFDouble spread;
@property (nonatomic, assign) PFDouble bidShift;
@property (nonatomic, assign) PFDouble askShift;
@property (nonatomic, assign) PFSpreadMode spreadMode;
@property (nonatomic, assign) PFInteger spreadMeasure;

-(void)recalcLevel1Quote:( PFQuote* )quote_;

-(void)recalcChartQuotesArrayWithQuotes:( NSArray* )quotes_;

-(void)recalcLevel2QuotesWithBidQuotes:( NSArray* )bid_quotes_
                          AndAskQuotes:( NSArray* )ask_quotes_
                          AndLevel1Bid:( double )bid_
                          AndLevel1Ask:( double )ask_;

@end
