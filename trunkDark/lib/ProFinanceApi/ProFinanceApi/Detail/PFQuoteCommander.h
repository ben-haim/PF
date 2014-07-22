#import "PFCommander.h"

#import "../PFTypes.h"

#import "../Data/PFDoneBlockDefs.h"
#import "../Data/PFChartPeriodType.h"
#import "../Data/PFSubscriptionType.h"

#import <Foundation/Foundation.h>

@protocol PFSymbol;

@protocol PFQuoteCommander <PFCommander>

-(void)subscribeToSymbols:( NSArray* )symbols_
                     type:( PFSubscriptionType )subscription_type_;

-(void)unsubscribeFromSymbols:( NSArray* )symbols_
                         type:( PFSubscriptionType )subscription_type_;

-(void)historyFilesForSymbol:( id< PFSymbol > )symbol_
                   accountId:( PFInteger )account_id_
                      period:( PFChartPeriodType )period_
                    fromDate:( NSDate* )from_date_
                      toDate:( NSDate* )to_date_
              timeZoneOffset:( PFInteger )time_zone_offset_
                   doneBlock:( PFChartFilesDoneBlock )done_block_;

@end
