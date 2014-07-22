#import "PFSpreadLevel.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

#import "PFQuote.h"
#import "PFQuoteInfo.h"
#import "PFLevel2Quote.h"
#import "PFInstrument.h"

@interface PFSpreadLevel ()

@property (nonatomic, assign) double spreadCoefficient;

-(double)calculateAskWithAsk: (double)ask_ AndBid: (double)bid_;
-(double)calculateBidWithAsk: (double)ask_ AndBid: (double)bid_;

@end

@implementation PFSpreadLevel

@synthesize spredLevelId;
@synthesize instrumentTypeId;
@synthesize instrumentId;
@synthesize spread;
@synthesize bidShift;
@synthesize askShift;
@synthesize spreadMode;
@synthesize spreadMeasure;
@synthesize spreadCoefficient;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects:
              [ PFMetaObjectField fieldWithId: PFFieldId name: @"spredLevelId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldInstrumentTypeId name: @"instrumentTypeId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldInstrumentId name: @"instrumentId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSpread name: @"spread" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBidShift name: @"bidShift" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAskShift name: @"askShift" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSpreadMode name: @"spreadMode" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSpreadMeasure name: @"spreadMeasure" ]
            , nil ] ];
}

-(void)recalcLevel1Quote: (PFQuote*)quote_
{
   self.spreadCoefficient = self.spreadMeasure == PFSpreadMeasurePips ? quote_.instrument.pointSize : 1.0;
   
   switch (quote_.instrument.barType) {
      case PFQuoteBarTypeBid:
      {
         quote_.open          = [ self calculateBidWithAsk: quote_.askOpen  AndBid: quote_.bidOpen ];
         quote_.high          = [ self calculateBidWithAsk: quote_.askHigh  AndBid: quote_.bidHigh ];
         quote_.low           = [ self calculateBidWithAsk: quote_.askLow   AndBid: quote_.bidLow ];
         quote_.previousClose = [ self calculateBidWithAsk: quote_.askClose AndBid: quote_.bidClose ];
         quote_.last          = [ self calculateBidWithAsk: quote_.ask      AndBid: quote_.bid ];
         
         break;
      }
      case PFQuoteBarTypeAsk:
      {
         quote_.open          = [ self calculateAskWithAsk: quote_.askOpen  AndBid: quote_.bidOpen ];
         quote_.high          = [ self calculateAskWithAsk: quote_.askHigh  AndBid: quote_.bidHigh ];
         quote_.low           = [ self calculateAskWithAsk: quote_.askLow   AndBid: quote_.bidLow ];
         quote_.previousClose = [ self calculateAskWithAsk: quote_.askClose AndBid: quote_.askClose ];
         quote_.last          = [ self calculateAskWithAsk: quote_.ask      AndBid: quote_.bid ];
         
         break;
      }
   }

   double new_bid_ = [ self calculateBidWithAsk: quote_.ask AndBid: quote_.bid ];
   double new_ask_ = [ self calculateAskWithAsk: quote_.ask AndBid: quote_.bid ];
   
   quote_.bid = new_bid_;
   quote_.ask = new_ask_;
}

-(void)recalcChartQuotesArrayWithQuotes: (NSArray*)quotes_
{
   for ( NSUInteger i = 0; i < quotes_.count; i++ )
   {
      if ( [ [ quotes_ objectAtIndex: i ] isMemberOfClass: [ PFLotsMinQuote class ] ] )
      {
         PFLotsMinQuote* lots_qoute_ = (PFLotsMinQuote*)[ quotes_ objectAtIndex: i ];
         
         double new_bid_open_  = [ self calculateBidWithAsk: lots_qoute_.askInfo.open  AndBid: lots_qoute_.bidInfo.open ];
         double new_bid_high_  = [ self calculateBidWithAsk: lots_qoute_.askInfo.high  AndBid: lots_qoute_.bidInfo.high ];
         double new_bid_low_   = [ self calculateBidWithAsk: lots_qoute_.askInfo.low   AndBid: lots_qoute_.bidInfo.low ];
         double new_bid_close_ = [ self calculateBidWithAsk: lots_qoute_.askInfo.close AndBid: lots_qoute_.bidInfo.close ];
         
         double new_ask_open_  = [ self calculateAskWithAsk: lots_qoute_.askInfo.open  AndBid: lots_qoute_.bidInfo.open ];
         double new_ask_high_  = [ self calculateAskWithAsk: lots_qoute_.askInfo.high  AndBid: lots_qoute_.bidInfo.high ];
         double new_ask_low_   = [ self calculateAskWithAsk: lots_qoute_.askInfo.low   AndBid: lots_qoute_.bidInfo.low ];
         double new_ask_close_ = [ self calculateAskWithAsk: lots_qoute_.askInfo.close AndBid: lots_qoute_.bidInfo.close ];
         
         lots_qoute_.bidInfo.open  = new_bid_open_;
         lots_qoute_.bidInfo.high  = new_bid_high_;
         lots_qoute_.bidInfo.low   = new_bid_low_;
         lots_qoute_.bidInfo.close = new_bid_close_;
         
         lots_qoute_.askInfo.open  = new_ask_open_;
         lots_qoute_.askInfo.high  = new_ask_high_;
         lots_qoute_.askInfo.low   = new_ask_low_;
         lots_qoute_.askInfo.close = new_ask_close_;
      }
   }
}

-(void)recalcLevel2QuotesWithBidQuotes:( NSArray* )bid_quotes_
                          AndAskQuotes:( NSArray* )ask_quotes_
                          AndLevel1Bid:( double )bid_
                          AndLevel1Ask:( double )ask_
{
   double best_bid_ = (bid_quotes_.count > 0) ? ((PFLevel2Quote*)[ bid_quotes_ objectAtIndex: 0 ]).realPrice : bid_;
   double best_ask_ = (ask_quotes_.count > 0) ? ((PFLevel2Quote*)[ ask_quotes_ objectAtIndex: 0 ]).realPrice : ask_;
   
   double spread_bid_offet_  = [ self calculateBidWithAsk: best_ask_ AndBid: best_bid_ ] - best_bid_;
   double spread_ask_offset_ = [ self calculateAskWithAsk: best_ask_ AndBid: best_bid_ ] - best_ask_;
   
   for ( PFLevel2Quote* quote_ in bid_quotes_ )
   {
      quote_.price = quote_.realPrice + spread_bid_offet_;
   }
   
   for ( PFLevel2Quote* quote_ in ask_quotes_ )
   {
      quote_.price = quote_.realPrice + spread_ask_offset_;
   }
}

-(double)calculateAskWithAsk: (double)ask_ AndBid: (double)bid_
{
   switch ( self.spreadMode )
   {
      case PFSpreadModeBid:
         return (bid_ != 0) ? ((bid_ + self.bidShift * self.spreadCoefficient) + self.spread * self.spreadCoefficient) : ask_;
         
      case PFSpreadModeBidAsk:
         if (bid_ == 0)
            bid_ = ask_;
         return ((ask_ + self.askShift * self.spreadCoefficient + bid_ + self.bidShift * self.spreadCoefficient) + self.spread * self.spreadCoefficient) / 2;
         
      case PFSpreadModeLimen:
         if (bid_ == 0)
            bid_ = ask_;
         double new_ask_ = ask_ + self.askShift * self.spreadCoefficient;
         double new_bid_ = bid_ + self.bidShift * self.spreadCoefficient;
         double delta_ = (new_ask_ - new_bid_) - self.spread * self.spreadCoefficient;

         return (delta_ < 0) ? (new_ask_ - delta_ / 2) : new_ask_;
         
      case PFSpreadModeNotFixed:
      case PFSpreadModeAsk:
      default:
         return (ask_ != 0) ? (ask_ + self.askShift * self.spreadCoefficient) : ask_;
   }
}

-(double)calculateBidWithAsk: (double)ask_ AndBid: (double)bid_
{
   switch ( self.spreadMode )
   {
      case PFSpreadModeAsk:
         return (ask_ != 0) ? ((ask_ + self.askShift * self.spreadCoefficient) - self.spread * self.spreadCoefficient) : bid_;
         
      case PFSpreadModeBidAsk:
         if (ask_ == 0)
            ask_ = bid_;
         
         return ((ask_ + self.askShift * self.spreadCoefficient + bid_ + self.bidShift * self.spreadCoefficient) - self.spread * self.spreadCoefficient) / 2;
         
      case PFSpreadModeLimen:
         if (ask_ == 0)
            ask_ = bid_;
         double new_ask_ = ask_ + self.askShift * self.spreadCoefficient;
         double new_bid_ = bid_ + self.bidShift * self.spreadCoefficient;
         double delta_ = (new_ask_ - new_bid_) - self.spread * self.spreadCoefficient;
         
         return (delta_ < 0) ? (new_bid_ + delta_ / 2) : new_bid_;
         
      case PFSpreadModeNotFixed:
      case PFSpreadModeBid:
      default:
         return (bid_ != 0) ? (bid_ + self.bidShift * self.spreadCoefficient) : bid_;
   }
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFSpreadLevel: spredLevelId=%lld instrumentTypeId=%d instrumentId=%d spread=%f bidShift=%f askShift=%f"
           , self.spredLevelId
           , self.instrumentTypeId
           , self.instrumentId
           , self.spread
           , self.bidShift
           , self.askShift ];
}

@end
