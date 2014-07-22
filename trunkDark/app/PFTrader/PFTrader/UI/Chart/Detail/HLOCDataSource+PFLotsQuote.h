//!XiP
#import "HLOCDataSource.h"

#import <ProFinanceApi/ProFinanceApi.h>

@protocol PFSymbol;

@interface HLOCDataSource (PFLotsQuote)

+(id)dataSourceWithQuotes:( NSArray* )quotes_
                   symbol:( id< PFSymbol > )symbol_
                   period:( PFChartPeriodType )period_;

@end
