#import "PFQuoteHistory.h"

#import "PFQuoteInfo.h"
#import "PFChartPeriodType.h"

#import "PFDataScanner.h"

#import "NSDate+PFTimeStamp.h"

#include <math.h>

static const int extVersion100 = 100;
static const int extVersion110 = 110;
static const int extVersion111 = 111;
static const int extVersion112 = 112;
static const int extVersion113 = 113;

@interface PFBaseQuote (PFDataScanner)

+(id)quoteWithScanner:( PFDataScanner* )scanner_;

@end

@implementation PFBaseQuote (PFDataScanner)

+(id)quoteWithScanner:( PFDataScanner* )scanner_
{
   PFBaseQuote* quote_ = [ self new ];

   quote_.date = [ NSDate dateWithMsecondsTimeStamp: [ scanner_ scanLongValue ] ];

   return quote_;
}

@end

@interface PFQuoteHistory ()

@property ( nonatomic, strong ) PFDataScanner* scanner;
@property ( nonatomic, strong ) NSArray* quotes;

@property ( nonatomic, assign ) PFInteger version;
@property ( nonatomic, assign ) PFLong startTime;
@property ( nonatomic, assign ) PFLong endTime;
@property ( nonatomic, assign ) PFChartPeriodType period;
@property ( nonatomic, assign ) PFBool isTrade;
@property ( nonatomic, assign ) PFByte precision;

@end

@implementation PFQuoteHistory

@synthesize scanner = _scanner;
@synthesize quotes = _quotes;

@synthesize version;
@synthesize startTime;
@synthesize endTime;
@synthesize period;
@synthesize isTrade;
@synthesize precision;

-(PFDouble)scanQuotePrice
{
   return [ self.scanner scanIntegerValue ] / pow( 10.0, self.precision );
}

-(PFQuoteInfo*)scanQuoteInfo
{
   PFQuoteInfo* info_ = [ PFQuoteInfo new ];

   info_.open = [ self scanQuotePrice ];
   info_.high = [ self scanQuotePrice ];
   info_.low = [ self scanQuotePrice ];
   info_.close = [ self scanQuotePrice ];
   
   return info_;
}

-(PFBaseQuote*)scanVersion100
{
   if (self.isTrade)
   {
      if (self.period == PFChartPeriodM1)
      {
         PFTradesMinQuote* quote_ = [ PFTradesMinQuote quoteWithScanner: self.scanner ];
         
         quote_.info = [self scanQuoteInfo]; //ohlc
         quote_.info.volume = (PFLong)[ self.scanner scanDoubleValue ];
         
         return quote_;
      }
      else if (self.period == PFChartPeriodD1)
      {
         PFTradesDayQuote* quote_ = [ PFTradesDayQuote quoteWithScanner: self.scanner ];
         
         quote_.info = [self scanQuoteInfo]; //ohlc
         quote_.info.volume = (PFLong)[ self.scanner scanDoubleValue ];
         
         return quote_;
      }
   }
   else
   {
      if (self.period == PFChartPeriodM1)
      {
         PFLotsMinQuote* quote_ = [ PFLotsMinQuote quoteWithScanner: self.scanner ];
         
         quote_.bidInfo = [ self scanQuoteInfo ]; //ohlc bid
         quote_.bidInfo.volume = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.askInfo = [ self scanQuoteInfo ]; //ohlc ask
         quote_.askInfo.volume = (PFLong)[ self.scanner scanDoubleValue ];
    
         return quote_;
      }
      else if (self.period == PFChartPeriodD1)
      {
         PFLotsDayQuote* quote_ = [ PFLotsDayQuote quoteWithScanner: self.scanner ];
         
         quote_.bidInfo = [ self scanQuoteInfo ]; //ohlc bid
         quote_.bidInfo.volume = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.askInfo = [ self scanQuoteInfo ]; //ohlc ask
         quote_.askInfo.volume = (PFLong)[ self.scanner scanDoubleValue ];
         
         return quote_;
      }
   }
   return nil;
}

-(PFBaseQuote*)scanVersion110
{
   if (self.isTrade)
   {
      if (self.period == PFChartPeriodM1)
      {
         PFTradesMinQuote* quote_ = [ PFTradesMinQuote quoteWithScanner: self.scanner ];
         
         quote_.info = [ self scanQuoteInfo ]; //ohlc
         quote_.volume = [ self.scanner scanLongValue ];
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         quote_.sessionType = [ self.scanner scanByteValue ];
         
         return quote_;
      }
      else if (self.period == PFChartPeriodD1)
      {
         PFTradesDayQuote* quote_ = [ PFTradesDayQuote quoteWithScanner: self.scanner ];
         
         quote_.info = [ self scanQuoteInfo ]; //ohlc
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.ticksPreMarket = [ self.scanner scanLongValue ];
         quote_.ticksAfterMarket = [ self.scanner scanLongValue ];
         quote_.volume = [ self.scanner scanLongValue ];
         quote_.volumePreMarket = [ self.scanner scanLongValue ];
         quote_.volumeAfterMarket = [ self.scanner scanLongValue ];
         quote_.infoTotal = [ self scanQuoteInfo ]; //ohlc total
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         
         return quote_;
      }
   }
   else
   {
      if (self.period == PFChartPeriodM1)
      {
         PFLotsMinQuote* quote_ = [ PFLotsMinQuote quoteWithScanner: self.scanner ];
         
         quote_.bidInfo = [ self scanQuoteInfo ]; //ohlc bid
         quote_.askInfo = [ self scanQuoteInfo ]; //ohlc ask
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         quote_.sessionType = [ self.scanner scanByteValue ];
         
         return quote_;
      }
      else if (self.period == PFChartPeriodD1)
      {
         PFLotsDayQuote* quote_ = [ PFLotsDayQuote quoteWithScanner: self.scanner ];
         
         quote_.bidInfo = [ self scanQuoteInfo ]; //ohlc bid
         quote_.bidInfoTotal = [ self scanQuoteInfo ]; //ohlc bid total
         quote_.askInfo = [ self scanQuoteInfo ]; //ohlc ask
         quote_.askInfoTotal = [ self scanQuoteInfo ]; //ohlc ask total
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.ticksPreMarket = [ self.scanner scanLongValue ];
         quote_.ticksAfterMarket = [ self.scanner scanLongValue ];
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         
         return quote_;
      }
   }
   return nil;
}

-(PFBaseQuote*)scanVersion111
{
   if (self.isTrade)
   {
      if (self.period == PFChartPeriodM1)
      {
         PFTradesMinQuote* quote_ = [ PFTradesMinQuote quoteWithScanner: self.scanner ];
         
         quote_.info = [ self scanQuoteInfo ]; //ohlc
         quote_.volume = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         quote_.sessionType = [ self.scanner scanByteValue ];
         
         return quote_;
      }
      else if (self.period == PFChartPeriodD1)
      {
         PFTradesDayQuote* quote_ = [ PFTradesDayQuote quoteWithScanner: self.scanner ];
         
         quote_.info = [ self scanQuoteInfo ]; //ohlc
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.ticksPreMarket = [ self.scanner scanLongValue ];
         quote_.ticksAfterMarket = [ self.scanner scanLongValue ];
         quote_.volume = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.volumePreMarket = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.volumeAfterMarket = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.infoTotal = [ self scanQuoteInfo ]; //ohlc total
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         
         return quote_;
      }
   }
   else
   {
      if (self.period == PFChartPeriodM1)
      {
         PFLotsMinQuote* quote_ = [ PFLotsMinQuote quoteWithScanner: self.scanner ];
         
         quote_.bidInfo = [ self scanQuoteInfo ]; //ohlc bid
         quote_.askInfo = [ self scanQuoteInfo ]; //ohlc ask
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         quote_.sessionType = [ self.scanner scanByteValue ];
         
         return quote_;
      }
      else if (self.period == PFChartPeriodD1)
      {
         PFLotsDayQuote* quote_ = [ PFLotsDayQuote quoteWithScanner: self.scanner ];
         
         quote_.bidInfo = [ self scanQuoteInfo ]; //ohlc bid
         quote_.bidInfoTotal = [ self scanQuoteInfo ]; //ohlc bid total
         quote_.askInfo = [ self scanQuoteInfo ]; //ohlc ask
         quote_.askInfoTotal = [ self scanQuoteInfo ]; //ohlc ask total
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.ticksPreMarket = [ self.scanner scanLongValue ];
         quote_.ticksAfterMarket = [ self.scanner scanLongValue ];
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         
         return quote_;
      }
   }
   return nil;
}

-(PFBaseQuote*)scanVersion112
{
   if (self.isTrade)
   {
      if (self.period == PFChartPeriodM1)
      {
         PFTradesMinQuote* quote_ = [ PFTradesMinQuote quoteWithScanner: self.scanner ];
         
         quote_.info = [ self scanQuoteInfo ]; //ohlc
         quote_.volume = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         quote_.sessionType = [ self.scanner scanByteValue ];
         
         return quote_;
      }
      else if (self.period == PFChartPeriodD1)
      {
         PFTradesDayQuote* quote_ = [ PFTradesDayQuote quoteWithScanner: self.scanner ];
         
         quote_.info = [ self scanQuoteInfo ]; //ohlc
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.ticksPreMarket = [ self.scanner scanLongValue ];
         quote_.ticksAfterMarket = [ self.scanner scanLongValue ];
         quote_.volume = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.volumePreMarket = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.volumeAfterMarket = (PFLong)[ self.scanner scanDoubleValue ];
         quote_.infoTotal = [ self scanQuoteInfo ]; //ohlc total
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         [self.scanner idleScanIntegerValue];
         
         return quote_;
      }
   }
   else
   {
      if (self.period == PFChartPeriodM1)
      {
         PFLotsMinQuote* quote_ = [ PFLotsMinQuote quoteWithScanner: self.scanner ];
         
         quote_.bidInfo = [ self scanQuoteInfo ]; //ohlc bid
         quote_.askInfo = [ self scanQuoteInfo ]; //ohlc ask
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         quote_.sessionType = [ self.scanner scanByteValue ];
         
         return quote_;
      }
      else if (self.period == PFChartPeriodD1)
      {
         PFLotsDayQuote* quote_ = [ PFLotsDayQuote quoteWithScanner: self.scanner ];
         
         quote_.bidInfo = [ self scanQuoteInfo ]; //ohlc bid
         quote_.bidInfoTotal = [ self scanQuoteInfo ]; //ohlc bid total
         quote_.askInfo = [ self scanQuoteInfo ]; //ohlc ask
         quote_.askInfoTotal = [ self scanQuoteInfo ]; //ohlc ask total
         quote_.ticks = [ self.scanner scanLongValue ];
         quote_.ticksPreMarket = [ self.scanner scanLongValue ];
         quote_.ticksAfterMarket = [ self.scanner scanLongValue ];
         quote_.openInterest = [ self.scanner scanIntegerValue ];
         [self.scanner idleScanIntegerValue];
         
         return quote_;
      }
   }
   return nil;
}

-(NSTimeInterval)filterTimeForPeriod:( PFChartPeriodType )period_
{
   if ( period_ == PFChartPeriodD1 )
      return 3600.0 * 6.0;
   else if ( period_ == PFChartPeriodTick )
      return 0.0;

   return 60.0;
}

-(BOOL)parseData:( NSData* )data_ error:( NSError** )error_
{
   self.scanner = [ PFDataScanner scannerWithData: data_ ];
   self.scanner.directBytesOrder = YES;

   self.version = [ self.scanner scanIntegerValue ];
   self.startTime = [ self.scanner scanLongValue ];
   self.endTime = [ self.scanner scanLongValue ];
   self.period = [ self.scanner scanByteValue ];
   self.isTrade = [ self.scanner scanBoolValue ];
   self.precision = [ self.scanner scanByteValue ];

   NSMutableArray* quotes_ = [ NSMutableArray array ];

   NSDate* previous_date_ = nil;
   NSTimeInterval filter_time_ = [ self filterTimeForPeriod: self.period ];
   
   while ( ![ self.scanner eof ] )
   {
      PFBaseQuote* quote_ = nil;
    
      switch (self.version) {
         case extVersion100:
            quote_ = [self scanVersion100]; break;
            
         case extVersion110:
            quote_ = [self scanVersion110]; break;
            
         case extVersion111:
            quote_ = [self scanVersion111]; break;
            
         case extVersion112:
            quote_ = [self scanVersion112]; break;
            
         case extVersion113:
            quote_ = [self scanVersion112]; break;
            //Поменялся только тиковый период, который мы не используем, поэтому считаем как 112
            
         default:
            NSLog(@"New ExtVersion - %d !!!", self.version);
            return NO;
      }
      
      if ( quote_.isValid )
      {
         if ( !previous_date_ || [ quote_.date timeIntervalSinceDate: previous_date_ ] >= filter_time_ )
         {
            [ quotes_ addObject: quote_ ];
         }
         previous_date_ = quote_.date;
      }
   }

   self.quotes = quotes_;

   return YES;
}

+(id)historyWithData:( NSData* )data_ error:( NSError** )error_
{
   PFQuoteHistory* history_ = [ self new ];

   if ( ![ history_ parseData: data_ error: error_ ] )
      return nil;

   return history_;
}

@end
