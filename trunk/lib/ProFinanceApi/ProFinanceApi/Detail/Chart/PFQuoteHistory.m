#import "PFQuoteHistory.h"

#import "PFQuoteInfo.h"
#import "PFChartPeriodType.h"

#import "PFDataScanner.h"

#import "NSDate+PFTimeStamp.h"

#include <math.h>

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
   PFInteger price_ = [ self.scanner scanIntegerValue ];
   return price_ / pow( 10.0, self.precision );
}

-(PFTickQuoteInfo*)scanTickQuoteInfo
{
   PFTickQuoteInfo* info_ = [ PFTickQuoteInfo new ];

   info_.price = [ self scanQuotePrice ];
   info_.volume = (PFLong)[ self.scanner scanDoubleValue ];

   return info_;
}

-(PFTickTradesQuote*)scanTickTradesQuote
{
   PFTickTradesQuote* quote_ = [ PFTickTradesQuote quoteWithScanner: self.scanner ];

   quote_.info = [ self scanTickQuoteInfo ];

   return quote_;
}

-(PFTickLotsQuote*)scanTickLotsQuote
{
   PFTickLotsQuote* quote_ = [ PFTickLotsQuote quoteWithScanner: self.scanner ];

   quote_.bidInfo = [ self scanTickQuoteInfo ];
   quote_.askInfo = [ self scanTickQuoteInfo ];

   return quote_;
}

-(PFQuoteInfo*)scanQuoteInfo
{
   PFQuoteInfo* info_ = [ PFQuoteInfo new ];

   info_.open = [ self scanQuotePrice ];
   info_.high = [ self scanQuotePrice ];
   info_.low = [ self scanQuotePrice ];
   info_.close = [ self scanQuotePrice ];
   info_.volume = (PFLong)[ self.scanner scanDoubleValue ];
   
   return info_;
}

-(PFTradesQuote*)scanTradesQuote
{
   PFTradesQuote* quote_ = [ PFTradesQuote quoteWithScanner: self.scanner ];

   quote_.info = [ self scanQuoteInfo ];

   return quote_;
}

-(PFLotsQuote*)scanLotsQuote
{
   PFLotsQuote* quote_ = [ PFLotsQuote quoteWithScanner: self.scanner ];

   quote_.bidInfo = [ self scanQuoteInfo ];
   quote_.askInfo = [ self scanQuoteInfo ];

   return quote_;
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

      if ( self.period ==  PFChartPeriodTick )
      {
         quote_ = self.isTrade
         ? [ self scanTickTradesQuote ]
         : [ self scanTickLotsQuote ];
         
      }
      else
      {
         quote_ = self.isTrade
            ? [ self scanTradesQuote ]
            : [ self scanLotsQuote ];
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
