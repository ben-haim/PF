#import "TickData.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation TickData

@synthesize Symbol;
@synthesize Bid;
@synthesize Ask;
@synthesize direction;
@synthesize Max;
@synthesize Min;
@synthesize lastUpdate;


- (void)dealloc 
{
   [Symbol release];
   [Bid release];
   [Ask release];
   [Max release];
   [Min release];
   [lastUpdate release];

	[super dealloc];
}

@end

@implementation TickData (PFQuote)

+(id)tickDataWithQuote:( id< PFQuote > )quote_
{
   TickData* tick_data_ = [ self new ];

   tick_data_.symbol = quote_.symbolName;
   tick_data_.bid = [ NSString stringWithFormat: @"%f", quote_.bid ];
   tick_data_.ask = [ NSString stringWithFormat: @"%f", quote_.ask ];
   tick_data_.direction = quote_.growthType != PFQuoteGrowthDown;
   tick_data_.lastUpdate = quote_.date;
   tick_data_.Max = @"1.0";
   tick_data_.Min = @"0.1";
   
   return [ tick_data_ autorelease ];
}

@end
